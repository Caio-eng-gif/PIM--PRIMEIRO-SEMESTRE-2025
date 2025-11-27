// server.js - Versão Final e Corrigida
import "dotenv/config";
import express from "express";
import sql from "mssql";
import cors from "cors";
import { GoogleGenAI } from "@google/genai";

const app = express();
app.use(cors());
app.use(express.json());

// Verifica se a chave da IA foi lida
console.log("Variável de Ambiente Lida (IA):", process.env.GEMINI_API_KEY ? process.env.GEMINI_API_KEY.substring(0,5) + "..." : "CHAVE AUSENTE");

// ----- CONFIGURAÇÃO AZURE SQL -----
const config = {
  user: process.env.DB_USER || "mvpadmin",
  password: process.env.DB_PASSWORD || "Mvpdesk1234@", // Use a senha REAL do Admin do Servidor
  server: process.env.DB_SERVER || "serv-mvpdesk1.database.windows.net",
  port: 1433,
  database: process.env.DB_NAME || "MVPDDESK", // CORREÇÃO: Nome do Banco (MVPDDESK)
  options: {
    encrypt: true, 
    enableArithAbort: true,
    ipVersion: "IPv4",
    trustServerCertificate: false
  },
  pool: {
    max: 10,
    min: 0,
    idleTimeoutMillis: 30000
  }
};

let pool = null;

async function getPool() {
  if (pool && pool.connected) {
    return pool;
  }
  try {
    pool = await sql.connect(config);
    console.log("Conexão com Azure SQL estabelecida com sucesso. ✔");
    return pool;
  } catch (err) {
    console.error("Erro ao obter pool de conexão com o banco de dados:", err);
    pool = null; 
    throw new Error("Falha na conexão com o banco de dados.");
  }
}

// ----- GEMINI (IA) -----
const ai = new GoogleGenAI(process.env.GEMINI_API_KEY);

/**
 * Rota de Login (POST /login)
 */
app.post("/login", async (req, res) => {
  const { email, senha } = req.body;
  try {
    const pool = await getPool();
    const result = await pool.request()
      .input("email", sql.NVarChar, email)
      .input("senha", sql.NVarChar, senha)
      .query(`
        SELECT UsuarioID, Nome, TipoUsuario  
        FROM Usuarios 
        WHERE Email = @email AND SenhaHash = @senha
      `);

    if (result.recordset && result.recordset.length > 0) {
      const user = result.recordset[0];
      
      // CORREÇÃO: Mapeia TipoUsuario para Perfil para o Frontend
      const userFinal = {
          UsuarioID: user.UsuarioID,
          Nome: user.Nome,
          Perfil: user.TipoUsuario 
      };
      
      res.json({ success: true, user: userFinal });
    } else {
      res.json({ success: false, message: "Usuário ou senha inválidos" });
    }
  } catch (err) {
    console.error("/login erro:", err);
    res.status(500).json({ success: false, message: "Erro interno no servidor ao tentar logar. Verifique a conexão com o BD." }); 
  }
});

/**
 * Sugestão de Solução pela IA (POST /sugerir)
 */
app.post("/sugerir", async (req, res) => {
  try {
    const { descricao } = req.body;
    const prompt = `Você é um analista de suporte técnico que sugere soluções rápidas, objetivas e com foco na resolução imediata. 
Problema reportado: ${descricao}
Responda APENAS com uma lista de 3 passos no formato Markdown (usando '* ') sempre.`;
    const resposta = await ai.models.generateContent({
      model: "gemini-2.5-flash",
      contents: [{ role: "user", parts: [{ text: prompt }] }],
      config: { maxOutputTokens: 200 }
    });
    res.json({ sugestao: resposta.text ?? resposta });
  } catch (error) {
    console.error("Erro ao chamar a API Gemini:", error);
    res.status(500).json({ erro: "Falha ao gerar sugestão da IA." });
  }
});


// ------------------------------------------------------------------
// ROTAS DO COLABORADOR
// ------------------------------------------------------------------

/**
 * Abrir Chamado (POST /chamados)
 */
app.post("/chamados", async (req, res) => {
  const { usuarioId, categoria, descricao } = req.body;
  try {
    const pool = await getPool();
    await pool.request()
      .input("usuarioId", sql.Int, usuarioId)
      .input("categoria", sql.NVarChar, categoria)
      .input("descricao", sql.NVarChar, descricao)
      .query(`
        INSERT INTO Chamados (UsuarioID, Categoria, Descricao, Status, DataAbertura)
        VALUES (@usuarioId, @categoria, @descricao, 'Aberto', GETDATE())
      `);
    res.json({ success: true, message: "Chamado registrado com sucesso!" });
  } catch (err) {
    console.error("/chamados erro:", err);
    res.status(500).json({ success: false, message: "Erro ao registrar chamado. Tente novamente." });
  }
});

/**
 * Histórico de Chamados do Colaborador (GET /chamados)
 */
app.get("/chamados", async (req, res) => {
  const { usuarioId } = req.query;
  try {
    const pool = await getPool();
    const result = await pool.request()
      .input("usuarioId", sql.Int, usuarioId)
      .query(`
        SELECT C.*, T.Nome AS NomeTecnico
        FROM Chamados C
        LEFT JOIN Usuarios T ON C.TecnicoID = T.UsuarioID
        WHERE C.UsuarioID = @usuarioId
        ORDER BY C.DataAbertura DESC
      `);
    res.json(result.recordset);
  } catch (err) {
    console.error("/chamados (GET) erro:", err);
    res.status(500).json([]); 
  }
});

