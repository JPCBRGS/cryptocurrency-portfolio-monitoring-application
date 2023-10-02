import 'package:flutter/material.dart';
import 'package:zenith/pages/home_page_without_main_sheet.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key); // Corrija o construtor

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreenWithoutMainSheet(),
    );
  }
}
