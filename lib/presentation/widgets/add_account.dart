import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mymoneyclone/controllers/accounts_controller.dart';
import 'package:mymoneyclone/controllers/records_controller.dart';
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
  RecordsController recController = Get.find();

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
    initialAmountController.selection = TextSelection(
      baseOffset: 0,
      extentOffset: initialAmountController.text.length,
    );
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    initialAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Title
              Text(
                widget.title,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: widget.title == AppConstants.addNewAcc ? 16 : 0),

              /// Initial Amount Field
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppConstants.initAmountTxt,
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
                  controller: initialAmountController,
                  keyboardType: TextInputType.number,
                  focusNode: focusNode,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  decoration: InputDecoration(
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

              Text(
                AppConstants.initAmountMsg,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.surface.withAlpha(200),
                  fontSize: 14,
                ),
              ),

              /// Name Field
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppConstants.name,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    fontSize: 18,
                  ),
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                child: TextField(
                  controller: nameController,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  decoration: InputDecoration(
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

              const SizedBox(height: 10),

              /// Icon Label
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppConstants.icon,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primaryContainer,
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
                  borderRadius: BorderRadius.circular(12),
                  border: BoxBorder.all(
                    width: 2,
                    color: Theme.of(context).colorScheme.surface,
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
                          color: Theme.of(context).colorScheme.onSecondary,
                          borderRadius: BorderRadius.circular(5),
                          border: selectedIcon == index
                              ? Border.all(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 2,
                                )
                              : null,
                        ),
                        child: Icon(
                          IconHelper.getIconsaxIcon(IconHelper.catIcons[index]),
                          color: Theme.of(context).colorScheme.onPrimary,
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
                        recController.updateAccountBalance(acc.key);
                      }
                      Get.back();
                    },
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
                      AppConstants.save,
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
      ),
    );
  }
}
