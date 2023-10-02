import 'dart:io';
import 'package:file_picker/file_picker.dart';

class CsvUtils {
  Future<String?> selectCsvFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result != null) {
      final file = File(result.files.single.path!);
      final csvString = await file.readAsString();
      return csvString;
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
