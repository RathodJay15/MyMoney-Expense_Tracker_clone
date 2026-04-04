import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:mymoneyclone/controllers/accounts_controller.dart';
import 'package:mymoneyclone/controllers/categories_controller.dart';
import 'package:mymoneyclone/controllers/records_controller.dart';
import 'package:mymoneyclone/core/constants/app_colors.dart';
import 'package:mymoneyclone/core/constants/app_constants.dart';
import 'package:mymoneyclone/core/constants/app_helper.dart';
import 'package:mymoneyclone/core/theme/icon_helper.dart';
import 'package:mymoneyclone/data/models/accounts_model.dart';
import 'package:mymoneyclone/data/models/category_model.dart';
import 'package:mymoneyclone/data/models/records_model.dart';
import 'package:mymoneyclone/presentation/widgets/add_account.dart';
import 'package:mymoneyclone/presentation/widgets/app_snackbar.dart';

class AddRecordScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddRecordScreenState();
}

class _AddRecordScreenState extends State<AddRecordScreen> {
  // RecordsController recordsController = Get.put(RecordsController());
  RecordsController recordsController = Get.find();

  String selectedType = AppConstants.expense;
  String enteredAmount = "0";
  String? selectedDate;
  String? selectedTime;
  AccountModel? selectedAccount;
  AccountModel? transferAccount;
  CategoryModel? selectedCategory;

  String operator = "";
  double firstValue = 0;
  bool isOperatorClicked = false;

  TextEditingController noteController = TextEditingController();

