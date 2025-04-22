import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:sundrift/core/constants/api_constants.dart';
import 'package:sundrift/core/constants/app_constants.dart';
import 'package:sundrift/core/network/connectivity_manager.dart';
import 'package:sundrift/core/errors/exceptions.dart';
import 'package:sundrift/core/storage/local_storage.dart';

/// API client for making network requests
class ApiClient extends GetxService {
  final http.Client _httpClient = http.Client();
  final ConnectivityManager _connectivityManager =
      Get.find<ConnectivityManager>();
  final LocalStorage _localStorage = Get.find<LocalStorage>();

  // Default timeout duration
  final Duration _timeout = AppConstants.apiTimeout;

  // Cache expiration durations
  final Duration _weatherCacheDuration = AppConstants.cacheDurationWeather;
  final Duration _forecastCacheDuration = AppConstants.cacheDurationForecast;
  final Duration _locationCacheDuration = AppConstants.cacheDurationLocation;

  // Weather API methods

  // Get current weather
  Future<Map<String, dynamic>> getCurrentWeather({
    required String location,
    String language = 'en',
    bool includeAqi = true,
  }) async {
    // Check cache first
    final String cacheKey =
        'current_weather_${location}_${language}_$includeAqi';
    final cachedData = _getCachedData(cacheKey, _weatherCacheDuration);
    if (cachedData != null) {
      return cachedData;
    }

    final Map<String, String> queryParams = {
      ApiConstants.weatherApiKeyParam: ApiConstants.weatherApiKey,
      ApiConstants.weatherApiQueryParam: location,
      ApiConstants.weatherApiLanguageParam: language,
    };

    if (includeAqi) {
      queryParams[ApiConstants.weatherApiAqiParam] =
          ApiConstants.weatherApiAqiYes;
    }

    final response = await _get(
      '${ApiConstants.weatherApiBaseUrl}${ApiConstants.currentWeatherEndpoint}',
      queryParams: queryParams,
    );

    // Cache the response
    _cacheData(cacheKey, response);

    return response;
  }

  // Get weather forecast
  Future<Map<String, dynamic>> getForecast({
    required String location,
    int days = 7,
    String language = 'en',
    bool includeAqi = true,
    bool includeAlerts = true,
  }) async {
    // For free tier, limit to 3 days
    final int actualDays = days > 3 ? 3 : days;

    // Check cache first
    final String cacheKey =
        'forecast_${location}_${actualDays}_${language}_$includeAqi$includeAlerts';
    final cachedData = _getCachedData(cacheKey, _forecastCacheDuration);
    if (cachedData != null) {
      return cachedData;
    }

    final Map<String, String> queryParams = {
      ApiConstants.weatherApiKeyParam: ApiConstants.weatherApiKey,
      ApiConstants.weatherApiQueryParam: location,
      ApiConstants.weatherApiDaysParam: actualDays.toString(),
      ApiConstants.weatherApiLanguageParam: language,
    };

    if (includeAqi) {
      queryParams[ApiConstants.weatherApiAqiParam] =
          ApiConstants.weatherApiAqiYes;
    }

    if (includeAlerts) {
      queryParams[ApiConstants.weatherApiAlertsParam] =
          ApiConstants.weatherApiAlertsYes;
    }

    final response = await _get(
      '${ApiConstants.weatherApiBaseUrl}${ApiConstants.forecastEndpoint}',
      queryParams: queryParams,
    );

    // Cache the response
    _cacheData(cacheKey, response);

    return response;
  }

  // Search location
  Future<List<dynamic>> searchLocation({
    required String query,
  }) async {
    // Check cache first if query isn't too short
    if (query.length > 2) {
      final String cacheKey = 'search_location_$query';
      final cachedData = _getCachedData(cacheKey, _locationCacheDuration);
      if (cachedData != null && cachedData is List) {
        return cachedData;
      }
    }

    final Map<String, String> queryParams = {
      ApiConstants.weatherApiKeyParam: ApiConstants.weatherApiKey,
      ApiConstants.weatherApiQueryParam: query,
    };

    // Use the search API endpoint
    final List<dynamic> response = await _getList(
      '${ApiConstants.weatherApiBaseUrl}${ApiConstants.searchLocationEndpoint}',
      queryParams: queryParams,
    );

    // Cache the response for queries that aren't too short
    if (query.length > 2) {
      _cacheData('search_location_$query', response);
    }

    return response;
  }

