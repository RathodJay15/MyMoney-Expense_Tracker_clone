import 'package:hive/hive.dart';

part 'records_model.g.dart';

@HiveType(typeId: 3)
class RecordModel extends HiveObject {
  @HiveField(0)
  final int? recordId;

  @HiveField(1)
  final String type;

  @HiveField(2)
  final int account;

  @HiveField(3)
  final int category;

  @HiveField(4)
  final String? note;

  @HiveField(5)
  final double amount;

  @HiveField(6)
  final String date;

  @HiveField(7)
  final String time;

  RecordModel({
    this.recordId,
    required this.type,
    required this.account,
    required this.category,
    this.note,
    required this.amount,
    required this.date,
    required this.time,
  });
}
