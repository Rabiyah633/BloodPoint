import 'package:flutter/material.dart';
import '../core/constants/app_fonts.dart';
  // Create Text Style
  TextStyle createTextStyle({
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.normal,
    Color color = Colors.black,
    String fontFamily = AppFonts.sfPro,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }