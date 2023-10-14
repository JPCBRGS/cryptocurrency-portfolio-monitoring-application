import 'package:sqflite/sqflite.dart';
import 'package:zenith/models/cryptocurrency.dart';

class CryptocurrencyHelper {
  final Database _db;

  CryptocurrencyHelper(this._db);

  Future<int> insertCryptocurrency(Cryptocurrency cryptocurrency) async {
    return await _db.insert('Cryptocurrencies', cryptocurrency.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
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

  Future<void> deleteCryptocurrency(Cryptocurrency cryptocurrency) async {
    await _db.delete(
      'Cryptocurrencies',
      where: 'Symbol = ? AND Portfolio = ?',
      whereArgs: [cryptocurrency.symbol, cryptocurrency.portfolio],
    );
  }

  Future<void> deleteAllCryptocurrencies() async {
    try {
      final rowsAffected = await _db.delete('Cryptocurrencies');
      print('Exclusão bem-sucedida. $rowsAffected registros excluídos.');
    } catch (e) {
      print('Erro ao excluir os registros: $e');
    }
  }
}
