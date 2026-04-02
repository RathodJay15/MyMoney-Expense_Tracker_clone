import 'package:hive/hive.dart';

part 'category_model.g.dart';

@HiveType(typeId: 0)
class CategoryModel extends HiveObject {
  @HiveField(0)
  int? categoryId;

  @HiveField(1)
  String type;

  @HiveField(2)
  String name;

  @HiveField(3)
  String icon;

  @HiveField(4)
  bool isIgnored;

  CategoryModel({
    this.categoryId,
    required this.type,
    required this.name,
    required this.icon,
    required this.isIgnored,
  });
}