  // Get astronomy info
  Future<Map<String, dynamic>> getAstronomy({
    required String location,
    required String date,
  }) async {
    // Build cache key
    final String cacheKey = 'astronomy_${location}_$date';
    final cachedData = _getCachedData(cacheKey, _forecastCacheDuration);
    if (cachedData != null) {
      return cachedData;
    }

    final Map<String, String> queryParams = {
      ApiConstants.weatherApiKeyParam: ApiConstants.weatherApiKey,
      ApiConstants.weatherApiQueryParam: location,
      ApiConstants.weatherApiDtParam: date,
    };

    final response = await _get(
      '${ApiConstants.weatherApiBaseUrl}${ApiConstants.astronomyEndpoint}',
      queryParams: queryParams,
    );

    // Cache the response
    _cacheData(cacheKey, response);

    return response;
  }

  // Get historical weather - Note: May require paid tier on weatherapi.com
  Future<Map<String, dynamic>> getHistoricalWeather({
    required String location,
    required String date,
    String? endDate,
    String language = 'en',
  }) async {
    final String cacheKey =
        'history_${location}_${date}_${endDate ?? ''}_$language';
    final cachedData = _getCachedData(
        cacheKey, Duration(days: 30)); // Long cache for historical data
    if (cachedData != null) {
      return cachedData;
    }

    final Map<String, String> queryParams = {
      ApiConstants.weatherApiKeyParam: ApiConstants.weatherApiKey,
      ApiConstants.weatherApiQueryParam: location,
      ApiConstants.weatherApiDtParam: date,
      ApiConstants.weatherApiLanguageParam: language,
    };

    if (endDate != null) {
      queryParams[ApiConstants.weatherApiEndDtParam] = endDate;
    }

    try {
      final response = await _get(
        '${ApiConstants.weatherApiBaseUrl}${ApiConstants.historyEndpoint}',
        queryParams: queryParams,
      );

      // Cache the response
      _cacheData(cacheKey, response);

      return response;
    } catch (e) {
      // Special handling for free tier limitations
      if (e is ForbiddenException || e is UnauthorizedException) {
        throw ApiException(
            'Historical weather data requires a paid API subscription');
      }
      rethrow;
    }
  }

  // Cache management methods
  // Cache management methods
  dynamic _getCachedData(String key, Duration cacheDuration) {
    try {
      final cachedData = _localStorage.getObject(key);
      if (cachedData != null) {
        // Check if the cache is still valid
        final cacheTimestamp = _localStorage.getDouble('${key}_timestamp');
        if (cacheTimestamp != null) {
          final currentTime = DateTime.now().millisecondsSinceEpoch.toDouble();
          if (currentTime - cacheTimestamp < cacheDuration.inMilliseconds) {
            return cachedData;
          }
        }
      }
    } catch (e) {
      // Ignore cache errors and fetch fresh data
    }
    return null;
  }

  void _cacheData(String key, dynamic data) {
    try {
      _localStorage.setObject(key, data);
      _localStorage.setDouble(
          '${key}_timestamp', DateTime.now().millisecondsSinceEpoch.toDouble());
    } catch (e) {
      // Ignore cache errors
    }
  }

  // Generic HTTP request methods

  // GET request returning a Map
  Future<Map<String, dynamic>> _get(
    String url, {
    Map<String, String>? queryParams,
    Map<String, String>? headers,
  }) async {
    try {
      // Check connectivity
      if (!await _connectivityManager.checkConnectivity()) {
        throw NoInternetException('No internet connection');
      }

      final uri = Uri.parse(url).replace(queryParameters: queryParams);
      final response =
          await _httpClient.get(uri, headers: headers).timeout(_timeout);

      return _processResponse(response);
    } on SocketException {
      throw NoInternetException('No internet connection');
    } on TimeoutException {
      throw ApiTimeoutException('Request timed out');
    } catch (e) {
      if (e is NoInternetException ||
          e is ApiTimeoutException ||
          e is ApiException) {
        rethrow;
      }
      throw ApiException('API request failed: $e');
    }
  }

