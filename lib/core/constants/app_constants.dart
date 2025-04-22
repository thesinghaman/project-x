/// App-wide constants
class AppConstants {
  // App info
  static const String appName = 'Sundrift';
  static const String appVersion = '1.0.0';

  // Storage keys
  static const String storageKeyLanguage = 'language';
  static const String storageKeyTheme = 'theme';
  static const String storageKeyTemperatureUnit = 'temperature_unit';
  static const String storageKeyWindSpeedUnit = 'wind_speed_unit';
  static const String storageKeyPressureUnit = 'pressure_unit';
  static const String storageKeyPrecipitationUnit = 'precipitation_unit';
  static const String storageKeyDistanceUnit = 'distance_unit';
  static const String storageKeyTimeFormat = 'time_format';
  static const String storageKeyDateFormat = 'date_format';
  static const String storageKeyOnboardingComplete = 'onboarding_complete';
  static const String storageKeyFavoriteLocations = 'favorite_locations';
  static const String storageKeyRecentSearches = 'recent_searches';
  static const String storageKeyLastLocation = 'last_location';
  static const String storageKeyLocationPermission = 'location_permission';
  static const String storageKeyNotificationPermission =
      'notification_permission';
  static const String storageKeyIsPremium = 'is_premium';

  // Units
  static const String unitCelsius = 'celsius';
  static const String unitFahrenheit = 'fahrenheit';
  static const String unitKilometerPerHour = 'km/h';
  static const String unitMilesPerHour = 'mph';
  static const String unitMetersPerSecond = 'm/s';
  static const String unitHectopascal = 'hPa';
  static const String unitInchOfMercury = 'inHg';
  static const String unitMillimeter = 'mm';
  static const String unitInch = 'in';
  static const String unitKilometer = 'km';
  static const String unitMile = 'mi';
  static const String unitTimeFormat12h = '12h';
  static const String unitTimeFormat24h = '24h';

  // Defaults
  static const String defaultLanguage = 'en_US';
  static const String defaultTheme = 'system';
  static const String defaultTemperatureUnit = unitCelsius;
  static const String defaultWindSpeedUnit = unitKilometerPerHour;
  static const String defaultPressureUnit = unitHectopascal;
  static const String defaultPrecipitationUnit = unitMillimeter;
  static const String defaultDistanceUnit = unitKilometer;
  static const String defaultTimeFormat = unitTimeFormat24h;

  // Limits
  static const int maxRecentSearches = 10;
  static const int maxFavoriteLocations = 5; // For free version
  static const int maxFavoriteLocationsPremium = 50; // For premium version
  static const int forecastDaysFree = 7;
  static const int forecastDaysPremium = 16;

  // Durations
  static const Duration locationUpdateInterval = Duration(minutes: 15);
  static const Duration weatherUpdateInterval = Duration(minutes: 30);
  static const Duration splashScreenDuration = Duration(seconds: 2);
  static const Duration animationDurationFast = Duration(milliseconds: 150);
  static const Duration animationDurationNormal = Duration(milliseconds: 300);
  static const Duration animationDurationSlow = Duration(milliseconds: 500);

  // API related
  static const int maxRetryAttempts = 3;
  static const Duration apiTimeout = Duration(seconds: 30);

  // Cache durations
  static const Duration cacheDurationWeather = Duration(minutes: 20);
  static const Duration cacheDurationForecast = Duration(hours: 1);
  static const Duration cacheDurationLocation = Duration(days: 7);

  // Notification channels
  static const String channelIdWeatherAlerts = 'weather_alerts';
  static const String channelIdDailyForecast = 'daily_forecast';
  static const String channelIdPrecipitation = 'precipitation';
  static const String channelIdTemperatureChanges = 'temperature_changes';

  // Routes for deep linking
  static const String deepLinkPrefix = 'sundrift://';
  static const String deepLinkWeather = 'weather';
  static const String deepLinkSettings = 'settings';
  static const String deepLinkAlerts = 'alerts';
}