// ------------------------------------------------------------------
// ROTAS DO TÉCNICO
// ------------------------------------------------------------------

/**
 * NOVO: Listar Chamados Abertos (GET /chamados/status)
 * Usada pelo técnico para ver o pool de chamados não atribuídos.
 */
app.get("/chamados/status", async (req, res) => {
  try {
    const pool = await getPool();
    const result = await pool.request()
      .input("status", sql.NVarChar, "Aberto")
      .query(`
        SELECT C.ChamadoID, C.Categoria, C.Descricao, C.Status, 
               U.Nome AS NomeColaborador, C.TecnicoID
        FROM Chamados C
        JOIN Usuarios U ON C.UsuarioID = U.UsuarioID
        WHERE C.Status = @status
        ORDER BY C.DataAbertura ASC
      `);
    res.json(result.recordset);
  } catch (err) {
    console.error("/chamados/status erro:", err);
    res.status(500).json([]);
  }
});


/**
 * Listar Chamados Atribuídos (GET /meusChamados)
 * Usada pelo técnico para ver seus chamados 'Em atendimento' e 'Concluídos'.
 */
app.get("/meusChamados", async (req, res) => {
  const { status, tecnicoId } = req.query;
  let query;

  try {
    const pool = await getPool();
    const request = pool.request();
    request.input("tecnicoId", sql.Int, tecnicoId);
    request.input("status", sql.NVarChar, status);

    // Esta rota agora foca nos status 'Em atendimento' e 'Concluído'
    query = `
        SELECT C.ChamadoID, C.Categoria, C.Descricao, C.Status, 
               U.Nome AS NomeColaborador, C.TecnicoID
        FROM Chamados C
        JOIN Usuarios U ON C.UsuarioID = U.UsuarioID
        WHERE C.Status = @status
        AND C.TecnicoID = @tecnicoId
        ORDER BY C.DataAbertura DESC
    `;

    const result = await request.query(query);
    res.json(result.recordset);

  } catch (err) {
    console.error("/meusChamados erro:", err);
    res.status(500).json([]);
  }
});


/**
 * Assumir Chamado (POST /assumirChamado)
 */
app.post("/assumirChamado", async (req, res) => {
  const { chamadoId, tecnicoId } = req.body;
  try {
    const pool = await getPool();
    await pool.request()
      .input("chamadoId", sql.Int, chamadoId)
      .input("tecnicoId", sql.Int, tecnicoId)
      .query(`
        UPDATE Chamados 
        SET TecnicoID = @tecnicoId, Status = 'Em atendimento' 
        WHERE ChamadoID = @chamadoId AND Status = 'Aberto'
      `);
    res.json({ success: true, message: "Chamado assumido com sucesso!" });
  } catch (err) {
    console.error("/assumirChamado erro:", err);
    res.status(500).json({ success: false, message: "Erro ao tentar assumir o chamado." });
  }
});

/**
 * Registrar Parecer (POST /pareceres)
 */
app.post("/pareceres", async (req, res) => {
  const { chamadoId, tecnicoId, texto, status } = req.body;
  try {
    const pool = await getPool();
    await pool.request()
      .input("chamadoId", sql.Int, chamadoId)
      .input("tecnicoId", sql.Int, tecnicoId)
      .input("texto", sql.NVarChar, texto)
      .input("status", sql.NVarChar, status)
      .query(`
        BEGIN TRANSACTION;
        
        INSERT INTO Pareceres (ChamadoID, TecnicoID, Texto, DataParecer, Status)
        VALUES (@chamadoId, @tecnicoId, @texto, GETDATE(), @status);
        
        UPDATE Chamados
        SET Status = @status
        WHERE ChamadoID = @chamadoId;
        
        COMMIT TRANSACTION;
      `);
    res.json({ success: true, message: "Parecer registrado e status atualizado com sucesso!" });
  } catch (err) {
    console.error("/pareceres (POST) erro:", err);
    res.status(500).json({ success: false, message: "Erro ao registrar o parecer." });
  }
});

/**
 * Listar Pareceres de um Chamado (GET /pareceres)
 */
app.get("/pareceres", async (req, res) => {
  const { chamadoId } = req.query;
  try {
    const pool = await getPool();
    const result = await pool.request()
      .input("chamadoId", sql.Int, chamadoId)
      .query(`
        SELECT P.*, T.Nome AS Tecnico 
        FROM Pareceres P
        JOIN Usuarios T ON P.TecnicoID = T.UsuarioID
        WHERE P.ChamadoID = @chamadoId
        ORDER BY P.DataParecer DESC
      `);
    res.json(result.recordset);
  } catch (err) {
    console.error("/pareceres (GET) erro:", err);
    res.status(500).json([]);
  }
});


// ----- INICIALIZAÇÃO DO SERVIDOR -----
app.get("/health", (req, res) => res.json({ ok: true, ts: new Date().toISOString() }));

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`API UNIFICADA rodando na porta ${PORT} 🚀`);
});