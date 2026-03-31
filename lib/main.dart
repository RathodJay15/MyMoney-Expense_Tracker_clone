import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mymoneyclone/core/theme/my_money_theme.dart';
import 'package:mymoneyclone/data/database/db_helper.dart';
import '/presentation/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.obj.initDB();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: MyMoneyTheme.lightTheme,
      darkTheme: MyMoneyTheme.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: HomeScreen()),
    );
  }
}
