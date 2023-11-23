import 'package:flutter/material.dart';
import 'package:zenith/constants/app_colors.dart';
import 'package:zenith/constants/font_styles.dart';
import 'package:zenith/helpers/coins_list_helper.dart';
import 'package:zenith/helpers/cryptocurrency_helper.dart';
import 'package:zenith/helpers/database_helper.dart';
import 'package:zenith/models/cryptocurrency.dart';
import 'package:zenith/view/components/main_bottom_navigation_bar.dart';
import 'package:zenith/view/components/main_drawer.dart';
import 'package:zenith/view/components/portfolio_dropdown.dart';
import 'package:zenith/view/screens/alert_screen.dart';

class HomeScreenWithPortfolio extends StatefulWidget {
  const HomeScreenWithPortfolio({Key? key}) : super(key: key);

  @override
  _HomeScreenWithPortfolioState createState() => _HomeScreenWithPortfolioState();
}

class _HomeScreenWithPortfolioState extends State<HomeScreenWithPortfolio> {
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  TextEditingController controller3 = TextEditingController();
  CoinsListHelper coinsListHelper = CoinsListHelper();
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
    cryptocurrencyHelper = await CryptocurrencyHelper(database);

    List<String> allPortfoliosOrderedByCryptocurrencyCount = await cryptocurrencyHelper.getPortfoliosOrderedByCryptocurrencies();

    setState(() {
      portfolios = allPortfoliosOrderedByCryptocurrencyCount;

      // Defina o valor inicial como o primeiro item da lista
      selectedPortfolio = portfolios.isNotEmpty ? portfolios[0] : '';
    });
    await getCryptocurrenciesFromPortfolioToShow(selectedPortfolio!);
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
      body: Container(
        margin: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PortfolioDropdown(
                  portfolios: portfolios,
                  selectedPortfolio: selectedPortfolio,
                  getCryptocurrenciesCallback: updateCryptocurrencies,
                ),
                Tooltip(
                  message: 'Refresh this page',
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.blueAccent,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.refresh),
                      color: Colors.white,
                      onPressed: () {
                        coinsListHelper.fetchAndSaveCoinsList();
                        setState(() {});
                      },
                    ),
                  ),
                ),
                Tooltip(
                  message: 'Add new token to this portfolio',
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.green,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.add),
                      color: Colors.white,
                      onPressed: () {
                        addNewCurrencyDialog();
                      },
                    ),
                  ),
                ),
                Tooltip(
                  message: 'Delete this portfolio',
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.redAccent,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.delete),
                      color: Colors.white,
                      onPressed: () {
                        // Lógica para o botão de remoção
                      },
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.only(top: 10.0),
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: cryptocurrencies.length,
                      itemBuilder: (context, index) {
                        String symbolLowerCase = cryptocurrencies[index].symbol.toLowerCase();
                        String? coinCurrentPrice = coinsListHelper.getCoinPriceBySymbol(symbolLowerCase);
                        String? coinImage = coinsListHelper.getCoinImageBySymbol(symbolLowerCase);
                        return GestureDetector(
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.network(
                                        coinImage!,
                                        width: 30, // Defina a largura desejada da imagem
                                        height: 30, // Defina a altura desejada da imagem
                                        fit: BoxFit.contain, // Ajuste o modo de ajuste da imagem conforme necessário
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          cryptocurrencies[index].symbol,
                                          style: FontStyles.montserratStyle(22),
                                        ),
                                        Text(
                                          cryptocurrencies[index].quantity.toString(),
                                          style: FontStyles.montserratStyle(14, color: AppColors.selectedItemColor),
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    Text(
                                      'R\$ ${coinCurrentPrice ?? ""}', // Usando "${coinCurrentPrice ?? ""}" para lidar com o caso em que coinCurrentPrice é nulo
                                      style: FontStyles.montserratStyle(22),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            ChangeCurrencyDialog(coinImage, symbolLowerCase, coinCurrentPrice!);
                          },
                        );
                      }),
                ),
              ),
            ),
          ],
        ),
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

  Future<void> getCryptocurrenciesFromPortfolioToShow(String portfolio) async {
    var cryptocurrenciesAux = await cryptocurrencyHelper.getCryptocurrenciesFromPortfolio(portfolio);
    setState(() {
      cryptocurrencies = cryptocurrenciesAux;
    });
  }

  void addNewCurrencyDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            height: 370,
            width: 270,
            padding: EdgeInsets.all(16), // Adicione algum espaçamento interno, se desejar
            child: Column(
              children: [
                TextField(
                  controller: controller1,
                  decoration: InputDecoration(
                    labelText: 'Symbol',
                  ),
                ),
                SizedBox(height: 10), // Adicione algum espaçamento vertical entre os campos
                TextField(
                  controller: controller2,
                  decoration: InputDecoration(
                    labelText: 'Quantity',
                  ),
                ),
                SizedBox(height: 10), // Adicione algum espaçamento vertical entre os campos
                TextField(
                  controller: controller3,
                  decoration: InputDecoration(
                    labelText: 'Average purchase price',
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void ChangeCurrencyDialog(String coinImage, String symbolLowerCase, String coinCurrentPrice) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            height: 370,
            width: 270,
            padding: EdgeInsets.all(16), // Adicione algum espaçamento interno, se desejar
            child: Column(
              children: [
                Image.network(
                  coinImage!,
                  width: 45, // Defina a largura desejada da imagem
                  height: 45, // Defina a altura desejada da imagem
                  fit: BoxFit.contain, // Ajuste o modo de ajuste da imagem conforme necessário
                ),
                SizedBox(height: 10), // Adicione algum espaçamento vertical entre os campos
                TextField(
                  controller: controller2,
                  decoration: InputDecoration(
                    labelText: 'Quantity',
                  ),
                ),
                SizedBox(height: 10), // Adicione algum espaçamento vertical entre os campos
                TextField(
                  controller: controller3,
                  decoration: InputDecoration(
                    labelText: 'Average purchase price',
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void updateCryptocurrencies(String newPortfolio) {
    setState(() {
      selectedPortfolio = newPortfolio;
      getCryptocurrenciesFromPortfolioToShow(newPortfolio);
    });
  }
}
