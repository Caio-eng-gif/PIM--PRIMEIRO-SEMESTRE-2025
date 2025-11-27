import 'package:flutter/foundation.dart'
    show kIsWeb, defaultTargetPlatform, TargetPlatform;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    if (!kIsWeb && _isDesktop()) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    _database = await _initDB('mvpdesk.db');
    return _database!;
  }

  bool _isDesktop() {
    return [
      TargetPlatform.windows,
      TargetPlatform.linux,
      TargetPlatform.macOS
    ].contains(defaultTargetPlatform);
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    print('Caminho do banco: $path');

    return await openDatabase(
      path,
      version: 2, // ALTERADO PARA FORÇAR MIGRAÇÃO
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
      onOpen: (db) => print('Banco aberto com sucesso!'),
    );
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    print("Migrando banco... Versão antiga: $oldVersion");

    if (oldVersion < 2) {
      await db.execute("DROP TABLE IF EXISTS chamados");
      await db.execute("DROP TABLE IF EXISTS usuarios");
      await _createDB(db, newVersion);
    }
  }

  Future _createDB(Database db, int version) async {
    // Tabela de usuários
    await db.execute('''
      CREATE TABLE usuarios (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        password TEXT NOT NULL
      )
    ''');

    // Tabela de chamados com detalhes + técnico
    await db.execute('''
      CREATE TABLE chamados (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo TEXT NOT NULL,
        descricao TEXT NOT NULL,
        detalhes TEXT NOT NULL,
        tecnico TEXT NOT NULL,
        status TEXT NOT NULL
      )
    ''');

    // Inserção de usuários oficiais
    await db.insert('usuarios', {
      'username': 'lucas.machado@alphacontabil.com',
      'password': '1234'
    });

    await db.insert('usuarios', {
      'username': 'gabriel.souza@alphacontabil.com',
      'password': '1234'
    });

    // Chamados de teste
    await db.insert('chamados', {
      'titulo': 'Servidor fora do ar',
      'descricao': 'Servidor principal não responde',
      'detalhes': 'Problema identificado no firewall. Reiniciado.',
      'tecnico': 'Lucas Gimenez',
      'status': 'Resolvido'
    });

    await db.insert('chamados', {
      'titulo': 'Erro no sistema contábil',
      'descricao': 'Usuário não consegue acessar módulo fiscal',
      'detalhes': 'Bug corrigido na API. Atualização aplicada.',
      'tecnico': 'Caio Costa',
      'status': 'Fechado'
    });

    await db.insert('chamados', {
      'titulo': 'Computador travando',
      'descricao': 'Máquina muito lenta',
      'detalhes': 'Limpeza e otimização realizadas.',
      'tecnico': 'Lucas Gimenez',
      'status': 'Aberto'
    });

    await db.insert('chamados', {
      'titulo': 'Impressora não imprime',
      'descricao': 'Erro de comunicação',
      'detalhes': 'Driver reinstalado e ok.',
      'tecnico': 'Caio Costa',
      'status': 'Em andamento'
    });

    await db.insert('chamados', {
      'titulo': 'E-mail não sincroniza',
      'descricao': 'Outlook parado',
      'detalhes': 'Cache removido e reparo feito.',
      'tecnico': 'Lucas Gimenez',
      'status': 'Fechado'
    });

    print('Banco inicializado com sucesso!');
  }

  Future<bool> checkLogin(String username, String password) async {
    try {
      final db = await database;
      final res = await db.query(
        'usuarios',
        where: 'username = ? AND password = ?',
        whereArgs: [username, password],
      );

      return res.isNotEmpty;
    } catch (e) {
      print('Erro ao verificar login: $e');
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getChamados() async {
    try {
      final db = await database;
      return await db.query('chamados');
    } catch (e) {
      print('Erro ao carregar chamados: $e');
      return [];
    }
  }
}
