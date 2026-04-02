import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mymoneyclone/core/constants/app_constants.dart';
import 'package:mymoneyclone/core/theme/my_money_theme.dart';
import 'package:mymoneyclone/data/models/accounts_model.dart';
import 'package:mymoneyclone/data/models/budget_model.dart';
import 'package:mymoneyclone/data/models/category_model.dart';
import 'package:mymoneyclone/data/models/records_model.dart';
import 'package:mymoneyclone/data/models/type_model.dart';
import 'package:mymoneyclone/data/services/hive_default_vals.dart';
import '/presentation/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(CategoryModelAdapter());
  Hive.registerAdapter(AccountModelAdapter());
  Hive.registerAdapter(RecordModelAdapter());
  Hive.registerAdapter(BudgetModelAdapter());
  Hive.registerAdapter(TypeModelAdapter());

  await Hive.openBox<AccountModel>(AppConstants.accountHiveBox);
  await Hive.openBox<CategoryModel>(AppConstants.categoryHiveBox);
  await Hive.openBox<RecordModel>(AppConstants.recordHiveBox);
  await Hive.openBox<BudgetModel>(AppConstants.budgetHiveBox);
  await Hive.openBox<TypeModel>(AppConstants.typeHiveBox);

  await HiveDefaultVals.defaultVals();

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
