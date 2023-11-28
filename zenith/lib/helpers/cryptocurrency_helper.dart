import 'package:sqflite/sqflite.dart';
import 'package:zenith/helpers/coins_list_helper.dart';
import 'package:zenith/models/cryptocurrency.dart';

class CryptocurrencyHelper {
  final Database _db;

  CryptocurrencyHelper(this._db);

  // Recebe uma nova Cryptocurrency e insere ela no portfólio. Caso a moeda já exista naquele portfólio, é feita uma média dos valores antes que ela seja adicionada
  Future<void> insertCryptocurrency(Cryptocurrency cryptocurrency) async {
    // Caso a criptomoeda que se faria o insert não exista na lista de criptomoedas disponíveis, o método não faz nada
    if (!CoinsListHelper().checkIfCoinExistsBySymbol(cryptocurrency.symbol.toLowerCase())) {
      return;
    }

    final existingCrypto = await getCryptocurrencyInPortfolio(cryptocurrency.portfolio, cryptocurrency.symbol);

    if (existingCrypto != null) {
      // Atualiza os valores do registro existente
      final newQuantity = existingCrypto.quantity + cryptocurrency.quantity;
      final newAveragePurchasePrice = (cryptocurrency.averagePurchasePrice != 0)
          ? (existingCrypto.averagePurchasePrice * existingCrypto.quantity + cryptocurrency.averagePurchasePrice * cryptocurrency.quantity) /
              newQuantity
          : existingCrypto.averagePurchasePrice;
      final updatedCrypto = Cryptocurrency(
        portfolio: cryptocurrency.portfolio,
        symbol: cryptocurrency.symbol.toUpperCase(),
        quantity: newQuantity,
        averagePurchasePrice: newAveragePurchasePrice,
      );

      // Atualiza o registro existente no banco de dados
      await updateCryptocurrency(updatedCrypto);
    } else {
      // Se a moeda não existir, insira-a normalmente
      await _db.insert('Cryptocurrencies', cryptocurrency.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  // Retorna uma Cryptocurrency em um portfólio a partir do nome do portfólio e o symbol da moeda
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

  // Retorna todas as Cryptocurrency existentes que estejam vinculadas ao portfólio cujo nome é passado como parâmetro
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

  // Método para alterar uma Cryptocurrency (recebe uma Cryptocurrency como parâmetro e atualiza quantidade e/ou preço médio de compra)
  Future<void> updateCryptocurrency(Cryptocurrency cryptocurrency) async {
    await _db.update(
      'Cryptocurrencies',
      cryptocurrency.toMap(),
      where: 'Symbol = ? AND Portfolio = ?',
      whereArgs: [cryptocurrency.symbol, cryptocurrency.portfolio],
    );
  }

  // Método para excluir todo um portfólio, recebe uma string com seu nome por parâmetro
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

  // Método para excluir uma determinada Cryptocurrency em um portfólio. Recebe o symbol da criptomoeda e nome do portfólio como parâmetro
  Future<void> deleteCryptocurrencyInPortfolio(String portfolio, String symbol) async {
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

  // Exclui todas Cryptocurrency cadastradas no banco
  Future<void> deleteAllCryptocurrencies() async {
    try {
      final rowsAffected = await _db.delete('Cryptocurrencies');
      print('Exclusão bem-sucedida. $rowsAffected registros excluídos.');
    } catch (e) {
      print('Erro ao excluir os registros: $e');
    }
  }

  // Retorna TRUE caso exista um portfólio com o nome passado como parâmetro, e FALSE caso não exista
  Future<bool> checkIfPortfolioExists(String portfolioName) async {
    final count = Sqflite.firstIntValue(await _db.rawQuery('SELECT COUNT(*) FROM Cryptocurrencies WHERE Portfolio = ?', [portfolioName]));
    return count != null && count > 0;
  }

  // Retorna a quantidade de portfólios diferentes existentes no banco de dados
  Future<int> countDistinctPortfolios() async {
    final result = await _db.rawQuery('SELECT COUNT(DISTINCT Portfolio) FROM Cryptocurrencies');
    final count = Sqflite.firstIntValue(result);
    return count ?? 0;
  }

  // Retorna uma lista com o nome de todos portfólios cadastrados ordenados pela quantidade de criptomoedas em cada um de forma decrescente
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
