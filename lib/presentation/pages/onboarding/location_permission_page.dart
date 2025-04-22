import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sundrift/app/themes/app_theme.dart';
import 'package:sundrift/core/constants/asset_paths.dart';
import 'package:sundrift/presentation/controllers/permission_controller.dart';
import 'package:sundrift/presentation/widgets/common/custom_button.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LocationPermissionPage extends StatelessWidget {
  const LocationPermissionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize controller
    final controller = Get.put(PermissionController());

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.lg),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Location illustration
                Animate(
                  effects: [
                    FadeEffect(
                      duration: AppDimensions.animNormal,
                      delay: Duration.zero,
                    ),
                    ScaleEffect(
                      duration: AppDimensions.animNormal,
                      delay: Duration.zero,
                      begin: const Offset(0.9, 0.9),
                      end: const Offset(1.0, 1.0),
                    ),
                  ],
                  child: Image.asset(
                    AssetPaths.locationPermission,
                    height: 200,
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(height: AppDimensions.xl),

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
                    'location_permission_title'.tr,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: AppDimensions.md),

                // Description
                Animate(
                  effects: [
                    FadeEffect(
                      duration: AppDimensions.animNormal,
                      delay: const Duration(milliseconds: 300),
                    ),
                    SlideEffect(
                      duration: AppDimensions.animNormal,
                      delay: const Duration(milliseconds: 300),
                      begin: const Offset(0, 20),
                      end: const Offset(0, 0),
                    ),
                  ],
                  child: Text(
                    'location_permission_message'.tr,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onBackground
                              .withOpacity(0.7),
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: AppDimensions.xxl),

                // Permission button
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
                        text: 'location_permission_button'.tr,
                        onPressed: controller.requestLocationPermission,
                        isLoading: controller.isLoading.value,
                        isFullWidth: true,
                        icon: Iconsax.location,
                      )),
                ),

                const SizedBox(height: AppDimensions.md),

                // Skip for now button
                Animate(
                  effects: [
                    FadeEffect(
                      duration: AppDimensions.animNormal,
                      delay: const Duration(milliseconds: 500),
                    ),
                  ],
                  child: TextButton(
                    onPressed: controller.skipLocationPermission,
                    child: Text(
                      'skip'.tr,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.7),
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
