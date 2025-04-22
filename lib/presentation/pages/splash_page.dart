import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sundrift/core/constants/asset_paths.dart';
import 'package:sundrift/app/themes/app_theme.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Stack(
          children: [
            // Background gradient
            Container(
              decoration: BoxDecoration(
                gradient: AppGradients.primaryGradient,
              ),
            ),

            // Content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App logo
                  Animate(
                    effects: [
                      FadeEffect(
                        duration: AppDimensions.animNormal,
                        delay: Duration.zero,
                      ),
                      ScaleEffect(
                        duration: AppDimensions.animNormal,
                        delay: Duration.zero,
                        begin: const Offset(0.8, 0.8),
                        end: const Offset(1.0, 1.0),
                      ),
                    ],
                    child: Image.asset(
                      AssetPaths.logoPath,
                      width: 120,
                      height: 120,
                    ),
                  ),

                  const SizedBox(height: AppDimensions.lg),

                  // App name
                  Animate(
                    effects: [
                      FadeEffect(
                        duration: AppDimensions.animNormal,
                        delay: const Duration(milliseconds: 200),
                      ),
                      SlideEffect(
                        duration: AppDimensions.animNormal,
                        delay: const Duration(milliseconds: 200),
                        begin: const Offset(0, 10),
                        end: const Offset(0, 0),
                      ),
                    ],
                    child: Text(
                      'app_name'.tr,
                      style:
                          Theme.of(context).textTheme.displayMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                  ),

                  const SizedBox(height: AppDimensions.xl),

                  // Loading animation
                  Animate(
                    effects: [
                      FadeEffect(
                        duration: AppDimensions.animNormal,
                        delay: const Duration(milliseconds: 400),
                      ),
                    ],
                    child: Lottie.asset(
                      AssetPaths.weatherLoadingAnimation,
                      width: 80,
                      height: 80,
                    ),
                  ),

                  const SizedBox(height: AppDimensions.md),

                  // Loading text
                  Animate(
                    effects: [
                      FadeEffect(
                        duration: AppDimensions.animNormal,
                        delay: const Duration(milliseconds: 500),
                      ),
                    ],
                    child: Text(
                      'splash_message'.tr,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
