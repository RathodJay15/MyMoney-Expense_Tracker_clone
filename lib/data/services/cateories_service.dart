import 'package:mymoneyclone/core/constants/app_constants.dart';
import 'package:mymoneyclone/data/database/db_helper.dart';
import 'package:mymoneyclone/data/models/category_model.dart';

class CategoriesService {
  final db = DatabaseHelper.obj;

  Future<int> insert(CategoryModel category) async {
    final database = await db.database;

    final index = await database.insert(
      AppConstants.categoryTable,
      category.toMap(),
    );
    return index;
  }

  Future<List<CategoryModel>> getAll() async {
    final database = await db.database;

    final result = await database.query(AppConstants.categoryTable);

    return result.map((e) => CategoryModel.fromMap(e)).toList();
  }

  Future<int> delete(int id) async {
    final database = await db.database;

    return await database.delete(
      AppConstants.categoryTable,
      where: 'categoryId = ?',
      whereArgs: [id],
    );
  }

  Future<int> update(CategoryModel category) async {
    print("----------------------Update service called");
    final database = await db.database;

    return await database.update(
      AppConstants.categoryTable,
      category.toMap(),
      where: 'categoryId = ?',
      whereArgs: [category.categoryId],
    );
  }
}
