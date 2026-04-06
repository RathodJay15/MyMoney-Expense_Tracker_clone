import 'package:get/get.dart';
import 'package:mymoneyclone/core/constants/app_helper.dart';
import 'package:mymoneyclone/data/models/accounts_model.dart';
import 'package:mymoneyclone/data/models/category_model.dart';
import 'package:mymoneyclone/data/models/records_model.dart';
import 'package:mymoneyclone/data/models/type_model.dart';
import 'package:mymoneyclone/data/services/accounts_hive_service.dart';
import 'package:mymoneyclone/data/services/categories_hive_service.dart';
import 'package:mymoneyclone/data/services/records_hive_service.dart';
import 'package:mymoneyclone/data/services/type_hive_service.dart';

class RecordsController extends GetxController {
  final RecordsHiveService _service = RecordsHiveService();
  final TypeHiveService _tServise = TypeHiveService();
  final AccountsHiveService _accountsHiveService = AccountsHiveService();
  final CategoriesHiveService _categoriesHiveService = CategoriesHiveService();

  // ================= STATE =================

  var records = <RecordModel>[].obs;
  var groupedRecords = <String, List<RecordModel>>{}.obs;

  var types = <TypeModel>[].obs;

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

      final data = _service.getAll();
      records.value = data;

      _groupRecordsByDate();
      _calculateSummary();
    } catch (e) {
      print("Fetch error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchTypes() async {
    types.value = _tServise.getAll();
  }

  // ================= GROUPING =================

  void _groupRecordsByDate() {
    Map<String, List<RecordModel>> grouped = {};

    for (var record in records) {
      if (!grouped.containsKey(AppHelper.getFormattedDateString(record.date))) {
        grouped[AppHelper.getFormattedDateString(record.date)] = [];
      }
      grouped[AppHelper.getFormattedDateString(record.date)]!.add(record);
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
    await _service.add(record);
    await fetchRecords(); // refresh
  }

  // ================= UPDATE =================

  Future<void> updateRecord(RecordModel record) async {
    await _service.update(record);
    await fetchRecords();
  }

  // ================= DELETE =================

  Future<void> deleteRecord(RecordModel record) async {
    await _service.delete(record);
    await fetchRecords();
  }

  //===========================================
  CategoryModel? getCatById(int id) {
    return _categoriesHiveService.getCatById(id);
  }

  AccountModel? getAccById(int id) {
    return _accountsHiveService.getAccById(id);
  }
}
