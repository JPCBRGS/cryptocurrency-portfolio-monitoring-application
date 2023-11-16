import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:zenith/constants/app_colors.dart';
import 'package:zenith/constants/font_styles.dart';
import 'package:zenith/data/cryptocurrency_helper.dart';
import 'package:zenith/databases/database_helper.dart';
import 'package:zenith/models/cryptocurrency.dart';
import 'package:zenith/utils/csv_utils.dart';
import 'package:zenith/view/components/main_bottom_navigation_bar.dart';
import 'package:zenith/view/components/main_drawer.dart';
import 'package:zenith/view/components/portfolio_dropdown.dart';
import 'package:zenith/view/screens/alert_screen.dart';

class HomeScreenWithPortfolio extends StatefulWidget {
  const HomeScreenWithPortfolio({super.key});

  @override
  State<HomeScreenWithPortfolio> createState() => _HomeScreenWithPortfolioState();
}

class _HomeScreenWithPortfolioState extends State<HomeScreenWithPortfolio> {
  int _currentIndex = 0; // define o índice referente a página atual conforme necessário
  List<String> portfolios = [];
  String? selectedPortfolio;
  List<Cryptocurrency> cryptocurrencies = [];
  var dbHelper;
  var database;
  var cryptocurrencyHelper;

  Future<void> loadData() async {
    dbHelper = DatabaseHelper.instance;
    database = await dbHelper.database;
    cryptocurrencyHelper = CryptocurrencyHelper(database);

    List<String> allPortfoliosOrderedByCryptocurrencyCount = await cryptocurrencyHelper.getPortfoliosOrderedByCryptocurrencies();

    setState(() {
      portfolios = allPortfoliosOrderedByCryptocurrencyCount;
      // Defina o valor inicial como o primeiro item da lista
      selectedPortfolio = portfolios.isNotEmpty ? portfolios[0] : '';
    });

    getCryptocurrenciesFromPortfolioToShow(selectedPortfolio!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Portfolios',
          style: FontStyles.montserratStyle(18),
        ),
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
      ),
      drawer: MainDrawer(
        loadedDropdownState: () {
          loadData();
        },
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
        PortfolioDropdown(
          portfolios: portfolios,
          selectedPortfolio: selectedPortfolio,
        ),
        ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: cryptocurrencies.length,
            itemBuilder: (context, index) {
              return Row(
                children:[
                  Text(
                    cryptocurrencies[index].symbol,
                    style: FontStyles.montserratStyle(18),),
                  Text(
                    cryptocurrencies[index].quantity.toString(),
                    style: FontStyles.montserratStyle(18),),
                ],
              );
            })
      ]),
      bottomNavigationBar: MainBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  void initState() {
    super.initState();
    loadData();
  }

  void getCryptocurrenciesFromPortfolioToShow(String portfolio) async{
    cryptocurrencies = await cryptocurrencyHelper.getCryptocurrenciesFromPortfolio(portfolio);
  }

  // método da barra de navegação inferior para navegar entre páginas diferentes
  void _onItemTapped(int index) {
    if (index == 1) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => AlertScreen()));
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }
}
