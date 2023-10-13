import 'package:flutter/material.dart';
import 'package:zenith/databases/database_helper.dart';
import 'package:zenith/screens/home_screen_without_main_sheet.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Garante que o Flutter esteja inicializado

  final dbHelper = DatabaseHelper.instance; // Inicialize seu DatabaseHelper
  await dbHelper.database; // Inicialize o banco de dados

  dbHelper.copyFileToExternalStorage();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreenWithoutMainSheet(),
    );
  }
}
