import 'package:get/get.dart';
import 'package:sundrift/presentation/controllers/search_controller.dart';
import 'package:sundrift/presentation/controllers/favorites_controller.dart';

/// Binding for the search page
class SearchBinding extends Bindings {
  @override
  void dependencies() {
    // Make sure FavoritesController is available for the SearchController
    if (!Get.isRegistered<FavoritesController>()) {
      Get.put<FavoritesController>(FavoritesController());
    }

    // Initialize the SearchController
    Get.put<SearchController>(SearchController());
  }
}
