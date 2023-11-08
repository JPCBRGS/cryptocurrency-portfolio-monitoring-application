import 'package:flutter/material.dart';
import 'package:zenith/constants/app_colors.dart';

class HomeScreenWithPortfolio extends StatefulWidget {
  const HomeScreenWithPortfolio({super.key});

  @override
  State<HomeScreenWithPortfolio> createState() => _HomeScreenWithPortfolioState();
}

class _HomeScreenWithPortfolioState extends State<HomeScreenWithPortfolio> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBackgroundColor,
      appBar: AppBar(),
      body: Container(),
    );
  }
}