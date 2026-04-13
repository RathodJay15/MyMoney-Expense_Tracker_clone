import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mymoneyclone/controllers/accounts_controller.dart';
import 'package:mymoneyclone/controllers/records_controller.dart';
import 'package:mymoneyclone/core/constants/app_constants.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:mymoneyclone/presentation/old_screens/accounts_screen.dart';
import 'package:mymoneyclone/presentation/old_screens/add_record_screen.dart';
import 'package:mymoneyclone/presentation/old_screens/analysis_screen.dart';
import 'package:mymoneyclone/presentation/old_screens/budget_screen.dart';
import 'package:mymoneyclone/presentation/old_screens/categories_screen.dart';
import 'package:mymoneyclone/presentation/old_screens/records_screen.dart';

class HomeScreenOld extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreenOld>
    with SingleTickerProviderStateMixin {
  RecordsController recordsController = Get.find();
  AccountsController accountsController = Get.find();

  int _selectedIndex = 0;

  void _addNewRecord() {
    Get.to(AddRecordScreen(oldRecord: null));
  }

  @override
  Widget build(BuildContext) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      drawer: Drawer(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        child: ListView(
          children: [
            ListTile(
              title: Text(
                AppConstants.myMoney,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Iconsax.setting_2_copy,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              title: Text(
                "Preferences",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Iconsax.document_download_copy,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              title: Text(
                "Export records",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Iconsax.save_2_copy,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              title: Text(
                "Backup & Restore",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Iconsax.trash_copy,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              title: Text(
                "Delete & Reset",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Iconsax.star_copy,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              title: Text(
                "Pro version",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Iconsax.like_1_copy,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              title: Text(
                "Like MyMoney",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Iconsax.info_circle_copy,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              title: Text(
                "Help",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Iconsax.send_2_copy,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              title: Text(
                "Feedback",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
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
      title: Obx(() {
        String showTotel = recordsController.showTotal.value;
        String income = AppConstants.amount(
          recordsController.totalIncome.value,
        );
        String expense = AppConstants.amount(
          recordsController.totalExpense.value,
        );
        String total = AppConstants.amount(
          recordsController.totalBalance.value,
        );
        return Container(
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
                          onPressed: () {
                            recordsController.previousPeriod();
                          },
                          icon: Icon(
                            Iconsax.arrow_circle_left_copy,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                        ),

                        Text(
                          recordsController.getFormattedHeaderDate(),
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            recordsController.nextPeriod();
                          },
                          icon: Icon(
                            Iconsax.arrow_circle_right_copy,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 0,
                    child: IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return FilterDialog();
                          },
                        );
                      },
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
                    expense,
                    Theme.of(context).colorScheme.error,
                  ),
                  _recordsAnalysisAppbarItem(
                    AppConstants.income,
                    income,
                    Theme.of(context).colorScheme.onInverseSurface,
                  ),

                  if (showTotel == AppConstants.yes)
                    _recordsAnalysisAppbarItem(
                      AppConstants.total,
                      total,
                      recordsController.totalBalance.value >= 0
                          ? Theme.of(context).colorScheme.onInverseSurface
                          : Theme.of(context).colorScheme.error,
                    ),
                ],
              ),
            ],
          ),
        );
      }),
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
      title: Obx(() {
        final accountsBalanceTotal =
            accountsController.accountBalanceTotal.value;
        final expenseSofar = recordsController.totalExpenseSofar.value;
        final incomeSofar = recordsController.totalIncomeSofar.value;
        return Container(
          padding: EdgeInsets.fromLTRB(16, 10, 16, 12),
          width: double.infinity,
          color: Theme.of(context).colorScheme.onPrimary,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                AppConstants.allAccounts(accountsBalanceTotal),
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
                    AppConstants.amount(expenseSofar),
                    Theme.of(context).colorScheme.error,
                  ),

                  _accountsCategoryAppBarItem(
                    AppConstants.incomeSoFar,
                    AppConstants.amount(incomeSofar),
                    Theme.of(context).colorScheme.onInverseSurface,
                  ),
                ],
              ),
            ],
          ),
        );
      }),
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

class FilterDialog extends StatelessWidget {
  RecordsController recordsController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppConstants.displayOptions,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                dialogTitle(AppConstants.viewMode, context),
                SizedBox(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    modeValue(context, AppConstants.daily),
                    modeValue(context, AppConstants.weekly),
                    modeValue(context, AppConstants.monthly),
                    modeValue(context, AppConstants.threeMonths),
                    modeValue(context, AppConstants.sixMonths),
                    modeValue(context, AppConstants.yearly),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                dialogTitle(AppConstants.showTotal, context),
                SizedBox(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    totalValue(context, AppConstants.yes),
                    totalValue(context, AppConstants.no),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                dialogTitle(AppConstants.carryOver, context),
                SizedBox(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    surplusValue(context, AppConstants.on),
                    surplusValue(context, AppConstants.off),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Iconsax.info_circle_copy,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurfaceVariant.withAlpha(150),
                ),
                SizedBox(width: 5),
                SizedBox(
                  width: 280,
                  child: Text(
                    AppConstants.carryOverMsg,
                    maxLines: 3,
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurfaceVariant.withAlpha(120),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget dialogTitle(String text, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget modeValue(BuildContext context, String text) {
    return Obx(() {
      String mode = recordsController.selectedMode.value;
      return Padding(
        padding: const EdgeInsets.all(4.0),
        child: InkWell(
          splashColor: Theme.of(
            context,
          ).colorScheme.onSurfaceVariant.withAlpha(50),
          onTap: () {
            if (text == AppConstants.threeMonths ||
                text == AppConstants.sixMonths ||
                text == AppConstants.yearly)
              return;
            recordsController.changeMode(text);
          },
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: SizedBox(
              width: 125,
              child: Row(
                children: [
                  if (mode == text)
                    Icon(
                      Iconsax.tick_circle_copy,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      size: 18,
                    ),
                  SizedBox(width: 4),
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 18,
                      color: mode == text
                          ? Theme.of(context).colorScheme.onSurfaceVariant
                          : Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant.withAlpha(120),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget totalValue(BuildContext context, String text) {
    return Obx(() {
      String total = recordsController.showTotal.value;
      return Padding(
        padding: const EdgeInsets.all(4.0),
        child: InkWell(
          splashColor: Theme.of(
            context,
          ).colorScheme.onSurfaceVariant.withAlpha(50),
          onTap: () {
            recordsController.toggleShowTotal(text);
          },
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: SizedBox(
              width: 125,
              child: Row(
                children: [
                  if (total == text)
                    Icon(
                      Iconsax.tick_circle_copy,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      size: 18,
                    ),
                  SizedBox(width: 4),
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 18,
                      color: total == text
                          ? Theme.of(context).colorScheme.onSurfaceVariant
                          : Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant.withAlpha(120),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget surplusValue(BuildContext context, String text) {
    return Obx(() {
      String surplus = recordsController.surplus.value;
      return Padding(
        padding: const EdgeInsets.all(4.0),
        child: InkWell(
          splashColor: Theme.of(
            context,
          ).colorScheme.onSurfaceVariant.withAlpha(50),
          onTap: () {
            recordsController.toggleSurplus(text);
          },
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: SizedBox(
              width: 125,
              child: Row(
                children: [
                  if (surplus == text)
                    Icon(
                      Iconsax.tick_circle_copy,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      size: 18,
                    ),
                  SizedBox(width: 4),
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 18,
                      color: surplus == text
                          ? Theme.of(context).colorScheme.onSurfaceVariant
                          : Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant.withAlpha(120),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
