import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:logger/logger.dart';

class DatabaseHelper {
  // Defina o nome do banco de dados e a versão
  static const _databaseName = 'cryptocurrency_database.db';
  static final _log = Logger();

  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initializeDatabase();
    return _database!;
  }

  Future<Database> _initializeDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Cryptocurrencies(
        Portfolio TEXT,
        Symbol TEXT,
        Quantity REAL,
        AveragePurchasePrice REAL
      )
    ''');
    _log.i('Tabela Cryptocurrencies criada.');

    await db.execute('''
      CREATE TABLE Alerts(
        Symbol TEXT,
        TargetPrice REAL,
        Status BOOLEAN
      )
    ''');
    _log.i('Tabela de alertas criada.');
  }

  Future<void> copyDatabaseFileToExternalStorage() async {
    final appDocDir = await getDatabasesPath();
    final sourceFile = File('$appDocDir/$_databaseName');
    final destinationFile = File('/sdcard/Documents/$_databaseName');

    try {
      await sourceFile.copy(destinationFile.path);
      _log.i('Banco de dados copiado para o armazenamento externo.');
    } catch (e) {
      _log.e('Erro ao copiar o banco de dados: $e');
    }
  }

  Future<void> deleteDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);

    try {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
        _log.i('Banco de dados excluído.');
      }
    } catch (e) {
      _log.e('Erro ao excluir o banco de dados: $e');
    }
  }
}
