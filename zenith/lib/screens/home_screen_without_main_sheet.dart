import 'package:flutter/material.dart';
import 'package:zenith/constants/app_colors.dart';

import '../utils/csv_utils.dart';
import '../utils/csv_parser.dart';

class HomeScreenWithoutMainSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.secondaryBackgroundColor,
        title: const Text('Zenith'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                CsvUtils csvUtils = CsvUtils();
                // Lógica para selecionar um arquivo CSV existente
                String? csvString = await csvUtils.selectCsvFile();
                if (csvString != null) {
                  final cryptos = parseCSV(csvString);
                  
                  for (final crypto in cryptos) {
                    print('Name: ${crypto.name}');
                    print('Quantity: ${crypto.quantity}');
                    print('Purchase Price: ${crypto.mediumPurchasePrice}');
                    print('Medium Sell Price: ${crypto.mediumSellPrice}');
                  }
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    AppColors.secondaryBackgroundColor),
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
                // Lógica para selecionar um arquivo CSV existente
                csvUtils.createEmptyCsvFile();
                // Lógica para criar um arquivo CSV vazio
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    AppColors.secondaryBackgroundColor),
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
