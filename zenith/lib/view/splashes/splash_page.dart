// ignore_for_file: prefer_const_constructors, unused_import

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: Text("Bem-vindo")
      ),
    );
  }
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
}