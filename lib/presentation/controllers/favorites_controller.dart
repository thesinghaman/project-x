import 'package:get/get.dart';
import 'package:sundrift/core/constants/app_constants.dart';
import 'package:sundrift/core/storage/local_storage.dart';
import 'package:sundrift/core/network/api_client.dart';
import 'package:sundrift/data/models/favorite_location_model.dart';
import 'package:sundrift/data/models/current_weather_model.dart';
import 'package:sundrift/presentation/controllers/home_controller.dart';

class FavoritesController extends GetxController {
  // Dependencies
  final LocalStorage _localStorage = Get.find<LocalStorage>();
  final ApiClient _apiClient = Get.find<ApiClient>();

  // Observable variables
  final RxBool isLoading = false.obs;
  final RxList<FavoriteLocationModel> favoriteLocations =
      <FavoriteLocationModel>[].obs;
  final RxMap<String, CurrentWeatherModel?> favoriteWeatherData =
      <String, CurrentWeatherModel?>{}.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isRefreshing = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadFavoriteLocations();
  }

  // Load favorite locations from storage
  Future<void> loadFavoriteLocations() async {
    isLoading.value = true;
    hasError.value = false;

    try {
      // Load from local storage
      final locationJson = _localStorage.getObject(
        AppConstants.storageKeyFavoriteLocations,
        defaultValue: [],
      );

      if (locationJson is List) {
        favoriteLocations.value = locationJson
            .map((json) => FavoriteLocationModel.fromJson(json))
            .toList();

        // Fetch weather data for all favorites
        await fetchWeatherForFavorites();
      }
    } catch (e) {
      // Handle error
      hasError.value = true;
      errorMessage.value = e.toString();
      favoriteLocations.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch weather data for all favorite locations
  Future<void> fetchWeatherForFavorites() async {
    if (favoriteLocations.isEmpty) return;

    for (var location in favoriteLocations) {
      await fetchWeatherForLocation(location);
    }
  }

  // Fetch weather for a single location
  Future<void> fetchWeatherForLocation(FavoriteLocationModel location) async {
    try {
      // Create location query (prefer coordinates if available)
      String locationQuery = location.latitude != 0 && location.longitude != 0
          ? '${location.latitude},${location.longitude}'
          : location.name;

      // Fetch current weather
      final weatherData = await _apiClient.getCurrentWeather(
        location: locationQuery,
      );

      // Create weather model and add to map
      final currentWeather = CurrentWeatherModel.fromJson(weatherData);
      favoriteWeatherData[location.locationId] = currentWeather;
    } catch (e) {
      // Set null for this location to indicate error
      favoriteWeatherData[location.locationId] = null;
      print('Error fetching weather for ${location.name}: $e');
    }
  }

  // Add a favorite location
  Future<void> addFavoriteLocation(FavoriteLocationModel location) async {
    // Check if location already exists
    final exists = favoriteLocations
        .any((element) => element.locationId == location.locationId);

    if (!exists) {
      // Check maximum limit
      final isPremium = _localStorage.getBool(
        AppConstants.storageKeyIsPremium,
        defaultValue: false,
      );

      final maxLocations = isPremium
          ? AppConstants.maxFavoriteLocationsPremium
          : AppConstants.maxFavoriteLocations;

      // Add location if under the limit
      if (favoriteLocations.length < maxLocations) {
        favoriteLocations.add(location);

        // Fetch weather for this location
        await fetchWeatherForLocation(location);

        // Save to storage
        await _saveFavoriteLocations();

        Get.snackbar(
          'favorites'.tr,
          'Location added to favorites',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        // Show premium upgrade message
        Get.snackbar(
          'favorites'.tr,
          'Maximum favorite locations reached. Upgrade to premium for more.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  // Remove a favorite location
  Future<void> removeFavoriteLocation(String locationId) async {
    favoriteLocations
        .removeWhere((element) => element.locationId == locationId);

    // Remove weather data for this location
    favoriteWeatherData.remove(locationId);

    // Save to storage
    await _saveFavoriteLocations();

    Get.snackbar(
      'favorites'.tr,
      'Location removed from favorites',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // Save favorite locations to storage
  Future<void> _saveFavoriteLocations() async {
    final List<Map<String, dynamic>> locationMaps =
        favoriteLocations.map((location) => location.toJson()).toList();

    await _localStorage.setObject(
      AppConstants.storageKeyFavoriteLocations,
      locationMaps,
    );
  }

  // Check if a location is in favorites
  bool isLocationFavorite(String locationId) {
    return favoriteLocations.any((element) => element.locationId == locationId);
  }

  // Refresh all favorite locations
  Future<void> refreshFavorites() async {
    isRefreshing.value = true;

    try {
      await fetchWeatherForFavorites();
    } catch (e) {
      print('Error refreshing favorites: $e');
    } finally {
      isRefreshing.value = false;
    }
  }

  // Set location as current on home screen
  void setAsCurrentLocation(FavoriteLocationModel location) {
    try {
      // Get the home controller
      final HomeController homeController = Get.find<HomeController>();

      // Create location query (prefer coordinates if available)
      String locationQuery = location.latitude != 0 && location.longitude != 0
          ? '${location.latitude},${location.longitude}'
          : location.name;

      // Update the current location in the home controller
      homeController.fetchWeatherData(location: locationQuery);

      // Save as last location
      _localStorage.setString(
        AppConstants.storageKeyLastLocation,
        location.name,
      );

      // Store the query for future use
      _localStorage.setString('current_location_query', locationQuery);

      // Show success message
      Get.snackbar(
        'Location updated',
        '${location.name} is now your current location',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      print('Error setting current location: $e');
    }
  }

  // Reorder favorites
  Future<void> reorderFavorites(int oldIndex, int newIndex) async {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    final item = favoriteLocations.removeAt(oldIndex);
    favoriteLocations.insert(newIndex, item);

    // Save updated order to storage
    await _saveFavoriteLocations();
  }
}
