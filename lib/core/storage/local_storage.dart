import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service for storing data locally using SharedPreferences
class LocalStorage extends GetxService {
  late SharedPreferences _prefs;

  Future<LocalStorage> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  // String operations
  Future<bool> setString(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  String getString(String key, {String defaultValue = ''}) {
    return _prefs.getString(key) ?? defaultValue;
  }

  // Boolean operations
  Future<bool> setBool(String key, bool value) async {
    return await _prefs.setBool(key, value);
  }

  bool getBool(String key, {bool defaultValue = false}) {
    return _prefs.getBool(key) ?? defaultValue;
  }

  // Integer operations
  Future<bool> setInt(String key, int value) async {
    return await _prefs.setInt(key, value);
  }

  int getInt(String key, {int defaultValue = 0}) {
    return _prefs.getInt(key) ?? defaultValue;
  }

  // Double operations
  Future<bool> setDouble(String key, double value) async {
    return await _prefs.setDouble(key, value);
  }

  double getDouble(String key, {double defaultValue = 0.0}) {
    return _prefs.getDouble(key) ?? defaultValue;
  }

  // String list operations
  Future<bool> setStringList(String key, List<String> value) async {
    return await _prefs.setStringList(key, value);
  }

  List<String> getStringList(String key,
      {List<String> defaultValue = const []}) {
    return _prefs.getStringList(key) ?? defaultValue;
  }

  // Object operations (encoded as JSON)
  Future<bool> setObject(String key, dynamic value) async {
    return await _prefs.setString(key, jsonEncode(value));
  }

  dynamic getObject(String key, {dynamic defaultValue}) {
    final String? data = _prefs.getString(key);
    if (data == null) return defaultValue;

    try {
      return jsonDecode(data);
    } catch (e) {
      return defaultValue;
    }
  }

  // Remove operations
  Future<bool> remove(String key) async {
    return await _prefs.remove(key);
  }

  // Clear all data
  Future<bool> clear() async {
    return await _prefs.clear();
  }

  // Check if key exists
  bool hasKey(String key) {
    return _prefs.containsKey(key);
  }
}
