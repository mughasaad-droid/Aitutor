import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF9333EA),
        brightness: Brightness.light,
      ).copyWith(
        primary: const Color(0xFF1E293B), // Dark Slate for buttons/icons
        onPrimary: Colors.white,
        surface: Colors.white.withOpacity(0.9), // Semi-transparent cards
        onSurface: const Color(0xFF0F172A), // Almost black text
      ),
      scaffoldBackgroundColor: Colors.transparent, // Important for background
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Color(0xFF0F172A),
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xFF0F172A),
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Color(0xFF0F172A)),
        bodyMedium: TextStyle(color: Color(0xFF1E293B)),
        displayLarge: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.bold),
      ),
      cardTheme: CardThemeData(
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: Colors.white.withOpacity(0.85),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0F172A), // Dark buttons
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF3B82F6),
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: const Color(0xFF0F172A),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: const Color(0xFF1E293B),
      ),
    );
  }
}
