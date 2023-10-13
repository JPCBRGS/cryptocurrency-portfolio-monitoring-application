import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  // Defina o nome do banco de dados e a versão
  static final _databaseName = 'crypto_database.db';
  late Database _db;

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
    print(path);
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> copyFileToExternalStorage() async {
    final appDocDir = await getDatabasesPath();
    final sourceFile = File('$appDocDir/$_databaseName');
    final destinationFile = File('/sdcard/Documents/$_databaseName');
    await sourceFile.copy(destinationFile.path);
    print("finished");
  }

  // Método para criar a estrutura do banco de dados
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Portfolios(
        ID INTEGER PRIMARY KEY,
        Name TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE Cryptocurrencies(
        ID INTEGER PRIMARY KEY,
        PortfolioID INTEGER,
        Name TEXT,
        Quantity REAL,
        PurchasePrice REAL,
        MediumSellPrice REAL,
        FOREIGN KEY (PortfolioID) REFERENCES Portfolios(ID)
      )
    ''');
  }
}
