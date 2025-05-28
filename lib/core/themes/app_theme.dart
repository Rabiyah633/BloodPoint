import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/app_fonts.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.white,
        background: AppColors.background,
        error: AppColors.error,
        onPrimary: AppColors.white,
        onSecondary: AppColors.white,
        onSurface: AppColors.black,
        onBackground: AppColors.black,
        onError: AppColors.white,
      ),
      
      // App Bar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: TextStyle(
          fontFamily: AppFonts.raleway,
          fontSize: 20,
          fontWeight: AppFonts.bold,
          color: AppColors.white,
        ),
        iconTheme: IconThemeData(color: AppColors.white),
      ),
      
      // Text Theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: AppFonts.raleway,
          fontSize: 32,
          fontWeight: AppFonts.bold,
          color: AppColors.black,
        ),
        displayMedium: TextStyle(
          fontFamily: AppFonts.raleway,
          fontSize: 28,
          fontWeight: AppFonts.bold,
          color: AppColors.black,
        ),
        displaySmall: TextStyle(
          fontFamily: AppFonts.raleway,
          fontSize: 24,
          fontWeight: AppFonts.semiBold,
          color: AppColors.black,
        ),
        headlineLarge: TextStyle(
          fontFamily: AppFonts.raleway,
          fontWeight: AppFonts.bold,
          color: AppColors.black,
        ),
        headlineMedium: TextStyle(
          fontFamily: AppFonts.raleway,
          fontWeight: AppFonts.bold,
          color: AppColors.black,
        ),
        titleLarge: TextStyle(
          fontFamily: AppFonts.raleway,
          fontWeight: AppFonts.bold,
          color: AppColors.black,
        ),
        bodyLarge: TextStyle(
          fontFamily: AppFonts.sfPro,
          color: AppColors.black,
        ),
        bodyMedium: TextStyle(
          fontFamily: AppFonts.sfPro,
          color: AppColors.black,
        ),
        bodySmall: TextStyle(
          fontFamily: AppFonts.sfPro,
          fontSize: 12,
          fontWeight: AppFonts.regular,
          color: AppColors.grey,
        ),
        labelLarge: TextStyle(
          fontFamily: AppFonts.sfPro,
          fontSize: 16,
          fontWeight: AppFonts.medium,
          color: AppColors.white,
        ),
      ),
      
      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontFamily: AppFonts.sfPro,
            fontSize: 16,
            fontWeight: AppFonts.medium,
          ),
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: const TextStyle(
            fontFamily: AppFonts.sfPro,
            fontWeight: AppFonts.medium,
          ),
        ),
      ),
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightGrey,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintStyle: const TextStyle(
          fontFamily: AppFonts.sfPro,
          color: AppColors.grey,
        ),
        labelStyle: const TextStyle(
          fontFamily: AppFonts.sfPro,
          color: AppColors.grey,
        ),
      ),
      
      // Card Theme
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: AppColors.white,
      ),
      
      // Icon Theme
      iconTheme: const IconThemeData(
        color: AppColors.grey,
      ),
      primaryIconTheme: const IconThemeData(
        color: AppColors.white,
      ),
      
      // Progress Indicator Theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
      ),
      
      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.grey,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: TextStyle(
          fontFamily: AppFonts.sfPro,
          fontSize: 12,
          fontWeight: AppFonts.medium,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: AppFonts.sfPro,
          fontSize: 12,
        ),
      ),
      
      // Drawer Theme
      drawerTheme: const DrawerThemeData(
        backgroundColor: AppColors.white,
        elevation: 8,
      ),
      
      // FloatingActionButton Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
