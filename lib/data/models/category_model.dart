class CategoryModel {
  final int? categoryId;
  final String type;
  final String name;
  final String icon;
  final int ignore;

  CategoryModel({
    this.categoryId,
    required this.type,
    required this.name,
    required this.icon,
    required this.ignore,
  });

  Map<String, dynamic> toMap() {
    return {
      'categoryId': categoryId,
      'type': type,
      'name': name,
      'icon': icon,
      'ignore': ignore,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      categoryId: map['categoryId'],
      type: map['type'],
      name: map['name'],
      icon: map['icon'],
      ignore: map['ignore'],
    );
  }

  final Map<String, String> incomeCategoryIcons = {
    "Awards": "award",
    "Coupons": "ticket_discount",
    "Grants": "gift",
    "Lottery": "ticket_star",
    "Refunds": "money_recive",
    "Rental": "home_2",
    "Salary": "wallet_3",
    "Sale": "tag",
  };

  final Map<String, String> expenseCategoryIcons = {
    "Baby": "baby",
    "Beauty": "brush_2",
    "Bills": "receipt_item",
    "Car": "car",
    "Clothing": "shop",
    "Education": "teacher",
    "Electronics": "device_message",
    "Entertainment": "video_play",
    "Food": "cup",
    "Health": "heart",
    "Home": "home",
    "Insurance": "security_safe",
    "Shopping": "shopping_cart",
    "Social": "people",
    "Sport": "activity",
    "Tax": "receipt_edit",
    "Telephone": "call",
    "Transportation": "bus",
  };
}
