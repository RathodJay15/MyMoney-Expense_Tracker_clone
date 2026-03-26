import 'package:flutter/material.dart';
import 'package:mymoneyclone/core/constants/app_constants.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:mymoneyclone/presentation/accounts_screen.dart';
import 'package:mymoneyclone/presentation/analysis_screen.dart';
import 'package:mymoneyclone/presentation/budget_screen.dart';
import 'package:mymoneyclone/presentation/categories_screen.dart';
import 'package:mymoneyclone/presentation/records_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext) {
    return SafeArea(
      child: Scaffold(
        drawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(child: Text('Menu')),
              ListTile(title: Text('Home')),
            ],
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: IndexedStack(
          index: _selectedIndex,
          children: [
            RecordsScreen(),
            AnalysisScreen(),
            BudgetScreen(),
            AccountsScreen(),
            CategoriesScreen(),
          ],
        ),
        floatingActionButton: Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onPrimary,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(47, 0, 0, 0),
                blurRadius: 5,
                spreadRadius: 3,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: IconButton(
            onPressed: () {},
            icon: Icon(
              Iconsax.add_circle_copy,
              color: Theme.of(context).colorScheme.primary,
              size: 35,
            ),
          ),
        ),

        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
          currentIndex: _selectedIndex,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Theme.of(context).colorScheme.onSurfaceVariant,
          selectedIconTheme: IconThemeData(size: 30),
          onTap: (index) => setState(() => _selectedIndex = index),
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                _selectedIndex == 0
                    ? Iconsax.receipt_2_1
                    : Iconsax.receipt_2_1_copy,
              ),
              label: AppConstants.records,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                _selectedIndex == 1 ? Iconsax.chart_3 : Iconsax.chart_1_copy,
              ),
              label: AppConstants.analysis,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                _selectedIndex == 2
                    ? Iconsax.calculator
                    : Iconsax.calculator_copy,
              ),
              label: AppConstants.budgets,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                _selectedIndex == 3 ? Iconsax.wallet : Iconsax.wallet_1_copy,
              ),
              label: AppConstants.accounts,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                _selectedIndex == 4
                    ? Iconsax.category_2
                    : Iconsax.category_2_copy,
              ),
              label: AppConstants.categories,
            ),
          ],
        ),
      ),
    );
  }
}
