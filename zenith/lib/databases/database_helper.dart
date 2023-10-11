import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  // Defina o nome do banco de dados e a versão
  static final _databaseName = 'crypto_database.db';
  static final _databaseVersion = 1;

  // Crie uma instância única da classe DatabaseHelper
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Crie uma referência para o banco de dados SQLite
  static Database? _database;

  // Método para acessar o banco de dados
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  // Método para inicializar o banco de dados
  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> initializeDatabase() async {
    final db = await _initDatabase();
    if (db.isOpen) {
      print('Banco de dados criado com sucesso.');
    } else {
      print('Falha ao criar o banco de dados.');
    }
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
