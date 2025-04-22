import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:sundrift/core/constants/api_constants.dart';
import 'package:sundrift/core/constants/app_constants.dart';
import 'package:sundrift/core/network/connectivity_manager.dart';
import 'package:sundrift/core/errors/exceptions.dart';

/// API client for making network requests
class ApiClient extends GetxService {
  final http.Client _httpClient = http.Client();
  final ConnectivityManager _connectivityManager =
      Get.find<ConnectivityManager>();

  // Default timeout duration
  final Duration _timeout = AppConstants.apiTimeout;

  // Weather API methods

  // Get current weather
  Future<Map<String, dynamic>> getCurrentWeather({
    required String location,
    String language = 'en',
    bool includeAqi = true,
  }) async {
    final Map<String, String> queryParams = {
      ApiConstants.weatherApiKeyParam: ApiConstants.weatherApiKey,
      ApiConstants.weatherApiQueryParam: location,
      ApiConstants.weatherApiLanguageParam: language,
    };

    if (includeAqi) {
      queryParams[ApiConstants.weatherApiAqiParam] =
          ApiConstants.weatherApiAqiYes;
    }

    return await _get(
      '${ApiConstants.weatherApiBaseUrl}${ApiConstants.currentWeatherEndpoint}',
      queryParams: queryParams,
    );
  }

  // Get weather forecast
  Future<Map<String, dynamic>> getForecast({
    required String location,
    int days = 7,
    String language = 'en',
    bool includeAqi = true,
    bool includeAlerts = true,
  }) async {
    final Map<String, String> queryParams = {
      ApiConstants.weatherApiKeyParam: ApiConstants.weatherApiKey,
      ApiConstants.weatherApiQueryParam: location,
      ApiConstants.weatherApiDaysParam: days.toString(),
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

    return await _get(
      '${ApiConstants.weatherApiBaseUrl}${ApiConstants.forecastEndpoint}',
      queryParams: queryParams,
    );
  }

  // Search location
  Future<List<dynamic>> searchLocation({
    required String query,
  }) async {
    final Map<String, String> queryParams = {
      ApiConstants.weatherApiKeyParam: ApiConstants.weatherApiKey,
      ApiConstants.weatherApiQueryParam: query,
    };

    return await _getList(
      '${ApiConstants.weatherApiBaseUrl}${ApiConstants.searchLocationEndpoint}',
      queryParams: queryParams,
    );
  }

  // Get astronomy info
  Future<Map<String, dynamic>> getAstronomy({
    required String location,
    required String date,
  }) async {
    final Map<String, String> queryParams = {
      ApiConstants.weatherApiKeyParam: ApiConstants.weatherApiKey,
      ApiConstants.weatherApiQueryParam: location,
      ApiConstants.weatherApiDtParam: date,
    };

    return await _get(
      '${ApiConstants.weatherApiBaseUrl}${ApiConstants.astronomyEndpoint}',
      queryParams: queryParams,
    );
  }

  // Get historical weather
  Future<Map<String, dynamic>> getHistoricalWeather({
    required String location,
    required String date,
    String? endDate,
    String language = 'en',
  }) async {
    final Map<String, String> queryParams = {
      ApiConstants.weatherApiKeyParam: ApiConstants.weatherApiKey,
      ApiConstants.weatherApiQueryParam: location,
      ApiConstants.weatherApiDtParam: date,
      ApiConstants.weatherApiLanguageParam: language,
    };

    if (endDate != null) {
      queryParams[ApiConstants.weatherApiEndDtParam] = endDate;
    }

    return await _get(
      '${ApiConstants.weatherApiBaseUrl}${ApiConstants.historyEndpoint}',
      queryParams: queryParams,
    );
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
  // ignore: unused_element
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
      final response = await _httpClient
          .post(
            uri,
            headers: headers,
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

  @override
  void onClose() {
    _httpClient.close();
    super.onClose();
  }
}
