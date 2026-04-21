import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mymoneyclone/core/constants/app_constants.dart';
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
  var filtredRecords = <RecordModel>[].obs;
  var searchResultRecords = <RecordModel>[].obs;
  var groupedRecords = <String, List<RecordModel>>{}.obs;

  var types = <TypeModel>[].obs;

  var totalIncomeSofar = 0.0.obs;
  var totalExpenseSofar = 0.0.obs;

  var totalIncome = 0.0.obs;
  var totalExpense = 0.0.obs;
  var totalBalance = 0.0.obs;

  var isLoading = false.obs;

  var recordAnalysisMonth = DateTime.now().obs;

  var selectedMode = AppConstants.monthly.obs; // monthly , daily , weekly

  var showTotal = AppConstants.yes.obs;

  var surplus = AppConstants.off.obs;

  // ================= INIT =================

  @override
  void onInit() {
    super.onInit();
    fetchRecords();
    _calculateSofarSummary();
  }

  void changeMode(String mode) {
    selectedMode.value = mode;
    _groupRecords();
    fetchTypes();
  }

  void toggleShowTotal(String mode) {
    showTotal.value = mode;
  }

  void toggleSurplus(String mode) {
    surplus.value = mode;
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

  void filterRecords() {
    final d = recordAnalysisMonth.value;

    final filtered = _allRecords.where((r) {
      // DAILY
      if (selectedMode.value == AppConstants.daily) {
        return r.date.year == d.year &&
            r.date.month == d.month &&
            r.date.day == d.day;
      }

      // WEEKLY
      if (selectedMode.value == AppConstants.weekly) {
        final start = d.subtract(Duration(days: d.weekday - 1));
        final end = start.add(Duration(days: 6));

        return r.date.isAfter(start.subtract(Duration(days: 2))) &&
            r.date.isBefore(end);
      }

      // MONTHLY
      return r.date.year == d.year && r.date.month == d.month;
    }).toList();

    filtredRecords.value = filtered;
    _calculateRecordSummary();
    _groupRecords();
  }

  void _groupRecords() {
    filtredRecords.sort((a, b) => b.date.compareTo(a.date));

    Map<String, List<RecordModel>> map = {};
    for (var r in filtredRecords) {
      String key = DateFormat('dd MMM yyyy').format(r.date);

      if (!map.containsKey(key)) {
        map[key] = [];
      }

      map[key]!.add(r);
    }

    groupedRecords.value = map;
  }

  void nextPeriod() {
    final d = recordAnalysisMonth.value;

    if (selectedMode.value == AppConstants.daily) {
      recordAnalysisMonth.value = d.add(Duration(days: 1));
    } else if (selectedMode.value == AppConstants.weekly) {
      recordAnalysisMonth.value = d.add(Duration(days: 7));
    } else {
      recordAnalysisMonth.value = DateTime(d.year, d.month + 1);
    }

    filterRecords();
  }

  String getFormattedHeaderDate() {
    final date = recordAnalysisMonth.value;

    switch (selectedMode.value) {
      case AppConstants.daily:
        return DateFormat('MMM dd, yyyy').format(date);

      case AppConstants.weekly:
        final startOfWeek = date.subtract(Duration(days: date.weekday - 1));
        final endOfWeek = startOfWeek.add(Duration(days: 6));

        return "${DateFormat('MMM dd').format(startOfWeek)} - ${DateFormat('MMM dd').format(endOfWeek)}";

      case AppConstants.monthly:
      default:
        return DateFormat('MMMM, yyyy').format(date);
    }
  }

  void previousPeriod() {
    final d = recordAnalysisMonth.value;

    if (selectedMode.value == AppConstants.daily) {
      recordAnalysisMonth.value = d.subtract(Duration(days: 1));
    } else if (selectedMode.value == AppConstants.weekly) {
      recordAnalysisMonth.value = d.subtract(Duration(days: 7));
    } else {
      recordAnalysisMonth.value = DateTime(d.year, d.month - 1);
    }

    filterRecords();
  }

  void _calculateRecordSummary() {
    double income = 0;
    double expense = 0;

    for (var r in filtredRecords) {
      if (r.type == AppConstants.income) {
        income += r.amount;
      } else if (r.type == AppConstants.expense) {
        expense += r.amount;
      }
    }

    totalIncome.value = income;
    totalExpense.value = expense;
    totalBalance.value = income - expense;
  }

  void _calculateSofarSummary() {
    double income = 0;
    double expense = 0;

    for (var record in _allRecords) {
      if (record.type == AppConstants.income) {
        income += record.amount;
      } else if (record.type == AppConstants.expense) {
        expense += record.amount;
      }
    }

    totalIncomeSofar.value = income;
    totalExpenseSofar.value = expense;
  }

  // ==================== Search =========================

  void searchRecords(String query) {
    if (query.trim().isEmpty) {
      searchResultRecords.clear();
      return;
    }

    final lowerQuery = query.toLowerCase();

    final results = _allRecords.where((record) {
      final account = getAccById(record.accountId);
      final category = record.categoryId != null
          ? getCatById(record.categoryId!)
          : null;
      final transferAccount = record.transferAccountId != null
          ? getAccById(record.transferAccountId!)
          : null;

      // Convert all fields to searchable strings
      final accountName = account?.name.toLowerCase() ?? "";
      final categoryName = category?.name.toLowerCase() ?? "";
      final transferAccName = transferAccount?.name.toLowerCase() ?? "";
      final note = record.note?.toLowerCase() ?? "";
      final amount = record.amount.toString(); // no lowercase needed

      return accountName.contains(lowerQuery) ||
          categoryName.contains(lowerQuery) ||
          transferAccName.contains(lowerQuery) ||
          note.contains(lowerQuery) ||
          amount.contains(lowerQuery);
    }).toList();

    searchResultRecords.value = results;
  }

  void clearSearch() {
    searchResultRecords.clear();
  }

  void updateAccountBalance(int id) async {
    double balance = 0.0;

    AccountModel? account = getAccById(id);
    if (account == null) return;

    balance = account.initialAmount;

    for (var record in _allRecords) {
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

  // ==========================================

  Map<String, Map<String, List<RecordModel>>> fetchRecordByAccount(int id) {
    final accountRecords = _allRecords.where((r) => r.accountId == id).toList();

    Map<String, List<RecordModel>> tempGrouped = {};

    for (var record in accountRecords) {
      final sortKey =
          "${record.date.year}-${record.date.month.toString().padLeft(2, '0')}";

      if (!tempGrouped.containsKey(sortKey)) {
        tempGrouped[sortKey] = [];
      }
      tempGrouped[sortKey]!.add(record);
    }

    final ascKeys = tempGrouped.keys.toList()..sort();
    final descKeys = tempGrouped.keys.toList()..sort((a, b) => b.compareTo(a));

    Map<String, List<RecordModel>> ascMap = {};
    Map<String, List<RecordModel>> descMap = {};

    for (var key in ascKeys) {
      final recordsList = tempGrouped[key]!;

      recordsList.sort((a, b) => a.date.compareTo(b.date));

      final dateParts = key.split("-");
      final formattedKey = DateFormat(
        'MMMM yyyy',
      ).format(DateTime(int.parse(dateParts[0]), int.parse(dateParts[1])));

      ascMap[formattedKey] = recordsList;
    }

    for (var key in descKeys) {
      final recordsList = [...tempGrouped[key]!]; // clone list

      recordsList.sort((a, b) => b.date.compareTo(a.date));

      final dateParts = key.split("-");
      final formattedKey = DateFormat(
        'MMMM yyyy',
      ).format(DateTime(int.parse(dateParts[0]), int.parse(dateParts[1])));

      descMap[formattedKey] = recordsList;
    }

    return {AppConstants.oldToNew: ascMap, AppConstants.newToOld: descMap};
  }

  Map<String, Map<String, List<RecordModel>>> fetchRecordByCategory(int id) {
    final catRecords = _allRecords.where((r) => r.categoryId == id).toList();

    Map<String, List<RecordModel>> tempGrouped = {};

    for (var record in catRecords) {
      final sortKey =
          "${record.date.year}-${record.date.month.toString().padLeft(2, '0')}";

      if (!tempGrouped.containsKey(sortKey)) {
        tempGrouped[sortKey] = [];
      }
      tempGrouped[sortKey]!.add(record);
    }

    final ascKeys = tempGrouped.keys.toList()..sort();
    final descKeys = tempGrouped.keys.toList()..sort((a, b) => b.compareTo(a));

    Map<String, List<RecordModel>> ascMap = {};
    Map<String, List<RecordModel>> descMap = {};

    for (var key in ascKeys) {
      final recordsList = tempGrouped[key]!;

      recordsList.sort((a, b) => a.date.compareTo(b.date));

      final dateParts = key.split("-");
      final formattedKey = DateFormat(
        'MMMM yyyy',
      ).format(DateTime(int.parse(dateParts[0]), int.parse(dateParts[1])));

      ascMap[formattedKey] = recordsList;
    }

    for (var key in descKeys) {
      final recordsList = [...tempGrouped[key]!]; // clone list

      recordsList.sort((a, b) => b.date.compareTo(a.date));

      final dateParts = key.split("-");
      final formattedKey = DateFormat(
        'MMMM yyyy',
      ).format(DateTime(int.parse(dateParts[0]), int.parse(dateParts[1])));

      descMap[formattedKey] = recordsList;
    }

    return {AppConstants.oldToNew: ascMap, AppConstants.newToOld: descMap};
  }

  Map<String, List<RecordModel>> fetchRecordsByCatMonth(
    int categoryId,
    DateTime selectedMonth, {
    bool isAsc = true,
  }) {
    // Filter records by category + month
    final filtered = _allRecords.where((r) {
      return r.categoryId == categoryId &&
          r.date.month == selectedMonth.month &&
          r.date.year == selectedMonth.year;
    }).toList();

    // Step 2: Sort full list first
    filtered.sort(
      (a, b) => isAsc ? a.date.compareTo(b.date) : b.date.compareTo(a.date),
    );

    // Step 3: Group by date (day-wise)
    Map<String, List<RecordModel>> grouped = {};

    for (var record in filtered) {
      final key = DateFormat('dd MMM yyyy').format(record.date);

      if (!grouped.containsKey(key)) {
        grouped[key] = [];
      }

      grouped[key]!.add(record);
    }

    return grouped;
  }

  List<RecordModel> getRecordsForDuration(DateTime from, DateTime to) {
    return filtredRecords.where((e) {
      return e.date.isAfter(from) && e.date.isBefore(to);
    }).toList();
  }

  //===========================================
  CategoryModel? getCatById(int id) {
    return _categoriesHiveService.getCatById(id);
  }

  AccountModel? getAccById(int id) {
    return _accountsHiveService.getAccById(id);
  }

  double getCatSpentTotal(DateTime date, int catId) {
    final month = date.month;
    final year = date.year;

    final spentList = _allRecords.map((e) {
      if (e.categoryId != null) {
        if (e.categoryId == catId &&
            e.date.month == month &&
            e.date.year == year) {
          return e.amount;
        } else {
          return 0.0;
        }
      } else {
        return 0.0;
      }
    }).toList();

    return spentList.reduce((value, element) => element + value);
  }
}
