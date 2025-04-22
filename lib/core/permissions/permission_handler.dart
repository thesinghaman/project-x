import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sundrift/core/constants/app_constants.dart';
import 'package:sundrift/core/storage/local_storage.dart';

/// Service for handling app permissions
class PermissionHandler extends GetxService {
  final LocalStorage _localStorage = Get.find<LocalStorage>();

  // Reactive variables for permission states
  final RxBool isLocationPermissionGranted = false.obs;
  final RxBool isNotificationPermissionGranted = false.obs;

  // Initialize permissions
  Future<PermissionHandler> init() async {
    await _checkLocationPermission();
    await _checkNotificationPermission();
    return this;
  }

  // Check location permission
  Future<void> _checkLocationPermission() async {
    final locationStatus = await Permission.location.status;
    isLocationPermissionGranted.value = locationStatus.isGranted;

    // Save to local storage
    await _localStorage.setBool(AppConstants.storageKeyLocationPermission,
        isLocationPermissionGranted.value);
  }

  // Check notification permission
  Future<void> _checkNotificationPermission() async {
    final notificationStatus = await Permission.notification.status;
    isNotificationPermissionGranted.value = notificationStatus.isGranted;

    // Save to local storage
    await _localStorage.setBool(AppConstants.storageKeyNotificationPermission,
        isNotificationPermissionGranted.value);
  }

  // Request location permission
  Future<bool> requestLocationPermission() async {
    if (await Permission.location.isPermanentlyDenied) {
      // Open app settings if permission is permanently denied
      return await openAppSettings();
    } else {
      final status = await Permission.location.request();
      isLocationPermissionGranted.value = status.isGranted;

      // Save to local storage
      await _localStorage.setBool(AppConstants.storageKeyLocationPermission,
          isLocationPermissionGranted.value);

      return status.isGranted;
    }
  }

  // Request notification permission
  Future<bool> requestNotificationPermission() async {
    if (await Permission.notification.isPermanentlyDenied) {
      // Open app settings if permission is permanently denied
      return await openAppSettings();
    } else {
      final status = await Permission.notification.request();
      isNotificationPermissionGranted.value = status.isGranted;

      // Save to local storage
      await _localStorage.setBool(AppConstants.storageKeyNotificationPermission,
          isNotificationPermissionGranted.value);

      return status.isGranted;
    }
  }

  // Check if location permission is granted
  Future<bool> isLocationPermissionGrantedAsync() async {
    return await Permission.location.isGranted;
  }

  // Check if notification permission is granted
  Future<bool> isNotificationPermissionGrantedAsync() async {
    return await Permission.notification.isGranted;
  }
}
