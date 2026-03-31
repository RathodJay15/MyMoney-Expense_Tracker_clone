import 'package:get/get.dart';
import 'package:mymoneyclone/core/constants/app_constants.dart';
import 'package:mymoneyclone/data/services/cateories_service.dart';
import '../../data/models/category_model.dart';

class CategoryController extends GetxController {
  final CategoriesService _service = CategoriesService();

  // ================= STATE =================

  RxList<CategoryModel> categories = <CategoryModel>[].obs;

  RxList<CategoryModel> incomeCategories = <CategoryModel>[].obs;
  RxList<CategoryModel> expenseCategories = <CategoryModel>[].obs;

  RxBool isLoading = false.obs;

  // ================= INIT =================

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  // ================= FETCH =================

  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;

      final data = await _service.getAll();
      categories.value = data;

      _splitCategories();
    } catch (e) {
      print("Category fetch error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // ================= SPLIT =================

  void _splitCategories() {
    incomeCategories.value = categories
        .where((c) => c.type == AppConstants.income)
        .toList();

    expenseCategories.value = categories
        .where((c) => c.type == AppConstants.expense)
        .toList();
  }

  // ================= ADD =================

  Future<void> addCategory(CategoryModel category) async {
    await _service.insert(category);
    await fetchCategories();
  }

  // ================= UPDATE =================

  Future<void> updateCategory(CategoryModel category) async {
    print("----------------catName ${category.name}");
    int num = await _service.update(category);
    print("-------------updated cat index $num");
    await fetchCategories();
  }

  // ================= DELETE =================

  Future<void> deleteCategory(int id) async {
    await _service.delete(id);
    await fetchCategories();
  }
}
