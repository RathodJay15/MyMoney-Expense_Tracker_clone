class AccountModel {
  final int? accountId;
  final String name;
  final double balance;
  final String icon;

  AccountModel({
    this.accountId,
    required this.name,
    required this.balance,
    required this.icon,
  });

  Map<String, dynamic> toMap() {
    return {
      'accountId': accountId,
      'name': name,
      'balance': balance,
      'icon': icon,
    };
  }

  factory AccountModel.fromMap(Map<String, dynamic> map) {
    return AccountModel(
      accountId: map['accountId'],
      name: map['name'],
      balance: map['balance'],
      icon: map['icon'],
    );
  }
}
