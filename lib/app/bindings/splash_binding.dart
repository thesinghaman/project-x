import 'package:get/get.dart';
import 'package:sundrift/presentation/controllers/splash_controller.dart';

/// Binding for the splash screen
class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<SplashController>(SplashController());
  }
}
