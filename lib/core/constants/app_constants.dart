class AppConstants {
  // static const dbName = 'mymoney.db';
  // static const dbVersion = 1;

  //HIve Boxes
  static const categoryHiveBox = "categories";
  static const accountHiveBox = "accounts";
  static const recordHiveBox = "records";
  static const budgetHiveBox = "budgets";
  static const typeHiveBox = "types";

  static const currancy = '₹';

  static String amount(double amount) {
    return "$currancy$amount";
  }

  //App Bar
  static const myMoney = 'MyMoney';

  //Common
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
  static const options = "Options";
  static const ignore = "Ignore";
  static const restore = "Restore";
  static const recordsAllTime = "Records: All time";

  //Account screen
  static const addNewAcc = "ADD NEW ACCOUNT";
  static const balance = "Balance:";
  static const initialy = "Initialy:";
  static const initAmountTxt = "Initial amount";
  static const accDetails = "Account details";
  static const initAmountMsg =
      "*Initial amount will not be reflected in analisis";
  static const editAcc = "EDIT ACCOUNT";
  static const initAmountVal = "0";
  static const deleteThisAcc = "Delete this account?";
  static const deletingAccMsg =
      "Deleting this account will also delete all records and budgets for this account. Are you sure?";
  static const ingnoreThisAcc = "Ingnore this account?";
  static const ignoreAccMsg =
      "Unless used, this account will not appear anywhere else. You can restore it at any time. Are you sure?";

  //Category screen
  static const addNewCat = "ADD NEW CATEGORY";
  static const untitled = "Untitled";
  static const incomeCat = "Income categories";
  static const expenseCat = "Expense categories";
  static const expenseCategory = "Expense category";
  static const incomeCategory = "Income category";
  static const editCat = "EDIT CATEGORY";
  static const catDetails = "Category details";
  static const noRecordInThisCat = "No record in this category";
  static const deleteThisCat = "Delete this category?";
  static const deletingCatMsg =
      "Deleting this category will also delete all records and budgets for this category. Are you sure?";
  static const ingnoreThisCat = "Ingnore this category?";
  static const ignoreCatMsg =
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
