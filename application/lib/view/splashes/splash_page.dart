import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:zenith/constants/app_colors.dart'; // Importe o arquivo appColors.dart
import 'package:zenith/constants/font_styles.dart';
import 'package:zenith/helpers/cryptocurrency_helper.dart';
import 'package:zenith/helpers/database_helper.dart';
import 'package:zenith/view/screens/home_screen_with_portfolio.dart';
import 'package:zenith/view/screens/home_screen_without_portfolio.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform.scale(
              scale: 0.6,
              child: Image.asset('assets/images/blockchain-icon.png'),
            ),
            ShaderMask(
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                  colors: [const Color.fromARGB(255, 120, 190, 245), const Color.fromARGB(255, 255, 145, 180)],
                ).createShader(bounds);
              },
              child: Text(
                "Welcome!",
                style: FontStyles.montserratStyle(24, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    hasPortfolio();
  }

  Future<void> hasPortfolio() async {
    final _log = Logger();
    final dbHelper = DatabaseHelper.instance;
    final database = await dbHelper.database;
    CryptocurrencyHelper cryptocurrencyHelper = CryptocurrencyHelper(database);
    int portfolioCount = await cryptocurrencyHelper.countDistinctPortfolios();
    bool hasPortfolios = portfolioCount > 0 ? true : false;
    _log.i('Número de portfólios: $portfolioCount');
    if (!hasPortfolios) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreenWithoutPortfolio()));
    } else {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreenWithPortfolio()));
    }
  }
}
