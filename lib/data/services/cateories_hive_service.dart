import 'package:hive_flutter/hive_flutter.dart';
import 'package:mymoneyclone/core/constants/app_constants.dart';
import 'package:mymoneyclone/data/models/category_model.dart';

class CateoriesHiveService {
  final Box<CategoryModel> _categoryBox = Hive.box<CategoryModel>(
    AppConstants.categoryHiveBox,
  );

  Future<void> add(CategoryModel category) async {
    await _categoryBox.add(category);
  }

  List<CategoryModel> getAll() {
    final all = _categoryBox.values.toList();

    final active = all.where((e) => !e.isIgnored).toList();
    final ignored = all.where((e) => e.isIgnored).toList();

    active.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    ignored.sort(
      (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
    );

    return [...active, ...ignored];
  }

  Future<void> delete(CategoryModel category) async {
    await category.delete();
  }

  Future<void> update(CategoryModel category) async {
    await _categoryBox.put(category.key, category);
  }
}
