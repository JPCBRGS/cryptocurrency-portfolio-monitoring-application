import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:zenith/constants/app_colors.dart';
import 'package:zenith/constants/font_styles.dart';
import 'package:zenith/data/cryptocurrency_helper.dart';
import 'package:zenith/databases/database_helper.dart';
import 'package:zenith/models/cryptocurrency.dart';
import 'package:zenith/utils/csv_utils.dart';
import 'package:zenith/view/components/main_bottom_navigation_bar.dart';
import 'package:zenith/view/screens/alert_screen.dart';

class HomeScreenWithPortfolio extends StatefulWidget {
  const HomeScreenWithPortfolio({super.key});

  @override
  State<HomeScreenWithPortfolio> createState() => _HomeScreenWithPortfolioState();
}

class _HomeScreenWithPortfolioState extends State<HomeScreenWithPortfolio> {
  int _currentIndex = 0; // Defina o índice atual conforme necessário

  void _onItemTapped(int index) {
    if (index == 1) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => AlertScreen()));
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.secondaryBackgroundColor,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        /*
        title: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: null,
            onChanged: (String? newValue) {
              setState(() {
              });
            },
            items: [], // Adicione os itens do dropdown aqui
          ),
        ),*/
      ),
      drawer: Drawer(
        child: Container(
          color: AppColors.mainBackgroundColor,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                height: 94,
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    color: AppColors.secondaryBackgroundColor,
                  ),
                  child: Text(
                    'Actions',
                    style: FontStyles.montserratStyle(15, color: Colors.white, fontWeight: FontWeight.bold)
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  'Add new portfolio from files',
                  style: FontStyles.montserratStyle(15)
                ),
                onTap: () async {
                  CsvUtils csvUtils = CsvUtils();
                  var csvResult = await csvUtils.selectCsvFile();
                  if (csvResult != null) {
                    List<Cryptocurrency> cryptocurrencies =
                        csvUtils.parseCSVIntoCryptocurrencyList(csvResult['fileName'], csvResult['csvString']);
                    final dbHelper = DatabaseHelper.instance;
                    final database = await dbHelper.database;
                    CryptocurrencyHelper cryptocurrencyHelper = CryptocurrencyHelper(database);
                    for (Cryptocurrency cryptocurrency in cryptocurrencies) {
                      await cryptocurrencyHelper.insertCryptocurrency(cryptocurrency);
                    }
                    await dbHelper.copyFileToExternalStorage();
                  } else {
                    final _log = Logger();
                    _log.i('No file selected.');
                  }
                },
              ),
              ListTile(
                title: Text(
                  'Add new empty .CSV portfolio file',
                  style: FontStyles.montserratStyle(15)
                ),
                onTap: () async {
                  
                },
              ),
              ListTile(
                title: Text(
                  'View settings',
                  style: FontStyles.montserratStyle(15)
                ),
                onTap: () async {
                },
              ),
              ListTile(
                title: Text(
                  'Help',
                  style: FontStyles.montserratStyle(15)
                ),
                onTap: () async {
                },
              ),
            ],
          ),
        ),
      ),
      body: Container(), 
      bottomNavigationBar: MainBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }

    @override
  void initState() {
    super.initState();
  }

  Future<List<String>> getAllPortfolios() async {
    final dbHelper = DatabaseHelper.instance;
    final database = await dbHelper.database;
    CryptocurrencyHelper cryptocurrencyHelper = CryptocurrencyHelper(database);

    List<String> allPortfoliosOrderedByCryptocurrencyCount = await cryptocurrencyHelper.getPortfoliosOrderedByCryptocurrencies();

    return allPortfoliosOrderedByCryptocurrencyCount;
  }
}
