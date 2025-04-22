import 'package:get/get.dart';
import 'package:sundrift/presentation/controllers/favorites_controller.dart';

/// Binding for the favorites page
class FavoritesBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<FavoritesController>(FavoritesController());
  }
}
