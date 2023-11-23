import 'package:flutter/material.dart';
import 'package:zenith/constants/app_colors.dart';
import 'package:zenith/constants/font_styles.dart';
import 'package:zenith/view/components/main_bottom_navigation_bar.dart';
import 'package:zenith/view/screens/home_screen_with_portfolio.dart';

class AlertScreen extends StatefulWidget {
  const AlertScreen({Key? key}) : super(key: key);

  @override
  State<AlertScreen> createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen> {
  int _currentIndex = 1; // Defina o índice atual conforme necessário

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.secondaryBackgroundColor,
        title: Text(
          'Alerts',
          style: FontStyles.montserratStyle(18),
        ),
        actions: [
          IconButton(
            onPressed: (){}, 
            icon: Icon(
              Icons.notifications,
              color: Colors.yellow,
            ),
          ),
        ],
      ),
      body: Container(
        color: AppColors.mainBackgroundColor,
      ),
      bottomNavigationBar: MainBottomNavigationBar(
        currentIndex: _currentIndex,
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 70),
        child: FloatingActionButton(
          onPressed: () {
            // Add your functionality when the button is pressed
          },
          backgroundColor: AppColors.secondaryBackgroundColor, // Set the background color as needed
          child: const Icon(Icons.add), // You can change the icon as needed
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
    );
  }
}
