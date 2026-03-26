class AppConstants {
  static const dbName = 'mymoney.db';
  static const dbVersion = 1;

  static const currancy = '₹';

  // Tables
  static const recordTable = 'records';
  static const accountTable = 'accounts';
  static const categoryTable = 'categories';

  //App Bar
  static const myMoney = 'MyMoney';

  static const expense = "EXPENSE";
  static const income = "INCOME";
  static const total = "TOTAL";
  static const totalSpent = "TOTAL SPENT";
  static const totalBudget = "TOTAL BUDGET";
  static const expenseSoFar = "EXPENSE SO FAR";
  static const incomeSoFar = "INCOME SO FAR";

  static String allAccounts(double amount) {
    return '[ All Accounts $currancy${amount.toStringAsFixed(2)} ]';
  }

  //NavBar
  static const records = "Records";
  static const analysis = "Analysis";
  static const budgets = "Budgets";
  static const accounts = "Accounts";
  static const categories = "Categories";
}
