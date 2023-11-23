import 'package:flutter/material.dart';
import 'package:zenith/constants/app_colors.dart';
import 'package:zenith/constants/font_styles.dart';
import 'package:zenith/view/components/main_bottom_navigation_bar.dart';

class BlockchainDataScreen extends StatefulWidget {
  const BlockchainDataScreen({super.key});

  @override
  State<BlockchainDataScreen> createState() => _BlockchainDataScreenState();
}

class _BlockchainDataScreenState extends State<BlockchainDataScreen> {
  int _currentIndex = 2; // Defina o índice atual conforme necessário

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.secondaryBackgroundColor,
        title: Text(
          'Blockchain Data',
          style: FontStyles.montserratStyle(18),
        ),
      ),
      body: Container(
        color: AppColors.mainBackgroundColor,
      ),
      bottomNavigationBar: MainBottomNavigationBar(
        currentIndex: _currentIndex,
      ),
    );
  }
}

class _currentIndex {
}