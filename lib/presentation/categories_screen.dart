import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:mymoneyclone/controllers/categories_controller.dart';
import 'package:mymoneyclone/core/constants/app_colors.dart';
import 'package:mymoneyclone/core/constants/app_constants.dart';
import 'package:mymoneyclone/core/theme/icon_helper.dart';
import 'package:mymoneyclone/data/models/category_model.dart';
import 'package:mymoneyclone/presentation/widgets/add_category.dart';
import 'package:mymoneyclone/presentation/widgets/mymoney_alertdialog.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  // CategoryController catController = Get.put(CategoryController());
  CategoryController catController = Get.find();

  bool isExpense = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final income = catController.incomeCategories;
      final expense = catController.expenseCategories;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(bottom: 20),
          children: [
            categoryTypeLabel(AppConstants.incomeCat),

            ...income.map((e) => _listItem(e)),

            categoryTypeLabel(AppConstants.expenseCat),

            ...expense.map((e) => _listItem(e)),

            SizedBox(height: 20),

            Center(child: _addButton()),
          ],
        ),
      );
    });
  }

  Widget _listItem(CategoryModel category) {
    return InkWell(
      splashColor: Theme.of(context).colorScheme.onSurfaceVariant.withAlpha(50),
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          useSafeArea: true,
          builder: (context) => displayCat(category),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: !category.isIgnored
                    ? AppColors.blueBG
                    : AppColors.blueBG.withAlpha(90),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Icon(
                IconHelper.getIconsaxIcon(category.icon),
                size: 30,
                color: !category.isIgnored
                    ? AppColors.whitIcon
                    : AppColors.whitIcon.withAlpha(90),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                category.name,
                style: TextStyle(
                  color: !category.isIgnored
                      ? Theme.of(context).colorScheme.onSurfaceVariant
                      : Theme.of(
                          context,
                        ).colorScheme.onSurfaceVariant.withAlpha(90),
                  fontSize: 15,
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
                color: Theme.of(context).colorScheme.onSurfaceVariant,
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
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
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
                      await catController.deleteCategory(category);
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
                      final response = await MymoneyAlertdialog.showMyDialog(
                        context: context,
                        title: AppConstants.ingnoreThisCat,
                        content: AppConstants.ignoreCatMsg,
                      );
                      if (response == true) {
                        category.isIgnored = true;
                        await catController.updateCategory(category);
                      }
                    } else {
                      category.isIgnored = false;
                      await catController.updateCategory(category);
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
    );
  }

  Widget categoryTypeLabel(String label) {
    return Container(
      margin: EdgeInsets.only(top: 30, left: 10, right: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          Divider(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ],
      ),
    );
  }

  Widget _addButton() {
    return SizedBox(
      width: 230,
      child: OutlinedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return CategoryDialog(
                title: AppConstants.addNewCat,
                category: null,
              );
            },
          );
        },
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            width: 2.0,
          ),
          // Define the corner radius
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),

        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Iconsax.add_circle_copy,
                size: 25,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),

              Text(
                AppConstants.addNewCat,
                style: TextStyle(
                  fontSize: 15,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget displayCat(CategoryModel category) {
    final list = [];
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            color: Theme.of(context).colorScheme.surface,
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
                    icon: Icon(Iconsax.close_circle_copy, size: 40),
                  ),
                  SizedBox(width: 5),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppConstants.catDetails,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        AppConstants.recordsAllTime,
                        style: TextStyle(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurfaceVariant.withAlpha(180),
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
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Icon(
                    IconHelper.getIconsaxIcon(category.icon),
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
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        category.type == AppConstants.expense
                            ? AppConstants.expenseCategory
                            : AppConstants.incomeCategory,
                        style: TextStyle(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurfaceVariant.withAlpha(180),
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
            padding: EdgeInsets.all(20),
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface.withAlpha(100),
                border: BoxBorder.all(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurfaceVariant.withAlpha(90),
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Iconsax.info_circle_copy,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  SizedBox(width: 5),
                  SizedBox(
                    width: MediaQuery.maybeWidthOf(context)! * 0.80,
                    child: Text(
                      AppConstants.analysisDialog,
                      maxLines: 2,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: list.isEmpty
                ? Text(
                    AppConstants.noRecordInThisCat,
                    textAlign:
                        TextAlign.center, // Ensures multi-line text is centered
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      return ListTile(title: Text('Item $index'));
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
