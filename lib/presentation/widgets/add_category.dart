import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:mymoneyclone/controllers/categories_controller.dart';
import 'package:mymoneyclone/core/constants/app_colors.dart';
import 'package:mymoneyclone/core/constants/app_constants.dart';
import 'package:mymoneyclone/core/theme/icon_helper.dart';
import 'package:mymoneyclone/data/models/category_model.dart';

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
        ? IconHelper.catIcons.indexOf(widget.category!.icon)
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
                          ),
                        ),

                        const SizedBox(width: 10),

                        GestureDetector(
                          onTap: () => setState(() => isExpense = false),
                          child: Row(
                            children: [
                              if (!isExpense)
                                Icon(
                                  Iconsax.tick_circle_copy,
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
                                      : Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant
                                            .withAlpha(120),
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
                                  Iconsax.tick_circle_copy,
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
                                      : Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant
                                            .withAlpha(120),
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
                    ),
                  ),
                  SizedBox(width: 5),
                  SizedBox(
                    width: MediaQuery.maybeWidthOf(context)! * 0.59,
                    height: 50,
                    child: TextField(
                      controller: nameController,
                      focusNode: focusNode,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      decoration: InputDecoration(
                        isDense: true,
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.onPrimary,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            width: 2,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ),
                        ),
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
                  itemCount: IconHelper.catIcons.length,
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
                          IconHelper.getIconsaxIcon(IconHelper.catIcons[index]),
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
                            icon: IconHelper.catIcons[selectedIcon],
                            isIgnored: false,
                          ),
                        );
                      } else {
                        final cat = widget.category!;
                        cat.categoryId = widget.category!.categoryId;
                        cat.type = widget.category!.type;
                        cat.name = nameController.text.trim();
                        cat.icon = IconHelper.catIcons[selectedIcon];
                        await controller.updateCategory(cat);
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
