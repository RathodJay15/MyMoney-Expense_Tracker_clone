import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:mymoneyclone/core/constants/app_constants.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:mymoneyclone/presentation/accounts_screen.dart';
import 'package:mymoneyclone/presentation/add_record_screen.dart';
import 'package:mymoneyclone/presentation/analysis_screen.dart';
import 'package:mymoneyclone/presentation/budget_screen.dart';
import 'package:mymoneyclone/presentation/categories_screen.dart';
import 'package:mymoneyclone/presentation/records_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  void _addNewRecord() {
    Get.to(AddRecordScreen());
  }

  @override
  Widget build(BuildContext) {
    return Scaffold(
      body: Scaffold(
        drawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(child: Text('Menu')),
              ListTile(title: Text('Home')),
            ],
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                toolbarHeight: 40,
                snap: true,
                floating: true,
                backgroundColor: Theme.of(context).colorScheme.onPrimary,
                surfaceTintColor: Colors.transparent,
                centerTitle: false,
                iconTheme: IconThemeData(
                  color: Theme.of(context).colorScheme.primary,
                ),

                title: Text(
                  AppConstants.myMoney,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                actions: [
                  Icon(
                    Icons.search,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  SizedBox(width: 10),
                ],
              ),

              _selectedIndex == 0 || _selectedIndex == 1
                  ? _recordsAnalysisAppbar()
                  : SliverToBoxAdapter(child: SizedBox()),

              _selectedIndex == 2
                  ? _budgetAppBar()
                  : SliverToBoxAdapter(child: SizedBox()),

              _selectedIndex == 3 || _selectedIndex == 4
                  ? _accountsCategoryAppBar()
                  : SliverToBoxAdapter(child: SizedBox()),

              SliverFillRemaining(
                child: IndexedStack(
                  index: _selectedIndex,
                  children: [
                    RecordsScreen(),
                    AnalysisScreen(),
                    BudgetScreen(),
                    AccountsScreen(),
                    CategoriesScreen(),
                  ],
                ),
              ),
            ],
          ),
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
            onPressed: _addNewRecord,
            icon: Icon(
              Iconsax.add_circle_copy,
              color: Theme.of(context).colorScheme.primary,
              size: 35,
            ),
          ),
        ),
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(
          context,
        ).copyWith(canvasColor: Theme.of(context).colorScheme.onPrimary),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Theme.of(context).colorScheme.onSurfaceVariant,
          selectedIconTheme: IconThemeData(size: 30),
          // selectedFontSize: 12,
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

  SliverAppBar _recordsAnalysisAppbar() {
    return SliverAppBar(
      toolbarHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      automaticallyImplyLeading: false,
      iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
      title: Container(
        padding: EdgeInsets.fromLTRB(16, 10, 16, 12),
        width: double.infinity,
        color: Theme.of(context).colorScheme.onPrimary,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Iconsax.arrow_circle_left_copy,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                      ),

                      Text(
                        "March, 2026",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Iconsax.arrow_circle_right_copy,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  flex: 0,
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(Iconsax.sort_copy),
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),

            SizedBox(height: 15),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _recordsAnalysisAppbarItem(
                  AppConstants.expense,
                  "₹5,738.00",
                  Theme.of(context).colorScheme.error,
                ),
                _recordsAnalysisAppbarItem(
                  AppConstants.income,
                  "₹500.00",
                  Theme.of(context).colorScheme.onInverseSurface,
                ),
                _recordsAnalysisAppbarItem(
                  AppConstants.total,
                  "-₹5,238.00",
                  Theme.of(context).colorScheme.error,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _recordsAnalysisAppbarItem(String title, String amount, Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(
          amount,
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  SliverAppBar _budgetAppBar() {
    return SliverAppBar(
      toolbarHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      automaticallyImplyLeading: false,
      iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
      title: Container(
        padding: EdgeInsets.fromLTRB(16, 10, 16, 12),
        width: double.infinity,
        color: Theme.of(context).colorScheme.onPrimary,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Iconsax.arrow_circle_left_copy,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),

                Text(
                  "March, 2026",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Iconsax.arrow_circle_right_copy,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
              ],
            ),

            SizedBox(height: 15),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _budgetAppBarItem(
                  AppConstants.totalBudget,
                  "₹5,738.00",
                  Theme.of(context).colorScheme.onSurfaceVariant,
                ),

                _budgetAppBarItem(
                  AppConstants.totalSpent,
                  "-₹5,238.00",
                  Theme.of(context).colorScheme.error,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _budgetAppBarItem(String title, String amount, Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(
          amount,
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  SliverAppBar _accountsCategoryAppBar() {
    return SliverAppBar(
      toolbarHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      automaticallyImplyLeading: false,
      iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
      title: Container(
        padding: EdgeInsets.fromLTRB(16, 10, 16, 12),
        width: double.infinity,
        color: Theme.of(context).colorScheme.onPrimary,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              AppConstants.allAccounts(10000),
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _accountsCategoryAppBarItem(
                  AppConstants.expenseSoFar,
                  "₹5,738.00",
                  Theme.of(context).colorScheme.error,
                ),

                _accountsCategoryAppBarItem(
                  AppConstants.incomeSoFar,
                  "-₹5,238.00",
                  Theme.of(context).colorScheme.onInverseSurface,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _accountsCategoryAppBarItem(String title, String amount, Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(
          amount,
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
