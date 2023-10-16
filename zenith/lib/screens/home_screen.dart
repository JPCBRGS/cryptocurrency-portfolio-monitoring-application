import 'package:flutter/material.dart';
import 'package:zenith/databases/database_helper.dart';
import 'package:zenith/screens/home_screen_without_portfolios.dart';

class HomeScreenWithoutMainSheet extends StatelessWidget {
  const HomeScreenWithoutMainSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final dbHelper = DatabaseHelper.instance; // Inicializa a instância do helper do banco de dados
    return homeScreenWithoutPortfolios(context, dbHelper);
  }
}
