import 'package:hive/hive.dart';
import 'package:mymoneyclone/core/constants/app_constants.dart';
import 'package:mymoneyclone/data/models/budget_model.dart';

class BudgetHiveService {
  final Box<BudgetModel> _budgetBox = Hive.box<BudgetModel>(
    AppConstants.budgetHiveBox,
  );

  Future<void> add(BudgetModel budget) async {
    await _budgetBox.add(budget);
    print("-------added");
  }

  List<BudgetModel> getAll() {
    final all = _budgetBox.values.toList();
    return all;
  }

  Future<void> delete(BudgetModel budget) async {
    await budget.delete();
  }

  Future<void> update(BudgetModel budget) async {
    await _budgetBox.put(budget.key, budget);
  }
}
