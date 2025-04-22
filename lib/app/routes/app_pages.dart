import 'package:get/get.dart';
import 'package:sundrift/app/bindings/weather_details_binding.dart';
import 'package:sundrift/app/routes/app_routes.dart';

// Screens
import 'package:sundrift/presentation/pages/core_pages/home_page.dart';
import 'package:sundrift/presentation/pages/core_pages/search_page.dart';
import 'package:sundrift/presentation/pages/core_pages/settings_page.dart';
import 'package:sundrift/presentation/pages/core_pages/favorites_page.dart';
import 'package:sundrift/presentation/pages/core_pages/weather_details_page.dart';
import 'package:sundrift/presentation/pages/onboarding/onboarding_page.dart';
import 'package:sundrift/presentation/pages/onboarding/location_permission_page.dart';
import 'package:sundrift/presentation/pages/onboarding/notification_permission_page.dart';
import 'package:sundrift/presentation/pages/onboarding/preference_setup_page.dart';

// Bindings
import 'package:sundrift/app/bindings/home_binding.dart';
import 'package:sundrift/app/bindings/search_binding.dart';
import 'package:sundrift/app/bindings/settings_binding.dart';
import 'package:sundrift/app/bindings/favorites_binding.dart';
import 'package:sundrift/app/bindings/splash_binding.dart';

// Create a splash page for the routes
import 'package:sundrift/presentation/pages/splash_page.dart';

/// App pages and their bindings
class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.SPLASH,
      page: () => const SplashPage(),
      binding: SplashBinding(),
      transition: Transition.fade,
    ),
    GetPage(
      name: AppRoutes.ONBOARDING,
      page: () => const OnboardingPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.LOCATION_PERMISSION,
      page: () => const LocationPermissionPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.NOTIFICATION_PERMISSION,
      page: () => const NotificationPermissionPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.PREFERENCE_SETUP,
      page: () => const PreferenceSetupPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.HOME,
      page: () => const HomePage(),
      binding: HomeBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.SEARCH,
      page: () => const SearchPage(),
      binding: SearchBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.FAVORITES,
      page: () => const FavoritesPage(),
      binding: FavoritesBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.SETTINGS,
      page: () => const SettingsPage(),
      binding: SettingsBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.WEATHER_DETAILS,
      page: () => const WeatherDetailsPage(),
      binding: WeatherDetailsBinding(),
      transition: Transition.rightToLeft,
    ),
  ];
}
