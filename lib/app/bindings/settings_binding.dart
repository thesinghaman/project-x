import 'package:get/get.dart';
import 'package:sundrift/presentation/controllers/settings_controller.dart';

/// Binding for the settings page
class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingsController>(() => SettingsController());
  }
}
