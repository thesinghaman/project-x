import 'package:flutter/material.dart';
import 'package:sundrift/app/themes/app_theme.dart';

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  primaryColor: AppColors.primary,
  colorScheme: ColorScheme.light(
    primary: AppColors.primary,
    onPrimary: Colors.white,
    secondary: AppColors.secondary,
    onSecondary: Colors.white,
    surface: AppColors.surfaceLight,
    onSurface: AppColors.textDark,
    background: AppColors.backgroundLight,
    onBackground: AppColors.textDark,
    error: AppColors.error,
    onError: Colors.white,
  ),
  scaffoldBackgroundColor: AppColors.backgroundLight,
  textTheme: TextTheme(
    displayLarge:
        AppTextStyles.displayLarge.copyWith(color: AppColors.textDark),
    displayMedium:
        AppTextStyles.displayMedium.copyWith(color: AppColors.textDark),
    displaySmall:
        AppTextStyles.displaySmall.copyWith(color: AppColors.textDark),
    headlineLarge:
        AppTextStyles.headlineLarge.copyWith(color: AppColors.textDark),
    headlineMedium:
        AppTextStyles.headlineMedium.copyWith(color: AppColors.textDark),
    headlineSmall:
        AppTextStyles.headlineSmall.copyWith(color: AppColors.textDark),
    titleLarge: AppTextStyles.titleLarge.copyWith(color: AppColors.textDark),
    titleMedium: AppTextStyles.titleMedium.copyWith(color: AppColors.textDark),
    titleSmall: AppTextStyles.titleSmall.copyWith(color: AppColors.textDark),
    bodyLarge: AppTextStyles.bodyLarge.copyWith(color: AppColors.textDark),
    bodyMedium: AppTextStyles.bodyMedium.copyWith(color: AppColors.textDark),
    bodySmall: AppTextStyles.bodySmall.copyWith(color: AppColors.textDark),
    labelLarge: AppTextStyles.labelLarge.copyWith(color: AppColors.textDark),
    labelMedium: AppTextStyles.labelMedium.copyWith(color: AppColors.textDark),
    labelSmall: AppTextStyles.labelSmall.copyWith(color: AppColors.textDark),
  ),
  cardTheme: CardTheme(
    color: AppColors.surfaceLight,
    shadowColor: AppColors.shadow,
    elevation: 2,
    margin: const EdgeInsets.all(AppDimensions.sm),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
    ),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    centerTitle: true,
    iconTheme: IconThemeData(color: AppColors.textDark),
    titleTextStyle:
        AppTextStyles.titleLarge.copyWith(color: AppColors.textDark),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: AppColors.surfaceLight,
    selectedItemColor: AppColors.primary,
    unselectedItemColor: AppColors.textLight,
    selectedLabelStyle: AppTextStyles.labelSmall,
    unselectedLabelStyle: AppTextStyles.labelSmall,
    elevation: 8,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.surfaceLight,
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
      borderSide: BorderSide(color: AppColors.divider, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      borderSide: BorderSide(color: AppColors.primary, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      borderSide: BorderSide(color: AppColors.error, width: 1),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      borderSide: BorderSide(color: AppColors.error, width: 1.5),
    ),
    labelStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMedium),
    hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textLight),
    errorStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.error),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
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
      foregroundColor: AppColors.primary,
      side: BorderSide(color: AppColors.primary, width: 1.5),
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
      foregroundColor: AppColors.primary,
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
    color: AppColors.divider,
    thickness: 1,
    space: AppDimensions.md,
  ),
  sliderTheme: SliderThemeData(
    activeTrackColor: AppColors.primary,
    inactiveTrackColor: AppColors.primaryLight.withOpacity(0.3),
    thumbColor: AppColors.primary,
    overlayColor: AppColors.primary.withOpacity(0.2),
    trackHeight: 4,
  ),
  chipTheme: ChipThemeData(
    backgroundColor: AppColors.surfaceLight,
    disabledColor: AppColors.surfaceLight.withOpacity(0.5),
    selectedColor: AppColors.primary,
    secondarySelectedColor: AppColors.primaryLight,
    padding: const EdgeInsets.symmetric(
      horizontal: AppDimensions.md,
      vertical: AppDimensions.xs,
    ),
    labelStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.textDark),
    secondaryLabelStyle: AppTextStyles.bodySmall.copyWith(color: Colors.white),
    brightness: Brightness.light,
  ),
  dialogTheme: DialogTheme(
    backgroundColor: AppColors.surfaceLight,
    elevation: 8,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
    ),
  ),
  snackBarTheme: SnackBarThemeData(
    backgroundColor: AppColors.textDark,
    contentTextStyle: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
    ),
    behavior: SnackBarBehavior.floating,
  ),
  tabBarTheme: TabBarTheme(
    labelColor: AppColors.primary,
    unselectedLabelColor: AppColors.textLight,
    labelStyle: AppTextStyles.labelMedium,
    unselectedLabelStyle: AppTextStyles.labelMedium,
    indicatorSize: TabBarIndicatorSize.label,
    indicator: BoxDecoration(
      border: Border(
        bottom: BorderSide(color: AppColors.primary, width: 2),
      ),
    ),
  ),
  checkboxTheme: CheckboxThemeData(
    fillColor: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return AppColors.primary;
      }
      return Colors.transparent;
    }),
    checkColor: MaterialStateProperty.all(Colors.white),
    side: BorderSide(color: AppColors.textLight, width: 1.5),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
    ),
  ),
  radioTheme: RadioThemeData(
    fillColor: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return AppColors.primary;
      }
      return AppColors.textLight;
    }),
  ),
  switchTheme: SwitchThemeData(
    thumbColor: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return AppColors.primary;
      }
      return Colors.white;
    }),
    trackColor: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return AppColors.primary.withOpacity(0.5);
      }
      return AppColors.textLight.withOpacity(0.5);
    }),
  ),
  bottomSheetTheme: BottomSheetThemeData(
    backgroundColor: AppColors.surfaceLight,
    elevation: 8,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppDimensions.radiusLg),
      ),
    ),
  ),
);
