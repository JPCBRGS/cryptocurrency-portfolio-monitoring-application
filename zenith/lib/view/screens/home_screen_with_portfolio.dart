import 'package:flutter/material.dart';
import 'package:zenith/constants/app_colors.dart';
import 'package:zenith/constants/font_styles.dart';
import 'package:zenith/data/cryptocurrency_helper.dart';
import 'package:zenith/databases/database_helper.dart';
import 'package:zenith/models/cryptocurrency.dart';
import 'package:zenith/view/components/main_bottom_navigation_bar.dart';
import 'package:zenith/view/components/main_drawer.dart';
import 'package:zenith/view/components/portfolio_dropdown.dart';
import 'package:zenith/view/screens/alert_screen.dart';

class HomeScreenWithPortfolio extends StatefulWidget {
  const HomeScreenWithPortfolio({Key? key}) : super(key: key);

  @override
  _HomeScreenWithPortfolioState createState() =>
      _HomeScreenWithPortfolioState();
}

class _HomeScreenWithPortfolioState extends State<HomeScreenWithPortfolio> {
  int _currentIndex = 0; // define o índice referente à página atual conforme necessário
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

    List<String> allPortfoliosOrderedByCryptocurrencyCount =
        await cryptocurrencyHelper.getPortfoliosOrderedByCryptocurrencies();

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
              icon: const Icon(Icons.menu),
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
          Row(
            children: [
              PortfolioDropdown(
                portfolios: portfolios,
                selectedPortfolio: selectedPortfolio,
                getCryptocurrenciesCallback: updateCryptocurrencies,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: AppColors.secondaryBackgroundColor,
                ),
                child: IconButton(
                  icon: Icon(Icons.clear),
                  color: Colors.white,
                  onPressed: () {
                    // Adicione aqui a lógica para executar quando o botão for pressionado
                  },
                ),
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: cryptocurrencies.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 15.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cryptocurrencies[index].symbol,
                            style: FontStyles.montserratStyle(24),
                          ),
                          Text(
                            cryptocurrencies[index].quantity.toString(),
                            style: FontStyles.montserratStyle(16, color: AppColors.selectedItemColor),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: MainBottomNavigationBar(
        currentIndex: _currentIndex,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void getCryptocurrenciesFromPortfolioToShow(String portfolio) async {
    cryptocurrencies =
        await cryptocurrencyHelper.getCryptocurrenciesFromPortfolio(portfolio);
  }

  void updateCryptocurrencies(String newPortfolio) {
    setState(() {
      selectedPortfolio = newPortfolio;
      getCryptocurrenciesFromPortfolioToShow(newPortfolio);
    });
  }
}
