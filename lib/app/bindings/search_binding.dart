import 'package:get/get.dart';
import 'package:sundrift/presentation/controllers/search_controller.dart';

/// Binding for the search page
class SearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchController>(() => SearchController());
  }
}
