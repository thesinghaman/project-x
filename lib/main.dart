import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sundrift/app/app.dart';
import 'package:sundrift/app/bindings/initial_binding.dart';
import 'package:sundrift/core/constants/app_constants.dart';
import 'package:sundrift/app/routes/app_pages.dart';
import 'package:sundrift/app/themes/app_theme.dart';
import 'package:sundrift/app/themes/theme_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // Initialize services and controllers
  await initServices();

  runApp(const SundriftApp());
}

Future<void> initServices() async {
  // Initialize services here
  await Get.putAsync(() => ThemeController().init());

  // Initialize bindings
  InitialBinding().dependencies();
}
