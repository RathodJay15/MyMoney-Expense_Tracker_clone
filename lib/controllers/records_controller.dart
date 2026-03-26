import 'package:get/get.dart';
import 'package:mymoneyclone/data/models/records_model.dart';
import 'package:mymoneyclone/data/services/records_service.dart';

class RecordsController extends GetxController {
  final RecordsService _service = RecordsService();

  // ================= STATE =================

  var records = <RecordModel>[].obs;
  var groupedRecords = <String, List<RecordModel>>{}.obs;

  var totalIncome = 0.0.obs;
  var totalExpense = 0.0.obs;
  var totalBalance = 0.0.obs;

  var isLoading = false.obs;

  // ================= INIT =================

  @override
  void onInit() {
    super.onInit();
    fetchRecords();
  }

  // ================= FETCH =================

  Future<void> fetchRecords() async {
    try {
      isLoading.value = true;

      final data = await _service.getAll();
      records.value = data;

      _groupRecordsByDate();
      _calculateSummary();
    } catch (e) {
      print("Fetch error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // ================= GROUPING =================

  void _groupRecordsByDate() {
    Map<String, List<RecordModel>> grouped = {};

    for (var record in records) {
      if (!grouped.containsKey(record.date)) {
        grouped[record.date] = [];
      }
      grouped[record.date]!.add(record);
    }

    groupedRecords.value = grouped;
  }

  // ================= SUMMARY =================

  void _calculateSummary() {
    double income = 0;
    double expense = 0;

    for (var record in records) {
      if (record.type == 'income') {
        income += record.amount;
      } else if (record.type == 'expense') {
        expense += record.amount;
      }
    }

    totalIncome.value = income;
    totalExpense.value = expense;
    totalBalance.value = income - expense;
  }

  // ================= INSERT =================

  Future<void> addRecord(RecordModel record) async {
    await _service.insert(record);
    await fetchRecords(); // refresh
  }

  // ================= UPDATE =================

  Future<void> updateRecord(RecordModel record) async {
    await _service.update(record);
    await fetchRecords();
  }

  // ================= DELETE =================

  Future<void> deleteRecord(int id) async {
    await _service.delete(id);
    await fetchRecords();
  }
}
