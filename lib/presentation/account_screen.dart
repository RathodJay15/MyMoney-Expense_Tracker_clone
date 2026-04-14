import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:mymoneyclone/controllers/accounts_controller.dart';
import 'package:mymoneyclone/controllers/categories_controller.dart';
import 'package:mymoneyclone/controllers/records_controller.dart';
import 'package:mymoneyclone/core/constants/app_constants.dart';
import 'package:mymoneyclone/core/constants/app_helper.dart';
import 'package:mymoneyclone/core/theme/icon_helper.dart';
import 'package:mymoneyclone/data/models/accounts_model.dart';
import 'package:mymoneyclone/data/models/category_model.dart';
import 'package:mymoneyclone/data/models/records_model.dart';
import 'package:mymoneyclone/presentation/widgets/record_detail_dialog.dart';
import 'package:mymoneyclone/presentation/widgets/add_account.dart';
import 'package:mymoneyclone/presentation/widgets/custom_appbar.dart';
import 'package:mymoneyclone/presentation/widgets/mymoney_alertdialog.dart';

class AccountScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  AccountsController accountsController = Get.find();
  CategoryController categoryController = Get.find();
  RecordsController recordsController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Theme.of(context).colorScheme.onSurface,
      child: Stack(
        children: [
          CustomAppbar(),
          Positioned(
            bottom: 0,
            child: Container(
              height: MediaQuery.heightOf(context) * 0.82,
              width: MediaQuery.widthOf(context),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSurface,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _summarySection(),
                  Expanded(child: _tabBarSection()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summarySection() {
    return Obx(() {
      final accountsBalanceTotal = accountsController.accountBalanceTotal.value;
      final expenseSofar = recordsController.totalExpenseSofar.value;
      final incomeSofar = recordsController.totalIncomeSofar.value;
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              AppConstants.allAccounts(accountsBalanceTotal),
              style: TextStyle(
                color: Theme.of(context).colorScheme.surface,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _accountsCategoryAppBarItem(
                  AppConstants.expenseSoFar,
                  AppConstants.amount(expenseSofar),
                ),

                _accountsCategoryAppBarItem(
                  AppConstants.incomeSoFar,
                  AppConstants.amount(incomeSofar),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _accountsCategoryAppBarItem(String title, String amount) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.surface,
            fontSize: 15,
          ),
        ),
        SizedBox(height: 4),
        Text(
          amount,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primaryContainer,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _tabBarSection() {
    return Obx(() {
      final accountsList = accountsController.accounts;
      return Theme(
        data: Theme.of(context).copyWith(
          tabBarTheme: TabBarThemeData(
            dividerColor: Colors.transparent,
            overlayColor: WidgetStateProperty.all(Colors.transparent),
          ),
        ),
        child: ContainedTabBarView(
          tabs: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(AppConstants.accounts),
            ),
          ],
          tabBarProperties: TabBarProperties(
            width: 380,
            height: 50,
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            background: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface.withAlpha(80),
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
            indicator: BoxDecoration(
              color: Theme.of(context).colorScheme.onSurface,
              borderRadius: BorderRadius.circular(25.0),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorPadding: const EdgeInsets.all(
              4.0,
            ), // Creates the inset effect
            labelColor: Theme.of(context).colorScheme.surface,
            unselectedLabelColor: Theme.of(context).colorScheme.surface,
          ),
          views: [_incomeList(accountsList)],
        ),
      );
    });
  }

  Widget _incomeList(List<AccountModel> accountList) {
    return ListView.builder(
      padding: EdgeInsets.only(bottom: 30),
      itemCount: accountList.length,
      itemBuilder: (context, index) {
        final account = accountList[index];
        return _listItem(account);
      },
    );
  }

  Widget _listItem(AccountModel account) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          splashColor: account.isIgnored
              ? Colors.transparent
              : Theme.of(context).colorScheme.primary.withAlpha(50),
          onTap: () {
            if (account.isIgnored) return;
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              useSafeArea: true,
              builder: (context) => displayAcc(account),
            );
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onSecondary,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    IconHelper.getIconsaxIcon(account.icon),
                    size: 30,
                    color: !account.isIgnored
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.onPrimary.withAlpha(90),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    account.name,
                    style: TextStyle(
                      color: !account.isIgnored
                          ? Theme.of(context).colorScheme.primaryContainer
                          : Theme.of(context).colorScheme.surface.withAlpha(90),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      decoration: !account.isIgnored
                          ? null
                          : TextDecoration.lineThrough,
                      decorationColor: Theme.of(
                        context,
                      ).colorScheme.surface.withAlpha(90),
                    ),
                  ),
                ),
                PopupMenuButton(
                  tooltip: AppConstants.options,
                  icon: Icon(
                    Iconsax.more_copy,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  offset: const Offset(0, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: Theme.of(context).colorScheme.primary,
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AccountDialog(
                              title: AppConstants.editCat,
                              account: account,
                            );
                          },
                        );
                      },
                      child: SizedBox(
                        width: 150,
                        child: Text(
                          AppConstants.edit,
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      onTap: () async {
                        final response = await MymoneyAlertdialog.showMyDialog(
                          context: context,
                          title: AppConstants.deleteThisCat,
                          content: AppConstants.deletingCatMsg,
                        );
                        if (response == true) {
                          await accountsController.deleteAccount(account);
                        }
                      },
                      child: Text(
                        AppConstants.delete,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      onTap: () async {
                        if (!account.isIgnored) {
                          final response =
                              await MymoneyAlertdialog.showMyDialog(
                                context: context,
                                title: AppConstants.ingnoreThisCat,
                                content: AppConstants.ignoreCatMsg,
                              );
                          if (response == true) {
                            account.isIgnored = true;
                            await accountsController.updateAccounts(account);
                          }
                        } else {
                          account.isIgnored = false;
                          await accountsController.updateAccounts(account);
                        }
                      },
                      child: Text(
                        !account.isIgnored
                            ? AppConstants.ignore
                            : AppConstants.restore,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget displayAcc(AccountModel account) {
    final records = recordsController.fetchRecordByAccount(account.key);

    return Obx(() {
      var orderedRecords = records[accountsController.recordOrder.value];
      final groupedRecordsKyes = orderedRecords!.keys.toList();

      return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSurface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              color: Theme.of(context).colorScheme.primary,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(
                        Iconsax.close_circle_copy,
                        size: 40,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(width: 5),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppConstants.accDetails,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          AppConstants.recordsAllTime,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSecondary,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onSecondary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      IconHelper.getIconsaxIcon(account.icon),
                      size: 30,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          account.name,
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.primaryContainer,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${AppConstants.balance} ${AppConstants.amount(account.balance)}',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.surface,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (account.initialAmount != 0.00)
                          Text(
                            '${AppConstants.initialy} ${AppConstants.amount(account.initialAmount)}',
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).colorScheme.surface.withAlpha(180),
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSecondary,
                  border: BoxBorder.all(
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Iconsax.info_circle_copy,
                      color: Theme.of(context).colorScheme.surface,
                    ),
                    SizedBox(width: 5),
                    SizedBox(
                      width: MediaQuery.maybeWidthOf(context)! * 0.80,
                      child: Text(
                        AppConstants.analysisDialog,
                        maxLines: 2,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.surface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            groupedRecordsKyes.isEmpty
                ? Text(
                    AppConstants.noRecordInThisAcc,
                    textAlign:
                        TextAlign.center, // Ensures multi-line text is centered
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : orderedRecords.length == 1
                ? Text(
                    AppConstants.oneRecordInAcc,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          AppConstants.totalRecordsInAccount(
                            orderedRecords.length,
                          ),
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.primaryContainer,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: accountsController.changeRecordOrder,
                            borderRadius: BorderRadius.circular(8),
                            splashColor: Theme.of(
                              context,
                            ).colorScheme.primary.withAlpha(50),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Iconsax.sort_copy,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.surface,
                                    size: 25,
                                  ),
                                  Text(
                                    accountsController.recordOrder.value,
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.surface,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

            Expanded(
              child: ListView.builder(
                itemCount: groupedRecordsKyes.length,
                itemBuilder: (context, index) {
                  String groupKey = groupedRecordsKyes[index];
                  List<RecordModel> records = orderedRecords[groupKey]!;

                  return Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10.0,
                            ),
                            child: Text(
                              groupKey,
                              style: TextStyle(
                                color: Theme.of(
                                  context,
                                ).colorScheme.primaryContainer,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          _recordList(records, account),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _recordList(List<RecordModel> records, AccountModel account) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: records.length,
      itemBuilder: (context, index) {
        final record = records[index];
        CategoryModel? category;
        AccountModel? transferAccount;

        if (record.type == AppConstants.transfer) {
          transferAccount = recordsController.getAccById(
            record.transferAccountId!,
          );
        } else {
          category = recordsController.getCatById(record.categoryId!);
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
            splashColor: Theme.of(context).colorScheme.primary.withAlpha(50),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onSecondary,
                      borderRadius: BorderRadius.circular(5),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        transferAccount != null
                            ? Text(
                                "[${account.name} > ${transferAccount.name}]",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.primaryContainer,
                                ),
                              )
                            : Text(
                                category!.name,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.primaryContainer,
                                ),
                              ),

                        Text(
                          AppHelper.getFormattedDateString2(record.date),
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.surface,
                          ),
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
