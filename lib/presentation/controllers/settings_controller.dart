import 'dart:ui';

import 'package:get/get.dart';
import 'package:sundrift/app/themes/theme_controller.dart';
import 'package:sundrift/core/constants/app_constants.dart';
import 'package:sundrift/core/storage/local_storage.dart';
import 'package:sundrift/core/permissions/permission_handler.dart';

class SettingsController extends GetxController {
  // Dependencies
  final LocalStorage _localStorage = Get.find<LocalStorage>();
  final ThemeController _themeController = Get.find<ThemeController>();
  final PermissionHandler _permissionHandler = Get.find<PermissionHandler>();

  // Observable variables
  final RxString temperatureUnit = AppConstants.defaultTemperatureUnit.obs;
  final RxString theme = AppConstants.defaultTheme.obs;
  final RxString language = AppConstants.defaultLanguage.obs;
  final RxBool isLoading = false.obs;

  // Notification settings
  final RxBool dailyForecastNotification = false.obs;
  final RxBool weatherAlertsNotification = true.obs;
  final RxBool precipitationAlertsNotification = false.obs;
  final RxBool temperatureChangeAlertsNotification = false.obs;

  // App info
  final RxString appVersion = AppConstants.appVersion.obs;
  final RxBool isPremium = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadSettings();
  }

  // Load all settings
  void loadSettings() {
    // Load temperature unit
    temperatureUnit.value = _localStorage.getString(
      AppConstants.storageKeyTemperatureUnit,
      defaultValue: AppConstants.defaultTemperatureUnit,
    );

    // Load theme
    theme.value = _localStorage.getString(
      AppConstants.storageKeyTheme,
      defaultValue: AppConstants.defaultTheme,
    );

    // Load language
    language.value = _localStorage.getString(
      AppConstants.storageKeyLanguage,
      defaultValue: AppConstants.defaultLanguage,
    );

    // Load notification settings (these would normally be in a separate storage key)
    dailyForecastNotification.value = _localStorage.getBool(
      'notification_daily_forecast',
      defaultValue: false,
    );

    weatherAlertsNotification.value = _localStorage.getBool(
      'notification_weather_alerts',
      defaultValue: true,
    );

    precipitationAlertsNotification.value = _localStorage.getBool(
      'notification_precipitation',
      defaultValue: false,
    );

    temperatureChangeAlertsNotification.value = _localStorage.getBool(
      'notification_temperature_changes',
      defaultValue: false,
    );

    // Load premium status
    isPremium.value = _localStorage.getBool(
      AppConstants.storageKeyIsPremium,
      defaultValue: false,
    );
  }

  // Update temperature unit
  Future<void> updateTemperatureUnit(String unit) async {
    if (unit != temperatureUnit.value) {
      temperatureUnit.value = unit;
      await _localStorage.setString(
        AppConstants.storageKeyTemperatureUnit,
        unit,
      );
    }
  }

  // Update theme
  Future<void> updateTheme(String newTheme) async {
    if (newTheme != theme.value) {
      theme.value = newTheme;
      await _localStorage.setString(
        AppConstants.storageKeyTheme,
        newTheme,
      );

      // Apply theme
      _themeController.changeTheme(newTheme);
    }
  }

  // Update language
  Future<void> updateLanguage(String newLanguage) async {
    if (newLanguage != language.value) {
      language.value = newLanguage;
      await _localStorage.setString(
        AppConstants.storageKeyLanguage,
        newLanguage,
      );

      // Apply language
      final locale = _getLocaleFromLanguage(newLanguage);
      Get.updateLocale(locale);
    }
  }

  // Update notification setting
  Future<void> updateNotificationSetting(String key, bool value) async {
    await _localStorage.setBool(key, value);

    switch (key) {
      case 'notification_daily_forecast':
        dailyForecastNotification.value = value;
        break;
      case 'notification_weather_alerts':
        weatherAlertsNotification.value = value;
        break;
      case 'notification_precipitation':
        precipitationAlertsNotification.value = value;
        break;
      case 'notification_temperature_changes':
        temperatureChangeAlertsNotification.value = value;
        break;
    }

    // Request notification permission if enabling any notification
    if (value) {
      final isGranted =
          _permissionHandler.isNotificationPermissionGranted.value;
      if (!isGranted) {
        await _permissionHandler.requestNotificationPermission();
      }
    }
  }

  // Check if notification permission is granted
  bool isNotificationPermissionGranted() {
    return _permissionHandler.isNotificationPermissionGranted.value;
  }

  // Get locale from language code
  // Same as in preference_controller.dart
  // In a real app, this would be in a shared utility class
  static Locale _getLocaleFromLanguage(String languageCode) {
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
