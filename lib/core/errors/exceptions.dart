/// Base exception for all app exceptions
class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic details;

  AppException(this.message, {this.code, this.details});

  @override
  String toString() =>
      'AppException: $message${code != null ? ' (Code: $code)' : ''}';
}

// Network exceptions

/// Exception for API related errors
class ApiException extends AppException {
  ApiException(String message, {String? code, dynamic details})
      : super(message, code: code, details: details);
}

/// Exception thrown when there is no internet connection
class NoInternetException extends ApiException {
  NoInternetException(String message) : super(message, code: 'no_internet');
}

/// Exception thrown when an API request times out
class ApiTimeoutException extends ApiException {
  ApiTimeoutException(String message) : super(message, code: 'timeout');
}

/// Exception thrown for bad requests (HTTP 400)
class BadRequestException extends ApiException {
  BadRequestException(String message) : super(message, code: 'bad_request');
}

/// Exception thrown for unauthorized requests (HTTP 401)
class UnauthorizedException extends ApiException {
  UnauthorizedException(String message) : super(message, code: 'unauthorized');
}

/// Exception thrown for forbidden requests (HTTP 403)
class ForbiddenException extends ApiException {
  ForbiddenException(String message) : super(message, code: 'forbidden');
}

/// Exception thrown when a resource is not found (HTTP 404)
class NotFoundException extends ApiException {
  NotFoundException(String message) : super(message, code: 'not_found');
}

/// Exception thrown for too many requests (HTTP 429)
class TooManyRequestsException extends ApiException {
  TooManyRequestsException(String message)
      : super(message, code: 'too_many_requests');
}

/// Exception thrown for server errors (HTTP 5xx)
class ServerException extends ApiException {
  ServerException(String message) : super(message, code: 'server_error');
}

// Data exceptions

/// Exception for cache related errors
class CacheException extends AppException {
  CacheException(String message, {String? code, dynamic details})
      : super(message, code: code ?? 'cache_error', details: details);
}

/// Exception for data parsing errors
class ParseException extends AppException {
  ParseException(String message, {String? code, dynamic details})
      : super(message, code: code ?? 'parse_error', details: details);
}

// Location exceptions

/// Exception for location related errors
class LocationException extends AppException {
  LocationException(String message, {String? code, dynamic details})
      : super(message, code: code ?? 'location_error', details: details);
}

/// Exception thrown when location permission is denied
class LocationPermissionDeniedException extends LocationException {
  LocationPermissionDeniedException(String message)
      : super(message, code: 'location_permission_denied');
}

/// Exception thrown when location service is disabled
class LocationServiceDisabledException extends LocationException {
  LocationServiceDisabledException(String message)
      : super(message, code: 'location_service_disabled');
}

// Permission exceptions

/// Exception for permission related errors
class PermissionException extends AppException {
  PermissionException(String message, {String? code, dynamic details})
      : super(message, code: code ?? 'permission_error', details: details);
}

// Storage exceptions

/// Exception for storage related errors
class StorageException extends AppException {
  StorageException(String message, {String? code, dynamic details})
      : super(message, code: code ?? 'storage_error', details: details);
}

// Authentication exceptions

/// Exception for authentication related errors
class AuthException extends AppException {
  AuthException(String message, {String? code, dynamic details})
      : super(message, code: code ?? 'auth_error', details: details);
}

// Feature exceptions

/// Exception for premium feature related errors
class PremiumFeatureException extends AppException {
  PremiumFeatureException(String message, {String? code, dynamic details})
      : super(message, code: code ?? 'premium_feature', details: details);
}
