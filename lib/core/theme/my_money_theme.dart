import 'package:flutter/material.dart';

class MyMoneyTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: Color.fromARGB(255, 66, 150, 144), // Ligth Green
      onPrimary: Color.fromARGB(255, 42, 124, 118), // Dark Green
      primaryContainer: Color.fromARGB(255, 0, 0, 0), // Black
      surface: Color.fromARGB(255, 158, 158, 158), // Grey
      onSecondary: Color.fromARGB(255, 224, 228, 228), // Light Grey
      onSurface: Color.fromARGB(255, 255, 255, 255), // White
      onInverseSurface: Color.fromARGB(255, 27, 161, 0), // Green
      error: Color.fromARGB(255, 209, 0, 0), // Red
      inversePrimary: Color.fromARGB(255, 13, 50, 255),
    ),
  );
}
