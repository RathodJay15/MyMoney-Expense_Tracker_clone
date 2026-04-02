import 'package:mymoneyclone/core/constants/app_constants.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mymoneyclone/data/models/accounts_model.dart';

class AccountsHiveService {
  final Box<AccountModel> _accountBox = Hive.box<AccountModel>(
    AppConstants.accountHiveBox,
  );

  Future<void> add(AccountModel account) async {
    await _accountBox.add(account);
  }

  List<AccountModel> getAll() {
    final all = _accountBox.values.toList();

    final active = all.where((e) => !e.isIgnored).toList();
    final ignored = all.where((e) => e.isIgnored).toList();

    active.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    ignored.sort(
      (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
    );

    return [...active, ...ignored];
  }

  Future<void> delete(AccountModel account) async {
    await account.delete();
  }

  Future<void> update(AccountModel account) async {
    await _accountBox.put(account.key, account);
  }
}
