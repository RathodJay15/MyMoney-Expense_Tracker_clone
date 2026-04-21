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
    datePickerTheme: DatePickerThemeData(
      backgroundColor: Colors.white, // dialog bg
      rangePickerHeaderForegroundColor: Colors.black,

      headerHelpStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),

      headerBackgroundColor: Color.fromARGB(255, 66, 150, 144), // primary
      headerForegroundColor: Colors.white,

      dayForegroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.white;
        }
        return Colors.black;
      }),

      dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Color.fromARGB(255, 66, 150, 144); // selected day
        }
        return Colors.transparent;
      }),

      todayForegroundColor: WidgetStateProperty.all(
        Color.fromARGB(255, 66, 150, 144),
      ),

      todayBackgroundColor: WidgetStateProperty.all(Colors.transparent),

      weekdayStyle: TextStyle(
        color: Color.fromARGB(255, 0, 0, 0),
        fontWeight: FontWeight.bold,
      ),

      yearForegroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.black;
        }
        return Color.fromARGB(255, 0, 0, 0); // visible text
      }),

      yearBackgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Color.fromARGB(255, 66, 150, 144); // your primary
        }
        return Colors.transparent;
      }),

      yearOverlayColor: WidgetStateProperty.all(Colors.blue),

      dividerColor: Colors.grey,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),

    timePickerTheme: TimePickerThemeData(
      backgroundColor: Colors.white,

      hourMinuteColor: Color.fromARGB(255, 66, 150, 144),
      hourMinuteTextColor: Colors.white,

      dayPeriodColor: Color.fromARGB(255, 66, 150, 144),
      dayPeriodTextColor: Colors.white,

      dialBackgroundColor: Color.fromARGB(255, 224, 228, 228),
      dialHandColor: Color.fromARGB(255, 66, 150, 144),
      dialTextColor: Colors.black,

      entryModeIconColor: Colors.black,

      confirmButtonStyle: TextButton.styleFrom(
        foregroundColor: Color.fromARGB(255, 66, 150, 144),
      ),
      cancelButtonStyle: TextButton.styleFrom(
        foregroundColor: Color.fromARGB(255, 66, 150, 144),
      ),
      helpTextStyle: TextStyle(
        color: Color.fromARGB(255, 42, 124, 118),
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
  );
}
