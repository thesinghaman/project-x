import 'package:flutter/material.dart';
import 'package:sundrift/app/themes/app_theme.dart';

// Storm theme colors
final Color _primaryColor = Color(0xFF5C6BC0);
final Color _secondaryColor = Color(0xFF4DB6AC);
final Color _backgroundColor = Color(0xFF263238);
final Color _surfaceColor = Color(0xFF37474F);
final Color _textColor = Color(0xFFECEFF1);
final Color _accentColor = Color(0xFF7986CB);

final ThemeData stormTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  primaryColor: _primaryColor,
  colorScheme: ColorScheme.dark(
    primary: _primaryColor,
    onPrimary: Colors.white,
    secondary: _secondaryColor,
    onSecondary: Colors.white,
    surface: _surfaceColor,
    onSurface: _textColor,
    background: _backgroundColor,
    onBackground: _textColor,
    error: AppColors.error,
    onError: Colors.white,
  ),
  scaffoldBackgroundColor: _backgroundColor,
  textTheme: TextTheme(
    displayLarge: AppTextStyles.displayLarge.copyWith(color: _textColor),
    displayMedium: AppTextStyles.displayMedium.copyWith(color: _textColor),
    displaySmall: AppTextStyles.displaySmall.copyWith(color: _textColor),
    headlineLarge: AppTextStyles.headlineLarge.copyWith(color: _textColor),
    headlineMedium: AppTextStyles.headlineMedium.copyWith(color: _textColor),
    headlineSmall: AppTextStyles.headlineSmall.copyWith(color: _textColor),
    titleLarge: AppTextStyles.titleLarge.copyWith(color: _textColor),
    titleMedium: AppTextStyles.titleMedium.copyWith(color: _textColor),
    titleSmall: AppTextStyles.titleSmall.copyWith(color: _textColor),
    bodyLarge: AppTextStyles.bodyLarge.copyWith(color: _textColor),
    bodyMedium: AppTextStyles.bodyMedium.copyWith(color: _textColor),
    bodySmall: AppTextStyles.bodySmall.copyWith(color: _textColor),
    labelLarge: AppTextStyles.labelLarge.copyWith(color: _textColor),
    labelMedium: AppTextStyles.labelMedium.copyWith(color: _textColor),
    labelSmall: AppTextStyles.labelSmall.copyWith(color: _textColor),
  ),
  cardTheme: CardTheme(
    color: _surfaceColor,
    shadowColor: Colors.black.withOpacity(0.5),
    elevation: 4,
    margin: const EdgeInsets.all(AppDimensions.sm),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
    ),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    centerTitle: true,
    iconTheme: IconThemeData(color: _textColor),
    titleTextStyle: AppTextStyles.titleLarge.copyWith(color: _textColor),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: _surfaceColor,
    selectedItemColor: _accentColor,
    unselectedItemColor: _textColor.withOpacity(0.5),
    selectedLabelStyle: AppTextStyles.labelSmall,
    unselectedLabelStyle: AppTextStyles.labelSmall,
    elevation: 8,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: _surfaceColor,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: AppDimensions.md,
      vertical: AppDimensions.sm,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      borderSide: BorderSide(color: _primaryColor.withOpacity(0.3), width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      borderSide: BorderSide(color: _primaryColor, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      borderSide: BorderSide(color: AppColors.error, width: 1),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      borderSide: BorderSide(color: AppColors.error, width: 1.5),
    ),
    labelStyle:
        AppTextStyles.bodyMedium.copyWith(color: _textColor.withOpacity(0.7)),
    hintStyle:
        AppTextStyles.bodyMedium.copyWith(color: _textColor.withOpacity(0.5)),
    errorStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.errorLight),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: _accentColor,
      foregroundColor: Colors.white,
      elevation: 2,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.lg,
        vertical: AppDimensions.md,
      ),
      textStyle: AppTextStyles.labelLarge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: _accentColor,
      side: BorderSide(color: _accentColor, width: 1.5),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.lg,
        vertical: AppDimensions.md,
      ),
      textStyle: AppTextStyles.labelLarge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: _accentColor,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.md,
        vertical: AppDimensions.sm,
      ),
      textStyle: AppTextStyles.labelLarge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
    ),
  ),
  dividerTheme: DividerThemeData(
    color: _textColor.withOpacity(0.2),
    thickness: 1,
    space: AppDimensions.md,
  ),
  sliderTheme: SliderThemeData(
    activeTrackColor: _accentColor,
    inactiveTrackColor: _primaryColor.withOpacity(0.3),
    thumbColor: _accentColor,
    overlayColor: _accentColor.withOpacity(0.2),
    trackHeight: 4,
  ),
  chipTheme: ChipThemeData(
    backgroundColor: _surfaceColor,
    disabledColor: _surfaceColor.withOpacity(0.5),
    selectedColor: _primaryColor,
    secondarySelectedColor: _accentColor,
    padding: const EdgeInsets.symmetric(
      horizontal: AppDimensions.md,
      vertical: AppDimensions.xs,
    ),
    labelStyle: AppTextStyles.bodySmall.copyWith(color: _textColor),
    secondaryLabelStyle: AppTextStyles.bodySmall.copyWith(color: Colors.white),
    brightness: Brightness.dark,
  ),
  dialogTheme: DialogTheme(
    backgroundColor: _surfaceColor,
    elevation: 8,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
    ),
  ),
  snackBarTheme: SnackBarThemeData(
    backgroundColor: _surfaceColor,
    contentTextStyle: AppTextStyles.bodyMedium.copyWith(color: _textColor),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
    ),
    behavior: SnackBarBehavior.floating,
  ),
  tabBarTheme: TabBarTheme(
    labelColor: _accentColor,
    unselectedLabelColor: _textColor.withOpacity(0.5),
    labelStyle: AppTextStyles.labelMedium,
    unselectedLabelStyle: AppTextStyles.labelMedium,
    indicatorSize: TabBarIndicatorSize.label,
    indicator: BoxDecoration(
      border: Border(
        bottom: BorderSide(color: _accentColor, width: 2),
      ),
    ),
  ),
  checkboxTheme: CheckboxThemeData(
    fillColor: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return _accentColor;
      }
      return Colors.transparent;
    }),
    checkColor: MaterialStateProperty.all(Colors.white),
    side: BorderSide(color: _textColor.withOpacity(0.5), width: 1.5),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
    ),
  ),
  radioTheme: RadioThemeData(
    fillColor: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return _accentColor;
      }
      return _textColor.withOpacity(0.5);
    }),
  ),
  switchTheme: SwitchThemeData(
    thumbColor: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return _accentColor;
      }
      return Colors.white;
    }),
    trackColor: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return _accentColor.withOpacity(0.5);
      }
      return _textColor.withOpacity(0.3);
    }),
  ),
  bottomSheetTheme: BottomSheetThemeData(
    backgroundColor: _surfaceColor,
    elevation: 8,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppDimensions.radiusLg),
      ),
    ),
  ),
);
