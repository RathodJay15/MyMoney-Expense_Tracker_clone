import 'package:get/get.dart';
import 'package:mymoneyclone/controllers/accounts_controller.dart';
import 'package:mymoneyclone/controllers/categories_controller.dart';
import 'package:mymoneyclone/controllers/records_controller.dart';

class MymoneyBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RecordsController>(() => RecordsController(), fenix: true);
    Get.lazyPut<CategoryController>(() => CategoryController(), fenix: true);
    Get.lazyPut<AccountsController>(() => AccountsController(), fenix: true);
  }
}
