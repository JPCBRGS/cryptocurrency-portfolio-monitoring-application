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
  static List<dynamic> coinsList = [];
  static List<String> symbolsList = [];

  CoinsListHelper() {
    fetchAndSaveCoinsList();
    _loadCoinsList();
  }

  void _loadCoinsList() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/coins_list.json');

      // Verifica se o arquivo existe
      if (file.existsSync()) {
        String content = await file.readAsString();
        coinsList = json.decode(content);
        _log.i('Lista de criptomoedas carregada com sucesso.');
      } else {
        _log.i('Arquivo de lista de criptomoedas não encontrado.');
      }
    } catch (e) {
      _log.e('Erro ao carregar a lista de criptomoedas: $e');
    }
  }

  // Método para buscar uma lista de moedas por meio da API e repassar o valor de retorno a variável interna _coinsList
  Future<void> fetchCoinsList() async {
    final response = await http.get(Uri.parse(
        'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=false&locale=en'));
    if (response.statusCode == 200) {
      _log.i('Requisição da lista de criptomoedas finalizada com sucesso.');
      coinsList = json.decode(response.body);
    } else {
      _log.i('Falha ao realizar a requisição da lista de criptomoedas.');
    }
  }

  // Método responsável por copiar os dados retornados pela requisição em um arquivo .json no sistema
  Future<void> saveCoinsListToFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/coins_list.json');
    await file.writeAsString(json.encode(coinsList));
  }

  // Método para realizar a busca e o salvamento em um arquivo (chama os dois métodos acima)
  Future<void> fetchAndSaveCoinsList() async {
    await fetchCoinsList();
    await saveCoinsListToFile();
  }

  void extractSymbolsFromAvailableCryptocurrencies(List<dynamic> coinsList) {
    for (var coin in coinsList) {
      if (coin.containsKey("symbol")) {
        String symbol = coin["symbol"];
        symbolsList.add(symbol);
      }
    }
  }

  // Método para obter o id correspondente ao symbol de uma criptomoeda
  bool checkIfCoinExistsBySymbol(String symbol) {
    if (coinsList.isEmpty) {
      _log.e('A lista de criptomoedas não foi carregada ainda.');
      return false;
    }

    for (var coin in coinsList) {
      if (coin['symbol'] == symbol) {
        return true;
      }
    }

    _log.i('Nenhuma criptomoeda encontrada com o símbolo: $symbol');
    return false;
  }

  // Método para obter o id correspondente ao symbol de uma criptomoeda
  String? getCoinIdBySymbol(String symbol) {
    if (coinsList.isEmpty) {
      _log.e('A lista de criptomoedas não foi carregada ainda.');
      return null;
    }

    for (var coin in coinsList) {
      if (coin['symbol'] == symbol) {
        return coin['id'];
      }
    }

    _log.i('Nenhuma criptomoeda encontrada com o símbolo: $symbol');
    return null;
  }

  // Método para obter o nome correspondente ao symbol de uma criptomoeda
  String? getCoinNameBySymbol(String symbol) {
    if (coinsList.isEmpty) {
      _log.e('A lista de criptomoedas não foi carregada ainda.');
      return null;
    }

    for (var coin in coinsList) {
      if (coin['symbol'] == symbol) {
        return coin['name'];
      }
    }

    _log.i('Nenhuma criptomoeda encontrada com o símbolo: $symbol');
    return null;
  }

  // Método para obter a imagem correspondente a um symbol de uma criptomoeda
  String? getCoinImageBySymbol(String symbol) {
    if (coinsList.isEmpty) {
      _log.e('A lista de criptomoedas não foi carregada ainda.');
      return null;
    }

    for (var coin in coinsList) {
      if (coin['symbol'] == symbol) {
        return coin['image'];
      }
    }

    _log.i('Nenhuma criptomoeda encontrada com o símbolo: $symbol');
    return null;
  }

  // Método para obter o preço atual correspondente ao symbol de uma criptomoeda
  String? getCoinPriceBySymbol(String symbol) {
    if (coinsList.isEmpty) {
      _log.e('A lista de criptomoedas não foi carregada ainda.');
      return null;
    }

    for (var coin in coinsList) {
      if (coin['symbol'] == symbol) {
        double currentPrice = coin['current_price'].toDouble();
        String formattedPrice = currentPrice.toStringAsFixed(4); // Arredonda para duas casas decimais
        return formattedPrice;
      }
    }

    _log.i('Nenhuma criptomoeda encontrada com o símbolo: $symbol');
    return null;
  }

    String? getCoinMarketCapBySymbol(String symbol) {
    if (coinsList.isEmpty) {
      _log.e('A lista de criptomoedas não foi carregada ainda.');
      return null;
    }

    for (var coin in coinsList) {
      if (coin['symbol'] == symbol) {
        return coin['market_cap'].toString();
      }
    }

    _log.i('Nenhuma criptomoeda encontrada com o símbolo: $symbol');
    return null;
  }

  String? getCoinPriceVariationPercentageLastDayBySymbol(String symbol) {
    if (coinsList.isEmpty) {
      _log.e('A lista de criptomoedas não foi carregada ainda.');
      return null;
    }

    for (var coin in coinsList) {
      if (coin['symbol'] == symbol) {
        double priceVariation = coin['price_change_percentage_24h'];
        String formattedPriceVariation = priceVariation.toStringAsFixed(2);
        return formattedPriceVariation;
      }
    }

    _log.i('Nenhuma criptomoeda encontrada com o símbolo: $symbol');
    return null;
  }

  // Copia o arquivo coins_list.json do armazenamento interno do dispositivo para o armazenamento externo
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
}
