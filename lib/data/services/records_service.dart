import 'package:mymoneyclone/core/constants/app_constants.dart';
import 'package:mymoneyclone/data/database/db_helper.dart';
import 'package:mymoneyclone/data/models/records_model.dart';

class RecordsService {
  final db = DatabaseHelper.obj;

  Future<int> insert(RecordModel record) async {
    final database = await db.database;
    return await database.insert(AppConstants.recordTable, record.toMap());
  }

  Future<List<RecordModel>> getAll() async {
    final database = await db.database;

    final result = await database.query(
      AppConstants.recordTable,
      orderBy: 'date DESC, time DESC',
    );

    return result.map((e) => RecordModel.fromMap(e)).toList();
  }

  Future<List<RecordModel>> getByDate(String date) async {
    final database = await db.database;

    final result = await database.query(
      AppConstants.recordTable,
      where: 'date = ?',
      whereArgs: [date],
    );

    return result.map((e) => RecordModel.fromMap(e)).toList();
  }

  Future<int> delete(int id) async {
    final database = await db.database;

    return await database.delete(
      AppConstants.recordTable,
      where: 'recordId = ?',
      whereArgs: [id],
    );
  }

  Future<int> update(RecordModel record) async {
    final database = await db.database;

    return await database.update(
      AppConstants.recordTable,
      record.toMap(),
      where: 'recordId = ?',
      whereArgs: [record.recordId],
    );
  }
}
