import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sundrift/core/constants/asset_paths.dart';
import 'package:sundrift/app/themes/app_theme.dart';
import 'package:sundrift/presentation/controllers/onboarding_controller.dart';
import 'package:sundrift/presentation/widgets/common/custom_button.dart';
import 'package:flutter_animate/flutter_animate.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the onboarding controller
    final controller = Get.put(OnboardingController());

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.md),
                child: TextButton(
                  onPressed: controller.skipOnboarding,
                  child: Text(
                    'skip'.tr,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                ),
              ),
            ),

            // Page view
            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                onPageChanged: controller.onPageChanged,
                itemCount: 4,
                itemBuilder: (context, index) {
                  return _buildOnboardingPage(context, index);
                },
              ),
            ),

            // Page indicator and buttons
            Padding(
              padding: const EdgeInsets.all(AppDimensions.lg),
              child: Column(
                children: [
                  // Page indicator
                  Obx(() => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          4,
                          (index) => _buildPageIndicator(
                              context, index, controller.currentPage.value),
                        ),
                      )),

                  const SizedBox(height: AppDimensions.lg),

                  // Next/Get Started button
                  Obx(() => CustomButton(
                        text: controller.currentPage.value == 3
                            ? 'get_started'.tr
                            : 'next'.tr,
                        onPressed: controller.nextPage,
                        icon: controller.currentPage.value == 3
                            ? Iconsax.arrow_right_3
                            : null,
                        isFullWidth: true,
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build onboarding page
  Widget _buildOnboardingPage(BuildContext context, int index) {
    // Page content based on index
    String title;
    String description;
    String imagePath;

    switch (index) {
      case 0:
        title = 'onboarding_title_1'.tr;
        description = 'onboarding_desc_1'.tr;
        imagePath = AssetPaths.onboarding1;
        break;
      case 1:
        title = 'onboarding_title_2'.tr;
        description = 'onboarding_desc_2'.tr;
        imagePath = AssetPaths.onboarding2;
        break;
      case 2:
        title = 'onboarding_title_3'.tr;
        description = 'onboarding_desc_3'.tr;
        imagePath = AssetPaths.onboarding3;
        break;
      case 3:
        title = 'onboarding_title_4'.tr;
        description = 'onboarding_desc_4'.tr;
        imagePath = AssetPaths.onboarding4;
        break;
      default:
        title = '';
        description = '';
        imagePath = '';
    }

    return Padding(
      padding: const EdgeInsets.all(AppDimensions.lg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image
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
              imagePath,
              height: MediaQuery.of(context).size.height * 0.3,
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
              title,
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
              description,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.7),
                  ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  // Build page indicator
  Widget _buildPageIndicator(BuildContext context, int index, int currentPage) {
    bool isActive = index == currentPage;

    return AnimatedContainer(
      duration: AppDimensions.animFast,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: isActive ? 24 : 8,
      decoration: BoxDecoration(
        color: isActive
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
