import 'package:sqflite/sqflite.dart';
import 'package:zenith/models/cryptocurrency.dart';

class CryptocurrencyHelper {
  final Database _db;

  CryptocurrencyHelper(this._db);

Future<void> insertCryptocurrency(Cryptocurrency cryptocurrency) async {
  final existingCrypto = await getCryptocurrencyInPortfolio(cryptocurrency.portfolio, cryptocurrency.symbol);

  if (existingCrypto != null) {
    // Atualize os valores do registro existente
    final newQuantity = existingCrypto.quantity + cryptocurrency.quantity;
    final newPurchasePrice = (existingCrypto.mediumPurchasePrice * existingCrypto.quantity + cryptocurrency.mediumPurchasePrice * cryptocurrency.quantity) / newQuantity;
    final newSellPrice = (existingCrypto.mediumSellPrice * existingCrypto.quantity + cryptocurrency.mediumSellPrice * cryptocurrency.quantity) / newQuantity;

    final updatedCrypto = Cryptocurrency(
      portfolio: cryptocurrency.portfolio,
      symbol: cryptocurrency.symbol,
      quantity: newQuantity,
      mediumPurchasePrice: newPurchasePrice,
      mediumSellPrice: newSellPrice,
    );

    // Atualize o registro existente no banco de dados
    await _db.update(
      'Cryptocurrencies',
      updatedCrypto.toMap(),
      where: 'Portfolio = ? AND Symbol = ?',
      whereArgs: [cryptocurrency.portfolio, cryptocurrency.symbol],
    );
  } else {
    // Se a moeda não existir, insira-a normalmente
    await _db.insert('Cryptocurrencies', cryptocurrency.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }
}

  Future<Cryptocurrency?> getCryptocurrencyInPortfolio(String portfolio, String symbol) async {
    final List<Map<String, dynamic>> maps = await _db.query(
      'Cryptocurrencies',
      where: 'Portfolio = ? AND Symbol = ?',
      whereArgs: [portfolio, symbol],
    );

    if (maps.isNotEmpty) {
      return Cryptocurrency.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<List<Cryptocurrency>> getCryptocurrenciesFromPortfolio(String portfolioName) async {
    final List<Map<String, dynamic>> maps = await _db.query(
      'Cryptocurrencies',
      where: 'Portfolio = ?',
      whereArgs: [portfolioName],
    );

    final cryptocurrencies = List.generate(maps.length, (i) {
      return Cryptocurrency.fromMap(maps[i]);
    });

    return cryptocurrencies;
  }

  // Retorna uma lista com todas as Cryptocurrency disponíveis no banco
  Future<List<Cryptocurrency>> getAllCryptocurrencies() async {
    final List<Map<String, dynamic>> maps = await _db.query('Cryptocurrencies');

    return List.generate(maps.length, (i) {
      return Cryptocurrency.fromMap(maps[i]);
    });
  }

  // Método para alterar um 
  Future<void> updateCryptocurrency(Cryptocurrency cryptocurrency) async {
    await _db.update(
      'Cryptocurrencies',
      cryptocurrency.toMap(),
      where: 'Symbol = ? AND Portfolio = ?',
      whereArgs: [cryptocurrency.symbol, cryptocurrency.portfolio],
    );
  }

  Future<void> deleteCryptocurrencyPortfolio(String portfolio) async {
    final rowsAffected = await _db.delete(
      'Cryptocurrencies',
      where: 'Portfolio = ?',
      whereArgs: [portfolio],
    );
    
    if (rowsAffected > 0) {
      print('Exclusão bem-sucedida. $rowsAffected registros excluídos.');
    } else {
      print('Nenhum registro encontrado para exclusão.');
    }
  }
  
  Future<void> deleteCryptocurrencyInPortfolio(String symbol, String portfolio) async {
    final rowsAffected = await _db.delete(
      'Cryptocurrencies',
      where: 'Symbol = ? AND Portfolio = ?',
      whereArgs: [symbol, portfolio],
    );
    
    if (rowsAffected > 0) {
      print('Exclusão bem-sucedida. $rowsAffected registros excluídos.');
    } else {
      print('Nenhum registro encontrado para exclusão.');
    }
  }

  Future<void> deleteAllCryptocurrencies() async {
    try {
      final rowsAffected = await _db.delete('Cryptocurrencies');
      print('Exclusão bem-sucedida. $rowsAffected registros excluídos.');
    } catch (e) {
      print('Erro ao excluir os registros: $e');
    }
  }

  Future<bool> checkIfPortfolioExists(String portfolioName) async {
    final count = Sqflite.firstIntValue(await _db.rawQuery(
        'SELECT COUNT(*) FROM Cryptocurrencies WHERE Portfolio = ?', [portfolioName]));
    return count != null && count > 0;
  }

  Future<int> countDistinctPortfolios() async {
    final result = await _db.rawQuery('SELECT COUNT(DISTINCT Portfolio) FROM Cryptocurrencies');
    final count = Sqflite.firstIntValue(result);
    return count ?? 0;
  }

  Future<List<String>> getPortfoliosOrderedByCryptocurrencies() async {
    final List<Map<String, dynamic>> maps = await _db.rawQuery('''
      SELECT Portfolio, COUNT(Symbol) AS CryptoCount
      FROM Cryptocurrencies
      GROUP BY Portfolio
      ORDER BY CryptoCount DESC
    ''');

    final portfolios = List.generate(maps.length, (i) {
      return maps[i]['Portfolio'] as String;
    });

    return portfolios;
  }
}
