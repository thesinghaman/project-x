import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sundrift/app/routes/app_pages.dart';
import 'package:sundrift/app/routes/app_routes.dart';
import 'package:sundrift/app/themes/theme_controller.dart';
import 'package:sundrift/app/translations/app_translations.dart';

class SundriftApp extends StatelessWidget {
  const SundriftApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return GetBuilder<ThemeController>(builder: (_) {
      return GetMaterialApp(
        title: 'Sundrift',
        debugShowCheckedModeBanner: false,
        theme: themeController.lightTheme,
        darkTheme: themeController.darkTheme,
        themeMode: themeController.themeMode,
        defaultTransition: Transition.cupertino,
        transitionDuration: const Duration(milliseconds: 300),
        initialRoute: AppRoutes.SPLASH,
        getPages: AppPages.routes,
        translations: AppTranslations(),
        locale: Get.deviceLocale, // Default to device locale
        fallbackLocale: const Locale('en', 'US'),
        enableLog: true,
        logWriterCallback: (text, {bool isError = false}) {
          // Custom log handler if needed
          debugPrint('LOG: $text');
        },
      );
    });
  }
}
