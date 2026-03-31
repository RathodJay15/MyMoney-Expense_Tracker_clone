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
  static const type = "Type";
  static const name = "Name";
  static const icon = "Icon";
  static const save = "Save";
  static const cancel = "Cancel";
  static const incon = "Icon";
  static const edit = "Edit";
  static const delete = "Delete";
  static const yes = "Yes";
  static const no = "No";

  //Category screen
  static const addNewCat = "ADD NEW CATEGORY";
  static const untitled = "Untitled";
  static const incomeCat = "Income categories";
  static const expenseCat = "Expense categories";
  static const expenseCategory = "Expense category";
  static const incomeCategory = "Income category";
  static const editCat = "EDIT CATEGORY";
  static const ignore = "Ignore";
  static const restore = "Restore";
  static const catDetails = "Category details";
  static const recordsAllTime = "Records: All time";
  static const noRecordInThisCat = "No record in this category";
  static const deleteThisCat = "Delete this category?";
  static const deletingMsg =
      "Deleting this category will also delete all records and budgets for this category. Are you sure?";
  static const ingnoreThisCat = "Ingnore this category?";
  static const ignoreMsg =
      "Unless used, this category will not appear anywhere else. You can restore it at any time. Are you sure?";
  static const analysisDialog =
      "You can see Monthly, weekly, or daily statistics in the Analysis section.";

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
