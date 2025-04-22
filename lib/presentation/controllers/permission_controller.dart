import 'package:get/get.dart';
import 'package:sundrift/app/routes/app_routes.dart';
import 'package:sundrift/core/constants/app_constants.dart';
import 'package:sundrift/core/permissions/permission_handler.dart';
import 'package:sundrift/core/storage/local_storage.dart';

class PermissionController extends GetxController {
  // Dependencies
  final PermissionHandler _permissionHandler = Get.find<PermissionHandler>();
  final LocalStorage _localStorage = Get.find<LocalStorage>();

  // Observable variables
  final RxBool isLoading = false.obs;
  final RxBool isLocationPermissionGranted = false.obs;
  final RxBool isNotificationPermissionGranted = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Get initial permission states
    isLocationPermissionGranted.value =
        _permissionHandler.isLocationPermissionGranted.value;
    isNotificationPermissionGranted.value =
        _permissionHandler.isNotificationPermissionGranted.value;
  }

  // Request location permission
  Future<void> requestLocationPermission() async {
    isLoading.value = true;

    try {
      // Request permission
      final bool granted = await _permissionHandler.requestLocationPermission();
      isLocationPermissionGranted.value = granted;

      if (granted) {
        // If permission granted, move to next screen
        Get.offAllNamed(AppRoutes.NOTIFICATION_PERMISSION);
      } else {
        // Show error message if permission denied
        Get.snackbar(
          'location_error'.tr,
          'location_disabled'.tr,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      // Handle errors
      Get.snackbar(
        'error_occurred'.tr,
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Skip location permission
  void skipLocationPermission() {
    // Save that user skipped the permission
    _localStorage.setBool(
      AppConstants.storageKeyLocationPermission,
      false,
    );

    // Navigate to notification permission screen
    Get.offAllNamed(AppRoutes.NOTIFICATION_PERMISSION);
  }

  // Request notification permission
  Future<void> requestNotificationPermission() async {
    isLoading.value = true;

    try {
      // Request permission
      final bool granted =
          await _permissionHandler.requestNotificationPermission();
      isNotificationPermissionGranted.value = granted;

      // Whether granted or not, move to next screen
      Get.offAllNamed(AppRoutes.PREFERENCE_SETUP);
    } catch (e) {
      // Handle errors
      Get.snackbar(
        'error_occurred'.tr,
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Skip notification permission
  void skipNotificationPermission() {
    // Save that user skipped the permission
    _localStorage.setBool(
      AppConstants.storageKeyNotificationPermission,
      false,
    );

    // Navigate to preference setup screen
    Get.offAllNamed(AppRoutes.PREFERENCE_SETUP);
  }

  // Complete permission flow and go to home
  void completePermissionFlow() async {
    // Save preferences
    await _saveUserPreferences();

    // Navigate to home screen
    Get.offAllNamed(AppRoutes.HOME);
  }

  // Save user preferences
  Future<void> _saveUserPreferences() async {
    // Default preferences would be saved here
    // For example:
    await _localStorage.setString(
      AppConstants.storageKeyTemperatureUnit,
      AppConstants.defaultTemperatureUnit,
    );

    await _localStorage.setString(
      AppConstants.storageKeyTheme,
      AppConstants.defaultTheme,
    );

    // Mark that user completed the setup
    await _localStorage.setBool(
      AppConstants.storageKeyOnboardingComplete,
      true,
    );
  }
}
