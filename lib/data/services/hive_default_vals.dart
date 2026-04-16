import 'package:hive/hive.dart';
import 'package:mymoneyclone/data/models/records_model.dart';
import 'package:mymoneyclone/data/models/type_model.dart';
import '../models/category_model.dart';
import '../models/accounts_model.dart';
import '../../core/constants/app_constants.dart';

class HiveDefaultVals {
  static Future<void> defaultVals() async {
    final categoryBox = Hive.box<CategoryModel>(AppConstants.categoryHiveBox);

    final accountBox = Hive.box<AccountModel>(AppConstants.accountHiveBox);

    final typeBox = Hive.box<TypeModel>(AppConstants.typeHiveBox);

    final recordBox = Hive.box<RecordModel>(AppConstants.recordHiveBox);

    if (categoryBox.isEmpty) {
      await categoryBox.addAll([
        // INCOME
        CategoryModel(
          name: 'Awards',
          type: 'INCOME',
          icon: 'award',
          isIgnored: false,
          isBudgeted: false,
        ),
        CategoryModel(
          name: 'Coupons',
          type: 'INCOME',
          icon: 'ticket_discount',
          isIgnored: false,
          isBudgeted: false,
        ),
        CategoryModel(
          name: 'Grants',
          type: 'INCOME',
          icon: 'gift',
          isIgnored: false,
          isBudgeted: false,
        ),
        CategoryModel(
          name: 'Lottery',
          type: 'INCOME',
          icon: 'ticket_star',
          isIgnored: false,
          isBudgeted: false,
        ),
        CategoryModel(
          name: 'Refunds',
          type: 'INCOME',
          icon: 'money_recive',
          isIgnored: false,
          isBudgeted: false,
        ),
        CategoryModel(
          name: 'Rental',
          type: 'INCOME',
          icon: 'home_2',
          isIgnored: false,
          isBudgeted: false,
        ),
        CategoryModel(
          name: 'Salary',
          type: 'INCOME',
          icon: 'wallet_3',
          isIgnored: false,
          isBudgeted: false,
        ),
        CategoryModel(
          name: 'Sale',
          type: 'INCOME',
          icon: 'tag',
          isIgnored: false,
          isBudgeted: false,
        ),

        // EXPENSE
        CategoryModel(
          name: 'Baby',
          type: 'EXPENSE',
          icon: 'happyemoji',
          isIgnored: false,
          isBudgeted: false,
        ),
        CategoryModel(
          name: 'Beauty',
          type: 'EXPENSE',
          icon: 'brush_2',
          isIgnored: false,
          isBudgeted: false,
        ),
        CategoryModel(
          name: 'Bills',
          type: 'EXPENSE',
          icon: 'receipt_item',
          isIgnored: false,
          isBudgeted: false,
        ),
        CategoryModel(
          name: 'Car',
          type: 'EXPENSE',
          icon: 'car',
          isIgnored: false,
          isBudgeted: false,
        ),
        CategoryModel(
          name: 'Clothing',
          type: 'EXPENSE',
          icon: 'shop',
          isIgnored: false,
          isBudgeted: false,
        ),
        CategoryModel(
          name: 'Education',
          type: 'EXPENSE',
          icon: 'teacher',
          isIgnored: false,
          isBudgeted: false,
        ),
        CategoryModel(
          name: 'Electronics',
          type: 'EXPENSE',
          icon: 'device_message',
          isIgnored: false,
          isBudgeted: false,
        ),
        CategoryModel(
          name: 'Entertainment',
          type: 'EXPENSE',
          icon: 'video_play',
          isIgnored: false,
          isBudgeted: false,
        ),
        CategoryModel(
          name: 'Food',
          type: 'EXPENSE',
          icon: 'milk',
          isIgnored: false,
          isBudgeted: false,
        ),
        CategoryModel(
          name: 'Health',
          type: 'EXPENSE',
          icon: 'heart',
          isIgnored: false,
          isBudgeted: false,
        ),
        CategoryModel(
          name: 'Home',
          type: 'EXPENSE',
          icon: 'home',
          isIgnored: false,
          isBudgeted: false,
        ),
        CategoryModel(
          name: 'Insurance',
          type: 'EXPENSE',
          icon: 'security_safe',
          isIgnored: false,
          isBudgeted: false,
        ),
        CategoryModel(
          name: 'Shopping',
          type: 'EXPENSE',
          icon: 'shopping_cart',
          isIgnored: false,
          isBudgeted: false,
        ),
        CategoryModel(
          name: 'Social',
          type: 'EXPENSE',
          icon: 'people',
          isIgnored: false,
          isBudgeted: false,
        ),
        CategoryModel(
          name: 'Sport',
          type: 'EXPENSE',
          icon: 'cup',
          isIgnored: false,
          isBudgeted: false,
        ),
        CategoryModel(
          name: 'Tax',
          type: 'EXPENSE',
          icon: 'receipt_edit',
          isIgnored: false,
          isBudgeted: false,
        ),
        CategoryModel(
          name: 'Telephone',
          type: 'EXPENSE',
          icon: 'call',
          isIgnored: false,
          isBudgeted: false,
        ),
        CategoryModel(
          name: 'Transportation',
          type: 'EXPENSE',
          icon: 'bus',
          isIgnored: false,
          isBudgeted: false,
        ),
      ]);
    }

    if (accountBox.isEmpty) {
      await accountBox.addAll([
        AccountModel(
          name: 'Card',
          balance: 10000,
          initialAmount: 10000,
          icon: 'home_2',
          isIgnored: false,
        ),
        AccountModel(
          name: 'Cash',
          balance: 5000,
          initialAmount: 5000,
          icon: 'wallet_3',
          isIgnored: false,
        ),
        AccountModel(
          name: 'Savings',
          balance: 20000,
          initialAmount: 20000,
          icon: 'tag',
          isIgnored: false,
        ),
      ]);
    }

    if (typeBox.isEmpty) {
      await typeBox.addAll([
        TypeModel(name: AppConstants.income),
        TypeModel(name: AppConstants.expense),
        TypeModel(name: AppConstants.transfer),
      ]);
    }

    if (recordBox.isEmpty) {
      await recordBox.addAll([
        // ================= FEB =================

        // Feb 3
        RecordModel(
          type: AppConstants.income,
          accountId: 0,
          categoryId: 6, // Salary
          transferAccountId: null,
          amount: 5000,
          note: "Salary Feb",
          date: DateTime(2026, 2, 3),
          time: "10:00 AM",
        ),
        RecordModel(
          type: AppConstants.expense,
          accountId: 1,
          categoryId: 8, // Food
          transferAccountId: null,
          amount: 300,
          note: "Lunch",
          date: DateTime(2026, 2, 3),
          time: "2:00 PM",
        ),

        // Feb 10
        RecordModel(
          type: AppConstants.expense,
          accountId: 0,
          categoryId: 10, // Bills
          transferAccountId: null,
          amount: 1200,
          note: "Electric bill",
          date: DateTime(2026, 2, 10),
          time: "9:00 AM",
        ),
        RecordModel(
          type: AppConstants.transfer,
          accountId: 1,
          categoryId: null,
          transferAccountId: 2,
          amount: 1000,
          note: "Transfer to savings",
          date: DateTime(2026, 2, 10),
          time: "6:00 PM",
        ),

        // Feb 27
        RecordModel(
          type: AppConstants.income,
          accountId: 2,
          categoryId: 6,
          transferAccountId: null,
          amount: 2000,
          note: "Bonus",
          date: DateTime(2026, 2, 27),
          time: "11:00 AM",
        ),
        RecordModel(
          type: AppConstants.expense,
          accountId: 0,
          categoryId: 17, // Transportation
          transferAccountId: null,
          amount: 150,
          note: "Auto fare",
          date: DateTime(2026, 2, 27),
          time: "7:00 PM",
        ),

        // ================= MARCH =================

        // March 3
        RecordModel(
          type: AppConstants.income,
          accountId: 0,
          categoryId: 6,
          transferAccountId: null,
          amount: 6000,
          note: "Salary March",
          date: DateTime(2026, 3, 3),
          time: "10:00 AM",
        ),
        RecordModel(
          type: AppConstants.expense,
          accountId: 1,
          categoryId: 8,
          transferAccountId: null,
          amount: 400,
          note: "Dinner",
          date: DateTime(2026, 3, 3),
          time: "10:00 PM",
        ),

        // March 10
        RecordModel(
          type: AppConstants.expense,
          accountId: 0,
          categoryId: 10,
          transferAccountId: null,
          amount: 900,
          note: "Internet",
          date: DateTime(2026, 3, 10),
          time: "9:00 AM",
        ),
        RecordModel(
          type: AppConstants.transfer,
          accountId: 0,
          categoryId: null,
          transferAccountId: 2,
          amount: 1500,
          note: "Savings transfer",
          date: DateTime(2026, 3, 10),
          time: "6:00 PM",
        ),

        // March 27
        RecordModel(
          type: AppConstants.income,
          accountId: 2,
          categoryId: 6,
          transferAccountId: null,
          amount: 2500,
          note: "Freelance",
          date: DateTime(2026, 3, 27),
          time: "12:00 PM",
        ),
        RecordModel(
          type: AppConstants.expense,
          accountId: 1,
          categoryId: 14, // Shopping
          transferAccountId: null,
          amount: 700,
          note: "Clothes",
          date: DateTime(2026, 3, 27),
          time: "5:00 PM",
        ),

        // ================= APRIL =================

        // April 3
        RecordModel(
          type: AppConstants.income,
          accountId: 0,
          categoryId: 6,
          transferAccountId: null,
          amount: 7000,
          note: "Salary April",
          date: DateTime(2026, 4, 3),
          time: "10:00 AM",
        ),
        RecordModel(
          type: AppConstants.expense,
          accountId: 1,
          categoryId: 8,
          transferAccountId: null,
          amount: 500,
          note: "Lunch",
          date: DateTime(2026, 4, 3),
          time: "1:00 PM",
        ),

        // April 10
        RecordModel(
          type: AppConstants.expense,
          accountId: 0,
          categoryId: 10,
          transferAccountId: null,
          amount: 1100,
          note: "Electricity",
          date: DateTime(2026, 4, 10),
          time: "9:00 AM",
        ),
        RecordModel(
          type: AppConstants.transfer,
          accountId: 1,
          categoryId: null,
          transferAccountId: 2,
          amount: 2000,
          note: "Savings",
          date: DateTime(2026, 4, 10),
          time: "6:00 PM",
        ),

        // April 27
        RecordModel(
          type: AppConstants.income,
          accountId: 2,
          categoryId: 6,
          transferAccountId: null,
          amount: 3000,
          note: "Bonus",
          date: DateTime(2026, 4, 27),
          time: "11:00 AM",
        ),
        RecordModel(
          type: AppConstants.expense,
          accountId: 0,
          categoryId: 17,
          transferAccountId: null,
          amount: 200,
          note: "Transport",
          date: DateTime(2026, 4, 27),
          time: "10:00 PM",
        ),
      ]);
    }
  }
}
