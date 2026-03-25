class RecordModel {
  final int? recordId;
  final String type;
  final int account;
  final int category;
  final String? note;
  final double amount;
  final String date;
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

  Map<String, dynamic> toMap() {
    return {
      'recordId': recordId,
      'type': type,
      'account': account,
      'category': category,
      'note': note,
      'amount': amount,
      'date': date,
      'time': time,
    };
  }

  factory RecordModel.fromMap(Map<String, dynamic> map) {
    return RecordModel(
      recordId: map['recordId'],
      type: map['type'],
      account: map['account'],
      category: map['category'],
      note: map['note'],
      amount: map['amount'],
      date: map['date'],
      time: map['time'],
    );
  }
}
