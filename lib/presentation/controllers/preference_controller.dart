import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sundrift/app/routes/app_routes.dart';
import 'package:sundrift/core/constants/app_constants.dart';
import 'package:sundrift/core/storage/local_storage.dart';
import 'package:sundrift/app/themes/theme_controller.dart';

class PreferenceController extends GetxController {
  // Dependencies
  final LocalStorage _localStorage = Get.find<LocalStorage>();
  final ThemeController _themeController = Get.find<ThemeController>();

  // Observable variables
  final RxString temperatureUnit = AppConstants.defaultTemperatureUnit.obs;
  final RxString theme = AppConstants.defaultTheme.obs;
  final RxString language = AppConstants.defaultLanguage.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Load saved preferences if any
    _loadPreferences();
  }

  // Load preferences from local storage
  void _loadPreferences() {
    temperatureUnit.value = _localStorage.getString(
      AppConstants.storageKeyTemperatureUnit,
      defaultValue: AppConstants.defaultTemperatureUnit,
    );

    theme.value = _localStorage.getString(
      AppConstants.storageKeyTheme,
      defaultValue: AppConstants.defaultTheme,
    );

    language.value = _localStorage.getString(
      AppConstants.storageKeyLanguage,
      defaultValue: AppConstants.defaultLanguage,
    );
  }

  // Save preferences and continue to home screen
  Future<void> savePreferencesAndContinue() async {
    isLoading.value = true;

    try {
      // Save temperature unit
      await _localStorage.setString(
        AppConstants.storageKeyTemperatureUnit,
        temperatureUnit.value,
      );

      // Save theme
      await _localStorage.setString(
        AppConstants.storageKeyTheme,
        theme.value,
      );

      // Save language
      await _localStorage.setString(
        AppConstants.storageKeyLanguage,
        language.value,
      );

      // Apply theme
      _themeController.changeTheme(theme.value);

      // Apply language
      final locale = _getLocaleFromLanguage(language.value);
      Get.updateLocale(locale);

      // Mark onboarding as complete
      await _localStorage.setBool(
        AppConstants.storageKeyOnboardingComplete,
        true,
      );

      // Navigate to home screen
      Get.offAllNamed(AppRoutes.HOME);
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

  // Get locale from language code
  Locale _getLocaleFromLanguage(String languageCode) {
    switch (languageCode) {
      case 'en_US':
        return const Locale('en', 'US');
      case 'es_ES':
        return const Locale('es', 'ES');
      case 'fr_FR':
        return const Locale('fr', 'FR');
      case 'zh_CN':
        return const Locale('zh', 'CN');
      case 'ja_JP':
        return const Locale('ja', 'JP');
      default:
        return const Locale('en', 'US');
    }
  }
}
