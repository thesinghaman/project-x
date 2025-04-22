import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

/// Service for handling location-specific permissions and operations
class ALocationPermission extends GetxService {
  // Reactive variables
  final RxBool isLocationServiceEnabled = false.obs;

  Future<ALocationPermission> init() async {
    await checkLocationService();
    return this;
  }

  // Check if location services are enabled
  Future<bool> checkLocationService() async {
    isLocationServiceEnabled.value =
        await Geolocator.isLocationServiceEnabled();
    return isLocationServiceEnabled.value;
  }

  // Request location service
  Future<bool> requestLocationService() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, open location settings
      await Geolocator.openLocationSettings();
      // Re-check after settings have been opened
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      isLocationServiceEnabled.value = serviceEnabled;
      return serviceEnabled;
    }

    isLocationServiceEnabled.value = true;
    return true;
  }

  // Check permission status
  Future<LocationPermissionStatus> checkPermissionStatus() async {
    LocationPermissionStatus status = LocationPermissionStatus.unknown;

    // First check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return LocationPermissionStatus.disabled;
    }

    // Then check the permission status
    var permission = await Geolocator.checkPermission();
    switch (permission) {
      case LocationPermission.denied:
        status = LocationPermissionStatus.denied;
        break;
      case LocationPermission.deniedForever:
        status = LocationPermissionStatus.permanentlyDenied;
        break;
      case LocationPermission.whileInUse:
        status = LocationPermissionStatus.whileInUse;
        break;
      case LocationPermission.always:
        status = LocationPermissionStatus.always;
        break;
      default:
        status = LocationPermissionStatus.unknown;
    }

    return status;
  }

  // Request permission
  Future<LocationPermissionStatus> requestPermission() async {
    // First check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Request location service
      serviceEnabled = await requestLocationService();
      if (!serviceEnabled) {
        return LocationPermissionStatus.disabled;
      }
    }

    // Then request permission
    var permission = await Geolocator.requestPermission();
    switch (permission) {
      case LocationPermission.denied:
        return LocationPermissionStatus.denied;
      case LocationPermission.deniedForever:
        return LocationPermissionStatus.permanentlyDenied;
      case LocationPermission.whileInUse:
        return LocationPermissionStatus.whileInUse;
      case LocationPermission.always:
        return LocationPermissionStatus.always;
      default:
        return LocationPermissionStatus.unknown;
    }
  }

  // Get current position
  Future<Position?> getCurrentPosition({
    LocationAccuracy desiredAccuracy = LocationAccuracy.high,
    bool forceAndroidLocationManager = false,
    Duration? timeLimit,
  }) async {
    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: desiredAccuracy,
        forceAndroidLocationManager: forceAndroidLocationManager,
        timeLimit: timeLimit,
      );
    } catch (e) {
      return null;
    }
  }

  // Get last known position
  Future<Position?> getLastKnownPosition() async {
    try {
      return await Geolocator.getLastKnownPosition();
    } catch (e) {
      return null;
    }
  }
}

// Enum for location permission status
enum LocationPermissionStatus {
  unknown,
  disabled,
  denied,
  permanentlyDenied,
  whileInUse,
  always,
}
