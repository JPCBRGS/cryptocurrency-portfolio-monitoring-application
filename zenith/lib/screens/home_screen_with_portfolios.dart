/*
import 'package:flutter/material.dart';
import 'package:zenith/models/cryptocurrency.dart';

class HomeScreenWithPortfolios extends StatelessWidget {
  const HomeScreenWithPortfolios({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cryptocurrencies in the Portfolio'),
      ),
      body: FutureBuilder<List<Cryptocurrency>>(
        future: getCryptocurrenciesForPortfolio(), // Função para buscar criptomoedas do portfolio
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Mostra um indicador de carregamento enquanto aguarda o resultado.
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Text('Nenhuma criptomoeda encontrada no portfolio.');
          } else {
            final cryptocurrencies = snapshot.data;
            return ListView.builder(
              itemCount: cryptocurrencies?.length,
              itemBuilder: (context, index) {
                final cryptocurrency = cryptocurrencies[index];
                return ListTile(
                  title: Text(cryptocurrency.symbol),
                  subtitle: Text('Quantity: ${cryptocurrency.quantity}'),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<List<Cryptocurrency>> getCryptocurrenciesForPortfolio() async {
    final dbHelper = DatabaseHelper.instance; // Inicialize o helper do banco de dados
    final database = await dbHelper.database;
    final cryptocurrencyHelper = CryptocurrencyHelper(database);
    final portfolioName = 'Nome do Portfolio'; // Substitua pelo nome do seu portfolio
    return cryptocurrencyHelper.getCryptocurrenciesForPortfolio(portfolioName);
  }
}
*/