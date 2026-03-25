class BudgetModel {
  int id;
  int categoryId;
  double expenceLimit;
  DateTime month;

  BudgetModel({
    required this.categoryId,
    required this.expenceLimit,
    required this.id,
    required this.month,
  });
}
