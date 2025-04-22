import 'package:get/get.dart';
import 'package:sundrift/presentation/controllers/weather_details_controller.dart';

/// Binding for the weather details page
class WeatherDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<WeatherDetailsController>(WeatherDetailsController());
  }
}
