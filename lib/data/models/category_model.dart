class CategoryModel {
  final int? categoryId;
  final String type;
  final String name;
  final String icon;

  CategoryModel({
    this.categoryId,
    required this.type,
    required this.name,
    required this.icon,
  });

  Map<String, dynamic> toMap() {
    return {'categoryId': categoryId, 'type': type, 'name': name, 'icon': icon};
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      categoryId: map['categoryId'],
      type: map['type'],
      name: map['name'],
      icon: map['icon'],
    );
  }
}
