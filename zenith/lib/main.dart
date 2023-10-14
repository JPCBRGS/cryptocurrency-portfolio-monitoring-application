import 'package:flutter/material.dart';
import 'package:zenith/data/cryptocurrency_helper.dart';
import 'package:zenith/databases/database_helper.dart';
import 'package:zenith/models/cryptocurrency.dart';
import 'package:zenith/screens/home_screen_without_main_sheet.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Garante que o Flutter esteja inicializado

  final dbHelper = DatabaseHelper.instance; // Inicializa a instância do helper do banco de dados
  final database = await dbHelper.database; // Inicializa o banco (cria um se não existir, ou abre o banco já existente)

  final cryptocurrency = Cryptocurrency(
    portfolio: 'Binance',
    symbol: 'BTC',
    quantity: 1.0,
    mediumPurchasePrice: 50000.0,
    mediumSellPrice: 55000.0,
  );

  final CryptocurrencyHelper cryptocurrencyHelper = CryptocurrencyHelper(database);
  cryptocurrencyHelper.deleteCryptocurrency(cryptocurrency);

  await dbHelper
      .copyFileToExternalStorage(); // Copia o banco de dados do armazenamento interno para o armazenamento externo para pegar o arquivo por meio do pull_database.bat

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreenWithoutMainSheet(),
    );
  }
}
