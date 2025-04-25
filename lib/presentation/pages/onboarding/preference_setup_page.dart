import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sundrift/app/themes/app_theme.dart';
import 'package:sundrift/core/constants/app_constants.dart';
import 'package:sundrift/core/constants/asset_paths.dart';
import 'package:sundrift/presentation/controllers/preference_controller.dart';
import 'package:sundrift/presentation/widgets/common/custom_button.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PreferenceSetupPage extends StatelessWidget {
  const PreferenceSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controller
    final controller = Get.put(PreferenceController());

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Animate(
                effects: [
                  FadeEffect(
                    duration: AppDimensions.animNormal,
                    delay: const Duration(milliseconds: 200),
                  ),
                  SlideEffect(
                    duration: AppDimensions.animNormal,
                    delay: const Duration(milliseconds: 200),
                    begin: const Offset(0, 20),
                    end: const Offset(0, 0),
                  ),
                ],
                child: Text(
                  'preference_setup_title'.tr,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ),

              const SizedBox(height: AppDimensions.lg),

              // Preferences content
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Temperature unit
                      _buildSectionTitle(context, 'temperature_unit'.tr),
                      const SizedBox(height: AppDimensions.sm),
                      _buildTemperatureUnitSelector(context, controller),

                      const SizedBox(height: AppDimensions.lg),

                      // Theme preference
                      _buildSectionTitle(context, 'theme_preference'.tr),
                      const SizedBox(height: AppDimensions.sm),
                      _buildThemeSelector(context, controller),

                      const SizedBox(height: AppDimensions.lg),

                      // Language preference
                      _buildSectionTitle(context, 'language_preference'.tr),
                      const SizedBox(height: AppDimensions.sm),
                      _buildLanguageSelector(context, controller),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppDimensions.lg),

              // Get Started button
              Animate(
                effects: [
                  FadeEffect(
                    duration: AppDimensions.animNormal,
                    delay: const Duration(milliseconds: 400),
                  ),
                  SlideEffect(
                    duration: AppDimensions.animNormal,
                    delay: const Duration(milliseconds: 400),
                    begin: const Offset(0, 20),
                    end: const Offset(0, 0),
                  ),
                ],
                child: Obx(() => CustomButton(
                      text: 'get_started'.tr,
                      onPressed: controller.savePreferencesAndContinue,
                      isLoading: controller.isLoading.value,
                      isFullWidth: true,
                      icon: Iconsax.arrow_right_3,
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Build section title
  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }

  // Build temperature unit selector
  Widget _buildTemperatureUnitSelector(
      BuildContext context, PreferenceController controller) {
    return Obx(() => Row(
          children: [
            _buildSelectableCard(
              context: context,
              title: 'celsius'.tr,
              subtitle: '°C',
              isSelected:
                  controller.temperatureUnit.value == AppConstants.unitCelsius,
              onTap: () =>
                  controller.temperatureUnit.value = AppConstants.unitCelsius,
              icon: Iconsax.warning_2,
            ),
            const SizedBox(width: AppDimensions.md),
            _buildSelectableCard(
              context: context,
              title: 'fahrenheit'.tr,
              subtitle: '°F',
              isSelected: controller.temperatureUnit.value ==
                  AppConstants.unitFahrenheit,
              onTap: () => controller.temperatureUnit.value =
                  AppConstants.unitFahrenheit,
              icon: Iconsax.warning_2,
            ),
          ],
        ));
  }

  // Build theme selector
  Widget _buildThemeSelector(
      BuildContext context, PreferenceController controller) {
    return Obx(() => Column(
          children: [
            Row(
              children: [
                _buildSelectableCard(
                  context: context,
                  title: 'theme_light'.tr,
                  isSelected:
                      controller.theme.value == AppConstants.defaultTheme,
                  onTap: () =>
                      controller.theme.value = AppConstants.defaultTheme,
                  icon: Iconsax.sun_1,
                  subtitle: '',
                ),
                const SizedBox(width: AppDimensions.md),
                _buildSelectableCard(
                  context: context,
                  title: 'theme_dark'.tr,
                  isSelected: controller.theme.value == 'dark',
                  onTap: () => controller.theme.value = 'dark',
                  icon: Iconsax.moon,
                  subtitle: '',
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.md),
            Row(
              children: [
                _buildSelectableCard(
                  context: context,
                  title: 'theme_system'.tr,
                  isSelected: controller.theme.value == 'system',
                  onTap: () => controller.theme.value = 'system',
                  icon: Iconsax.mobile,
                  subtitle: '',
                ),
              ],
            ),
          ],
        ));
  }

  // Build language selector
  Widget _buildLanguageSelector(
      BuildContext context, PreferenceController controller) {
    return Obx(() => Column(
          children: [
            Row(
              children: [
                _buildSelectableCard(
                  context: context,
                  title: 'English',
                  isSelected: controller.language.value == 'en_US',
                  onTap: () => controller.language.value = 'en_US',
                  icon: Iconsax.global,
                  subtitle: '',
                ),
                const SizedBox(width: AppDimensions.md),
                _buildSelectableCard(
                  context: context,
                  title: 'Español',
                  isSelected: controller.language.value == 'es_ES',
                  onTap: () => controller.language.value = 'es_ES',
                  icon: Iconsax.global,
                  subtitle: '',
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.md),
            Row(
              children: [
                _buildSelectableCard(
                  context: context,
                  title: 'Français',
                  isSelected: controller.language.value == 'fr_FR',
                  onTap: () => controller.language.value = 'fr_FR',
                  icon: Iconsax.global,
                  subtitle: '',
                ),
                const SizedBox(width: AppDimensions.md),
                _buildSelectableCard(
                  context: context,
                  title: '中文',
                  isSelected: controller.language.value == 'zh_CN',
                  onTap: () => controller.language.value = 'zh_CN',
                  icon: Iconsax.global,
                  subtitle: '',
                ),
              ],
            ),
          ],
        ));
  }

  // Build selectable card
  Widget _buildSelectableCard({
    required BuildContext context,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
    required IconData icon,
    String subtitle = '',
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: AppDimensions.animFast,
          padding: const EdgeInsets.all(AppDimensions.md),
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
                : Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            border: Border.all(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.1),
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected ? AppShadows.small : null,
          ),
          child: Column(
            children: [
              // Check indicator
              Align(
                alignment: Alignment.topRight,
                child: AnimatedOpacity(
                  duration: AppDimensions.animFast,
                  opacity: isSelected ? 1.0 : 0.0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      size: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              // Icon
              Icon(
                icon,
                size: 32,
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.7),
              ),

              const SizedBox(height: AppDimensions.sm),

              // Title
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                textAlign: TextAlign.center,
              ),

              // Subtitle (if provided)
              if (subtitle.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.7),
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
