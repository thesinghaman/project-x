import 'package:get/get.dart';
import 'package:sundrift/core/constants/app_constants.dart';
import 'package:sundrift/core/storage/local_storage.dart';
import 'package:sundrift/data/models/favorite_location_model.dart';

class FavoritesController extends GetxController {
  // Dependencies
  final LocalStorage _localStorage = Get.find<LocalStorage>();

  // Observable variables
  final RxBool isLoading = false.obs;
  final RxList<FavoriteLocationModel> favoriteLocations =
      <FavoriteLocationModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadFavoriteLocations();
  }

  // Load favorite locations from storage
  Future<void> loadFavoriteLocations() async {
    isLoading.value = true;

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
      }
    } catch (e) {
      // Handle error
      favoriteLocations.value = [];
    } finally {
      isLoading.value = false;
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
}
