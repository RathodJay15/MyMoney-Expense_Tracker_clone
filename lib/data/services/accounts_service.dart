import 'package:mymoneyclone/core/constants/app_constants.dart';
import 'package:mymoneyclone/data/database/db_helper.dart';
import 'package:mymoneyclone/data/models/accounts_model.dart';

class CateoriesService {
  final db = DatabaseHelper.obj;

  Future<int> insert(AccountModel account) async {
    final database = await db.database;

    return await database.insert(AppConstants.accountTable, account.toMap());
  }

  Future<List<AccountModel>> getAll() async {
    final database = await db.database;

    final result = await database.query(AppConstants.categoryTable);

    return result.map((e) => AccountModel.fromMap(e)).toList();
  }

  Future<int> delete(int id) async {
    final database = await db.database;

    return await database.delete(
      AppConstants.accountTable,
      where: 'accountId = ?',
      whereArgs: [id],
    );
  }

  Future<int> update(AccountModel account) async {
    final database = await db.database;

    return await database.update(
      AppConstants.accountTable,
      account.toMap(),
      where: 'accountId = ?',
      whereArgs: [account.accountId],
    );
  }
}
