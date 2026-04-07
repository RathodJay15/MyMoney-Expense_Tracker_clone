import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:mymoneyclone/core/constants/app_constants.dart';
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

  var _allRecords = <RecordModel>[];
  var records = <RecordModel>[].obs;
  var groupedRecords = <String, List<RecordModel>>{}.obs;

  var types = <TypeModel>[].obs;

  var totalIncomeSofar = 0.0.obs;
  var totalExpenseSofar = 0.0.obs;

  var isLoading = false.obs;

  var recordAnalysisMonth = DateTime.now().obs;

  // ================== filter ===================

  void nextMonth() {
    recordAnalysisMonth.value = DateTime(
      recordAnalysisMonth.value.year,
      recordAnalysisMonth.value.month + 1,
    );
    filterRecords();
  }

  void previousMonth() {
    recordAnalysisMonth.value = DateTime(
      recordAnalysisMonth.value.year,
      recordAnalysisMonth.value.month - 1,
    );
    filterRecords();
  }

  void filterRecords() {
    final month = recordAnalysisMonth.value.month;
    final year = recordAnalysisMonth.value.year;

    final filtered = _allRecords.where((record) {
      return record.date.month == month && record.date.year == year;
    }).toList();

    records.value = filtered;

    _groupRecordsByDate();
  }

  // ================= INIT =================

  @override
  void onInit() {
    super.onInit();
    fetchRecords();
    _calculateSofarSummary();
  }

  // ================= FETCH =================

  Future<void> fetchRecords() async {
    try {
      isLoading.value = true;

      final data = _service.getAll();
      _allRecords = data;

      filterRecords();
    } catch (e) {
      debugPrint("Fetch error: $e");
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

  void _calculateSofarSummary() {
    double income = 0;
    double expense = 0;

    for (var record in records) {
      if (record.type == AppConstants.income) {
        income += record.amount;
      } else if (record.type == AppConstants.expense) {
        expense += record.amount;
      }
    }

    totalIncomeSofar.value = income;
    totalExpenseSofar.value = expense;
  }

  void updateAccountBalance(int id) async {
    double balance = 0.0;

    AccountModel? account = getAccById(id);
    if (account == null) return;

    balance = account.initialAmount;

    for (var record in records) {
      // if income
      if (record.accountId == id && record.type == AppConstants.income) {
        balance += record.amount;
      }
      // if expense
      else if (record.accountId == id && record.type == AppConstants.expense) {
        balance -= record.amount;
      }
      // if transfer from
      else if (record.accountId == id && record.type == AppConstants.transfer) {
        balance -= record.amount;
      }
      // if transfer to
      else if (record.transferAccountId == id &&
          record.type == AppConstants.transfer) {
        balance += record.amount;
      }
    }

    account.balance = balance;
    await _accountsHiveService.update(account);
  }
  // ================= INSERT =================

  Future<void> addRecord(RecordModel record) async {
    await _service.add(record);
    await fetchRecords(); // refresh
  }

  // ================= UPDATE =================

  Future<void> updateRecord(RecordModel record) async {
    await _service.update(record);
    fetchRecords();
  }

  // ================= DELETE =================

  Future<void> deleteRecord(RecordModel record) async {
    await _service.delete(record);
    await fetchRecords();

    updateAccountBalance(record.accountId);

    if (record.type == AppConstants.transfer &&
        record.transferAccountId != null) {
      updateAccountBalance(record.transferAccountId!);
    }
  }

  //===========================================
  CategoryModel? getCatById(int id) {
    return _categoriesHiveService.getCatById(id);
  }

  AccountModel? getAccById(int id) {
    return _accountsHiveService.getAccById(id);
  }
}
