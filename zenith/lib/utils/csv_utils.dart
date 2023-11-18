import 'dart:io';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:zenith/models/cryptocurrency.dart';

class CsvUtils {
  // Método responsável por selecionar um arquivo .CSV do sistema, transformar em uma string, e retornar um map com o nome do arquivo e a string dos dados
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

  // Método responsável por receber um map que tem dois membros, o nome do portfólio e a string csvString que contém os dados do .CSV importado com as Cryptocurrency
  // Retorna uma lista de Cryptocurrency correspondentes aos dados processados
  List<Cryptocurrency> parseCSVIntoCryptocurrencyList(String portfolioName, String csvString) {
    final List<List<dynamic>> csvList = const CsvToListConverter(eol: '\n', fieldDelimiter: ';').convert(csvString);
    final List<Cryptocurrency> processedCryptocurrencies = [];
    for (final row in csvList) {
      if (row.isNotEmpty) {
        final cryptocurrency = Cryptocurrency(
          portfolio: portfolioName, // Define o nome do portfolio
          symbol: row[0],
          quantity: double.tryParse(row[1].toString()) ?? 0.0,
          averagePurchasePrice: double.tryParse(row[2].toString()) ?? 0.0,
        );
        processedCryptocurrencies.add(cryptocurrency);
      }
    }
    return processedCryptocurrencies;
  }
}
