import 'package:get/get.dart';
import 'package:sundrift/core/network/api_client.dart';
import 'package:sundrift/core/network/connectivity_manager.dart';
import 'package:sundrift/core/storage/local_storage.dart';
import 'package:sundrift/core/storage/secure_storage.dart';
import 'package:sundrift/core/device/device_info.dart';
import 'package:sundrift/core/permissions/permission_handler.dart';
import 'package:sundrift/app/services/app_lifecycle_service.dart';

/// Initial bindings for the app
/// This class is responsible for initial dependencies injection
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Core services
    // We need to make sure ConnectivityManager is initialized BEFORE ApiClient
    Get.put(ConnectivityManager().init(), permanent: true); // Initialize first
    Get.put(LocalStorage().init(), permanent: true);
    Get.put(SecureStorage().init(), permanent: true);
    Get.put(DeviceInfo().init(), permanent: true);
    Get.put(PermissionHandler().init(), permanent: true);
    Get.put(AppLifecycleService(), permanent: true);

    // Only put ApiClient after ConnectivityManager is initialized
    Get.put(ApiClient(), permanent: true);
  }
}
