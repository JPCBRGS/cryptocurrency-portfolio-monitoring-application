import 'package:flutter/material.dart';
import 'package:zenith/helpers/blockchain_helper.dart';
import 'package:zenith/helpers/coins_list_helper.dart';
import 'package:zenith/helpers/database_helper.dart';
import 'package:zenith/view/splashes/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DatabaseHelper dbHelper = await DatabaseHelper.instance;
  CoinsListHelper coinsListHelper = await CoinsListHelper();
  await coinsListHelper.copyCoinsListFileToExternalStorage();
  await dbHelper.copyDatabaseFileToExternalStorage();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Zenith',
      home: SplashPage(),
    );
  }
}
