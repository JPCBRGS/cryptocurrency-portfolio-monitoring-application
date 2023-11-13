import 'package:flutter/material.dart';
import 'package:zenith/constants/app_colors.dart';
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
      ),
      drawer: Drawer(
        // Adicione itens ao Drawer conforme necessário
      ),
      body: Container(), // Corpo da tela principal
      bottomNavigationBar: MainBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
