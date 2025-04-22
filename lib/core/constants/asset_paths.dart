/// Asset paths for the app
class AssetPaths {
  // Images
  static const String imagesPath = 'assets/images';
  static const String logoPath = '$imagesPath/logos/logo.png';
  static const String logoDarkPath = '$imagesPath/logos/logo_dark.png';
  static const String logoSmallPath = '$imagesPath/logos/logo_small.png';
  static const String logoSmallDarkPath =
      '$imagesPath/logos/logo_small_dark.png';

  // Background images
  static const String backgroundsPath = '$imagesPath/backgrounds';
  static const String clearSkyBg = '$backgroundsPath/clear_sky.png';
  static const String cloudyBg = '$backgroundsPath/cloudy.png';
  static const String rainyBg = '$backgroundsPath/rainy.png';
  static const String snowyBg = '$backgroundsPath/snowy.png';
  static const String stormBg = '$backgroundsPath/storm.png';

  // Onboarding illustrations
  static const String onboardingPath = '$imagesPath/illustrations/onboarding';
  static const String onboarding1 = '$onboardingPath/onboarding_1.png';
  static const String onboarding2 = '$onboardingPath/onboarding_2.png';
  static const String onboarding3 = '$onboardingPath/onboarding_3.png';
  static const String onboarding4 = '$onboardingPath/onboarding_4.png';
  static const String locationPermission =
      '$onboardingPath/location_permission.png';
  static const String notificationPermission =
      '$onboardingPath/notification_permission.png';
  static const String preferenceSetup = '$onboardingPath/preference_setup.png';

  // Empty state illustrations
  static const String emptyStatesPath =
      '$imagesPath/illustrations/empty_states';
  static const String noResults = '$emptyStatesPath/no_results.png';
  static const String noFavorites = '$emptyStatesPath/no_favorites.png';
  static const String noAlerts = '$emptyStatesPath/no_alerts.png';
  static const String connectionError = '$emptyStatesPath/connection_error.png';
  static const String locationError = '$emptyStatesPath/location_error.png';

  // Premium illustrations
  static const String premiumPath = '$imagesPath/illustrations/premium';
  static const String premiumFeatures = '$premiumPath/premium_features.png';
  static const String premiumBadge = '$premiumPath/premium_badge.png';

  // Icons
  static const String iconsPath = 'assets/icons';
  static const String weatherIconsPath = '$iconsPath/weather';
  static const String navigationIconsPath = '$iconsPath/navigation';
  static const String uiIconsPath = '$iconsPath/ui';

  // Weather icons
  static const String clearSkyIcon = '$weatherIconsPath/clear_sky.png';
  static const String fewCloudsIcon = '$weatherIconsPath/few_clouds.png';
  static const String scatteredCloudsIcon =
      '$weatherIconsPath/scattered_clouds.png';
  static const String brokenCloudsIcon = '$weatherIconsPath/broken_clouds.png';
  static const String showerRainIcon = '$weatherIconsPath/shower_rain.png';
  static const String rainIcon = '$weatherIconsPath/rain.png';
  static const String thunderstormIcon = '$weatherIconsPath/thunderstorm.png';
  static const String snowIcon = '$weatherIconsPath/snow.png';
  static const String mistIcon = '$weatherIconsPath/mist.png';
  static const String windyIcon = '$weatherIconsPath/windy.png';
  static const String foggyIcon = '$weatherIconsPath/foggy.png';
  static const String hazeIcon = '$weatherIconsPath/haze.png';
  static const String dustIcon = '$weatherIconsPath/dust.png';
  static const String tornadoIcon = '$weatherIconsPath/tornado.png';

  // Animations
  static const String animationsPath = 'assets/animations';
  static const String lottiePath = '$animationsPath/lottie';

  // Lottie animations
  static const String splashAnimation = '$lottiePath/splash_animation.json';
  static const String weatherLoadingAnimation =
      '$lottiePath/weather_loading.json';
  static const String locationLoadingAnimation =
      '$lottiePath/location_loading.json';
  static const String dataRefreshAnimation = '$lottiePath/data_refresh.json';
  static const String rainAnimation = '$lottiePath/rain_animation.json';
  static const String sunAnimation = '$lottiePath/sun_animation.json';
  static const String cloudAnimation = '$lottiePath/cloud_animation.json';
  static const String snowAnimation = '$lottiePath/snow_animation.json';
  static const String thunderAnimation = '$lottiePath/thunder_animation.json';
  static const String windAnimation = '$lottiePath/wind_animation.json';
  static const String fogAnimation = '$lottiePath/fog_animation.json';
  static const String tornadoAnimation = '$lottiePath/tornado_animation.json';

  // JSON data
  static const String jsonPath = 'assets/json';
  static const String countryCodesPath = '$jsonPath/country_codes.json';
}
