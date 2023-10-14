import 'package:csv/csv.dart';
import 'package:zenith/models/cryptocurrency.dart';

// Método responsável por pegar um .CSV com as criptomoedas e distribuí-lo em uma lista de Cryptocurrency para retornar
List<Cryptocurrency> parseCSV(String csvString, String portfolioName) {
  final List<List<dynamic>> csvList = const CsvToListConverter(eol: '\n', fieldDelimiter: ';').convert(csvString);
  final List<Cryptocurrency> cryptos = [];
  for (final row in csvList) {
    if (row.isNotEmpty) {
      final crypto = Cryptocurrency(
        portfolio: portfolioName, // Define o nome do portfolio
        symbol: row[0] ?? '',
        quantity: double.tryParse(row[1].toString()) ?? 0.0,
        mediumPurchasePrice: double.tryParse(row[2].toString()) ?? 0.0,
        mediumSellPrice: double.tryParse(row[3].toString()) ?? 0.0,
      );
      cryptos.add(crypto);
    }
  }
  return cryptos;
}

