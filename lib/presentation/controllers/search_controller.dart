import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sundrift/core/constants/app_constants.dart';
import 'package:sundrift/core/network/api_client.dart';
import 'package:sundrift/core/storage/local_storage.dart';
import 'package:sundrift/presentation/controllers/favorites_controller.dart';

class SearchController extends GetxController {
  // Dependencies
  final ApiClient _apiClient = Get.find<ApiClient>();
  final LocalStorage _localStorage = Get.find<LocalStorage>();
  final FavoritesController _favoritesController =
      Get.find<FavoritesController>();

  // Text editing controller
  late TextEditingController textController;

  // Observable variables
  final RxBool isLoading = false.obs;
  final RxList<dynamic> searchResults = <dynamic>[].obs;
  final RxList<dynamic> recentSearches = <dynamic>[].obs;
  final RxString searchQuery = ''.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    textController = TextEditingController();
    loadRecentSearches();
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }

  // Load recent searches from storage
  void loadRecentSearches() {
    final searches = _localStorage.getObject(
      AppConstants.storageKeyRecentSearches,
      defaultValue: [],
    );

    if (searches is List) {
      recentSearches.value = searches;
    }
  }

  // Search for locations
  Future<void> searchLocations(String query) async {
    if (query.isEmpty) {
      searchResults.clear();
      return;
    }

    searchQuery.value = query;
    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';

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
    final List<dynamic> searches =
        recentSearches.where((element) => element != query).toList();

    // Add the query to the beginning
    searches.insert(0, query);

    // Limit the list size
    if (searches.length > AppConstants.maxRecentSearches) {
      searches.removeLast();
    }

    // Update the list and save
    recentSearches.value = searches;
    _localStorage.setObject(
      AppConstants.storageKeyRecentSearches,
      searches,
    );
  }

  // Clear recent searches
  void clearRecentSearches() {
    recentSearches.clear();
    _localStorage.remove(AppConstants.storageKeyRecentSearches);
  }

  // Clear search results
  void clearSearchResults() {
    searchResults.clear();
    textController.clear();
    searchQuery.value = '';
  }

  // Select a location from search results
  void selectLocation(dynamic location) {
    // Save as last location
    _localStorage.setString(
      AppConstants.storageKeyLastLocation,
      location['name'],
    );

    // Navigate back to home
    Get.back();
  }

  // Check if a location is in favorites
  bool isLocationFavorite(String locationId) {
    return _favoritesController.isLocationFavorite(locationId);
  }
}
