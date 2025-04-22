import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

/// Service for getting device information
class DeviceInfo extends GetxService {
  late DeviceInfoPlugin _deviceInfoPlugin;
  late String _deviceId;
  late String _deviceModel;
  late String _deviceOS;
  late String _deviceOSVersion;
  late String _deviceManufacturer;
  late bool _isPhysicalDevice;

  // Getters
  String get deviceId => _deviceId;
  String get deviceModel => _deviceModel;
  String get deviceOS => _deviceOS;
  String get deviceOSVersion => _deviceOSVersion;
  String get deviceManufacturer => _deviceManufacturer;
  bool get isPhysicalDevice => _isPhysicalDevice;

  Future<DeviceInfo> init() async {
    _deviceInfoPlugin = DeviceInfoPlugin();
    await _getDeviceInfo();
    return this;
  }

  Future<void> _getDeviceInfo() async {
    try {
      if (kIsWeb) {
        await _getWebDeviceInfo();
      } else if (Platform.isAndroid) {
        await _getAndroidDeviceInfo();
      } else if (Platform.isIOS) {
        await _getIOSDeviceInfo();
      } else if (Platform.isWindows) {
        await _getWindowsDeviceInfo();
      } else if (Platform.isMacOS) {
        await _getMacOSDeviceInfo();
      } else if (Platform.isLinux) {
        await _getLinuxDeviceInfo();
      } else {
        _setDefaultDeviceInfo();
      }
    } catch (e) {
      _setDefaultDeviceInfo();
    }
  }

  Future<void> _getAndroidDeviceInfo() async {
    final info = await _deviceInfoPlugin.androidInfo;
    _deviceId = info.id;
    _deviceModel = '${info.brand} ${info.model}';
    _deviceOS = 'Android';
    _deviceOSVersion = info.version.release;
    _deviceManufacturer = info.manufacturer;
    _isPhysicalDevice = info.isPhysicalDevice;
  }

  Future<void> _getIOSDeviceInfo() async {
    final info = await _deviceInfoPlugin.iosInfo;
    _deviceId = info.identifierForVendor ?? 'unknown';
    _deviceModel = info.model;
    _deviceOS = 'iOS';
    _deviceOSVersion = info.systemVersion;
    _deviceManufacturer = 'Apple';
    _isPhysicalDevice = info.isPhysicalDevice;
  }

  Future<void> _getWebDeviceInfo() async {
    final info = await _deviceInfoPlugin.webBrowserInfo;
    _deviceId = (info.vendor ?? 'unknown') + (info.userAgent ?? ' unknown');
    _deviceModel = info.browserName.name;
    _deviceOS = 'Web';
    _deviceOSVersion = 'unknown';
    _deviceManufacturer = info.vendor ?? "";
    _isPhysicalDevice = false;
  }

  Future<void> _getWindowsDeviceInfo() async {
    final info = await _deviceInfoPlugin.windowsInfo;
    _deviceId = info.deviceId;
    _deviceModel = info.productName;
    _deviceOS = 'Windows';
    _deviceOSVersion =
        '${info.majorVersion}.${info.minorVersion}.${info.buildNumber}';
    _deviceManufacturer = info.registeredOwner;
    _isPhysicalDevice = true;
  }

  Future<void> _getMacOSDeviceInfo() async {
    final info = await _deviceInfoPlugin.macOsInfo;
    _deviceId = info.systemGUID ?? info.computerName;
    _deviceModel = info.model;
    _deviceOS = 'macOS';
    _deviceOSVersion =
        '${info.majorVersion}.${info.minorVersion}.${info.patchVersion}';
    _deviceManufacturer = 'Apple';
    _isPhysicalDevice = true;
  }

  Future<void> _getLinuxDeviceInfo() async {
    final info = await _deviceInfoPlugin.linuxInfo;
    _deviceId = info.machineId ?? 'unknown';
    _deviceModel = info.name;
    _deviceOS = 'Linux';
    _deviceOSVersion = info.version ?? 'unknown';
    _deviceManufacturer = info.prettyName;
    _isPhysicalDevice = true;
  }

  void _setDefaultDeviceInfo() {
    _deviceId = 'unknown';
    _deviceModel = 'unknown';
    _deviceOS = 'unknown';
    _deviceOSVersion = 'unknown';
    _deviceManufacturer = 'unknown';
    _isPhysicalDevice = true;
  }

  // Get all device information as a map
  Map<String, dynamic> getAllDeviceInfo() {
    return {
      'deviceId': _deviceId,
      'deviceModel': _deviceModel,
      'deviceOS': _deviceOS,
      'deviceOSVersion': _deviceOSVersion,
      'deviceManufacturer': _deviceManufacturer,
      'isPhysicalDevice': _isPhysicalDevice,
    };
  }
}
