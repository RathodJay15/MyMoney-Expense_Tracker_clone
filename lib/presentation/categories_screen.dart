import 'package:flex_menu_button/flex_menu_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:mymoneyclone/controllers/categories_controller.dart';
import 'package:mymoneyclone/core/constants/app_colors.dart';
import 'package:mymoneyclone/core/constants/app_constants.dart';
import 'package:mymoneyclone/core/theme/icon_helper.dart';
import 'package:mymoneyclone/data/database/db_helper.dart';
import 'package:mymoneyclone/data/models/category_model.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  CategoryController catController = Get.put(CategoryController());

  bool isExpense = false;

  @override
  void initState() {
    super.initState();
    checkCat();
  }

  void checkCat() async {
    final db = await DatabaseHelper.obj.database;

    final result = await db.rawQuery('SELECT * FROM categories');

    print(result);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final income = catController.incomeCategories;
      final expense = catController.expenseCategories;

      return ListView(
        padding: EdgeInsets.only(bottom: 20),
        children: [
          categoryTypeLabel(AppConstants.incomeCat),

          ...income.map((e) => _listItem(e)),

          categoryTypeLabel(AppConstants.expenseCat),

          ...expense.map((e) => _listItem(e)),

          SizedBox(height: 20),

          Center(child: _addButton()),
        ],
      );
    });
  }

  Widget _listItem(CategoryModel category) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: AppColors.blueBG,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Icon(IconHelper.getIconsaxIcon(category.icon), size: 30),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              category.name,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          PopupMenuButton(
            tooltip: 'Options',
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
                child: ListTile(
                  title: Text(
                    AppConstants.edit,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 18,
                    ),
                  ),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              PopupMenuItem(
                onTap: () async {
                  await catController.deleteCategory(category.categoryId!);
                },
                child: ListTile(
                  title: Text(
                    AppConstants.delete,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 18,
                    ),
                  ),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
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
}

class CategoryDialog extends StatefulWidget {
  final String title;
  final CategoryModel? category;

  CategoryDialog({super.key, required this.title, required this.category});

  @override
  State<CategoryDialog> createState() => _CategoryDialogState();
}

class _CategoryDialogState extends State<CategoryDialog> {
  final CategoryController controller = Get.find();
  late TextEditingController nameController;
  bool isExpense = true;
  int selectedIcon = 0;

  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    nameController = TextEditingController(
      text: widget.category != null
          ? widget.category!.name
          : AppConstants.untitled,
    );

    selectedIcon = widget.category != null
        ? IconHelper.icons.indexOf(widget.category!.icon)
        : 0;
    focusNode.requestFocus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(),
      child: Dialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Title
              Text(
                widget.title,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: widget.title == AppConstants.addNewCat ? 16 : 0),

              /// Type
              widget.title == AppConstants.addNewCat
                  ? Row(
                      children: [
                        Text(
                          '${AppConstants.type}:',
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(width: 10),

                        GestureDetector(
                          onTap: () => setState(() => isExpense = false),
                          child: Row(
                            children: [
                              if (!isExpense)
                                Icon(
                                  Icons.check,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                  size: 16,
                                ),
                              SizedBox(width: 4),
                              Text(
                                AppConstants.income,
                                style: TextStyle(
                                  color: !isExpense
                                      ? Theme.of(
                                          context,
                                        ).colorScheme.onSurfaceVariant
                                      : Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 20),

                        GestureDetector(
                          onTap: () => setState(() => isExpense = true),
                          child: Row(
                            children: [
                              if (isExpense)
                                Icon(
                                  Icons.check,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                  size: 16,
                                ),
                              SizedBox(width: 4),
                              Text(
                                AppConstants.expense,
                                style: TextStyle(
                                  color: isExpense
                                      ? Theme.of(
                                          context,
                                        ).colorScheme.onSurfaceVariant
                                      : Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : SizedBox(),

              SizedBox(height: widget.title == AppConstants.addNewCat ? 16 : 0),

              /// Name Field
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    AppConstants.name,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 5),
                  SizedBox(
                    width: 265,
                    child: TextField(
                      controller: nameController,
                      focusNode: focusNode,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.onPrimary,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            width: 2,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              /// Icon Label
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppConstants.icon,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              /// Icon Grid
              Container(
                height: 120,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onPrimary,
                  borderRadius: BorderRadius.circular(12),
                  border: BoxBorder.all(
                    width: 2,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                child: GridView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: IconHelper.icons.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => setState(() => selectedIcon = index),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.blueBG,
                          shape: BoxShape.circle,
                          border: selectedIcon == index
                              ? Border.all(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimary,
                                  width: 2,
                                )
                              : null,
                        ),
                        child: Icon(
                          IconHelper.getIconsaxIcon(IconHelper.icons[index]),
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              /// Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        width: 2,
                      ),
                    ),
                    child: Text(
                      AppConstants.cancel,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  OutlinedButton(
                    onPressed: () async {
                      if (widget.category == null) {
                        String type = isExpense
                            ? AppConstants.expense
                            : AppConstants.income;

                        await controller.addCategory(
                          CategoryModel(
                            type: type,
                            name: nameController.text.trim(),
                            icon: IconHelper.icons[selectedIcon],
                          ),
                        );
                      } else {
                        print('dfdfdsfdsfsdf');
                        await controller.updateCategory(
                          CategoryModel(
                            categoryId: widget.category!.categoryId,
                            type: widget.category!.type,
                            name: nameController.text.trim(),
                            icon: IconHelper.icons[selectedIcon],
                          ),
                        );
                      }
                      Get.back();
                    },
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        width: 2,
                      ),
                    ),
                    child: Text(
                      AppConstants.save,
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
    );
  }
}
