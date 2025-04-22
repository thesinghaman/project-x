import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sundrift/core/constants/app_constants.dart';
import 'package:sundrift/core/network/api_client.dart';
import 'package:sundrift/core/storage/local_storage.dart';
import 'package:sundrift/data/models/current_weather_model.dart';
import 'package:sundrift/data/models/forecast_model.dart';
import 'package:sundrift/data/models/favorite_location_model.dart';
import 'package:sundrift/presentation/controllers/home_controller.dart';

class WeatherDetailsController extends GetxController {
  // Dependencies
  final ApiClient _apiClient = Get.find<ApiClient>();
  final LocalStorage _localStorage = Get.find<LocalStorage>();

  // Observable variables
  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString lastUpdated = ''.obs;

  // Weather data
  final Rx<CurrentWeatherModel?> currentWeather =
      Rx<CurrentWeatherModel?>(null);
  final Rx<ForecastModel?> forecast = Rx<ForecastModel?>(null);

  // Current location
  final Rx<FavoriteLocationModel?> location = Rx<FavoriteLocationModel?>(null);

  @override
  void onInit() {
    super.onInit();
    // Try to get location from arguments
    final args = Get.arguments;
    if (args is Map<String, dynamic> && args.containsKey('location')) {
      loadLocationData(args['location']);
    }
  }

  // Load weather data for a specific location
  Future<void> loadLocationData(FavoriteLocationModel locationModel) async {
    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';
    location.value = locationModel;

    try {
      // Ensure latitude and longitude are doubles
      final double lat = locationModel.latitude is int
          ? (locationModel.latitude as int).toDouble()
          : locationModel.latitude;

      final double lon = locationModel.longitude is int
          ? (locationModel.longitude as int).toDouble()
          : locationModel.longitude;

      // Create location query (prefer coordinates if available)
      String locationQuery =
          lat != 0 && lon != 0 ? '$lat,$lon' : locationModel.name;

      // Update last updated time
      final now = DateTime.now();
      lastUpdated.value = DateFormat('h:mm a').format(now);

      // Get current weather
      final weatherData = await _apiClient.getCurrentWeather(
        location: locationQuery,
      );

      currentWeather.value = CurrentWeatherModel.fromJson(weatherData);

      // Get forecast data
      final forecastData = await _apiClient.getForecast(
        location: locationQuery,
        days: 7,
      );

      forecast.value = ForecastModel.fromJson(forecastData);

      isLoading.value = false;
    } catch (e) {
      print('Error loading weather details: $e');
      isLoading.value = false;
      hasError.value = true;
      errorMessage.value = e.toString();
    }
  }

  // Refresh weather data
  Future<void> refreshData() async {
    if (location.value != null) {
      await loadLocationData(location.value!);
    }
  }

  // Set location as current on home screen
  void setAsCurrentLocation(FavoriteLocationModel locationModel) {
    try {
      // Get the home controller
      final HomeController homeController = Get.find<HomeController>();

      // Ensure latitude and longitude are doubles
      final double lat = locationModel.latitude is int
          ? (locationModel.latitude as int).toDouble()
          : locationModel.latitude;

      final double lon = locationModel.longitude is int
          ? (locationModel.longitude as int).toDouble()
          : locationModel.longitude;

      // Create location query (prefer coordinates if available)
      String locationQuery =
          lat != 0 && lon != 0 ? '$lat,$lon' : locationModel.name;

      // Update the current location in the home controller
      homeController.fetchWeatherData(location: locationQuery);

      // Save as last location
      _localStorage.setString(
        AppConstants.storageKeyLastLocation,
        locationModel.name,
      );

      // Store the query for future use
      _localStorage.setString('current_location_query', locationQuery);

      // Show success message
      Get.snackbar(
        'Location updated',
        '${locationModel.name} is now your current location',
        snackPosition: SnackPosition.BOTTOM,
      );

      // Navigate back to home
      Get.until((route) => Get.currentRoute == '/home');
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not set as current location: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
