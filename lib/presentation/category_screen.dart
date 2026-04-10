import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:mymoneyclone/controllers/accounts_controller.dart';
import 'package:mymoneyclone/controllers/categories_controller.dart';
import 'package:mymoneyclone/controllers/records_controller.dart';
import 'package:mymoneyclone/core/constants/app_colors.dart';
import 'package:mymoneyclone/core/constants/app_constants.dart';
import 'package:mymoneyclone/core/theme/icon_helper.dart';
import 'package:mymoneyclone/data/models/category_model.dart';
import 'package:mymoneyclone/presentation/widgets/add_category.dart';
import 'package:mymoneyclone/presentation/widgets/mymoney_alertdialog.dart';

class CategoryScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
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
          Container(
            width: double.infinity,
            height: 170,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.elliptical(200, 30),
                bottomRight: Radius.elliptical(200, 30),
              ),
            ),
            child: Stack(
              children: [
                SizedBox(
                  height: 200,
                  width: 200,
                  child: Image.asset(
                    "assets/images/png_bg_rings.png",
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Iconsax.menu_1_copy,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: Text(
                              AppConstants.myMoney,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.search,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
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
      final income = categoryController.incomeCategories;
      final expense = categoryController.expenseCategories;
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
              child: Text(AppConstants.incomeCategory),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(AppConstants.expenseCategory),
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
          views: [
            ListView(children: [...income.map((e) => _listItem(e))]),
            ListView(children: [...expense.map((e) => _listItem(e))]),
          ],
        ),
      );
    });
  }

  Widget _listItem(CategoryModel category) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          splashColor: category.isIgnored
              ? Colors.transparent
              : Theme.of(context).colorScheme.primary.withAlpha(50),
          onTap: () {
            if (category.isIgnored) return;
            // showModalBottomSheet(
            //   context: context,
            //   isScrollControlled: true,
            //   useSafeArea: true,
            //   builder: (context) => displayCat(category),
            // );
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
                    IconHelper.getIconsaxIcon(category.icon),
                    size: 30,
                    color: !category.isIgnored
                        ? Theme.of(context).colorScheme.onPrimary
                        : AppColors.whitIcon.withAlpha(90),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    category.name,
                    style: TextStyle(
                      color: !category.isIgnored
                          ? Theme.of(context).colorScheme.primaryContainer
                          : Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant.withAlpha(90),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      decoration: !category.isIgnored
                          ? null
                          : TextDecoration.lineThrough,
                      decorationColor: Theme.of(
                        context,
                      ).colorScheme.onSurfaceVariant.withAlpha(90),
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
                  color: Theme.of(context).colorScheme.surface,
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CategoryDialog(
                              title: AppConstants.editCat,
                              category: category,
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
                          await categoryController.deleteCategory(category);
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
                        if (!category.isIgnored) {
                          final response =
                              await MymoneyAlertdialog.showMyDialog(
                                context: context,
                                title: AppConstants.ingnoreThisCat,
                                content: AppConstants.ignoreCatMsg,
                              );
                          if (response == true) {
                            category.isIgnored = true;
                            await categoryController.updateCategory(category);
                          }
                        } else {
                          category.isIgnored = false;
                          await categoryController.updateCategory(category);
                        }
                      },
                      child: Text(
                        !category.isIgnored
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
}
