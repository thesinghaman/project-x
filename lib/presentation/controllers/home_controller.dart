import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sundrift/core/constants/app_constants.dart';
import 'package:sundrift/core/storage/local_storage.dart';
import 'package:sundrift/core/network/api_client.dart';
import 'package:sundrift/data/models/current_weather_model.dart';
import 'package:sundrift/data/models/forecast_model.dart';

class HomeController extends GetxController {
  // Dependencies
  final ApiClient _apiClient = Get.find<ApiClient>();
  final LocalStorage _localStorage = Get.find<LocalStorage>();

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
  Future<void> fetchWeatherData({String? location}) async {
    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';

    try {
      // Get location from parameter, local storage, or use default
      final String locationQuery = location ??
          _localStorage.getString(
            'current_location_query',
            defaultValue: _localStorage.getString(
              AppConstants.storageKeyLastLocation,
              defaultValue: 'New York',
            ),
          );

      // Update current location display name
      String displayLocation = locationQuery;
      if (locationQuery.contains(',')) {
        // If it's lat/lon coordinates, use the stored location name
        displayLocation = _localStorage.getString(
          AppConstants.storageKeyLastLocation,
          defaultValue: 'Current Location',
        );
      }
      currentLocation.value = displayLocation;

      // Update last updated time
      final now = DateTime.now();
      lastUpdated.value = DateFormat('h:mm a').format(now);

      // Make API calls to fetch real weather data
      try {
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

        // Save location as last location
        _localStorage.setString(
          AppConstants.storageKeyLastLocation,
          weatherData['location']['name'] ?? displayLocation,
        );

        // Store the location query for future use
        _localStorage.setString('current_location_query', locationQuery);
      } catch (e) {
        // If API calls fail, use placeholder data for development
        _usePlaceholderData();
        print('Using placeholder data due to API error: $e');
      }

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      hasError.value = true;
      errorMessage.value = e.toString();
    }
  }

  // Use placeholder data for development/testing
  void _usePlaceholderData() {
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

    // Placeholder for forecast data would be created here
    // This is just a stub - in a real implementation you'd create
    // a proper ForecastModel with hourly and daily data
  }

  // Refresh weather data
  Future<void> refreshWeatherData() async {
    await fetchWeatherData();
    return Future.value();
  }
}
