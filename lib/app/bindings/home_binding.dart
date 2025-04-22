import 'package:get/get.dart';
import 'package:sundrift/presentation/controllers/home_controller.dart';
import 'package:sundrift/presentation/controllers/weather_details_controller.dart';
import 'package:sundrift/presentation/controllers/favorites_controller.dart';

/// Bindings for home and related pages
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Home controller
    Get.lazyPut<HomeController>(() => HomeController());

    // Weather details controller (for detailed weather info)
    Get.lazyPut<WeatherDetailsController>(() => WeatherDetailsController());

    // Favorites controller
    Get.lazyPut<FavoritesController>(() => FavoritesController());
  }
}
