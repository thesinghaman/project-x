import 'package:flutter/material.dart';
import 'package:sundrift/app/themes/app_theme.dart';

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  primaryColor: AppColors.primary,
  colorScheme: ColorScheme.dark(
    primary: AppColors.primary,
    onPrimary: Colors.white,
    secondary: AppColors.secondary,
    onSecondary: Colors.white,
    surface: AppColors.surfaceDark,
    onSurface: AppColors.textDarkDark,
    background: AppColors.backgroundDark,
    onBackground: AppColors.textDarkDark,
    error: AppColors.error,
    onError: Colors.white,
  ),
  scaffoldBackgroundColor: AppColors.backgroundDark,
  textTheme: TextTheme(
    displayLarge:
        AppTextStyles.displayLarge.copyWith(color: AppColors.textDarkDark),
    displayMedium:
        AppTextStyles.displayMedium.copyWith(color: AppColors.textDarkDark),
    displaySmall:
        AppTextStyles.displaySmall.copyWith(color: AppColors.textDarkDark),
    headlineLarge:
        AppTextStyles.headlineLarge.copyWith(color: AppColors.textDarkDark),
    headlineMedium:
        AppTextStyles.headlineMedium.copyWith(color: AppColors.textDarkDark),
    headlineSmall:
        AppTextStyles.headlineSmall.copyWith(color: AppColors.textDarkDark),
    titleLarge:
        AppTextStyles.titleLarge.copyWith(color: AppColors.textDarkDark),
    titleMedium:
        AppTextStyles.titleMedium.copyWith(color: AppColors.textDarkDark),
    titleSmall:
        AppTextStyles.titleSmall.copyWith(color: AppColors.textDarkDark),
    bodyLarge: AppTextStyles.bodyLarge.copyWith(color: AppColors.textDarkDark),
    bodyMedium:
        AppTextStyles.bodyMedium.copyWith(color: AppColors.textDarkDark),
    bodySmall: AppTextStyles.bodySmall.copyWith(color: AppColors.textDarkDark),
    labelLarge:
        AppTextStyles.labelLarge.copyWith(color: AppColors.textDarkDark),
    labelMedium:
        AppTextStyles.labelMedium.copyWith(color: AppColors.textDarkDark),
    labelSmall:
        AppTextStyles.labelSmall.copyWith(color: AppColors.textDarkDark),
  ),
  cardTheme: CardTheme(
    color: AppColors.surfaceDark,
    shadowColor: Colors.black.withOpacity(0.3),
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
    iconTheme: IconThemeData(color: AppColors.textDarkDark),
    titleTextStyle:
        AppTextStyles.titleLarge.copyWith(color: AppColors.textDarkDark),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: AppColors.surfaceDark,
    selectedItemColor: AppColors.primaryLight,
    unselectedItemColor: AppColors.textMediumDark,
    selectedLabelStyle: AppTextStyles.labelSmall,
    unselectedLabelStyle: AppTextStyles.labelSmall,
    elevation: 8,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.surfaceDark,
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
      borderSide: BorderSide(color: AppColors.dividerDark, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      borderSide: BorderSide(color: AppColors.primaryLight, width: 1.5),
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
        AppTextStyles.bodyMedium.copyWith(color: AppColors.textMediumDark),
    hintStyle:
        AppTextStyles.bodyMedium.copyWith(color: AppColors.textLightDark),
    errorStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.errorLight),
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
      foregroundColor: AppColors.primaryLight,
      side: BorderSide(color: AppColors.primaryLight, width: 1.5),
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
      foregroundColor: AppColors.primaryLight,
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
    color: AppColors.dividerDark,
    thickness: 1,
    space: AppDimensions.md,
  ),
  sliderTheme: SliderThemeData(
    activeTrackColor: AppColors.primaryLight,
    inactiveTrackColor: AppColors.primary.withOpacity(0.3),
    thumbColor: AppColors.primaryLight,
    overlayColor: AppColors.primaryLight.withOpacity(0.2),
    trackHeight: 4,
  ),
  chipTheme: ChipThemeData(
    backgroundColor: AppColors.surfaceDark,
    disabledColor: AppColors.surfaceDark.withOpacity(0.5),
    selectedColor: AppColors.primaryLight,
    secondarySelectedColor: AppColors.primary,
    padding: const EdgeInsets.symmetric(
      horizontal: AppDimensions.md,
      vertical: AppDimensions.xs,
    ),
    labelStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.textDarkDark),
    secondaryLabelStyle: AppTextStyles.bodySmall.copyWith(color: Colors.white),
    brightness: Brightness.dark,
  ),
  dialogTheme: DialogTheme(
    backgroundColor: AppColors.surfaceDark,
    elevation: 8,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
    ),
  ),
  snackBarTheme: SnackBarThemeData(
    backgroundColor: AppColors.surfaceDark,
    contentTextStyle:
        AppTextStyles.bodyMedium.copyWith(color: AppColors.textDarkDark),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
    ),
    behavior: SnackBarBehavior.floating,
  ),
  tabBarTheme: TabBarTheme(
    labelColor: AppColors.primaryLight,
    unselectedLabelColor: AppColors.textLightDark,
    labelStyle: AppTextStyles.labelMedium,
    unselectedLabelStyle: AppTextStyles.labelMedium,
    indicatorSize: TabBarIndicatorSize.label,
    indicator: BoxDecoration(
      border: Border(
        bottom: BorderSide(color: AppColors.primaryLight, width: 2),
      ),
    ),
  ),
  checkboxTheme: CheckboxThemeData(
    fillColor: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return AppColors.primaryLight;
      }
      return Colors.transparent;
    }),
    checkColor: MaterialStateProperty.all(Colors.black),
    side: BorderSide(color: AppColors.textLightDark, width: 1.5),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
    ),
  ),
  radioTheme: RadioThemeData(
    fillColor: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return AppColors.primaryLight;
      }
      return AppColors.textLightDark;
    }),
  ),
  switchTheme: SwitchThemeData(
    thumbColor: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return AppColors.primaryLight;
      }
      return Colors.white;
    }),
    trackColor: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return AppColors.primaryLight.withOpacity(0.5);
      }
      return AppColors.textLightDark.withOpacity(0.5);
    }),
  ),
  bottomSheetTheme: BottomSheetThemeData(
    backgroundColor: AppColors.surfaceDark,
    elevation: 8,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppDimensions.radiusLg),
      ),
    ),
  ),
);
