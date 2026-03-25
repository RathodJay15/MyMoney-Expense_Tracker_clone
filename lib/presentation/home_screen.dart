import 'package:flutter/material.dart';
import 'package:mymoneyclone/core/constants/app_constants.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
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
            Center(child: Text("fasdfsdfaf")),
            Center(child: Text("fasdfsdfaf")),
            Center(child: Text("fasdfsdfaf")),
            Center(child: Text("fasdfsdfaf")),
          ],
        ),
        floatingActionButton: InkWell(
          onTap: () {},
          child: Container(
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
            child: Icon(
              Iconsax.add_circle,
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
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Iconsax.receipt),
              label: AppConstants.records,
            ),
            BottomNavigationBarItem(
              icon: Icon(Iconsax.chart_1),
              label: AppConstants.analysis,
            ),
            BottomNavigationBarItem(
              icon: Icon(Iconsax.wallet_1),
              label: AppConstants.budgets,
            ),
            BottomNavigationBarItem(
              icon: Icon(Iconsax.bank),
              label: AppConstants.accounts,
            ),
            BottomNavigationBarItem(
              icon: Icon(Iconsax.category_2),
              label: AppConstants.categories,
            ),
          ],
        ),
      ),
    );
  }
}