  // GET request returning a List
  Future<List<dynamic>> _getList(
    String url, {
    Map<String, String>? queryParams,
    Map<String, String>? headers,
  }) async {
    try {
      // Check connectivity
      if (!await _connectivityManager.checkConnectivity()) {
        throw NoInternetException('No internet connection');
      }

      final uri = Uri.parse(url).replace(queryParameters: queryParams);
      final response =
          await _httpClient.get(uri, headers: headers).timeout(_timeout);

      return _processListResponse(response);
    } on SocketException {
      throw NoInternetException('No internet connection');
    } on TimeoutException {
      throw ApiTimeoutException('Request timed out');
    } catch (e) {
      if (e is NoInternetException ||
          e is ApiTimeoutException ||
          e is ApiException) {
        rethrow;
      }
      throw ApiException('API request failed: $e');
    }
  }

  // POST request
  Future<Map<String, dynamic>> _post(
    String url, {
    Map<String, String>? queryParams,
    Map<String, String>? headers,
    dynamic body,
  }) async {
    try {
      // Check connectivity
      if (!await _connectivityManager.checkConnectivity()) {
        throw NoInternetException('No internet connection');
      }

      final uri = Uri.parse(url).replace(queryParameters: queryParams);
      final jsonHeaders = headers ?? {};
      if (!jsonHeaders.containsKey('Content-Type') && body is! String) {
        jsonHeaders['Content-Type'] = 'application/json; charset=utf-8';
      }

      final response = await _httpClient
          .post(
            uri,
            headers: jsonHeaders,
            body: body is String ? body : jsonEncode(body),
          )
          .timeout(_timeout);

      return _processResponse(response);
    } on SocketException {
      throw NoInternetException('No internet connection');
    } on TimeoutException {
      throw ApiTimeoutException('Request timed out');
    } catch (e) {
      if (e is NoInternetException ||
          e is ApiTimeoutException ||
          e is ApiException) {
        rethrow;
      }
      throw ApiException('API request failed: $e');
    }
  }

  // Process HTTP response
  Map<String, dynamic> _processResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        return jsonDecode(response.body);
      } catch (e) {
        throw ApiException('Failed to parse response: $e');
      }
    } else {
      _handleErrorResponse(response);
      // The above method will throw, but we add a return to satisfy the type system
      throw ApiException(
          'API request failed with status code: ${response.statusCode}');
    }
  }

  // Process HTTP response returning a List
  List<dynamic> _processListResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        return jsonDecode(response.body);
      } catch (e) {
        throw ApiException('Failed to parse response: $e');
      }
    } else {
      _handleErrorResponse(response);
      // The above method will throw, but we add a return to satisfy the type system
      throw ApiException(
          'API request failed with status code: ${response.statusCode}');
    }
  }

  // Handle error responses
  void _handleErrorResponse(http.Response response) {
    switch (response.statusCode) {
      case 400:
        throw BadRequestException('Bad request: ${response.body}');
      case 401:
        throw UnauthorizedException('Unauthorized: ${response.body}');
      case 403:
        throw ForbiddenException('Forbidden: ${response.body}');
      case 404:
        throw NotFoundException('Not found: ${response.body}');
      case 429:
        throw TooManyRequestsException('Too many requests: ${response.body}');
      case 500:
      case 501:
      case 502:
      case 503:
        throw ServerException('Server error: ${response.body}');
      default:
        throw ApiException(
            'API request failed with status: ${response.statusCode}, body: ${response.body}');
    }
  }

  // Retry mechanism for API calls
  Future<T> retryRequest<T>(Future<T> Function() requestMethod,
      {int maxRetries = 3}) async {
    int retryCount = 0;
    while (true) {
      try {
        return await requestMethod();
      } catch (e) {
        if (e is NoInternetException) {
          // Don't retry for no internet
          rethrow;
        }

        retryCount++;
        if (retryCount >= maxRetries) {
          rethrow;
        }

        // Exponential backoff
        final waitTime = Duration(milliseconds: 300 * (2 << retryCount));
        await Future.delayed(waitTime);
      }
    }
  }

  @override
  void onClose() {
    _httpClient.close();
    super.onClose();
  }
}
