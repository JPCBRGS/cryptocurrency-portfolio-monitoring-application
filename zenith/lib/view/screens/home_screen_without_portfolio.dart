import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:zenith/constants/app_colors.dart';
import 'package:zenith/data/cryptocurrency_helper.dart';
import 'package:zenith/databases/database_helper.dart';
import 'package:zenith/models/cryptocurrency.dart';
import 'package:zenith/utils/csv_utils.dart';
import 'package:zenith/view/screens/home_screen_with_portfolio.dart';

class HomeScreenWithoutPortfolio extends StatefulWidget {
  const HomeScreenWithoutPortfolio({super.key});

  @override
  State<HomeScreenWithoutPortfolio> createState() => _HomeScreenWithoutPortfolioState();
}

class _HomeScreenWithoutPortfolioState extends State<HomeScreenWithoutPortfolio> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.mainBackgroundColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  CsvUtils csvUtils = CsvUtils();
                  var csvResult = await csvUtils.selectCsvFile();
                  if (csvResult != null) {
                    List<Cryptocurrency> Cryptocurrencies = csvUtils.parseCSVIntoCryptocurrencyList(csvResult['fileName'], csvResult['csvString']);
                    final dbHelper = DatabaseHelper.instance;
                    final database = await dbHelper.database;
                    CryptocurrencyHelper cryptocurrencyHelper = CryptocurrencyHelper(database);
                    for (Cryptocurrency cryptocurrency in Cryptocurrencies) {
                      await cryptocurrencyHelper.insertCryptocurrency(cryptocurrency);
                    }
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreenWithPortfolio()));
                  } else {
                    final _log = Logger();
                    _log.i('Nenhum arquivo foi selecionado.');
                  }
                },
                child: Text(
                  "Importar arquivo .CSV",
                  style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                child: Text(
                  "começar com um arquivo vazio",
                  style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
