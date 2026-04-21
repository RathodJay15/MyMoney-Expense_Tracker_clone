import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:mymoneyclone/data/models/type_model.dart';
import 'package:mymoneyclone/presentation/widgets/app_snackbar.dart';

class AddRecordScreen extends StatefulWidget {
  String title;
  RecordModel? oldRecord;
  AddRecordScreen({required this.title, required this.oldRecord});
  @override
  State<StatefulWidget> createState() => AddRecordScreenState();
}

class AddRecordScreenState extends State<AddRecordScreen> {
  final _formKey = GlobalKey<FormState>();
  RecordsController recordsController = Get.find();
  AccountsController accountsController = Get.find();
  CategoryController categoryController = Get.find();

  TextEditingController noteController = TextEditingController();

  String? selectedType;
  String enteredAmount = "0";
  DateTime? selectedDate;
  String? selectedTime;
  String operator = "";
  double firstValue = 0;
  bool isOperatorClicked = false;

  AccountModel? selectedAccount;
  AccountModel? transferAccount;
  CategoryModel? selectedCategory;

  void _addRecord() async {
    if (!_formKey.currentState!.validate()) return;

    if (enteredAmount == "0" || enteredAmount.isEmpty) {
      AppSnackbar.showSnackBar(
        context,
        Iconsax.dollar_circle,
        AppConstants.amountCantBeZero,
      );
      return;
    }

    final isTransfer = selectedType == AppConstants.transfer;
    final isUpdate = widget.oldRecord != null;

    if (isUpdate) {
      final record = widget.oldRecord!;

      record.type = selectedType!;
      record.accountId = selectedAccount!.key;
      record.categoryId = isTransfer ? null : selectedCategory!.key;
      record.transferAccountId = isTransfer ? transferAccount!.key : null;
      record.amount = double.parse(enteredAmount);
      record.note = noteController.text.trim();
      record.date = selectedDate!;
      record.time = selectedTime!;

      record.save();

      recordsController.updateAccountBalance(selectedAccount!.key);
    } else {
      final record = RecordModel(
        type: selectedType!,
        accountId: selectedAccount!.key,
        categoryId: isTransfer ? null : selectedCategory!.key,
        transferAccountId: isTransfer ? transferAccount!.key : null,
        amount: double.parse(enteredAmount),
        note: noteController.text.trim(),
        date: selectedDate!,
        time: selectedTime!,
      );

      recordsController.addRecord(record);
    }

    await recordsController.fetchRecords();
    if (isTransfer) {
      recordsController.updateAccountBalance(selectedAccount!.key);
      recordsController.updateAccountBalance(transferAccount!.key);
    } else {
      recordsController.updateAccountBalance(selectedAccount!.key);
    }
    Get.back();
    accountsController.fetchAccounts();
  }

