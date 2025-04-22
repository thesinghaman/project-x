import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sundrift/core/constants/app_constants.dart';
import 'package:sundrift/core/network/api_client.dart';
import 'package:sundrift/core/storage/local_storage.dart';
import 'package:sundrift/data/models/favorite_location_model.dart';
import 'package:sundrift/presentation/controllers/favorites_controller.dart';
import 'package:sundrift/presentation/controllers/home_controller.dart';

class SearchController extends GetxController {
  // Dependencies
  final ApiClient _apiClient = Get.find<ApiClient>();
  final LocalStorage localStorage = Get.find<LocalStorage>();
  late final FavoritesController _favoritesController;
  late final HomeController _homeController;

  // Text editing controller
  late TextEditingController textController;
  final FocusNode searchFocusNode = FocusNode();

  // Observable variables
  final RxBool isLoading = false.obs;
  final RxList<dynamic> searchResults = <dynamic>[].obs;
  final RxList<String> recentSearches = <String>[].obs;
  final RxString searchQuery = ''.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool showClearButton = false.obs;
  final RxBool hasSearched = false.obs;

  // Debounce for search
  Worker? _debounceWorker;
  final int _debounceMilliseconds = 500;

  @override
  void onInit() {
    super.onInit();
    textController = TextEditingController();

    // Initialize controllers that might not be available at startup
    _initDependentControllers();

    // Load recent searches
    loadRecentSearches();

    // Listen for text changes to show/hide clear button
    _setupListeners();
  }

  void _initDependentControllers() {
    try {
      _favoritesController = Get.find<FavoritesController>();
    } catch (e) {
      _favoritesController = Get.put(FavoritesController());
    }

    try {
      _homeController = Get.find<HomeController>();
    } catch (e) {
      _homeController = Get.put(HomeController());
    }
  }

  void _setupListeners() {
    // Listen for changes to show/hide clear button
    textController.addListener(() {
      showClearButton.value = textController.text.isNotEmpty;

      // Update search query
      searchQuery.value = textController.text;
    });

    // Setup debounce for search as user types
    _debounceWorker = debounce(
      searchQuery,
      (value) {
        if (value.isNotEmpty && value.length > 2) {
          searchLocations(value);
        }
      },
      time: Duration(milliseconds: _debounceMilliseconds),
    );
  }

  @override
  void onClose() {
    textController.dispose();
    searchFocusNode.dispose();
    _debounceWorker?.dispose();
    super.onClose();
  }

  // Load recent searches from storage
  void loadRecentSearches() {
    final searches = localStorage.getObject(
      AppConstants.storageKeyRecentSearches,
      defaultValue: [],
    );

    if (searches is List) {
      recentSearches.value = searches.cast<String>();
    }
  }

  // Search for locations
  Future<void> searchLocations(String query) async {
    if (query.isEmpty) {
      searchResults.clear();
      hasSearched.value = false;
      return;
    }

    searchQuery.value = query;
    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';
    hasSearched.value = true;

    try {
      final results = await _apiClient.searchLocation(query: query);
      searchResults.value = results;

      // Add to recent searches if results found
      if (results.isNotEmpty) {
        addToRecentSearches(query);
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
      searchResults.clear();
    } finally {
      isLoading.value = false;
    }
  }

  // Add query to recent searches
  void addToRecentSearches(String query) {
    // Create a new list without the current query (if it exists)
    final List<String> searches =
        recentSearches.where((element) => element != query).toList();

    // Add the query to the beginning
    searches.insert(0, query);

    // Limit the list size
    if (searches.length > AppConstants.maxRecentSearches) {
      searches.removeLast();
    }

    // Update the list and save
    recentSearches.value = searches;
    localStorage.setObject(
      AppConstants.storageKeyRecentSearches,
      searches,
    );
  }

  // Clear recent searches
  void clearRecentSearches() {
    recentSearches.clear();
    localStorage.remove(AppConstants.storageKeyRecentSearches);
  }

  // Clear search results
  void clearSearchResults() {
    searchResults.clear();
    textController.clear();
    searchQuery.value = '';
    hasSearched.value = false;
  }

  // Select a location from search results
  void selectLocation(dynamic location) {
    // Create a location ID
    String locationId = '${location["name"]}_${location["country"]}';

    // Save as last location
    localStorage.setString(
      AppConstants.storageKeyLastLocation,
      location['name'],
    );

    // Create a query string for the API
    String locationQuery = location["lat"] != null && location["lon"] != null
        ? '${location["lat"]},${location["lon"]}'
        : location["name"];

    // Store this in shared prefs
    localStorage.setString('current_location_query', locationQuery);

    // Refresh the weather data with the new location
    _homeController.fetchWeatherData(location: locationQuery);

    // Navigate back to home
    Get.back();
  }

  // Add location to favorites
  void addToFavorites(dynamic location) {
    String locationId = '${location["name"]}_${location["country"]}';

    final favoriteLocation = FavoriteLocationModel(
      locationId: locationId,
      name: location["name"],
      country: location["country"],
      latitude: location["lat"] ?? 0.0,
      longitude: location["lon"] ?? 0.0,
    );

    _favoritesController.addFavoriteLocation(favoriteLocation);
  }

  // Remove location from favorites
  void removeFromFavorites(dynamic location) {
    String locationId = '${location["name"]}_${location["country"]}';
    _favoritesController.removeFavoriteLocation(locationId);
  }

  // Check if a location is in favorites
  bool isLocationFavorite(dynamic location) {
    String locationId = '${location["name"]}_${location["country"]}';
    return _favoritesController.isLocationFavorite(locationId);
  }
}
