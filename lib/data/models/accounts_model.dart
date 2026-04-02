import 'package:hive/hive.dart';

part 'accounts_model.g.dart';

@HiveType(typeId: 1)
class AccountModel extends HiveObject {
  @HiveField(0)
  int? accountId;

  @HiveField(1)
  String name;

  @HiveField(2)
  double balance;

  @HiveField(3)
  String icon;

  @HiveField(4)
  bool isIgnored;

  @HiveField(5)
  double initialAmount;

  AccountModel({
    this.accountId,
    required this.name,
    required this.balance,
    required this.icon,
    required this.isIgnored,
    required this.initialAmount,
  });
}
