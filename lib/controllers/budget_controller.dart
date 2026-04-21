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
  RxList<BudgetModel> oldBudgetsFliteredByMonth = <BudgetModel>[].obs;

  var budgetMonth = DateTime.now().obs;

  var oldMonth = DateTime.now().obs;

  // ================= INIT =================

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    _updateOldMonth();
    ever(budgetMonth, (_) {
      _updateOldMonth();
    });
    fetchBudgets();
  }

  // ================= FETCH =================

  Future<void> fetchBudgets() async {
    try {
      budgets.value = await _service.getAll();
      budgetsFliteredByMonth.value = filterBudgetsByMonth(budgetMonth.value);
    } catch (e) {
      print("Budget fetch error: $e");
    }
  }

  List<BudgetModel> filterBudgetsByMonth(DateTime month) {
    return budgets.where((e) {
      return e.month.year == month.year && e.month.month == month.month;
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
    budgetsFliteredByMonth.value = filterBudgetsByMonth(budgetMonth.value);
  }

  String getFormattedHeaderDate() {
    final date = budgetMonth.value;

    return DateFormat('MMMM, yyyy').format(date);
  }

  void previousPeriod() {
    final d = budgetMonth.value;

    budgetMonth.value = DateTime(d.year, d.month - 1);
    budgetsFliteredByMonth.value = filterBudgetsByMonth(budgetMonth.value);
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

  // ======================== Copy Budget Methods =============================
  void nextPeriodOld() {
    final d = oldMonth.value;

    oldMonth.value = DateTime(d.year, d.month + 1);
    oldBudgetsFliteredByMonth.value = filterBudgetsByMonth(oldMonth.value);
  }

  String getFormattedOldHeaderDate() {
    final date = oldMonth.value;

    return DateFormat('MMMM, yyyy').format(date);
  }

  void previousPeriodOld() {
    final d = oldMonth.value;

    oldMonth.value = DateTime(d.year, d.month - 1);
    oldBudgetsFliteredByMonth.value = filterBudgetsByMonth(oldMonth.value);
  }

  void _updateOldMonth() {
    final d = budgetMonth.value;

    oldMonth.value = DateTime(d.year, d.month - 1);
    oldBudgetsFliteredByMonth.value = filterBudgetsByMonth(oldMonth.value);
  }

  bool canGoNextOldMonth() {
    final current = oldMonth.value;
    final limit = DateTime(budgetMonth.value.year, budgetMonth.value.month - 1);

    return current.isBefore(limit);
  }

  Future<void> copyBudgetsFromOldToCurrent() async {
    final sourceMonth = oldMonth.value;
    final targetMonth = budgetMonth.value;

    // source budgets (old month)
    final sourceBudgets = filterBudgetsByMonth(sourceMonth);

    // target budgets (current month)
    final targetBudgets = filterBudgetsByMonth(targetMonth);

    final targetMap = {for (var b in targetBudgets) b.categoryId: b};

    for (var source in sourceBudgets) {
      if (targetMap.containsKey(source.categoryId)) {
        final existing = targetMap[source.categoryId]!;

        existing.expenceLimit = source.expenceLimit;
        await _service.update(existing);
      } else {
        // ➕ add new
        final newBudget = BudgetModel(
          categoryId: source.categoryId,
          expenceLimit: source.expenceLimit,
          month: DateTime(targetMonth.year, targetMonth.month),
        );

        await _service.add(newBudget);
      }
    }

    await fetchBudgets();
  }
}
