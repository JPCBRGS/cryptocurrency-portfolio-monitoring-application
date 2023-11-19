import 'package:flutter/material.dart';
import 'package:zenith/constants/app_colors.dart';
import 'package:zenith/view/screens/alert_screen.dart';
import 'package:zenith/view/screens/blockchain_data_screen.dart';
import 'package:zenith/view/screens/home_screen_with_portfolio.dart';

class MainBottomNavigationBar extends StatelessWidget {
  final int currentIndex;

  const MainBottomNavigationBar({
    Key? key,
    required this.currentIndex,
  }) : super(key: key);

  void _onItemTapped(int index, BuildContext context) {
    if (index == 0) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomeScreenWithPortfolio()));
    }

    if (index == 1) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AlertScreen()));
    } 

    if (index == 2) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const BlockchainDataScreen()));
    }
    else {
      // Adicione qualquer lógica adicional aqui, se necessário.
      // Por exemplo, você pode querer realizar alguma ação específica ao tocar em outros ícones.
      // Se não for necessário, você pode remover este bloco else.
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: AppColors.secondaryBackgroundColor,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: 'Alerts',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Search',
        ),
      ],
      selectedItemColor: AppColors.selectedItemColor,
      unselectedItemColor: Colors.white,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      currentIndex: currentIndex,
      onTap: (index) => _onItemTapped(index, context),
    );
  }
}
