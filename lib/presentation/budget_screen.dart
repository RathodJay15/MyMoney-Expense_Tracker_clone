import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:mymoneyclone/controllers/budget_controller.dart';
import 'package:mymoneyclone/controllers/categories_controller.dart';
import 'package:mymoneyclone/controllers/records_controller.dart';
import 'package:mymoneyclone/core/constants/app_constants.dart';
import 'package:mymoneyclone/core/constants/app_helper.dart';
import 'package:mymoneyclone/core/theme/icon_helper.dart';
import 'package:mymoneyclone/data/models/accounts_model.dart';
import 'package:mymoneyclone/data/models/budget_model.dart';
import 'package:mymoneyclone/data/models/category_model.dart';
import 'package:mymoneyclone/data/models/records_model.dart';
import 'package:mymoneyclone/presentation/widgets/empty_state.dart';
import 'package:mymoneyclone/presentation/widgets/record_detail_dialog.dart';
import 'package:mymoneyclone/presentation/widgets/app_snackbar.dart';
import 'package:mymoneyclone/presentation/widgets/mymoney_alertdialog.dart';
import 'package:mymoneyclone/presentation/widgets/custom_appbar.dart';
import 'package:percent_indicator/multi_segment_linear_indicator.dart';
import 'package:percent_indicator/percent_indicator.dart';

