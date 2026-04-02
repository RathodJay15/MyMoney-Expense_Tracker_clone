import 'package:mymoneyclone/core/constants/app_constants.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mymoneyclone/data/models/records_model.dart';

class RecordsHiveService {
  final Box<RecordModel> _recordBox = Hive.box<RecordModel>(
    AppConstants.recordHiveBox,
  );

  Future<void> add(RecordModel record) async {
    await _recordBox.add(record);
  }

  List<RecordModel> getAll() {
    return _recordBox.values.toList();
  }

  Future<void> delete(RecordModel record) async {
    await record.delete();
  }

  Future<void> update(RecordModel record) async {
    await record.save();
  }
}
