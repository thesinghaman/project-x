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
    Get.put(ApiClient(), permanent: true);
    Get.put(ConnectivityManager(), permanent: true);
    Get.put(LocalStorage(), permanent: true);
    Get.put(SecureStorage(), permanent: true);
    Get.put(DeviceInfo(), permanent: true);
    Get.put(PermissionHandler(), permanent: true);
    Get.put(AppLifecycleService(), permanent: true);
  }
}
