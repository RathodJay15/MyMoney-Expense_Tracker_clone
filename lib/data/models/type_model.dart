import 'package:hive/hive.dart';

part 'type_model.g.dart';

@HiveType(typeId: 4)
class TypeModel extends HiveObject {
  @HiveField(0)
  int? typeId;

  @HiveField(1)
  String name;

  TypeModel({this.typeId, required this.name});
}
