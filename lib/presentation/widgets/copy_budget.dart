import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:mymoneyclone/controllers/budget_controller.dart';
import 'package:mymoneyclone/controllers/categories_controller.dart';
import 'package:mymoneyclone/core/constants/app_constants.dart';
import 'package:mymoneyclone/core/theme/icon_helper.dart';
import 'package:mymoneyclone/data/models/budget_model.dart';

class CopyBudget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CopyBudgetState();
}

class _CopyBudgetState extends State<CopyBudget> {
  BudgetController budgetController = Get.find();
  CategoryController categoryController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      List<BudgetModel> budgets = budgetController.oldBudgetsFliteredByMonth;

      return Dialog(
        backgroundColor: Theme.of(context).colorScheme.onSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppConstants.copyBudget,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                "${AppConstants.month} ${budgetController.getFormattedHeaderDate()}",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.surface,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 13),
              SizedBox(
                width: 300,
                child: Text(
                  AppConstants.selectMonthMsg,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 13),
              Container(
                height: 300,
                width: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    width: 2,
                    color: Theme.of(context).colorScheme.surface,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            budgetController.previousPeriodOld();
                          },
                          icon: Icon(
                            Iconsax.arrow_circle_left_copy,
                            color: Theme.of(
                              context,
                            ).colorScheme.primaryContainer,
                            size: 22,
                          ),
                        ),

                        SizedBox(
                          width: 150,
                          child: Text(
                            budgetController.getFormattedOldHeaderDate(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).colorScheme.primaryContainer,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                        IconButton(
                          onPressed: budgetController.canGoNextOldMonth()
                              ? () {
                                  budgetController.nextPeriodOld();
                                }
                              : null,
                          icon: budgetController.canGoNextOldMonth()
                              ? Icon(
                                  Iconsax.arrow_circle_right_copy,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.primaryContainer,
                                  size: 22,
                                )
                              : SizedBox(width: 22),
                        ),
                      ],
                    ),
                    Divider(
                      color: Theme.of(context).colorScheme.surface,
                      height: 2,
                      thickness: 2,
                    ),
                    Expanded(
                      child: budgets.isEmpty
                          ? Center(
                              child: Text(
                                AppConstants.noBudgetApplied,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.surface,
                                  fontSize: 16,
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: budgets.length,
                              itemBuilder: (context, index) {
                                final budget = budgets[index];
                                final category = categoryController.getCatById(
                                  budget.categoryId,
                                );
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onSecondary,
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child: Icon(
                                          IconHelper.getIconsaxIcon(
                                            category!.icon,
                                          ),
                                          size: 20,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onPrimary,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          category.name,
                                          style: TextStyle(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.primaryContainer,
                                            fontSize: 16,
                                            overflow: TextOverflow.ellipsis,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            AppConstants.limit,
                                            style: TextStyle(
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.primaryContainer,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(width: 5),

                                          Text(
                                            AppConstants.amount(
                                              budget.expenceLimit,
                                            ),
                                            style: TextStyle(
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.surface,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Iconsax.info_circle_copy,
                      color: Theme.of(context).colorScheme.surface,
                    ),
                    SizedBox(width: 5),
                    SizedBox(
                      width: 270,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: Text(
                      AppConstants.close,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  OutlinedButton(
                    onPressed: () {
                      budgetController.copyBudgetsFromOldToCurrent();
                      Get.back();
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: Text(
                      AppConstants.copyAll,
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
    });
  }
}
