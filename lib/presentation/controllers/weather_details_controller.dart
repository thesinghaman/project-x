import 'package:get/get.dart';
import 'package:sundrift/data/models/current_weather_model.dart';
import 'package:sundrift/data/models/forecast_model.dart';
import 'package:sundrift/presentation/controllers/home_controller.dart';

class WeatherDetailsController extends GetxController {
  // Dependencies
  final HomeController _homeController = Get.find<HomeController>();

  // Observable variables
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;
  final RxInt selectedTabIndex = 0.obs;

  // Weather data references (shared with HomeController)
  Rx<CurrentWeatherModel?> get currentWeather => _homeController.currentWeather;
  Rx<ForecastModel?> get forecast => _homeController.forecast;

  // Tab selection methods
  void selectHourlyTab() {
    selectedTabIndex.value = 0;
  }

  void selectDailyTab() {
    selectedTabIndex.value = 1;
  }

  void selectDetailsTab() {
    selectedTabIndex.value = 2;
  }
}
