import 'package:get/get.dart';
import 'package:mymoneyclone/core/constants/app_constants.dart';
import 'package:mymoneyclone/data/models/accounts_model.dart';
import 'package:mymoneyclone/data/services/accounts_hive_service.dart';

class AccountsController extends GetxController {
  final AccountsHiveService _service = AccountsHiveService();

  // ================= STATE =================

  RxList<AccountModel> accounts = <AccountModel>[].obs;

  RxList<AccountModel> displayAccounts = <AccountModel>[].obs;

  var accountBalanceTotal = 0.0.obs;

  RxBool isLoading = false.obs;

  // ================= INIT =================

  @override
  void onInit() {
    super.onInit();
    fetchAccounts();
  }

  // ================= FETCH =================

  Future<void> fetchAccounts() async {
    try {
      isLoading.value = true;

      final data = await _service.getAll();
      accounts.value = data;

      displayAccounts.value = accounts
          .where((a) => a.isIgnored == false)
          .toList();

      calculateBalanceSummary();
    } catch (e) {
      print("Account fetch error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // ================= ADD =================

  Future<void> addAccounts(AccountModel account) async {
    await _service.add(account);
    await fetchAccounts();
  }

  // ================= UPDATE =================

  Future<void> updateAccounts(AccountModel account) async {
    await _service.update(account);
    await fetchAccounts();
  }

  // ================= DELETE =================

  Future<void> deleteAccount(AccountModel account) async {
    await _service.delete(account);
    await fetchAccounts();
  }

  // ================= CALCULATIONS =============

  void calculateBalanceSummary() {
    double balance = 0.0;
    for (var account in accounts) {
      balance += account.balance;
    }

    accountBalanceTotal.value = balance;
  }

  // ==============================================
  RxString recordOrder = AppConstants.newToOld.obs;

  void changeRecordOrder() {
    recordOrder.value = recordOrder.value == AppConstants.newToOld
        ? AppConstants.oldToNew
        : AppConstants.newToOld;
  }
}
