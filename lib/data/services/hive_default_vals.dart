import 'package:hive/hive.dart';
import '../models/category_model.dart';
import '../models/accounts_model.dart';
import '../../core/constants/app_constants.dart';

class HiveDefaultVals {
  static Future<void> defaultVals() async {
    final categoryBox = Hive.box<CategoryModel>(AppConstants.categoryHiveBox);

    final accountBox = Hive.box<AccountModel>(AppConstants.accountHiveBox);

    if (categoryBox.isEmpty) {
      await categoryBox.addAll([
        // INCOME
        CategoryModel(
          name: 'Awards',
          type: 'INCOME',
          icon: 'award',
          isIgnored: false,
        ),
        CategoryModel(
          name: 'Coupons',
          type: 'INCOME',
          icon: 'ticket_discount',
          isIgnored: false,
        ),
        CategoryModel(
          name: 'Grants',
          type: 'INCOME',
          icon: 'gift',
          isIgnored: false,
        ),
        CategoryModel(
          name: 'Lottery',
          type: 'INCOME',
          icon: 'ticket_star',
          isIgnored: false,
        ),
        CategoryModel(
          name: 'Refunds',
          type: 'INCOME',
          icon: 'money_recive',
          isIgnored: false,
        ),
        CategoryModel(
          name: 'Rental',
          type: 'INCOME',
          icon: 'home_2',
          isIgnored: false,
        ),
        CategoryModel(
          name: 'Salary',
          type: 'INCOME',
          icon: 'wallet_3',
          isIgnored: false,
        ),
        CategoryModel(
          name: 'Sale',
          type: 'INCOME',
          icon: 'tag',
          isIgnored: false,
        ),

        // EXPENSE
        CategoryModel(
          name: 'Baby',
          type: 'EXPENSE',
          icon: 'happyemoji',
          isIgnored: false,
        ),
        CategoryModel(
          name: 'Beauty',
          type: 'EXPENSE',
          icon: 'brush_2',
          isIgnored: false,
        ),
        CategoryModel(
          name: 'Bills',
          type: 'EXPENSE',
          icon: 'receipt_item',
          isIgnored: false,
        ),
        CategoryModel(
          name: 'Car',
          type: 'EXPENSE',
          icon: 'car',
          isIgnored: false,
        ),
        CategoryModel(
          name: 'Clothing',
          type: 'EXPENSE',
          icon: 'shop',
          isIgnored: false,
        ),
        CategoryModel(
          name: 'Education',
          type: 'EXPENSE',
          icon: 'teacher',
          isIgnored: false,
        ),
        CategoryModel(
          name: 'Electronics',
          type: 'EXPENSE',
          icon: 'device_message',
          isIgnored: false,
        ),
        CategoryModel(
          name: 'Entertainment',
          type: 'EXPENSE',
          icon: 'video_play',
          isIgnored: false,
        ),
        CategoryModel(
          name: 'Food',
          type: 'EXPENSE',
          icon: 'milk',
          isIgnored: false,
        ),
        CategoryModel(
          name: 'Health',
          type: 'EXPENSE',
          icon: 'heart',
          isIgnored: false,
        ),
        CategoryModel(
          name: 'Home',
          type: 'EXPENSE',
          icon: 'home',
          isIgnored: false,
        ),
        CategoryModel(
          name: 'Insurance',
          type: 'EXPENSE',
          icon: 'security_safe',
          isIgnored: false,
        ),
        CategoryModel(
          name: 'Shopping',
          type: 'EXPENSE',
          icon: 'shopping_cart',
          isIgnored: false,
        ),
        CategoryModel(
          name: 'Social',
          type: 'EXPENSE',
          icon: 'people',
          isIgnored: false,
        ),
        CategoryModel(
          name: 'Sport',
          type: 'EXPENSE',
          icon: 'cup',
          isIgnored: false,
        ),
        CategoryModel(
          name: 'Tax',
          type: 'EXPENSE',
          icon: 'receipt_edit',
          isIgnored: false,
        ),
        CategoryModel(
          name: 'Telephone',
          type: 'EXPENSE',
          icon: 'call',
          isIgnored: false,
        ),
        CategoryModel(
          name: 'Transportation',
          type: 'EXPENSE',
          icon: 'bus',
          isIgnored: false,
        ),
      ]);
    }

    if (accountBox.isEmpty) {
      await accountBox.addAll([
        AccountModel(
          name: 'Card',
          balance: 0,
          initialAmount: 0,
          icon: 'home_2',
          isIgnored: false,
        ),
        AccountModel(
          name: 'Cash',
          balance: 0,
          initialAmount: 0,
          icon: 'wallet_3',
          isIgnored: false,
        ),
        AccountModel(
          name: 'Savings',
          balance: 0,
          initialAmount: 0,
          icon: 'tag',
          isIgnored: false,
        ),
      ]);
    }
  }
}
