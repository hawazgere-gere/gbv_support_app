import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData mainTheme = ThemeData(
    colorScheme: const ColorScheme(
      primary: Color(0xFF7C4700), // Warm organic palette
      secondary: Color(0xFFA86700),
      background: Color(0xFFFEEEDA),
      surface: Color(0xFFFFF8E1),
      onPrimary: Color(0xFFFFFFFF),
      onSecondary: Color(0xFFFFFFFF),
      onSurface: Color(0xFF4E342E),
      onBackground: Color(0xFF4E342E),
      error: Colors.red,
      onError: Colors.white,
      brightness: Brightness.light,
    ),
    fontFamily: 'Roboto',
    useMaterial3: true,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}
