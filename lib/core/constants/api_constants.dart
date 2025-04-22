import 'package:flutter_dotenv/flutter_dotenv.dart';

/// API constants and endpoints
class ApiConstants {
  // Base URLs
  static String get weatherApiBaseUrl => dotenv.get('WEATHER_API_BASE_URL',
      fallback: 'https://api.weatherapi.com/v1');
  static String get geocodingApiBaseUrl => dotenv.get('GEOCODING_API_BASE_URL',
      fallback: 'https://api.opencagedata.com/geocode/v1');

  // API Keys
  static String get weatherApiKey =>
      dotenv.get('WEATHER_API_KEY', fallback: '');
  static String get geocodingApiKey =>
      dotenv.get('GEOCODING_API_KEY', fallback: '');

  // Weather API Endpoints
  static const String currentWeatherEndpoint = '/current.json';
  static const String forecastEndpoint = '/forecast.json';
  static const String searchLocationEndpoint = '/search.json';
  static const String historyEndpoint = '/history.json';
  static const String astronomyEndpoint = '/astronomy.json';
  static const String airQualityEndpoint = '/air-quality.json';

  // Weather API Default Parameters
  static const String weatherApiLanguageParam = 'lang';
  static const String weatherApiKeyParam = 'key';
  static const String weatherApiQueryParam = 'q';
  static const String weatherApiDaysParam = 'days';
  static const String weatherApiAqiParam = 'aqi';
  static const String weatherApiAlertsParam = 'alerts';
  static const String weatherApiDtParam = 'dt';
  static const String weatherApiEndDtParam = 'end_dt';
  static const String weatherApiHourParam = 'hour';

  // Weather API Parameter Values
  static const String weatherApiAqiYes = 'yes';
  static const String weatherApiAlertsYes = 'yes';

  // Geocoding API Endpoints
  static const String forwardGeocodingEndpoint = '/json';
  static const String reverseGeocodingEndpoint = '/json';

  // Geocoding API Parameters
  static const String geocodingApiKeyParam = 'key';
  static const String geocodingApiQueryParam = 'q';
  static const String geocodingApiLanguageParam = 'language';
  static const String geocodingApiLimitParam = 'limit';
  static const String geocodingApiLatParam = 'latitude';
  static const String geocodingApiLonParam = 'longitude';

  // Error messages
  static const String errorInvalidApiKey = 'Invalid or missing API key';
  static const String errorLocationNotFound = 'Location not found';
  static const String errorRequestFailed = 'Request failed, please try again';
  static const String errorNoData = 'No data available';
}
