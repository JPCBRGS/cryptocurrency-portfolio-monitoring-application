import 'package:flutter/material.dart';
import 'package:zenith/constants/app_colors.dart';

import '../utils/csv_utils.dart';
import '../utils/csv_parser.dart';

class HomeScreenWithoutMainSheet extends StatelessWidget {
  const HomeScreenWithoutMainSheet({super.key});

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
            // Botão para importar um .CSV do sistema
            ElevatedButton(
              onPressed: () async {
                CsvUtils csvUtils = CsvUtils(); // Cria uma instância da classe csvUtils para realizar operações com .csv
                
                final csvData = await csvUtils.selectCsvFile(); // Lógica para selecionar um arquivo CSV existente no armazenamento
                if (csvData != null) {
                  final fileName = csvData['fileName'];
                  final csvString = csvData['csvString'];
                  
                  // DEBUG
                  print('Nome do arquivo: $fileName');

                  final cryptos = parseCSV(csvString, fileName);
                  for (final crypto in cryptos) {
                    print('Portfolio: ${crypto.portfolio}');
                    print('Symbol: ${crypto.symbol}');
                    print('Quantity: ${crypto.quantity}');
                    print('Purchase Price: ${crypto.mediumPurchasePrice}');
                    print('Medium Sell Price: ${crypto.mediumSellPrice}');
                  }
                  // DEBUG
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

            // Botão para criar o arquivo .CSV vazio quando não é realizada a importação
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                CsvUtils csvUtils = CsvUtils();
                csvUtils.createEmptyCsvFile();
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
