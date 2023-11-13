import 'package:flutter/material.dart';
import 'package:zenith/constants/app_colors.dart';
import 'package:zenith/view/components/main_bottom_navigation_bar.dart';
import 'package:zenith/view/screens/home_screen_with_portfolio.dart';

class AlertScreen extends StatefulWidget {
  const AlertScreen({Key? key}) : super(key: key);

  @override
  State<AlertScreen> createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen> {
  int _currentIndex = 1; // Defina o índice atual conforme necessário

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreenWithPortfolio()));
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.secondaryBackgroundColor,
        title: Text('Price Alerts'),
      ),
      body: Container(
        color: AppColors.mainBackgroundColor,
      ),
      bottomNavigationBar: MainBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
