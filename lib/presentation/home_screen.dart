import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:mymoneyclone/controllers/records_controller.dart';
import 'package:mymoneyclone/core/constants/app_constants.dart';
import 'package:mymoneyclone/core/theme/icon_helper.dart';
import 'package:mymoneyclone/data/models/accounts_model.dart';
import 'package:mymoneyclone/data/models/category_model.dart';
import 'package:mymoneyclone/data/models/records_model.dart';
import 'package:mymoneyclone/data/services/hive_to_scv.dart';
import 'package:mymoneyclone/presentation/account_screen.dart';
import 'package:mymoneyclone/presentation/category_screen.dart';
import 'package:mymoneyclone/presentation/add_record_screen.dart';
import 'package:mymoneyclone/presentation/budget_screen.dart';
import 'package:mymoneyclone/presentation/export_screen.dart';
import 'package:mymoneyclone/presentation/widgets/add_account.dart';
import 'package:mymoneyclone/presentation/widgets/add_category.dart';
import 'package:mymoneyclone/presentation/widgets/copy_budget.dart';
import 'package:mymoneyclone/presentation/widgets/custom_appbar.dart';
import 'package:mymoneyclone/presentation/widgets/empty_state.dart';
import 'package:mymoneyclone/presentation/widgets/record_detail_dialog.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  RecordsController recordsController = Get.find();
  int selected = 0;

  void _masterAdd() {
    if (selected == 0) {
      Get.to(
        AddRecordScreen(title: AppConstants.addNewRecord, oldRecord: null),
      );
    } else if (selected == 1) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CopyBudget();
        },
      );
    } else if (selected == 2) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AccountDialog(title: AppConstants.addNewAcc, account: null);
        },
      );
    } else if (selected == 3) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CategoryDialog(title: AppConstants.addNewCat, category: null);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: Theme.of(context).colorScheme.onSurface,
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.onSurface,
        resizeToAvoidBottomInset: false,
        drawer: Drawer(
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
          child: ListView(
            children: [
              ListTile(
                title: Text(
                  AppConstants.myMoney,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(
                  Iconsax.setting_2_copy,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                title: Text(
                  AppConstants.preferences,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(
                  Iconsax.document_download_copy,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                onTap: () {
                  Get.back();
                  Get.to(ExportScreen());
                },
                title: Text(
                  AppConstants.exportRecords,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(
                  Iconsax.save_2_copy,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                title: Text(
                  AppConstants.backupRestore,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(
                  Iconsax.trash_copy,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                title: Text(
                  AppConstants.deleteReset,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(
                  Iconsax.star_copy,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                title: Text(
                  AppConstants.proVersion,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(
                  Iconsax.like_1_copy,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                title: Text(
                  AppConstants.likeMyMoney,
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
                  AppConstants.help,
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
                  AppConstants.feedback,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: IndexedStack(
          index: selected,
          children: [
            _homeScreenBody(),
            BudgetScreen(),
            AccountScreen(),
            CategoryScreen(),
          ],
        ),
        floatingActionButton: Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(47, 0, 0, 0),
                blurRadius: 5,
                spreadRadius: 3,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: IconButton(
            onPressed: _masterAdd,
            icon: Icon(
              Iconsax.add_circle_copy,
              color: Theme.of(context).colorScheme.onSurface,
              size: 35,
            ),
          ),
        ),

        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.surface.withAlpha(50),
                blurRadius: 5,
                spreadRadius: 5,
                offset: Offset(0, -2), // Shadow position
              ),
            ],
          ),
          child: StylishBottomBar(
            backgroundColor: Theme.of(context).colorScheme.onSurface,
            fabLocation: StylishBarFabLocation.center,
            hasNotch: true,
            notchStyle: NotchStyle.circle,
            currentIndex: selected,
            onTap: (index) {
              setState(() => selected = index);
            },
            option: AnimatedBarOptions(iconStyle: IconStyle.animated),
            items: [
              BottomBarItem(
                icon: Icon(
                  Iconsax.home_2_copy,
                  color: Theme.of(context).colorScheme.surface,
                ),
                selectedIcon: Icon(
                  Iconsax.home_2,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: Text(AppConstants.records),
                selectedColor: Theme.of(context).colorScheme.primary,
              ),

              BottomBarItem(
                icon: Icon(
                  Iconsax.calculator_copy,
                  color: Theme.of(context).colorScheme.surface,
                ),
                selectedIcon: Icon(
                  Iconsax.calculator,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: Text(AppConstants.budgets),
                selectedColor: Theme.of(context).colorScheme.primary,
              ),

              BottomBarItem(
                icon: Icon(
                  Iconsax.wallet_1_copy,
                  color: Theme.of(context).colorScheme.surface,
                ),
                selectedIcon: Icon(
                  Iconsax.wallet,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: Text(AppConstants.accounts),
                selectedColor: Theme.of(context).colorScheme.primary,
              ),

              BottomBarItem(
                icon: Icon(
                  Iconsax.category_2_copy,
                  color: Theme.of(context).colorScheme.surface,
                ),
                selectedIcon: Icon(
                  Iconsax.category_2,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: Text(AppConstants.categories),
                selectedColor: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _homeScreenBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _headerSection(),
        Expanded(child: _recordListSection()),
      ],
    );
  }

  Widget _headerSection() {
    return Container(
      height: 260,
      color: Theme.of(context).colorScheme.onSurface,
      child: Stack(
        children: [
          CustomAppbar(),
          Positioned(bottom: 24, child: _summaryCard()),
        ],
      ),
    );
  }

  Widget _summaryCard() {
    return Obx(() {
      String showTotel = recordsController.showTotal.value;
      String income = AppConstants.amount(recordsController.totalIncome.value);
      String expense = AppConstants.amount(
        recordsController.totalExpense.value,
      );
      String total = AppConstants.amount(recordsController.totalBalance.value);
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          height: 145,
          padding: const EdgeInsets.all(18),
          width: MediaQuery.widthOf(context) - 40,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onPrimary,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                blurRadius: 10,
                color: Theme.of(context).colorScheme.surface.withAlpha(80),
                spreadRadius: 3,
                offset: Offset(0, 15),
              ),
            ],
          ),
          child: Column(
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
                            color: Theme.of(context).colorScheme.onSurface,
                            size: 22,
                          ),
                        ),

                        SizedBox(
                          width: 150,
                          child: Text(
                            recordsController.getFormattedHeaderDate(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            recordsController.nextPeriod();
                          },
                          icon: Icon(
                            Iconsax.arrow_circle_right_copy,
                            color: Theme.of(context).colorScheme.onSurface,
                            size: 22,
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
              const SizedBox(height: 10),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _summaryItem(
                    icon: Iconsax.arrow_up_1,
                    title: AppConstants.expense,
                    amount: expense,
                  ),
                  _summaryItem(
                    icon: Iconsax.arrow_down,
                    title: AppConstants.income,
                    amount: income,
                  ),
                  if (showTotel == AppConstants.yes)
                    _summaryItem(
                      icon: Iconsax.arrow_right_2,
                      title: AppConstants.total,
                      amount: total,
                    ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _summaryItem({
    required IconData icon,
    required String title,
    required String amount,
  }) {
    return Flexible(
      flex: 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 13,
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.onSurface.withAlpha(50),
                child: Icon(
                  icon,
                  color: Theme.of(context).colorScheme.onSurface,
                  size: 16,
                ),
              ),
              const SizedBox(width: 5),
              Text(
                title,
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSecondary.withAlpha(180),
                  fontSize: 16,
                ),
              ),
            ],
          ),
          Text(
            amount,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _recordListSection() {
    return Obx(() {
      final groupedRecordsKyes = recordsController.groupedRecords.keys.toList();
      if (groupedRecordsKyes.isEmpty) {
        return Center(
          child: EmptystateScreen.emptyState(
            icon: Iconsax.receipt_add_copy,
            title: AppConstants.recordEmptyStateMsg,
            context: context,
          ),
        );
      }
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.only(bottom: 30),
          itemCount: groupedRecordsKyes.length,
          itemBuilder: (context, index) {
            String groupKey = groupedRecordsKyes[index];
            List<RecordModel> records =
                recordsController.groupedRecords[groupKey]!;

            return Padding(
              padding: EdgeInsets.only(top: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      groupKey,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _recordList(records),
                ],
              ),
            );
          },
        ),
      );
    });
  }

  Widget _recordList(List<RecordModel> records) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: records.length,
      itemBuilder: (context, index) {
        final record = records[index];
        final account = recordsController.getAccById(record.accountId);

        String title = "";
        CategoryModel? category;
        AccountModel? transferAccount;

        if (record.type == AppConstants.transfer) {
          title = AppConstants.transfer;
          transferAccount = recordsController.getAccById(
            record.transferAccountId!,
          );
        } else {
          category = recordsController.getCatById(record.categoryId!);

          title = category!.name;
        }

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return RecordDetailDialog(record: record);
                },
              );
            },
            splashColor: Theme.of(context).colorScheme.onPrimary.withAlpha(50),
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onSecondary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      record.transferAccountId == null
                          ? IconHelper.getIconsaxIcon(category!.icon)
                          : Iconsax.arrow_swap_horizontal_copy,
                      color: Theme.of(context).colorScheme.onPrimary,
                      size: 30,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.primaryContainer,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              IconHelper.getIconsaxIcon(account!.icon),
                              color: Theme.of(context).colorScheme.onPrimary,
                              size: 20,
                            ),
                            SizedBox(width: 5),

                            Text(
                              account.name,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.surface,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 10),
                            if (transferAccount != null)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Iconsax.arrow_right_1_copy,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onPrimary,
                                  ),
                                  SizedBox(width: 10),
                                  Icon(
                                    IconHelper.getIconsaxIcon(
                                      transferAccount.icon,
                                    ),
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onPrimary,
                                    size: 20,
                                  ),
                                  SizedBox(width: 5),

                                  Text(
                                    transferAccount.name,
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.surface,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Text(
                    AppConstants.amount(record.amount),
                    style: TextStyle(
                      color: record.type == AppConstants.transfer
                          ? Theme.of(context).colorScheme.inversePrimary
                          : record.type == AppConstants.expense
                          ? Theme.of(context).colorScheme.error
                          : Theme.of(context).colorScheme.onInverseSurface,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class FilterDialog extends StatelessWidget {
  RecordsController recordsController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).colorScheme.primary,
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
                color: Theme.of(context).colorScheme.onSurface,
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
                  color: Theme.of(context).colorScheme.onSurface.withAlpha(150),
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
                      ).colorScheme.onSurface.withAlpha(120),
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
          color: Theme.of(context).colorScheme.onSurface,
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
                      color: Theme.of(context).colorScheme.onSurface,
                      size: 18,
                    ),
                  SizedBox(width: 4),
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 18,
                      color: mode == text
                          ? Theme.of(context).colorScheme.onSurface
                          : Theme.of(
                              context,
                            ).colorScheme.onSurface.withAlpha(120),
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
          splashColor: Theme.of(context).colorScheme.onSurface.withAlpha(50),
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
                      color: Theme.of(context).colorScheme.onSurface,
                      size: 18,
                    ),
                  SizedBox(width: 4),
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 18,
                      color: total == text
                          ? Theme.of(context).colorScheme.onSurface
                          : Theme.of(
                              context,
                            ).colorScheme.onSurface.withAlpha(120),
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
                      color: Theme.of(context).colorScheme.onSurface,
                      size: 18,
                    ),
                  SizedBox(width: 4),
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 18,
                      color: surplus == text
                          ? Theme.of(context).colorScheme.onSurface
                          : Theme.of(
                              context,
                            ).colorScheme.onSurface.withAlpha(120),
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