  void _getDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
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
    recordsController.fetchTypes();
    if (widget.oldRecord == null) {
      selectedType = AppConstants.expense;
      selectedDate = DateTime.now();
      selectedTime = AppHelper.getFormattedTimeString(TimeOfDay.now(), context);
    } else {
      final account = recordsController.getAccById(widget.oldRecord!.accountId);
      AccountModel? transferAccountOld;
      CategoryModel? category;
      if (widget.oldRecord!.type == AppConstants.transfer) {
        transferAccountOld = recordsController.getAccById(
          widget.oldRecord!.transferAccountId!,
        );
      } else {
        category = recordsController.getCatById(widget.oldRecord!.categoryId!);
      }

      selectedDate = widget.oldRecord!.date;
      selectedTime = widget.oldRecord!.time;
      selectedType = widget.oldRecord!.type;
      selectedAccount = account;
      selectedCategory = category;
      transferAccount = transferAccountOld;
      noteController.text = widget.oldRecord!.note ?? "";
      enteredAmount = widget.oldRecord!.amount.toString();
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: Theme.of(context).colorScheme.onSurface,
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          height: MediaQuery.heightOf(context),
          width: MediaQuery.widthOf(context),
          color: Theme.of(context).colorScheme.onSurface,
          child: Stack(
            children: [
              _headerSection(),
              Positioned(
                bottom: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    height: MediaQuery.heightOf(context) * 0.90,
                    width: MediaQuery.widthOf(context) - 40,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onSurface,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).colorScheme.surface,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: _bodySection(),
                  ),
                ),
              ),
              Positioned(bottom: 0, child: _calculatorSection()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _headerSection() {
    return Container(
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
                  vertical: 35,
                  horizontal: 5,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(
                        Icons.keyboard_arrow_left_rounded,
                        size: 35,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      widget.title,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: _addRecord,
                      icon: Icon(
                        Icons.check_rounded,
                        size: 30,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _bodySection() {
    return Obx(() {
      final List<TypeModel> typeList = recordsController.types;
      final List<AccountModel> accountList = accountsController.accounts;
      final List<CategoryModel> incomeList = categoryController.incomeCategories
          .where((c) => c.isIgnored == false)
          .toList();
      final List<CategoryModel> expenseList = categoryController
          .expenseCategories
          .where((c) => c.isIgnored == false)
          .toList();
      return Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _title(AppConstants.type),
            SizedBox(height: 5),
            _customDropDown(
              typeList,
              AppConstants.selectAType,
              AppConstants.type,
              Validations.type,
              initVal: widget.oldRecord != null ? selectedType : null,
            ),

            SizedBox(height: 8),

            _title(
              selectedType == AppConstants.transfer
                  ? AppConstants.from
                  : AppConstants.account,
            ),
            SizedBox(height: 5),
            _customDropDown(
              accountList,
              AppConstants.selectAnAccount,
              AppConstants.account,
              Validations.account,
              initVal: widget.oldRecord != null ? selectedAccount!.name : null,
            ),

            SizedBox(height: 8),

            if (selectedType == AppConstants.transfer) ...[
              _title(AppConstants.to),
              SizedBox(height: 5),
              _customDropDown(
                accountList,
                AppConstants.selectAnAccount,
                AppConstants.transfer,
                Validations.transfer,
                initVal: widget.oldRecord != null
                    ? transferAccount!.name
                    : null,
              ),
            ] else ...[
              _title(AppConstants.category),
              SizedBox(height: 5),
              _customDropDown(
                selectedType == AppConstants.income ? incomeList : expenseList,
                AppConstants.selectACategory,
                AppConstants.category,
                Validations.category,
                initVal: widget.oldRecord != null
                    ? selectedCategory!.name
                    : null,
              ),
            ],
            SizedBox(height: 8),

            _dateTime(),

            SizedBox(height: 8),

            _title(AppConstants.addNotes),
            SizedBox(height: 5),
            _noteSection(),
          ],
        ),
      );
    });
  }

  Widget _title(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Theme.of(context).colorScheme.surface,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _customDropDown(
    List<dynamic> list,
    String hint,
    String dropdownType,
    String? Function(String?)? validator, {
    String? initVal,
  }) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.error,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.surface,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        // Border when the dropdown IS focused/open
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Theme.of(
          context,
        ).colorScheme.onSurface, // Background of the field itself
      ),
      dropdownColor: Theme.of(context).colorScheme.onSurface,
      iconEnabledColor: Theme.of(context).colorScheme.surface,
      icon: Icon(Iconsax.arrow_down, size: 20),
      hint: Text(
        hint,
        style: TextStyle(
          color: Theme.of(context).colorScheme.surface,
          fontSize: 18,
        ),
      ),
      initialValue: list.any((e) => e.name == initVal) ? initVal : null,
      items: list.map((var e) {
        return DropdownMenuItem<String>(
          value: e.name,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              e.runtimeType == TypeModel
                  ? SizedBox()
                  : Icon(
                      IconHelper.getIconsaxIcon(e.icon),
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
              SizedBox(width: 5),
              SizedBox(
                width: 180,
                child: Text(
                  e.name,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              // SizedBox(width: 30),
              e.runtimeType == AccountModel
                  ? Text(
                      AppConstants.amount(e.balance),
                      style: TextStyle(
                        color: e.balance >= 0
                            ? Theme.of(context).colorScheme.onInverseSurface
                            : Theme.of(context).colorScheme.error,
                      ),
                    )
                  : SizedBox(),
            ],
          ),
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          final selectedItem = list.firstWhere((e) => e.name == newValue);

          if (dropdownType == AppConstants.type) {
            selectedType = newValue;

            selectedCategory = null;
            transferAccount = null;
            selectedAccount = null;
          } else if (dropdownType == AppConstants.account) {
            selectedAccount = selectedItem as AccountModel;
          } else if (dropdownType == AppConstants.category) {
            selectedCategory = selectedItem as CategoryModel;
          } else if (dropdownType == AppConstants.transfer) {
            transferAccount = selectedItem as AccountModel;
          }
        });
      },
      validator: validator,
    );
  }

  Widget _dateTime() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              _title(AppConstants.date),
              SizedBox(height: 5),
              InkWell(
                splashColor: Theme.of(context).colorScheme.primary,
                onTap: _getDate,
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.surface,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      AppHelper.getFormattedDateString(selectedDate!),
                      style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).colorScheme.surface,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 10),
        Flexible(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              _title(AppConstants.time),
              SizedBox(height: 5),
              InkWell(
                splashColor: Theme.of(context).colorScheme.primary,
                onTap: () => _getTime(context),
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.surface,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      selectedTime!,
                      style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).colorScheme.surface,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _noteSection() {
    return TextField(
      controller: noteController,
      keyboardType: TextInputType.text,
      style: TextStyle(
        color: Theme.of(context).colorScheme.surface,
        fontSize: 18,
      ),
      maxLines: 2,
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        hintText: AppConstants.addNotes,
        fillColor: Theme.of(context).colorScheme.onSurface,
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
    );
  }

  Widget _calculatorSection() {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(10),
        width: MediaQuery.widthOf(context),
        color: Theme.of(context).colorScheme.onSecondary,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 90,
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).colorScheme.onSurface,
                // border: Border.all(
                //   color: Theme.of(context).colorScheme.surface,
                //   width: 2,
                // ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      operator,
                      style: TextStyle(
                        fontSize: 30,
                        color: Theme.of(context).colorScheme.surface,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        enteredAmount,
                        style: TextStyle(
                          fontSize: 55,
                          color: Theme.of(context).colorScheme.surface,
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
                        ).colorScheme.primary.withAlpha(10),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 25,
                          ),
                          child: Icon(
                            Iconsax.tag_cross_copy,
                            size: 30,
                            color: Theme.of(context).colorScheme.surface,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 5),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _calcButton(isSign: true, value: "+"),
                _calcButton(isSign: false, value: "7"),
                _calcButton(isSign: false, value: "8"),
                _calcButton(isSign: false, value: "9"),
              ],
            ),
            SizedBox(height: 5),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _calcButton(isSign: true, value: "-"),
                _calcButton(isSign: false, value: "4"),
                _calcButton(isSign: false, value: "5"),
                _calcButton(isSign: false, value: "6"),
              ],
            ),
            SizedBox(height: 5),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _calcButton(isSign: true, value: "×"),
                _calcButton(isSign: false, value: "1"),
                _calcButton(isSign: false, value: "2"),
                _calcButton(isSign: false, value: "3"),
              ],
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _calcButton(isSign: true, value: "÷"),
                _calcButton(isSign: false, value: "0"),
                _calcButton(isSign: false, value: "."),
                _calcButton(isSign: true, value: "="),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _calcButton({required bool isSign, required String value}) {
    return SizedBox(
      width: MediaQuery.widthOf(context) * 0.23,
      height: 50,
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
          backgroundColor: Theme.of(context).colorScheme.onSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          value,
          style: TextStyle(
            color: isSign
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.primaryContainer,
            fontSize: 30,
          ),
        ),
      ),
    );
  }
}

class Validations {
  static String? type(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppConstants.noTypeSelected;
    }
    return null;
  }

  static String? account(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppConstants.noAccountSelected;
    }
    return null;
  }

  static String? category(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppConstants.noCategorySelected;
    }
    return null;
  }

  static String? transfer(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppConstants.transferAccountsAreSame;
    }
    return null;
  }
}
