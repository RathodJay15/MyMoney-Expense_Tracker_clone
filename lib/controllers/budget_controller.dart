import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mymoneyclone/controllers/records_controller.dart';
import 'package:mymoneyclone/data/models/budget_model.dart';
import 'package:mymoneyclone/data/services/budget_hive_service.dart';

class BudgetController extends GetxController {
  final BudgetHiveService _service = BudgetHiveService();

  // ================= STATE =================

  RxList<BudgetModel> budgets = <BudgetModel>[].obs;
  RxList<BudgetModel> budgetsFliteredByMonth = <BudgetModel>[].obs;

  var budgetMonth = DateTime.now().obs;

  // ================= INIT =================

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchBudgets();
  }

  // ================= FETCH =================

  Future<void> fetchBudgets() async {
    try {
      budgets.value = await _service.getAll();
      filterBudgetsByMonth();
    } catch (e) {
      print("Budget fetch error: $e");
    }
  }

  void filterBudgetsByMonth() {
    final m = budgetMonth.value;
    budgetsFliteredByMonth.value = budgets.where((e) {
      return e.month.year == m.year && e.month.month == m.month;
    }).toList();
  }

  // ================= ADD =================

  Future<void> addBudget(BudgetModel budget) async {
    await _service.add(budget);
    await fetchBudgets();
  }

  // ================= UPDATE =================

  Future<void> updateBudget(BudgetModel budget) async {
    await _service.update(budget);
    await fetchBudgets();
  }

  // ================= DELETE =================

  Future<void> deleteBudget(BudgetModel budget) async {
    await _service.delete(budget);
    await fetchBudgets();
  }

  void nextPeriod() {
    final d = budgetMonth.value;

    budgetMonth.value = DateTime(d.year, d.month + 1);
    filterBudgetsByMonth();
  }

  String getFormattedHeaderDate() {
    final date = budgetMonth.value;

    return DateFormat('MMMM, yyyy').format(date);
  }

  void previousPeriod() {
    final d = budgetMonth.value;

    budgetMonth.value = DateTime(d.year, d.month - 1);
    filterBudgetsByMonth();
  }

  double getTotalBudget() {
    return budgetsFliteredByMonth.fold(0, (sum, b) => sum + b.expenceLimit);
  }

  double getTotalSpent(RecordsController recordsController) {
    double total = 0;

    for (var budget in budgetsFliteredByMonth) {
      final spent = recordsController.getCatSpentTotal(
        budgetMonth.value,
        budget.categoryId,
      );
      total += spent;
    }

    return total;
  }
}
