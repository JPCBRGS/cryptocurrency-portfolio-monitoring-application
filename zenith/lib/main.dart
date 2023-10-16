import 'package:flutter/material.dart';
import 'package:zenith/data/cryptocurrency_helper.dart';
import 'package:zenith/databases/database_helper.dart';
import 'package:zenith/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Garante que o Flutter esteja inicializado

  final dbHelper = DatabaseHelper.instance; // Inicializa a instância do helper do banco de dados
  final database = await dbHelper.database; // Inicializa o banco (cria um se não existir, ou abre o banco já existente)

  CryptocurrencyHelper cryptocurrencyHelper = CryptocurrencyHelper(database);

  await dbHelper.copyFileToExternalStorage();
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
