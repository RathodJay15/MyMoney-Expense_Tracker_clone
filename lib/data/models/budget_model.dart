import 'package:hive/hive.dart';

part 'budget_model.g.dart';

@HiveType(typeId: 2)
class BudgetModel extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  int categoryId;

  @HiveField(2)
  double expenceLimit;

  @HiveField(3)
  DateTime month;

  BudgetModel({
    required this.categoryId,
    required this.expenceLimit,
    required this.id,
    required this.month,
  });
}
