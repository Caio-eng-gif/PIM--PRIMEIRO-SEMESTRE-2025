CREATE TABLE Usuarios (
    UsuarioID INT IDENTITY(1,1) PRIMARY KEY,
    Nome NVARCHAR(100) NOT NULL,
    Email NVARCHAR(150) UNIQUE NOT NULL,
    SenhaHash NVARCHAR(255) NOT NULL,
    TipoUsuario NVARCHAR(50) NOT NULL, -- 'cliente', 'tecnico', 'admin'
    DataCadastro DATETIME DEFAULT GETDATE()
);

CREATE TABLE Chamados (
    ChamadoID INT IDENTITY(1,1) PRIMARY KEY,
    UsuarioID INT NOT NULL, -- quem abriu
    Categoria NVARCHAR(100) NOT NULL, -- Hardware, Software, Outros
    Descricao NVARCHAR(MAX) NOT NULL,
    Status NVARCHAR(50) DEFAULT 'Aberto', -- Aberto, Em Atendimento, Concluído
    DataAbertura DATETIME DEFAULT GETDATE(),
    DataConclusao DATETIME NULL,
    FOREIGN KEY (UsuarioID) REFERENCES Usuarios(UsuarioID)
);

CREATE TABLE Pareceres (
    ParecerID INT IDENTITY(1,1) PRIMARY KEY,
    ChamadoID INT NOT NULL,
    TecnicoID INT NOT NULL,
    Texto NVARCHAR(MAX) NOT NULL,
    Status NVARCHAR(50) NOT NULL, -- Em Atendimento, Concluído
    DataParecer DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (ChamadoID) REFERENCES Chamados(ChamadoID),
    FOREIGN KEY (TecnicoID) REFERENCES Usuarios(UsuarioID)
);

ALTER TABLE Chamados
ADD TecnicoID INT NULL;

ALTER TABLE Chamados
ADD CONSTRAINT FK_Chamados_Usuarios_Tecnico
FOREIGN KEY (TecnicoID) REFERENCES Usuarios(UsuarioID);

Alter table Pareceres
ADD CONSTRAINT FK_Pareceres_Chamados FOREIGN KEY (ChamadoID) REFERENCES Chamados(ChamadoID);

ALTER TABLE Pareceres
ADD CONSTRAINT FK_Pareceres_Tecnicos FOREIGN KEY (TecnicoID) REFERENCES Usuarios(UsuarioID)

select*from Usuarios;

select*from Chamados;

select*from Pareceres;

INSERT INTO Usuarios (Nome, Email, SenhaHash, TipoUsuario)
VALUES 
('Caio Costa', 'caio.c@alphacontabil.com', 'caio123456', 'Técnico'),

('Lucas Gimenez', 'lucas.g@alphacontabil.com', 'lucasg123456', 'Técnico'),

('Lucas Machado', 'lucas.m@alphacontabil.com', 'lucasm123456', 'Colaborador'),

('Gabriel Souza', 'gabriel.s@alphacontabil.com', 'gabriel123456', 'Colaborador'),

('Pedro Leite', 'pedro.l@alphacontabil.com', 'pedro123', 'Administrador'),

('Rodrigo Resteli', 'rodrigo.r@alphacontabil.com', 'rodrigo123', 'Administrador');

SELECT name, type_desc FROM sys.sql_logins;

CREATE LOGIN mvpadmin WITH PASSWORD = 'Mvpdesk1234@';

SELECT UsuarioID, Nome, TipoUsuario
FROM Usuarios 
WHERE Email = 'caio.c@alphacontabil.com' 
  AND SenhaHash = 'caio123456';