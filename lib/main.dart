import 'package:flutter/material.dart';
import 'package:mymoneyclone/core/theme/my_money_theme.dart';
import '/presentation/home_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: MyMoneyTheme.lightTheme,
      darkTheme: MyMoneyTheme.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: HomeScreen()),
    );
  }
}
