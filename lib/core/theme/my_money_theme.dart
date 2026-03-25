import 'package:flutter/material.dart';
import 'package:mymoneyclone/core/constants/app_colors.dart';

class MyMoneyTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.lightBackground,
    colorScheme: const ColorScheme.light(
      primary: AppColors.lightPrimaryText,
      onPrimary: AppColors.lightBackground,
      surface: AppColors.lightBackground,
      onSurface: AppColors.lightPrimaryText,
      error: AppColors.lightExpense,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.lightBackground,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: AppColors.lightPrimaryText,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        fontFamily: 'Serif', // Custom font for the "MyMoney" feel
      ),
      iconTheme: IconThemeData(color: AppColors.lightPrimaryText),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.lightPrimaryText),
      bodyMedium: TextStyle(color: AppColors.lightPrimaryText),
      titleMedium: TextStyle(
        color: AppColors.lightPrimaryText,
        fontWeight: FontWeight.w600,
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.lightDivider,
      thickness: 1,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.lightBackground,
      selectedItemColor: AppColors.lightPrimaryText,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBackground,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.darkAccentGold,
      onSurfaceVariant: AppColors.darkLAccentGold,
      onPrimary: AppColors.darkLBackground,
      onInverseSurface: AppColors.darkIncome,
      surface: AppColors.darkBackground,
      onSurface: AppColors.darkPrimaryText,
      error: AppColors.darkExpense,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkBackground,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: AppColors.darkAccentGold,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: AppColors.darkPrimaryText),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.darkPrimaryText),
      bodyMedium: TextStyle(color: AppColors.darkPrimaryText),
      titleMedium: TextStyle(
        color: AppColors.darkAccentGold,
        fontWeight: FontWeight.w600,
      ),
    ),
    dividerTheme: DividerThemeData(
      color: Colors.white.withAlpha(10),
      thickness: 1,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.darkBackground,
      selectedItemColor: AppColors.darkAccentGold,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
    ),
  );
}
