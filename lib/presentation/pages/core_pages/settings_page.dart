import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sundrift/app/themes/app_theme.dart';
import 'package:sundrift/core/constants/app_constants.dart';
import 'package:sundrift/presentation/controllers/settings_controller.dart';

import '../../../app/themes/theme_controller.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controller
    final controller = Get.find<SettingsController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('settings'.tr),
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left),
          onPressed: () => Get.back(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.md),
        children: [
          // Units section
          _buildSectionHeader(context, 'units'.tr),

          // Temperature unit
          _buildSettingItem(
            context,
            icon: Iconsax.warning_2,
            title: 'temperature_unit'.tr,
            onTap: () => _showTemperatureUnitBottomSheet(context, controller),
            trailing: Obx(() => Text(
                  controller.temperatureUnit.value == AppConstants.unitCelsius
                      ? 'celsius'.tr
                      : 'fahrenheit'.tr,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                )),
          ),

          const Divider(),

          // Appearance section
          _buildSectionHeader(context, 'theme'.tr),

          // Theme selection
          _buildSettingItem(
            context,
            icon: Iconsax.color_swatch,
            title: 'theme'.tr,
            onTap: () => _showThemeBottomSheet(context, controller),
            trailing: Obx(() => Text(
                  _getThemeText(controller.theme.value),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                )),
          ),

          const Divider(),

          // Language section
          _buildSectionHeader(context, 'language'.tr),

          // Language selection
          _buildSettingItem(
            context,
            icon: Iconsax.global,
            title: 'language'.tr,
            onTap: () => _showLanguageBottomSheet(context, controller),
            trailing: Obx(() => Text(
                  _getLanguageText(controller.language.value),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                )),
          ),

          const Divider(),

          // Notifications section
          _buildSectionHeader(context, 'notifications'.tr),

          // Weather alerts
          Obx(() => _buildSwitchItem(
                context,
                icon: Iconsax.notification,
                title: 'weather_alerts'.tr,
                value: controller.weatherAlertsNotification.value,
                onChanged: (value) => controller.updateNotificationSetting(
                  'notification_weather_alerts',
                  value,
                ),
              )),

          // Daily forecast
          Obx(() => _buildSwitchItem(
                context,
                icon: Iconsax.calendar,
                title: 'daily_forecast_notification'.tr,
                value: controller.dailyForecastNotification.value,
                onChanged: (value) => controller.updateNotificationSetting(
                  'notification_daily_forecast',
                  value,
                ),
              )),

          // Precipitation alerts
          Obx(() => _buildSwitchItem(
                context,
                icon: Iconsax.cloud_drizzle,
                title: 'precipitation_alerts'.tr,
                value: controller.precipitationAlertsNotification.value,
                onChanged: (value) => controller.updateNotificationSetting(
                  'notification_precipitation',
                  value,
                ),
              )),

          // Temperature change alerts
          Obx(() => _buildSwitchItem(
                context,
                icon: Iconsax.chart_21,
                title: 'temperature_change_alerts'.tr,
                value: controller.temperatureChangeAlertsNotification.value,
                onChanged: (value) => controller.updateNotificationSetting(
                  'notification_temperature_changes',
                  value,
                ),
              )),

          const Divider(),

          // About section
          _buildSectionHeader(context, 'about'.tr),

          // Version
          _buildSettingItem(
            context,
            icon: Iconsax.info_circle,
            title: 'version'.tr,
            trailing: Text(
              controller.appVersion.value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),

          // Privacy policy
          _buildSettingItem(
            context,
            icon: Iconsax.shield,
            title: 'privacy_policy'.tr,
            onTap: () => {/* Open privacy policy */},
          ),

          // Terms of service
          _buildSettingItem(
            context,
            icon: Iconsax.document,
            title: 'terms_of_service'.tr,
            onTap: () => {/* Open terms of service */},
          ),

          // Data sources
          _buildSettingItem(
            context,
            icon: Iconsax.data,
            title: 'data_sources'.tr,
            onTap: () => {/* Show data sources */},
          ),

          // Premium
          Obx(() => controller.isPremium.value
              ? Container()
              : _buildSettingItem(
                  context,
                  icon: Iconsax.crown,
                  title: 'premium_features'.tr,
                  onTap: () => {/* Open premium features */},
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.sm,
                      vertical: AppDimensions.xs,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusSm),
                    ),
                    child: Text(
                      'go_premium'.tr,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                )),
        ],
      ),
    );
  }

  // Build section header
  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.sm),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }

  // Build setting item
  Widget _buildSettingItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).colorScheme.primary,
      ),
      title: Text(title),
      trailing: trailing ?? const Icon(Iconsax.arrow_right_3),
      onTap: onTap,
    );
  }

  // Build switch item
  Widget _buildSwitchItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).colorScheme.primary,
      ),
      title: Text(title),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  // Temperature unit bottom sheet
  void _showTemperatureUnitBottomSheet(
      BuildContext context, SettingsController controller) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(AppDimensions.lg),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppDimensions.radiusLg),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'temperature_unit'.tr,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppDimensions.md),
            Obx(() => RadioListTile<String>(
                  title: Text('celsius'.tr),
                  value: AppConstants.unitCelsius,
                  groupValue: controller.temperatureUnit.value,
                  onChanged: (value) {
                    controller.updateTemperatureUnit(value!);
                    Get.back();
                  },
                )),
            Obx(() => RadioListTile<String>(
                  title: Text('fahrenheit'.tr),
                  value: AppConstants.unitFahrenheit,
                  groupValue: controller.temperatureUnit.value,
                  onChanged: (value) {
                    controller.updateTemperatureUnit(value!);
                    Get.back();
                  },
                )),
          ],
        ),
      ),
    );
  }

  // Theme bottom sheet
  void _showThemeBottomSheet(
      BuildContext context, SettingsController controller) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(AppDimensions.lg),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppDimensions.radiusLg),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'theme'.tr,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppDimensions.md),
            Obx(() => RadioListTile<String>(
                  title: Text('theme_light'.tr),
                  value: ThemeController.LIGHT_THEME,
                  groupValue: controller.theme.value,
                  onChanged: (value) {
                    controller.updateTheme(value!);
                    Get.back();
                  },
                )),
            Obx(() => RadioListTile<String>(
                  title: Text('theme_dark'.tr),
                  value: ThemeController.DARK_THEME,
                  groupValue: controller.theme.value,
                  onChanged: (value) {
                    controller.updateTheme(value!);
                    Get.back();
                  },
                )),
            Obx(() => RadioListTile<String>(
                  title: Text('theme_system'.tr),
                  value: ThemeController.SYSTEM_THEME,
                  groupValue: controller.theme.value,
                  onChanged: (value) {
                    controller.updateTheme(value!);
                    Get.back();
                  },
                )),
            Obx(() => RadioListTile<String>(
                  title: Text('theme_sunrise'.tr),
                  value: ThemeController.SUNRISE_THEME,
                  groupValue: controller.theme.value,
                  onChanged: (value) {
                    controller.updateTheme(value!);
                    Get.back();
                  },
                )),
            Obx(() => RadioListTile<String>(
                  title: Text('theme_sunset'.tr),
                  value: ThemeController.SUNSET_THEME,
                  groupValue: controller.theme.value,
                  onChanged: (value) {
                    controller.updateTheme(value!);
                    Get.back();
                  },
                )),
          ],
        ),
      ),
    );
  }

  // Language bottom sheet
  void _showLanguageBottomSheet(
      BuildContext context, SettingsController controller) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(AppDimensions.lg),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppDimensions.radiusLg),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'language'.tr,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppDimensions.md),
            Obx(() => RadioListTile<String>(
                  title: const Text('English'),
                  value: 'en_US',
                  groupValue: controller.language.value,
                  onChanged: (value) {
                    controller.updateLanguage(value!);
                    Get.back();
                  },
                )),
            Obx(() => RadioListTile<String>(
                  title: const Text('Español'),
                  value: 'es_ES',
                  groupValue: controller.language.value,
                  onChanged: (value) {
                    controller.updateLanguage(value!);
                    Get.back();
                  },
                )),
            Obx(() => RadioListTile<String>(
                  title: const Text('Français'),
                  value: 'fr_FR',
                  groupValue: controller.language.value,
                  onChanged: (value) {
                    controller.updateLanguage(value!);
                    Get.back();
                  },
                )),
            Obx(() => RadioListTile<String>(
                  title: const Text('中文'),
                  value: 'zh_CN',
                  groupValue: controller.language.value,
                  onChanged: (value) {
                    controller.updateLanguage(value!);
                    Get.back();
                  },
                )),
            Obx(() => RadioListTile<String>(
                  title: const Text('日本語'),
                  value: 'ja_JP',
                  groupValue: controller.language.value,
                  onChanged: (value) {
                    controller.updateLanguage(value!);
                    Get.back();
                  },
                )),
          ],
        ),
      ),
    );
  }

  // Get theme text from value
  String _getThemeText(String theme) {
    switch (theme) {
      case ThemeController.LIGHT_THEME:
        return 'theme_light'.tr;
      case ThemeController.DARK_THEME:
        return 'theme_dark'.tr;
      case ThemeController.SYSTEM_THEME:
        return 'theme_system'.tr;
      case ThemeController.SUNRISE_THEME:
        return 'theme_sunrise'.tr;
      case ThemeController.SUNSET_THEME:
        return 'theme_sunset'.tr;
      case ThemeController.STORM_THEME:
        return 'theme_storm'.tr;
      case ThemeController.SNOW_THEME:
        return 'theme_snow'.tr;
      default:
        return 'theme_system'.tr;
    }
  }

  // Get language text from value
  String _getLanguageText(String language) {
    switch (language) {
      case 'en_US':
        return 'English';
      case 'es_ES':
        return 'Español';
      case 'fr_FR':
        return 'Français';
      case 'zh_CN':
        return '中文';
      case 'ja_JP':
        return '日本語';
      default:
        return 'English';
    }
  }
}
