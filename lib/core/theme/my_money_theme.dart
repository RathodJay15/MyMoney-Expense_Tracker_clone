import 'package:flutter/material.dart';
import 'package:mymoneyclone/core/constants/app_colors.dart';

class MyMoneyTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: AppColors.lightPrimaryText,
      onPrimary: AppColors.lightBackground,
      surface: AppColors.lightBackground,
      onSurface: AppColors.lightPrimaryText,
      error: AppColors.lightExpense,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.darkAccentGold,
      onSurfaceVariant: AppColors.darkLAccentGold,
      onPrimary: AppColors.darkLBackground,
      onInverseSurface: AppColors.darkIncome,
      surface: AppColors.darkBackground,
      onSurface: AppColors.darkPrimaryText,
      error: AppColors.darkExpense,
    ),
  );
}
