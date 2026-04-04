import 'package:hive/hive.dart';

part 'records_model.g.dart';

@HiveType(typeId: 3)
class RecordModel extends HiveObject {
  @HiveField(0)
  final int? recordId;

  @HiveField(1)
  final String type;

  @HiveField(2)
  final String account;

  @HiveField(3)
  final String? category;

  @HiveField(4)
  final String? transferAccount;

  @HiveField(5)
  final String? note;

  @HiveField(6)
  final double amount;

  @HiveField(7)
  final String date;

  @HiveField(8)
  final String time;

  RecordModel({
    this.recordId,
    required this.type,
    required this.account,
    required this.category,
    required this.transferAccount,
    this.note,
    required this.amount,
    required this.date,
    required this.time,
  });
}
