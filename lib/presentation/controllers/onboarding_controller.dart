import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sundrift/app/routes/app_routes.dart';
import 'package:sundrift/core/constants/app_constants.dart';
import 'package:sundrift/core/storage/local_storage.dart';

class OnboardingController extends GetxController {
  // Dependencies
  final LocalStorage _localStorage = Get.find<LocalStorage>();

  // Controllers
  late PageController pageController;

  // Observable variables
  final RxInt currentPage = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize page controller
    pageController = PageController(initialPage: 0);
  }

  @override
  void onClose() {
    // Dispose controllers
    pageController.dispose();
    super.onClose();
  }

  // Handle page changes
  void onPageChanged(int page) {
    currentPage.value = page;
  }

  // Move to next page or complete onboarding
  void nextPage() {
    if (currentPage.value < 3) {
      // Go to next page with animation
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Complete onboarding
      completeOnboarding();
    }
  }

  // Skip onboarding and go directly to permission screens
  void skipOnboarding() {
    completeOnboarding();
  }

  // Mark onboarding as complete and navigate to next screen
  void completeOnboarding() async {
    // Save onboarding completion status
    await _localStorage.setBool(
      AppConstants.storageKeyOnboardingComplete,
      true,
    );

    // Navigate to location permission screen
    Get.offAllNamed(AppRoutes.LOCATION_PERMISSION);
  }
}
