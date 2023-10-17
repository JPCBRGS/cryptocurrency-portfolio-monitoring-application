import 'package:flutter/material.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:zenith/data/cryptocurrency_helper.dart';
import 'package:zenith/databases/database_helper.dart';
import 'package:zenith/screens/home_screen_without_portfolios.dart';

class HomeScreen extends StatelessWidget {
  final int portfolioCount;
  final DatabaseHelper dbHelper;

  const HomeScreen({Key? key, required this.dbHelper, required this.portfolioCount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (portfolioCount <= 0) {
      return HomeScreenWithoutPortfolios(dbHelper: dbHelper);
    } else {
      return HomeScreenWithoutPortfolios(dbHelper: dbHelper);
    }
  }
}
