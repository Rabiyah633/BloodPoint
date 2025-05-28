import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFFED213A);
  static const Color primaryDark = Color(0xFF93291E);
  
  // Secondary Colors
  static const Color secondary = Color(0xFF93291E);
  
  // Basic Colors
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color grey = Colors.grey;
  static const Color lightGrey = Color(0xFFF5F5F5);
  static const Color error = Colors.red;
  static const Color success = Colors.green;
  
  // Background Colors
  static const Color background = Color(0xFFF5F5F5);
  
  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFED213A),  // #ed213a
      Color(0xFF93291E),  // #93291e
    ],
  );
}