import 'package:hive/hive.dart';

part 'records_model.g.dart';

@HiveType(typeId: 3)
class RecordModel extends HiveObject {
  @HiveField(0)
  int? recordId;

  @HiveField(1)
  String type;

  @HiveField(2)
  int accountId;

  @HiveField(3)
  int? categoryId;

  @HiveField(4)
  int? transferAccountId;

  @HiveField(5)
  String? note;

  @HiveField(6)
  double amount;

  @HiveField(7)
  DateTime date;

  @HiveField(8)
  String time;

  RecordModel({
    this.recordId,
    required this.type,
    required this.accountId,
    required this.categoryId,
    required this.transferAccountId,
    this.note,
    required this.amount,
    required this.date,
    required this.time,
  });
}
