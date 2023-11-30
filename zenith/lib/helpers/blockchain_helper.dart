import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class BlockchainHelper {
  static final _log = Logger();
  static List<dynamic> coinsList = [];
  static List<String> symbolsList = [];

  BlockchainHelper() {}

  Future<void> fetchBitcoinTransaction() async {
    final url = 'https://svc.blockdaemon.com/universal/v1/bitcoin/mainnet/tx/71d4f3412ec11128bbd9ce988d5bff2ec3bb6ea3953c8faf189d88ae49de9f7a';
    final apiKey = 'zpka_2ca01a33067b47cca285c82303d2fc1b_360ea1dd';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'X-API-Key': apiKey,
          'accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Se a resposta foi bem-sucedida, você pode processar os dados aqui
        final jsonData = json.decode(response.body);
        print('Dados da API:');
        print(jsonData);
      } else {
        // Se a resposta não foi bem-sucedida, você pode lidar com o erro aqui
        print('Erro na requisição: ${response.statusCode}');
        print('Corpo da resposta: ${response.body}');
      }
    } catch (e) {
      // Se ocorrer uma exceção durante a requisição, você pode lidar com ela aqui
      print('Erro durante a requisição: $e');
    }
  }
}
