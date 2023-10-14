import 'dart:io';
import 'package:file_picker/file_picker.dart';

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
}
