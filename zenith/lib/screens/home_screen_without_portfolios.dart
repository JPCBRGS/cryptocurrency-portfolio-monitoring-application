import 'package:flutter/material.dart';
import 'package:zenith/constants/app_colors.dart';
import 'package:zenith/data/cryptocurrency_helper.dart';
import 'package:zenith/databases/database_helper.dart';
import '../utils/csv_utils.dart';

class HomeScreenWithoutPortfolios extends StatelessWidget {
  final DatabaseHelper dbHelper;

  HomeScreenWithoutPortfolios({Key? key, required this.dbHelper}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.secondaryBackgroundColor,
        title: const Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                CsvUtils csvUtils = CsvUtils();
                final csvData = await csvUtils.selectCsvFile();
                if (csvData != null) {
                  final fileName = csvData['fileName'];
                  final csvString = csvData['csvString'];
                  final database = await dbHelper.database;
                  CryptocurrencyHelper cryptocurrencyHelper = CryptocurrencyHelper(database);
                  bool portfolioExists = await cryptocurrencyHelper.checkIfPortfolioExists(fileName);
                  if (portfolioExists) {
                    // Lógica para exibir mensagem de erro
                  } else {
                    final cryptos = csvUtils.parseCSVIntoCryptocurrencyList(csvString, fileName);
                    for (final crypto in cryptos) {
                      await cryptocurrencyHelper.insertCryptocurrency(crypto);
                    }
                    await dbHelper.copyFileToExternalStorage();
                  }
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(AppColors.secondaryBackgroundColor),
              ),
              child: const SizedBox(
                width: 250,
                height: 50,
                child: Center(
                  child: Text('Selecionar um arquivo .CSV existente'),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                CsvUtils csvUtils = CsvUtils();
                csvUtils.createEmptyCsvFile();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(AppColors.secondaryBackgroundColor),
              ),
              child: const SizedBox(
                width: 250,
                height: 50,
                child: Center(
                  child: Text('Começar com um arquivo vazio'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
