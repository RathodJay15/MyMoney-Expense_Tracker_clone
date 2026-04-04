import 'package:hive_flutter/hive_flutter.dart';
import 'package:mymoneyclone/core/constants/app_constants.dart';
import 'package:mymoneyclone/data/models/type_model.dart';

class TypeHiveService {
  final Box<TypeModel> _typeBox = Hive.box<TypeModel>(AppConstants.typeHiveBox);

  List<TypeModel> getAll() {
    return _typeBox.values.toList();
  }
}
