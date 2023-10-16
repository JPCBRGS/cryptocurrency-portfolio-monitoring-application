import 'dart:io';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:zenith/models/cryptocurrency.dart';

class CsvUtils {

Future<Map?> selectCsvFile() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['csv'],
  ); // Esse é o método responsável por buscar um arquivo no sistema

  if (result != null) {
    final file = File(result.files.single.path!);
    final fileNameWithExtension = result.files.single.name;
    
    // Remove a extensão ".csv" do nome do arquivo
    final fileName = fileNameWithExtension.replaceAll('.csv', ''); // Retira a extensão do nome do arquivo (que é utilizado como nome do portfólio)

    final csvString = await file.readAsString();

    return {'fileName': fileName, 'csvString': csvString};
  } else {
    // Nenhum arquivo selecionado
    print('Nenhum arquivo selecionado');
    return null;
  }
}

  void createEmptyCsvFile() {
    // Lógica para criar um arquivo CSV vazio
    print('Criar um arquivo CSV vazio');
  }

  // Método responsável por pegar um .CSV com as criptomoedas e distribuí-lo em uma lista de Cryptocurrency para retornar
  List<Cryptocurrency> parseCSVIntoCryptocurrencyList(String csvString, String portfolioName) {
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
}
