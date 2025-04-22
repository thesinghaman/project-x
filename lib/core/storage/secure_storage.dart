import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Secure storage service for storing sensitive data
class SecureStorage extends GetxService {
  late final FlutterSecureStorage _secureStorage;

  // Android secure storage options
  final AndroidOptions _androidOptions = const AndroidOptions(
    encryptedSharedPreferences: true,
  );

  // iOS secure storage options
  final IOSOptions _iosOptions = const IOSOptions(
    accessibility: KeychainAccessibility.first_unlock,
  );

  Future<SecureStorage> init() async {
    _secureStorage = FlutterSecureStorage(
      aOptions: _androidOptions,
      iOptions: _iosOptions,
    );
    return this;
  }

  // String operations
  Future<void> setString(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  Future<String?> getString(String key) async {
    return await _secureStorage.read(key: key);
  }

  // Object operations (encoded as JSON)
  Future<void> setObject(String key, dynamic value) async {
    await _secureStorage.write(key: key, value: jsonEncode(value));
  }

  Future<dynamic> getObject(String key, {dynamic defaultValue}) async {
    final String? data = await _secureStorage.read(key: key);
    if (data == null) return defaultValue;

    try {
      return jsonDecode(data);
    } catch (e) {
      return defaultValue;
    }
  }

  // Delete operations
  Future<void> delete(String key) async {
    await _secureStorage.delete(key: key);
  }

  // Clear all data
  Future<void> deleteAll() async {
    await _secureStorage.deleteAll();
  }

  // Check if key exists
  Future<bool> hasKey(String key) async {
    return (await _secureStorage.read(key: key)) != null;
  }

  // Get all keys
  Future<Map<String, String>> getAll() async {
    return await _secureStorage.readAll();
  }
}
