import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sundrift/app/themes/light_theme.dart' as Light;
import 'package:sundrift/app/themes/dark_theme.dart' as Dark;
import 'package:sundrift/app/themes/system_theme.dart';
import 'package:sundrift/app/themes/custom_themes/sunrise_theme.dart';
import 'package:sundrift/app/themes/custom_themes/sunset_theme.dart';
import 'package:sundrift/app/themes/custom_themes/storm_theme.dart';
import 'package:sundrift/app/themes/custom_themes/snow_theme.dart';

class ThemeController extends GetxController {
  static ThemeController get to => Get.find();

  // Constants for theme selection
  static const String LIGHT_THEME = 'light';
  static const String DARK_THEME = 'dark';
  static const String SYSTEM_THEME = 'system';
  static const String SUNRISE_THEME = 'sunrise';
  static const String SUNSET_THEME = 'sunset';
  static const String STORM_THEME = 'storm';
  static const String SNOW_THEME = 'snow';

  late SharedPreferences _prefs;

  // Initialize with null-safety patterns instead of 'late'
  ThemeMode _themeMode = ThemeMode.system;
  ThemeData? _lightTheme;
  ThemeData? _darkTheme;
  String _selectedTheme = SYSTEM_THEME;

  // Getters for theme
  ThemeMode get themeMode => _themeMode;
  ThemeData get lightTheme => _lightTheme ?? Light.lightTheme;
  ThemeData get darkTheme => _darkTheme ?? Dark.darkTheme;
  String get selectedTheme => _selectedTheme;

  @override
  void onInit() {
    super.onInit();
    // Initialize with default theme
    _lightTheme = lightTheme;
    _darkTheme = darkTheme;
  }

  // Initialize controller
  Future<ThemeController> init() async {
    _prefs = await SharedPreferences.getInstance();
    _initializeTheme();
    return this;
  }

  // Initialize themes
  void _initializeTheme() {
    _selectedTheme = _prefs.getString('theme') ?? SYSTEM_THEME;

    // Set theme based on saved preference
    switch (_selectedTheme) {
      case LIGHT_THEME:
        _lightTheme = lightTheme;
        _darkTheme = lightTheme;
        _themeMode = ThemeMode.light;
        break;
      case DARK_THEME:
        _lightTheme = darkTheme;
        _darkTheme = darkTheme;
        _themeMode = ThemeMode.dark;
        break;
      case SUNRISE_THEME:
        _lightTheme = sunriseTheme;
        _darkTheme = sunriseTheme;
        _themeMode = ThemeMode.light;
        break;
      case SUNSET_THEME:
        _lightTheme = sunsetTheme;
        _darkTheme = sunsetTheme;
        _themeMode = ThemeMode.light;
        break;
      case STORM_THEME:
        _lightTheme = stormTheme;
        _darkTheme = stormTheme;
        _themeMode = ThemeMode.light;
        break;
      case SNOW_THEME:
        _lightTheme = snowTheme;
        _darkTheme = snowTheme;
        _themeMode = ThemeMode.light;
        break;
      case SYSTEM_THEME:
      default:
        _lightTheme = lightTheme;
        _darkTheme = darkTheme;
        _themeMode = ThemeMode.system;
        break;
    }
  }

  // Change theme
  void changeTheme(String theme) async {
    _selectedTheme = theme;
    await _prefs.setString('theme', theme);

    _initializeTheme();
    update();
  }
}
