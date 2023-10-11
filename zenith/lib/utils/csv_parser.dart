import 'package:csv/csv.dart';
import 'package:zenith/models/cryptocurrency.dart';

List<Cryptocurrency> parseCSV(String csvString) {
  final List<List<dynamic>> csvList = CsvToListConverter(eol: '\n', fieldDelimiter: ';').convert(csvString);
  final List<Cryptocurrency> cryptos = [];
  for (final row in csvList) {
    if (row.isNotEmpty) {
      final crypto = Cryptocurrency(
        name: row[0] ?? '',
        quantity: double.tryParse(row[1].toString()) ?? 0.0,
        mediumPurchasePrice: double.tryParse(row[2].toString()) ?? 0.0,
        mediumSellPrice: double.tryParse(row[3].toString()) ?? 0.0,
      );
      cryptos.add(crypto);
    }
  }
  return cryptos;
}
