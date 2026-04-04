import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mymoneyclone/controllers/accounts_controller.dart';
import 'package:mymoneyclone/core/constants/app_colors.dart';
import 'package:mymoneyclone/core/constants/app_constants.dart';
import 'package:mymoneyclone/core/theme/icon_helper.dart';
import 'package:mymoneyclone/data/models/accounts_model.dart';

class AccountDialog extends StatefulWidget {
  final String title;
  final AccountModel? account;

  AccountDialog({super.key, required this.title, required this.account});

  @override
  State<AccountDialog> createState() => _AccountDialogState();
}

class _AccountDialogState extends State<AccountDialog> {
  AccountsController accController = Get.find();

  // final AccountC controller = Get.find();
  late TextEditingController nameController;
  late TextEditingController initialAmountController;
  int selectedIcon = 0;

  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    nameController = TextEditingController(
      text: widget.account != null
          ? widget.account!.name
          : AppConstants.untitled,
    );

    initialAmountController = TextEditingController(
      text: widget.account != null
          ? widget.account!.initialAmount.toString()
          : AppConstants.initAmountVal,
    );

    selectedIcon = widget.account != null
        ? IconHelper.catIcons.indexOf(widget.account!.icon)
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

              SizedBox(height: widget.title == AppConstants.addNewAcc ? 16 : 0),

              /// Initial Amount Field
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    AppConstants.initAmountTxt,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(width: 5),
                  SizedBox(
                    width: MediaQuery.maybeWidthOf(context)! * 0.43,
                    height: 50,
                    child: TextField(
                      controller: initialAmountController,
                      keyboardType: TextInputType.number,
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

              SizedBox(height: 8),

              Text(
                AppConstants.initAmountMsg,
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurfaceVariant.withAlpha(200),
                  fontSize: 14,
                ),
              ),

              SizedBox(height: 8),

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
                    child: TextField(
                      controller: nameController,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.onPrimary,
                        isDense: true,
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
                      if (widget.account == null) {
                        accController.addAccounts(
                          AccountModel(
                            name: nameController.text,
                            balance: double.parse(initialAmountController.text),
                            icon: IconHelper.catIcons[selectedIcon],
                            isIgnored: false,
                            initialAmount: double.parse(
                              initialAmountController.text,
                            ),
                          ),
                        );
                      } else {
                        final acc = widget.account!;

                        acc.name = nameController.text;
                        acc.icon = IconHelper.catIcons[selectedIcon];
                        acc.initialAmount = double.parse(
                          initialAmountController.text,
                        );
                        acc.isIgnored = false;
                        accController.updateAccounts(acc);
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
