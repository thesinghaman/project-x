import 'package:get/get.dart';
import 'package:sundrift/app/routes/app_routes.dart';
import 'package:sundrift/core/constants/app_constants.dart';
import 'package:sundrift/core/storage/local_storage.dart';
import 'package:sundrift/core/permissions/permission_handler.dart';

class SplashController extends GetxController {
  final LocalStorage _localStorage = Get.find<LocalStorage>();
  final PermissionHandler _permissionHandler = Get.find<PermissionHandler>();

  @override
  void onInit() {
    super.onInit();
    // Initialize with a delay
    _initApp();
  }

  Future<void> _initApp() async {
    print("SplashController: Starting initApp");

    // Add a delay to show the splash screen
    await Future.delayed(AppConstants.splashScreenDuration);
    print("SplashController: Delay completed");

    // Check if onboarding is complete
    bool isOnboardingComplete = _localStorage.getBool(
      AppConstants.storageKeyOnboardingComplete,
      defaultValue: false,
    );
    print("SplashController: isOnboardingComplete = $isOnboardingComplete");

    if (isOnboardingComplete) {
      // User has completed onboarding, check permissions
      bool hasLocationPermission =
          await _permissionHandler.isLocationPermissionGrantedAsync();

      if (hasLocationPermission) {
        // Navigate to home screen
        Get.offAllNamed(AppRoutes.HOME);
      } else {
        // Navigate to location permission screen
        Get.offAllNamed(AppRoutes.LOCATION_PERMISSION);
      }
    } else {
      // User has not completed onboarding
      Get.offAllNamed(AppRoutes.ONBOARDING);
    }
  }
}
