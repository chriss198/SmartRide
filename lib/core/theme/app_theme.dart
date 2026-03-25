import 'package:flutter/material.dart';

class AppTheme {
  static const Color brandOrange = Color(0xFFE94F1C);
  static const Color darkGrey = Color(0xFF3C3C3B);
  static const Color oledBlack = Colors.black;

  static ThemeData get dayTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: brandOrange),
        appBarTheme: const AppBarTheme(
          backgroundColor: darkGrey,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: brandOrange,
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(50),
          ),
        ),
      );

  static ThemeData get nightTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: oledBlack,
        colorScheme: ColorScheme.fromSeed(
          seedColor: brandOrange,
          brightness: Brightness.dark,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: oledBlack,
          foregroundColor: Colors.white,
        ),
      );
}
