import 'dart:ui';

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
import 'package:zenith/view/screens/home_screen_without_portfolio.dart';

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
                    width: MediaQuery.of(context).size.width * 0.125,
                    height: MediaQuery.of(context).size.height * 0.0625,
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
                    width: MediaQuery.of(context).size.width * 0.125,
                    height: MediaQuery.of(context).size.height * 0.0625,
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
                    width: MediaQuery.of(context).size.width * 0.125,
                    height: MediaQuery.of(context).size.height * 0.0625,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.redAccent,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.delete),
                      color: Colors.white,
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: AppColors.secondaryBackgroundColor,
                                title: Text(
                                  'Confirm portfolio deletion',
                                  style: FontStyles.montserratStyle(20),
                                ),
                                content:
                                    Text('Are you sure you want to delete your "${selectedPortfolio}" portfolio?', style: FontStyles.montserratStyle(15)),
                                actions: [
                                  // Botão para cancelar
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(); // Fechar o diálogo
                                    },
                                    child: Text('Cancel', style: FontStyles.montserratStyle(15)),
                                  ),
                                  // Botão para confirmar a exclusão
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(); // Fechar o diálogo
                                      deleteCurrentPortfolio(selectedPortfolio!);
                                    },
                                    child: Text('Confirm', style: FontStyles.montserratStyle(15)),
                                  ),
                                ],
                              );
                            });
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
                        String currentPortfolioValueForCoin = (double.parse(coinCurrentPrice!) * cryptocurrencies[index].quantity).toStringAsFixed(4);
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
                                        width: MediaQuery.of(context).size.width * 0.1, // Defina a largura desejada da imagem
                                        height: MediaQuery.of(context).size.width * 0.1, // Defina a altura desejada da imagem
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
                                      'U\$ $currentPortfolioValueForCoin', // Usando "${coinCurrentPrice ?? ""}" para lidar com o caso em que coinCurrentPrice é nulo
                                      style: FontStyles.montserratStyle(22),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            changeSelectedCurrencyDialog(cryptocurrencies[index].quantity.toString(), cryptocurrencies[index].averagePurchasePrice.toString(), currentPortfolioValueForCoin, symbolLowerCase);
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

  void addNewCurrencyDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            color: AppColors.mainBackgroundColor,
            height: MediaQuery.of(context).size.height * 0.55,
            width: MediaQuery.of(context).size.width * 0.8,
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Text(
                    'Add new token',
                    style: FontStyles.montserratStyle(18, color: Colors.white),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03125),
                TextField(
                  controller: controller1,
                  style: FontStyles.montserratStyle(15, color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Symbol',
                    labelStyle: FontStyles.montserratStyle(15, color: Colors.white),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03125),
                TextField(
                  controller: controller2,
                  style: FontStyles.montserratStyle(15, color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Quantity',
                    labelStyle: FontStyles.montserratStyle(15, color: Colors.white),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03125),
                TextField(
                  controller: controller3,
                  style: FontStyles.montserratStyle(15, color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Average purchase price',
                    labelStyle: FontStyles.montserratStyle(15, color: Colors.white),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.0625),
                ElevatedButton(
                  onPressed: () async {
                    Cryptocurrency cryptocurrencyToInsert = Cryptocurrency(
                        portfolio: selectedPortfolio!,
                        symbol: controller1.text.toString(),
                        quantity: double.parse(controller2.text.toString()),
                        averagePurchasePrice: double.parse(controller3.text.toString()));
                    await cryptocurrencyHelper.insertCryptocurrency(cryptocurrencyToInsert);
                    setState(() {
                      getCryptocurrenciesFromPortfolioToShow(selectedPortfolio!);
                    });
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondaryBackgroundColor,
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    "Confirm",
                    style: FontStyles.montserratStyle(15, color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void changeSelectedCurrencyDialog(String ownedAmount, String averagePurchasePrice, String currentPortfolioValueForCoin, String symbolLowerCase) {
    String? coinImage;
    String? coinName;
    String? coinPrice;
    String? priceVariation;
    String? coinMarketCap;
    String symbolUpperCase = symbolLowerCase.toUpperCase();
    MaterialColor priceVariationColor;
    coinImage = coinsListHelper.getCoinImageBySymbol(symbolLowerCase);
    coinName = coinsListHelper.getCoinNameBySymbol(symbolLowerCase);
    coinPrice = coinsListHelper.getCoinPriceBySymbol(symbolLowerCase);
    coinMarketCap = coinsListHelper.getCoinMarketCapBySymbol(symbolLowerCase);
    priceVariation = coinsListHelper.getCoinPriceVariationPercentageLastDayBySymbol(symbolLowerCase);

    double.parse(priceVariation!) >= 0 ? priceVariationColor = Colors.green : priceVariationColor = Colors.red;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            color: AppColors.mainBackgroundColor,
            height: MediaQuery.of(context).size.height * 0.65,
            width: MediaQuery.of(context).size.width * 0.95,
            padding: EdgeInsets.all(16), // Adicione algum espaçamento interno, se desejar
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      Image.network(
                        coinImage!,
                        width: 50, // Defina a largura desejada da imagem
                        height: 50, // Defina a altura desejada da imagem
                        fit: BoxFit.contain, // Ajuste o modo de ajuste da imagem conforme necessário
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.0125),
                      Text(
                        "$coinName ($symbolUpperCase)",
                        style: FontStyles.montserratStyle(20),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03125),
                Row(
                  children: [
                    Text(
                      "Owned amount:",
                      style: FontStyles.montserratStyle(15),
                    ),
                    Spacer(),
                    Text(
                      ownedAmount!,
                      style: FontStyles.montserratStyle(15),
                    )
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03125),
                Row(
                  children: [
                    Text(
                      "Current price:",
                      style: FontStyles.montserratStyle(15),
                    ),
                    Spacer(),
                    Text(
                      "U\$ $coinPrice",
                      style: FontStyles.montserratStyle(15),
                    )
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03125),
                Row(
                  children: [
                    Text(
                      "Average purchase price:",
                      style: FontStyles.montserratStyle(15),
                    ),
                    Spacer(),
                    Text(
                      "U\$ $averagePurchasePrice",
                      style: FontStyles.montserratStyle(15),
                    )
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03125),
                Row(
                  children: [
                    Text(
                      "Total portfolio value:",
                      style: FontStyles.montserratStyle(15),
                    ),
                    Spacer(),
                    Text(
                      "U\$ $currentPortfolioValueForCoin",
                      style: FontStyles.montserratStyle(15),
                    )
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03125),
                Row(
                  children: [
                    Text(
                      "Market cap:",
                      style: FontStyles.montserratStyle(15),
                    ),
                    Spacer(),
                    Text(
                      "U\$ $coinMarketCap",
                      style: FontStyles.montserratStyle(15),
                    )
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03125),
                Row(
                  children: [
                    Text(
                      "Price variation (24 hours):",
                      style: FontStyles.montserratStyle(15),
                    ),
                    Spacer(),
                    Text(
                      "$priceVariation %",
                      style: FontStyles.montserratStyle(15, color: priceVariationColor),
                    )
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03125),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        // Lógica para o botão "Add"
                        // Adicione a lógica desejada quando o botão "Add" for pressionado
                      },
                      iconSize: 30, // Ajuste o tamanho do ícone conforme necessário
                      color: Colors.white,
                    ),

                    // Espaçamento entre os botões
                    Spacer(),

                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        // Lógica para o botão "Subtract"
                        // Adicione a lógica desejada quando o botão "Subtract" for pressionado
                      },
                      iconSize: 30, // Ajuste o tamanho do ícone conforme necessário
                      color: Colors.white,
                    ),

                    Spacer(),

                    IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        // Lógica para o botão "Remove all"
                        // Adicione a lógica desejada quando o botão "Remove all" for pressionado
                      },
                      iconSize: 30, // Ajuste o tamanho do ícone conforme necessário
                      color: Colors.white,
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                ElevatedButton(
                  child: Text(
                    "New alert",
                    style: FontStyles.montserratStyle(15, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondaryBackgroundColor,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    minimumSize:
                        Size(MediaQuery.of(context).size.width * 0.75, MediaQuery.of(context).size.height * 0.05), // Tamanho mínimo do botão "Add"
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void dropCoinDialog()
  {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            color: AppColors.mainBackgroundColor,
            height: MediaQuery.of(context).size.height * 0.55,
            width: MediaQuery.of(context).size.width * 0.8,
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Text(
                    'Add new token',
                    style: FontStyles.montserratStyle(18, color: Colors.white),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03125),
                TextField(
                  controller: controller1,
                  style: FontStyles.montserratStyle(15, color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Symbol',
                    labelStyle: FontStyles.montserratStyle(15, color: Colors.white),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03125),
                TextField(
                  controller: controller2,
                  style: FontStyles.montserratStyle(15, color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Quantity',
                    labelStyle: FontStyles.montserratStyle(15, color: Colors.white),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03125),
                TextField(
                  controller: controller3,
                  style: FontStyles.montserratStyle(15, color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Average purchase price',
                    labelStyle: FontStyles.montserratStyle(15, color: Colors.white),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.0625),
                ElevatedButton(
                  onPressed: () async {
                    Cryptocurrency cryptocurrencyToInsert = Cryptocurrency(
                        portfolio: selectedPortfolio!,
                        symbol: controller1.toString(),
                        quantity: double.parse(controller2.toString()),
                        averagePurchasePrice: double.parse(controller3.toString()));
                    await cryptocurrencyHelper.insertCryptocurrency(cryptocurrencyToInsert);
                    setState(() {
                      getCryptocurrenciesFromPortfolioToShow(selectedPortfolio!);
                    });
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondaryBackgroundColor,
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    "Confirm",
                    style: FontStyles.montserratStyle(15, color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> getCryptocurrenciesFromPortfolioToShow(String portfolio) async {
    var cryptocurrenciesAux = await cryptocurrencyHelper.getCryptocurrenciesFromPortfolio(portfolio);
    setState(() {
      cryptocurrencies = cryptocurrenciesAux;
    });
  }

  void updateCryptocurrencies(String newPortfolio) {
    setState(() {
      selectedPortfolio = newPortfolio;
      getCryptocurrenciesFromPortfolioToShow(newPortfolio);
    });
  }

  Future<void> deleteCurrentPortfolio(String portfolio) async {
    await cryptocurrencyHelper.deleteCryptocurrencyPortfolio(portfolio);
    var portfoliosAfterDeletion = await cryptocurrencyHelper.getPortfoliosOrderedByCryptocurrencies();

    setState(() {
      if (portfoliosAfterDeletion.isEmpty) {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreenWithoutPortfolio()));
      } else {
        selectedPortfolio = portfoliosAfterDeletion[0];
        portfolios = portfoliosAfterDeletion;
        loadData();
      }
    });
  }
}
