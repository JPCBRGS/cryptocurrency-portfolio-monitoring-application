import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FontStyles {
  static TextStyle montserratStyle(double fontSize, {Color color = Colors.white}) {
    return GoogleFonts.montserrat(
      textStyle: TextStyle(
        fontSize: fontSize,
        color: color,
      ),
    );
  }
}