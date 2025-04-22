import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Base theme colors
class AppColors {
  // Primary colors
  static const Color primary = Color(0xFF4A80F0);
  static const Color primaryLight = Color(0xFF8AB0FF);
  static const Color primaryDark = Color(0xFF3461C7);

  // Secondary colors
  static const Color secondary = Color(0xFF36CDA8);
  static const Color secondaryLight = Color(0xFF76E3CA);
  static const Color secondaryDark = Color(0xFF259A7D);

  // Background colors
  static const Color backgroundLight = Color(0xFFF8FAFF);
  static const Color backgroundDark = Color(0xFF1A1A2E);

  // Surface colors
  static const Color surfaceLight = Colors.white;
  static const Color surfaceDark = Color(0xFF252545);

  // Error colors
  static const Color error = Color(0xFFFF5252);
  static const Color errorLight = Color(0xFFFF8A8A);
  static const Color errorDark = Color(0xFFD32F2F);

  // Text colors
  static const Color textDark = Color(0xFF303030);
  static const Color textMedium = Color(0xFF606060);
  static const Color textLight = Color(0xFF909090);
  static const Color textLightDark = Color(0xFFCCCCCC);
  static const Color textMediumDark = Color(0xFF999999);
  static const Color textDarkDark = Color(0xFFEEEEEE);

  // Weather condition colors
  static const Color sunny = Color(0xFFFFB74D);
  static const Color cloudy = Color(0xFF90A4AE);
  static const Color rainy = Color(0xFF64B5F6);
  static const Color stormy = Color(0xFF5C6BC0);
  static const Color snowy = Color(0xFFB3E5FC);
  static const Color foggy = Color(0xFFCFD8DC);

  // Severity levels for weather alerts
  static const Color severityLow = Color(0xFFFFEC19);
  static const Color severityMedium = Color(0xFFFF9800);
  static const Color severityHigh = Color(0xFFFF5252);
  static const Color severityExtreme = Color(0xFFD50000);

  // Air quality index colors
  static const Color aqiGood = Color(0xFF4CAF50);
  static const Color aqiModerate = Color(0xFFFFEB3B);
  static const Color aqiUnhealthySensitive = Color(0xFFFF9800);
  static const Color aqiUnhealthy = Color(0xFFFF5252);
  static const Color aqiVeryUnhealthy = Color(0xFF9C27B0);
  static const Color aqiHazardous = Color(0xFF880E4F);

  // Utility colors
  static const Color divider = Color(0xFFE0E0E0);
  static const Color dividerDark = Color(0xFF424242);
  static const Color shadow = Color(0x1A000000);
  static const Color overlay = Color(0x80000000);
}

// Text styles
class AppTextStyles {
  static TextStyle displayLarge = GoogleFonts.poppins(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
  );

  static TextStyle displayMedium = GoogleFonts.poppins(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.25,
  );

  static TextStyle displaySmall = GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.w600,
  );

  static TextStyle headlineLarge = GoogleFonts.poppins(
    fontSize: 22,
    fontWeight: FontWeight.w600,
  );

  static TextStyle headlineMedium = GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );

  static TextStyle headlineSmall = GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  static TextStyle titleLarge = GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );

  static TextStyle titleMedium = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static TextStyle titleSmall = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static TextStyle bodyLarge = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.normal,
  );

  static TextStyle bodyMedium = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );

  static TextStyle bodySmall = GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.normal,
  );

  static TextStyle labelLarge = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static TextStyle labelMedium = GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  static TextStyle labelSmall = GoogleFonts.poppins(
    fontSize: 10,
    fontWeight: FontWeight.w500,
  );
}

// Dimensions
class AppDimensions {
  // Spacing
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;

  // Radius
  static const double radiusXs = 4.0;
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 24.0;
  static const double radiusXxl = 32.0;

  // Card sizes
  static const double cardHeightSm = 80.0;
  static const double cardHeightMd = 120.0;
  static const double cardHeightLg = 160.0;

  // Icon sizes
  static const double iconSm = 16.0;
  static const double iconMd = 24.0;
  static const double iconLg = 32.0;
  static const double iconXl = 48.0;

  // Button heights
  static const double buttonHeightSm = 32.0;
  static const double buttonHeightMd = 40.0;
  static const double buttonHeightLg = 48.0;

  // Input heights
  static const double inputHeight = 48.0;

  // Animation durations
  static const Duration animFast = Duration(milliseconds: 200);
  static const Duration animNormal = Duration(milliseconds: 300);
  static const Duration animSlow = Duration(milliseconds: 500);
}

// Shadows
class AppShadows {
  static List<BoxShadow> small = [
    BoxShadow(
      color: AppColors.shadow.withOpacity(0.04),
      blurRadius: 3,
      offset: const Offset(0, 1),
    ),
  ];

  static List<BoxShadow> medium = [
    BoxShadow(
      color: AppColors.shadow.withOpacity(0.08),
      blurRadius: 6,
      offset: const Offset(0, 3),
    ),
  ];

  static List<BoxShadow> large = [
    BoxShadow(
      color: AppColors.shadow.withOpacity(0.12),
      blurRadius: 10,
      offset: const Offset(0, 5),
    ),
  ];

  static List<BoxShadow> extraLarge = [
    BoxShadow(
      color: AppColors.shadow.withOpacity(0.16),
      blurRadius: 15,
      offset: const Offset(0, 8),
    ),
  ];
}

// Gradients
class AppGradients {
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.primary, AppColors.primaryDark],
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.secondary, AppColors.secondaryDark],
  );

  static const LinearGradient sunnyGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF4A80F0), Color(0xFF9EBBFF)],
  );

  static const LinearGradient cloudyGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF83B1FF), Color(0xFFB5D1FF)],
  );

  static const LinearGradient rainyGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF5583E7), Color(0xFF8EADEC)],
  );

  static const LinearGradient stormyGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF4A6FE3), Color(0xFF6B8DE4)],
  );

  static const LinearGradient snowyGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF8BA5E3), Color(0xFFB2C4F5)],
  );

  static const LinearGradient foggyGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF86A9ED), Color(0xFFAFC3F2)],
  );

  static const LinearGradient nightGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF2C3E7B), Color(0xFF4A64B4)],
  );
}
