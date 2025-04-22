import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sundrift/core/constants/app_constants.dart';
import 'package:sundrift/core/storage/local_storage.dart';
import 'package:sundrift/data/models/current_weather_model.dart';
import 'package:sundrift/data/models/forecast_model.dart';

class HomeController extends GetxController {
  // Dependencies
  //final ApiClient _apiClient = Get.find<ApiClient>();
  final LocalStorage _localStorage = Get.find<LocalStorage>();
  //final LocationPermission _locationPermission = Get.find<LocationPermission>();

  // Observable variables
  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString currentLocation = 'Loading...'.obs;
  final RxString lastUpdated = ''.obs;

  // Weather data
  final Rx<CurrentWeatherModel?> currentWeather =
      Rx<CurrentWeatherModel?>(null);
  final Rx<ForecastModel?> forecast = Rx<ForecastModel?>(null);

  @override
  void onInit() {
    super.onInit();
    // Fetch weather data on init
    fetchWeatherData();
  }

  // Fetch weather data
  Future<void> fetchWeatherData() async {
    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';

    try {
      // For now, we'll use a placeholder location until we implement the actual location services
      // In the future, this would use the user's current location or a saved location
      final location = _localStorage.getString(
        AppConstants.storageKeyLastLocation,
        defaultValue: 'New York',
      );

      // Update current location
      currentLocation.value = location;

      // Update last updated time
      final now = DateTime.now();
      lastUpdated.value = DateFormat('h:mm a').format(now);

      // Simulate API delay for testing
      await Future.delayed(const Duration(seconds: 2));

      // Here we would make API calls to fetch weather data
      // For now, we'll just use placeholder data

      // Placeholder for current weather data
      currentWeather.value = CurrentWeatherModel(
        temperature: 23,
        feelsLike: 24,
        conditionText: 'Sunny',
        conditionCode: 1000,
        humidity: 60,
        windSpeed: 15,
        windDirection: 'NE',
        pressure: 1012,
        precipitation: 0,
        uv: 5,
        visibility: 10,
      );

      // Placeholder for forecast data
      // In the real app, this would come from the API

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      hasError.value = true;
      errorMessage.value = e.toString();
    }
  }

  // Refresh weather data
  Future<void> refreshWeatherData() async {
    await fetchWeatherData();
  }
}
