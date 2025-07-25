import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:zenith/models/transaction.dart';

class BlockchainHelper {
  static final _log = Logger();
  static List<dynamic> coinsList = [];
  static List<String> symbolsList = [];

  BlockchainHelper() {}

Future<List<Transaction>> fetchBitcoinTransactionsForAddress(String address, {String protocol = "ethereum", String network = "mainnet"}) async {
  final url = 'https://svc.blockdaemon.com/universal/v1/$protocol/$network/account/$address/txs';
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
      // Decode the JSON response
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      // Check if 'data' key is present and is a list
      if (jsonResponse.containsKey('data') && jsonResponse['data'] is List<dynamic>) {
        // Create a list of Transaction objects
        List<Transaction> transactions = (jsonResponse['data'] as List<dynamic>).map((data) => Transaction.fromJson(data)).toList();
        return transactions;
      } else {
        // Handle the case where 'data' key is not present or not a list
        print('Erro: A chave "data" não está presente ou não é uma lista');
        return [];
      }
    } else {
      // Handle the case where the response was not successful
      print('Erro na requisição: ${response.statusCode}');
      print('Corpo da resposta: ${response.body}');
      return []; // Return an empty list in case of an error
    }
  } catch (e) {
    // Handle exceptions during the request
    print('Erro durante a requisição: $e');
    return []; // Return an empty list in case of an exception
  }
}


}