  void _getDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: AppHelper.getFormattedDateTime(selectedDate!),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        selectedDate = AppHelper.getFormattedDateString(picked);
      });
    }
  }

  void _addRecord() {
    if (enteredAmount == "0" || enteredAmount.isEmpty) {
      AppSnackbar.showSnackBar(
        context,
        Iconsax.dollar_circle,
        AppConstants.amountCantBeZero,
      );
      return;
    }
    if (selectedAccount == null) {
      AppSnackbar.showSnackBar(
        context,
        Iconsax.wallet,
        AppConstants.noAccountSelected,
      );
      return;
    }
    if (selectedType == AppConstants.transfer) {
      if (selectedAccount == transferAccount) {
        AppSnackbar.showSnackBar(
          context,
          Iconsax.wallet,
          AppConstants.transferAccountsAreSame,
        );
        return;
      }
    } else {
      if (selectedCategory == null) {
        AppSnackbar.showSnackBar(
          context,
          Iconsax.category_2,
          AppConstants.noCategorySelected,
        );
        return;
      }
    }

    if (selectedType == AppConstants.transfer) {
      recordsController.addRecord(
        RecordModel(
          type: selectedType,
          account: selectedAccount!.name,
          category: null,
          transferAccount: transferAccount!.name,
          amount: double.parse(enteredAmount),
          date: selectedDate!,
          time: selectedTime!,
        ),
      );
    } else {
      recordsController.addRecord(
        RecordModel(
          type: selectedType,
          account: selectedAccount!.name,
          category: selectedCategory!.name,
          transferAccount: null,
          amount: double.parse(enteredAmount),
          date: selectedDate!,
          time: selectedTime!,
        ),
      );
    }
    Get.back();
    print(
      "---------------------------------${recordsController.groupedRecords.length}",
    );
  }

  void _getTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: AppHelper.getFormattedTime(selectedTime!),
    );
    if (picked != null) {
      setState(() {
        selectedTime = AppHelper.getFormattedTimeString(picked, context);
      });
    }
  }

  String formatResult(double value) {
    if (value % 1 == 0) {
      return value.toInt().toString();
    } else {
      return value.toString();
    }
  }

  @override
  void didChangeDependencies() {
    selectedDate = AppHelper.getFormattedDateString(DateTime.now());
    selectedTime = AppHelper.getFormattedTimeString(TimeOfDay.now(), context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buttonsHeader(),
            _typeChoice(),
            _accountCategory(),
            Expanded(child: _noteSection()),
            SizedBox(height: 8),
            _calculatorSection(),
            _dateTimeSection(),
          ],
        ),
      ),
    );
  }

  Widget _buttonsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            Get.back();
          },
          borderRadius: BorderRadius.circular(10),
          splashColor: Theme.of(
            context,
          ).colorScheme.onSurfaceVariant.withAlpha(50),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: 110,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Iconsax.close_circle_copy,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  Text(
                    AppConstants.cancel,
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        InkWell(
          onTap: _addRecord,
          borderRadius: BorderRadius.circular(10),
          splashColor: Theme.of(
            context,
          ).colorScheme.onSurfaceVariant.withAlpha(50),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Iconsax.tick_circle_copy,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  Text(
                    AppConstants.save,
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _typeChoice() {
    return Padding(
      padding: EdgeInsets.all(5),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _types(AppConstants.income),
            VerticalDivider(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              thickness: 2,
              width: 20,
            ),
            _types(AppConstants.expense),
            VerticalDivider(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              thickness: 2,
              width: 20,
            ),
            _types(AppConstants.transfer),
          ],
        ),
      ),
    );
  }

  Widget _types(String name) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedType = name;
          selectedAccount = null;
          selectedCategory = null;
          transferAccount = null;
        });
      },
      borderRadius: BorderRadius.circular(10),
      splashColor: Theme.of(context).colorScheme.onSurfaceVariant.withAlpha(50),
      child: SizedBox(
        height: 30,
        width: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (selectedType == name)
              Padding(
                padding: const EdgeInsets.only(right: 3),
                child: Icon(
                  Iconsax.tick_circle,
                  size: 20,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            Text(
              name,
              style: TextStyle(
                fontSize: 15,
                color: selectedType == name
                    ? Theme.of(context).colorScheme.onSurfaceVariant
                    : Theme.of(
                        context,
                      ).colorScheme.onSurfaceVariant.withAlpha(120),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _accountCategory() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: AlignmentGeometry.center,
                  child: Text(
                    selectedType == AppConstants.transfer
                        ? AppConstants.from
                        : AppConstants.account,
                    style: TextStyle(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurfaceVariant.withAlpha(120),
                      fontSize: 20,
                    ),
                  ),
                ),
                SizedBox(
                  width: 200,
                  height: 50,
                  child: OutlinedButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        useSafeArea: true,
                        builder: (context) {
                          return _accountSelection(true);
                        },
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        width: 2,
                      ),
                    ),
                    child: selectedAccount == null
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Iconsax.wallet,
                                size: 35,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                              SizedBox(width: 5),

                              Text(
                                AppConstants.account,
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          )
                        : _showSelectedAccount(selectedAccount!),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 5),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: AlignmentGeometry.center,
                  child: Text(
                    selectedType == AppConstants.transfer
                        ? AppConstants.to
                        : AppConstants.category,
                    style: TextStyle(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurfaceVariant.withAlpha(120),
                      fontSize: 20,
                    ),
                  ),
                ),
                SizedBox(
                  width: 200,
                  height: 50,
                  child: OutlinedButton(
                    onPressed: () {
                      if (selectedType != AppConstants.transfer) {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          useSafeArea: true,
                          builder: (context) {
                            return _catgorySelection();
                          },
                        );
                      } else {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          useSafeArea: true,
                          builder: (context) {
                            return _accountSelection(false);
                          },
                        );
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        width: 2,
                      ),
                    ),
                    child: transferAccount == null && selectedCategory == null
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                selectedType == AppConstants.transfer
                                    ? Iconsax.wallet
                                    : Iconsax.category,
                                size: 35,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                              SizedBox(width: 5),

                              Text(
                                selectedType == AppConstants.transfer
                                    ? AppConstants.account
                                    : AppConstants.category,
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          )
                        : transferAccount == null && selectedCategory != null
                        ? _showSelecteCategory(selectedCategory!)
                        : _showSelectedAccount(transferAccount!),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _showSelectedAccount(AccountModel account) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 35,
          width: 35,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(7),
          ),
          child: Icon(
            IconHelper.getIconsaxIcon(account.icon),
            color: Theme.of(context).colorScheme.onPrimary,
            size: 25,
          ),
        ),
        SizedBox(width: 5),
        Text(
          account.name,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 18,
          ),
        ),
      ],
    );
  }

  Widget _showSelecteCategory(CategoryModel category) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: AppColors.blueBG,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Icon(
            IconHelper.getIconsaxIcon(category.icon),
            size: 30,
            color: AppColors.whitIcon,
          ),
        ),
        SizedBox(width: 5),
        Text(
          category.name,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 18,
          ),
        ),
      ],
    );
  }

  Widget _noteSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextField(
        controller: noteController,
        keyboardType: TextInputType.text,
        style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
        maxLines: 10,
        decoration: InputDecoration(
          isDense: true,
          filled: true,
          hintText: AppConstants.addNotes,
          fillColor: Theme.of(context).colorScheme.onPrimary,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              width: 2,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              width: 2,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }

  Widget _calculatorSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Container(
            height: 100,
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                width: 2,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  operator,
                  style: TextStyle(
                    fontSize: 30,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        enteredAmount,
                        style: TextStyle(
                          fontSize: 65,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            if (enteredAmount.length > 1) {
                              enteredAmount = enteredAmount.substring(
                                0,
                                enteredAmount.length - 1,
                              );
                            } else {
                              enteredAmount = "0";
                            }
                          });
                        },
                        borderRadius: BorderRadius.circular(5),
                        splashColor: Theme.of(
                          context,
                        ).colorScheme.onSurfaceVariant.withAlpha(10),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 25,
                          ),
                          child: Icon(
                            Iconsax.tag_cross_copy,
                            size: 30,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 5),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _calcButton(isSign: true, value: "+"),
              _calcButton(isSign: false, value: "7"),
              _calcButton(isSign: false, value: "8"),
              _calcButton(isSign: false, value: "9"),
            ],
          ),
        ),
        SizedBox(height: 5),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _calcButton(isSign: true, value: "-"),
              _calcButton(isSign: false, value: "4"),
              _calcButton(isSign: false, value: "5"),
              _calcButton(isSign: false, value: "6"),
            ],
          ),
        ),
        SizedBox(height: 5),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _calcButton(isSign: true, value: "×"),
              _calcButton(isSign: false, value: "1"),
              _calcButton(isSign: false, value: "2"),
              _calcButton(isSign: false, value: "3"),
            ],
          ),
        ),
        SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _calcButton(isSign: true, value: "÷"),
              _calcButton(isSign: false, value: "0"),
              _calcButton(isSign: false, value: "."),
              _calcButton(isSign: true, value: "="),
            ],
          ),
        ),
      ],
    );
  }

  Widget _calcButton({required bool isSign, required String value}) {
    return SizedBox(
      width: MediaQuery.widthOf(context) * 0.23,
      height: 80,
      child: OutlinedButton(
        onPressed: () {
          double result = 0;
          setState(() {
            if (!isSign) {
              if (enteredAmount.length >= 9) return;

              if (value == ".") {
                if (enteredAmount.contains(".")) return;

                enteredAmount += value;
                return;
              }

              if (enteredAmount == "0" || isOperatorClicked) {
                enteredAmount = value;
                isOperatorClicked = false;
              } else {
                enteredAmount += value;
              }
            } else {
              if (value == "=") {
                double secondValue = double.parse(enteredAmount);

                switch (operator) {
                  case "+":
                    result = firstValue + secondValue;
                    break;
                  case "-":
                    result = firstValue - secondValue;
                    break;
                  case "×":
                    result = firstValue * secondValue;
                    break;
                  case "÷":
                    if (secondValue == 0) {
                      enteredAmount = "0";
                      operator = "";
                      return;
                    }
                    result = firstValue / secondValue;
                    break;
                }

                enteredAmount = formatResult(result);

                operator = "";
                isOperatorClicked = true;
              } else {
                // store first value and operator
                firstValue = double.parse(enteredAmount);
                operator = value;
                isOperatorClicked = true;
              }
            }
          });
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: isSign
              ? Theme.of(context).colorScheme.surface
              : Theme.of(context).colorScheme.onSurfaceVariant,
          backgroundColor: isSign
              ? Theme.of(context).colorScheme.onSurfaceVariant
              : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          side: BorderSide(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            width: 2,
          ),
        ),
        child: Text(
          value,
          style: TextStyle(
            color: isSign
                ? Theme.of(context).colorScheme.surface
                : Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 30,
          ),
        ),
      ),
    );
  }

  Widget _dateTimeSection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: IntrinsicHeight(
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: InkWell(
                splashColor: Theme.of(
                  context,
                ).colorScheme.onSurfaceVariant.withAlpha(50),

                onTap: _getDate,
                borderRadius: BorderRadius.circular(5),
                child: Center(
                  child: Text(
                    selectedDate ?? "",
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ),
            VerticalDivider(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              thickness: 2,
              width: 20,
            ),
            Expanded(
              child: InkWell(
                splashColor: Theme.of(
                  context,
                ).colorScheme.onSurfaceVariant.withAlpha(50),

                onTap: () => _getTime(context),
                borderRadius: BorderRadius.circular(5),
                child: Center(
                  child: Text(
                    selectedTime ?? "",
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _accountSelection(bool isFromAccount) {
    AccountsController accController = Get.find();
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              AppConstants.selectAnAccount,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Obx(() {
            final accounts = accController.accounts;
            return ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: accounts.length,
              itemBuilder: (context, index) {
                final account = accounts[index];
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        if (isFromAccount) {
                          selectedAccount = account;
                        } else {
                          transferAccount = account;
                        }
                      });
                      Get.back();
                    },
                    borderRadius: BorderRadius.circular(10),
                    splashColor: Theme.of(
                      context,
                    ).colorScheme.onSurfaceVariant.withAlpha(50),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: ListTile(
                        leading: Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            color: AppColors.whitIcon,
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Icon(
                            IconHelper.getIconsaxIcon(account.icon),
                            size: 40,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                        title: Text(
                          account.name,
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                            fontSize: 18,
                          ),
                        ),
                        trailing: Text(
                          AppConstants.amount(account.balance),
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onInverseSurface,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: _addButton(AppConstants.addNewAcc),
          ),
        ],
      ),
    );
  }

  Widget _catgorySelection() {
    CategoryController catController = Get.find();
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              AppConstants.selectACategory,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Obx(() {
            final categories = selectedType == AppConstants.expense
                ? catController.expenseCategories
                : catController.incomeCategories;
            return SizedBox(
              height: MediaQuery.heightOf(context) * 0.77,
              child: GridView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 0,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1.1,
                ),
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          selectedCategory = category;
                        });
                        Get.back();
                      },
                      borderRadius: BorderRadius.circular(10),
                      splashColor: Theme.of(
                        context,
                      ).colorScheme.onSurfaceVariant.withAlpha(50),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              color: AppColors.blueBG,

                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Icon(
                              IconHelper.getIconsaxIcon(category.icon),
                              size: 50,
                              color: AppColors.whitIcon,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            category.name,
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                              overflow: TextOverflow.ellipsis,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                itemCount: categories.length,
              ),
            );
          }),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: _addButton(AppConstants.addNewCat),
          ),
        ],
      ),
    );
  }

  Widget _addButton(String txt) {
    return SizedBox(
      width: 230,
      child: OutlinedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AccountDialog(title: txt, account: null);
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
                AppConstants.addNewAcc,
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
