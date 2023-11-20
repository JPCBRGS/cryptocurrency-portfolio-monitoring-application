import 'dart:convert';
import 'dart:io';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class CoinsListHelper {
  static final _log = Logger();
  static List<dynamic> _coinsList = [];

  CoinsListHelper() {
    _loadCoinsList();
  }

  void _loadCoinsList() async {
    print("alou");
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/coins_list.json');

      // Verifica se o arquivo existe
      if (file.existsSync()) {
        String content = await file.readAsString();
        _coinsList = json.decode(content);
        _log.i('Lista de criptomoedas carregada com sucesso.');
      } else {
        _log.i('Arquivo de lista de criptomoedas não encontrado.');
      }
    } catch (e) {
      _log.e('Erro ao carregar a lista de criptomoedas: $e');
    }
  }

  // Método para obter o "id" correspondente a um "symbol"
  String? getCoinIdBySymbol(String symbol) {
    // Verifica se a lista de criptomoedas foi carregada
    if (_coinsList.isEmpty) {
      _log.e('A lista de criptomoedas não foi carregada ainda.');
      return null;
    }

    // Procura o "id" correspondente ao "symbol"
    for (var coin in _coinsList) {
      if (coin['symbol'] == symbol) {
        return coin['id'];
      }
    }

    // Se não encontrar correspondência, retorna null
    _log.i('Nenhuma criptomoeda encontrada com o símbolo: $symbol');
    return null;
  }

  Future<void> copyCoinsListFileToExternalStorage() async {
    final directory = await getApplicationDocumentsDirectory();
    final sourceFile = File('${directory.path}/coins_list.json');
    final destinationFile = File('/sdcard/Documents/coins_list.json');
    try {
      await sourceFile.copy(destinationFile.path);
      _log.i('Lista de criptomoedas copiadas para o armazenamento externo.');
    } catch (e) {
      _log.e('Erro ao copiar a lista de criptomoedas: $e');
    }
  }

  Future<List<dynamic>> fetchCoinsList() async {
    final response = await http.get(Uri.parse('https://api.coingecko.com/api/v3/coins/list'));

    if (response.statusCode == 200) {
      _log.i('Requisição da lista de criptomoedas finalizada com sucesso.');
      return json.decode(response.body);
    } else {
      _log.i('Falha ao realizar a requisição da lista de criptomoedas.');
      throw Exception('Falha ao carregar a lista de moedas');
    }
  }

  Future<void> saveCoinsListToFile(List<dynamic> coinsList) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/coins_list.json');
    await file.writeAsString(json.encode(coinsList));
  }
}
