// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  // Defina o nome do banco de dados e a versão
  static const _databaseName = 'cryptocurrency_database.db';

  static final DatabaseHelper instance = DatabaseHelper._init();
  
  // Crie uma referência para o banco de dados SQLite
  static Database? _database;

  DatabaseHelper._init();
  // Método para acessar o banco de dados
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

  Future<void> copyFileToExternalStorage() async {
    final appDocDir = await getDatabasesPath();
    final sourceFile = File('$appDocDir/$_databaseName');
    final destinationFile = File('/sdcard/Documents/$_databaseName');
    await sourceFile.copy(destinationFile.path);
  }

  Future<void> deleteDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);
    
    try {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
        print('Banco de dados excluído');
      }
    } catch (e) {
      print('Erro ao excluir o banco de dados: $e');
    }
  }

  // Método para criar a estrutura do banco de dados
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Cryptocurrencies(
        Portfolio TEXT,
        Symbol TEXT,
        Quantity REAL,
        AveragePurchasePrice REAL,
      )
    ''');
  }
}