class BudgetScreen extends StatelessWidget {
  CategoryController categoryController = Get.find();
  BudgetController budgetController = Get.find();
  RecordsController recordsController = Get.find();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.heightOf(context),
      width: MediaQuery.widthOf(context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _headerSection(context),
          Expanded(child: _budgetBody(context)),
        ],
      ),
    );
  }

  Widget _headerSection(BuildContext context) {
    return Container(
      height: 260,
      color: Theme.of(context).colorScheme.onSurface,
      child: Stack(
        children: [
          CustomAppbar(),
          Positioned(bottom: 24, child: _summaryCard(context)),
        ],
      ),
    );
  }

  Widget _summaryCard(BuildContext context) {
    return Obx(() {
      final totalBudget = budgetController.getTotalBudget();
      final totalSpent = budgetController.getTotalSpent(recordsController);
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
                            budgetController.previousPeriod();
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
                            budgetController.getFormattedHeaderDate(),
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
                            budgetController.nextPeriod();
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
                  Flexible(flex: 0, child: SizedBox()),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _summaryItem(
                    context,
                    title: AppConstants.totalBudget,
                    amount: totalBudget,
                  ),
                  _summaryItem(
                    context,
                    title: AppConstants.totalSpent,
                    amount: totalSpent,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _summaryItem(
    BuildContext context, {
    required String title,
    required double amount,
  }) {
    return Flexible(
      flex: 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSecondary.withAlpha(180),
              fontSize: 16,
            ),
          ),
          Text(
            AppConstants.amount(amount),
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

  Widget _budgetBody(BuildContext context) {
    return Obx(() {
      DateTime headerMonth = budgetController.budgetMonth.value;
      if (headerMonth.month < DateTime.now().month) {
        return Center(
          child: EmptystateScreen.emptyState(
            icon: Iconsax.calculator_copy,
            title: AppConstants.noBudgetForOldMonthMsg,
            context: context,
          ),
        );
      }

      return SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Obx(() {
                return Text(
                  "${AppConstants.budgetedCats} ${budgetController.getFormattedHeaderDate()}",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: _budgetedList(context),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                AppConstants.notBudgeted,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _notBudgetedList(),
            ),
            SizedBox(height: 20),
          ],
        ),
      );
    });
  }

  Widget _budgetedList(BuildContext context) {
    return Obx(() {
      final budgetList = budgetController.budgetsFliteredByMonth;
      if (budgetList.isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              AppConstants.noBudgetMsg,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.surface,
                fontSize: 15,
              ),
            ),
          ),
        );
      }
      return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        itemCount: budgetList.length,
        itemBuilder: (context, index) {
          final budget = budgetList[index];
          final category = categoryController.getCatById(budget.categoryId);
          final spent = recordsController.getCatSpentTotal(
            budgetController.budgetMonth.value,
            category!.key,
          );
          final remaining = budget.expenceLimit - spent;
          double spentPercent = 0;
          double remainingPercent = 0;

          if (spent <= budget.expenceLimit) {
            spentPercent = (spent / budget.expenceLimit).clamp(0, 1);
            remainingPercent = 1 - spentPercent;
          } else {
            spentPercent = 1;
            remainingPercent = 0;
          }

          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                if (spent == 0.0) {
                  AppSnackbar.showSnackBar(
                    context,
                    Iconsax.category_2_copy,
                    "${AppConstants.noExpenseForThisCat} ${category.name}",
                  );
                  return;
                }

                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  useSafeArea: true,
                  builder: (context) => displayCat(category, context, budget),
                );
              },
              borderRadius: BorderRadius.circular(15),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.onSecondary,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Icon(
                            IconHelper.getIconsaxIcon(category.icon),
                            size: 30,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                category.name,
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.primaryContainer,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 2),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppConstants.limit,
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primaryContainer,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 5),

                                  Text(
                                    AppConstants.amount(budget.expenceLimit),
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.surface,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
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
                                    return SetBudget(
                                      month: budgetController.budgetMonth.value,
                                      oldBudget: budget,
                                      category: category,
                                    );
                                  },
                                );
                              },
                              child: SizedBox(
                                width: 150,
                                child: Text(
                                  AppConstants.changeLimit,
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
                                final response =
                                    await MymoneyAlertdialog.showMyDialog(
                                      context: context,
                                      title: AppConstants.removeThisBudget,
                                      content: AppConstants.removeBudgetMsg,
                                    );
                                if (response == true) {
                                  await budgetController.deleteBudget(budget);
                                }
                              },
                              child: Text(
                                AppConstants.removeBudget,
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 6),

                    MultiSegmentLinearIndicator(
                      width: double.maxFinite,
                      lineHeight: 10,

                      segments: [
                        SegmentLinearIndicator(
                          percent: spentPercent,
                          color: spent <= budget.expenceLimit
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.error,
                        ),
                        SegmentLinearIndicator(
                          percent: remainingPercent,
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                      ],
                      barRadius: Radius.circular(3),
                      animation: true,
                      animationDuration: 800,
                      curve: Curves.easeInOut,
                    ),
                    SizedBox(height: 6),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${AppConstants.amount(spent)} ${AppConstants.spent}",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                        Text(
                          "${AppConstants.amount(remaining)} ${AppConstants.remaining}",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
  }

  Widget _notBudgetedList() {
    return Obx(() {
      final expenseCats = categoryController.expenseCategories;
      final budgetList = budgetController.budgetsFliteredByMonth;
      final budgetedCatIds = budgetList.map((b) => b.categoryId).toSet();
      final categories = expenseCats
          .where((e) => e.isIgnored == false && !budgetedCatIds.contains(e.key))
          .toList();

      return ListView.builder(
        padding: EdgeInsets.zero,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Container(
            margin: EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onSecondary,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    IconHelper.getIconsaxIcon(category.icon),
                    size: 30,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    category.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                OutlinedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return SetBudget(
                          category: category,
                          month: budgetController.budgetMonth.value,
                          oldBudget: null,
                        );
                      },
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.onSurface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  child: Text(
                    AppConstants.setBudget,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    });
  }

  Widget displayCat(
    CategoryModel category,
    BuildContext context,
    BudgetModel budget,
  ) {
    return Obx(() {
      final ascRecords = recordsController.fetchRecordsByCatMonth(
        category.key,
        budgetController.budgetMonth.value,
        isAsc: true,
      );
      final descRecords = recordsController.fetchRecordsByCatMonth(
        category.key,
        budgetController.budgetMonth.value,
        isAsc: false,
      );
      double totalExpense = 0;

      ascRecords.forEach((key, recordsList) {
        for (var record in recordsList) {
          if (record.type == AppConstants.expense) {
            totalExpense += record.amount;
          }
        }
      });

      double expensePercantage = (totalExpense * 100) / budget.expenceLimit;

      final orderedRecords =
          categoryController.recordOrder.value == AppConstants.oldToNew
          ? ascRecords
          : descRecords;
      final groupedRecordsKyes = orderedRecords.keys.toList();
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
                          AppConstants.catDetails,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${AppConstants.timeSelected} ${budgetController.getFormattedHeaderDate()}",
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
                      IconHelper.getIconsaxIcon(category.icon),
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
                          category.name,
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.primaryContainer,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          category.type == AppConstants.expense
                              ? AppConstants.expenseCategory
                              : AppConstants.incomeCategory,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.surface,
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
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: CircularPercentIndicator(
                        radius: 60.0,
                        lineWidth: 6.0,
                        animation: true,
                        percent: expensePercantage / 100,
                        center: Text(
                          "${expensePercantage.toStringAsFixed(2)} %",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        circularStrokeCap: CircularStrokeCap.round,
                        progressColor: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    SizedBox(
                      width: 150,
                      child: Text(
                        "${AppConstants.epenseInThisMonth} ${AppConstants.amount(totalExpense)}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    AppConstants.totalRecordsInCategory(orderedRecords.length),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (orderedRecords.length >= 2)
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: categoryController.changeRecordOrder,
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
                                color: Theme.of(context).colorScheme.surface,
                                size: 25,
                              ),
                              Text(
                                categoryController.recordOrder.value,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.surface,
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
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
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
                          _recordList(records, category),
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

  Widget _recordList(List<RecordModel> records, CategoryModel category) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: records.length,
      itemBuilder: (context, index) {
        final record = records[index];
        AccountModel? account = recordsController.getAccById(record.accountId);

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
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      IconHelper.getIconsaxIcon(account!.icon),
                      size: 30,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  SizedBox(width: 10),

                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          account.name,
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(
                              context,
                            ).colorScheme.primaryContainer,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppHelper.getFormattedDateString2(record.date),
                              style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).colorScheme.surface,
                              ),
                            ),
                            SizedBox(width: 10),

                            Text(
                              record.time,
                              style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).colorScheme.surface,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Text(
                    AppConstants.amount(record.amount),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(width: 5),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class SetBudget extends StatefulWidget {
  CategoryModel category;
  DateTime month;
  BudgetModel? oldBudget;
  SetBudget({
    required this.category,
    required this.month,
    required this.oldBudget,
  });
  @override
  State<StatefulWidget> createState() => _SetBudgetState();
}

class _SetBudgetState extends State<SetBudget> {
  BudgetController budgetController = Get.find();
  CategoryController categoryController = Get.find();
  TextEditingController limitController = TextEditingController();
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    focusNode.requestFocus();
    if (widget.oldBudget != null) {
      limitController.text = widget.oldBudget!.expenceLimit.toString();
    }
    super.initState();
  }

  void _onSave() async {
    if (limitController.text.isEmpty) {
      AppSnackbar.showSnackBar(
        context,
        Iconsax.money,
        AppConstants.noLimitAdded,
      );
      return;
    }
    if (widget.oldBudget == null) {
      BudgetModel budget = BudgetModel(
        categoryId: widget.category.key,
        expenceLimit: double.parse(limitController.text.trim()),
        month: widget.month,
      );
      await budgetController.addBudget(budget);
      widget.category.isBudgeted = true;
      await categoryController.updateCategory(widget.category);
    } else if (widget.oldBudget != null) {
      widget.oldBudget!.expenceLimit = double.parse(
        limitController.text.trim(),
      );
      await budgetController.updateBudget(widget.oldBudget!);
    }
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppConstants.setBudget,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 15),
            Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  width: 2,
                  color: Theme.of(context).colorScheme.surface,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onSecondary,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(
                      IconHelper.getIconsaxIcon(widget.category.icon),
                      size: 30,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    widget.category.name,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                AppConstants.limit,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 50,
              child: TextField(
                controller: limitController,
                focusNode: focusNode,
                keyboardType: TextInputType.number,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.surface,
                  fontSize: 18,
                ),
                decoration: InputDecoration(
                  hint: Text(
                    '0',
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.surface,
                    ),
                  ),
                  isDense: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      width: 2,
                      color: Theme.of(context).colorScheme.surface,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      width: 2,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Month: ${budgetController.getFormattedHeaderDate()}",
              style: TextStyle(
                color: Theme.of(context).colorScheme.surface,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: () => Get.back(),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.onPrimary,
                      width: 2,
                    ),
                  ),
                  child: Text(
                    AppConstants.cancel,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 18,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                OutlinedButton(
                  onPressed: _onSave,
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.onPrimary,
                      width: 2,
                    ),
                  ),
                  child: Text(
                    AppConstants.set,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 18,
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
}
