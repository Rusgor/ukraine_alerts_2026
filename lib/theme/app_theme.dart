import 'package:flutter/material.dart';

abstract class AppColors {
  // Home screen gradient
  static const homeGradientTop = Color(0xFF87CEEB);
  static const homeGradientBottom = Color(0xFFE8F5A0);

  // Alerts Map
  static const mapBackground = Color(0xFFD6EEFF);

  // Region Alerts - initial
  static const regionInitialBackground = Color(0xFFD6EEFF);
  static const regionAppBar = Color(0xFF90CAF9);

  // Region Alerts - no alert (green)
  static const noAlertGradientTop = Color(0xFF388E3C);
  static const noAlertGradientBottom = Color(0xFF76FF03);
  static const noAlertAppBar = Color(0xFF2E7D32);

  // Region Alerts - alert active (red)
  static const alertGradientTop = Color(0xFF6D1B1B);
  static const alertGradientBottom = Color(0xFFF44336);
  static const alertAppBar = Color(0xFF8B2525);

  // General
  static const textDark = Color(0xFF1A237E);
  static const textWhite = Colors.white;
  static const surface = Colors.white;
  static const error = Color(0xFFD32F2F);
}

abstract class AppSizes {
  static const paddingS = 8.0;
  static const paddingM = 12.0;
  static const paddingL = 16.0;
  static const paddingXL = 24.0;

  static const radiusS = 8.0;
  static const radiusM = 12.0;
  static const radiusL = 16.0;
  static const radiusXL = 24.0;

  static const fontS = 12.0;
  static const fontM = 14.0;
  static const fontL = 16.0;
  static const fontXL = 20.0;
  static const fontXXL = 24.0;

  static const iconM = 24.0;
  static const iconL = 32.0;
}

ThemeData buildAppTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: AppColors.textDark,
      surface: AppColors.surface,
      error: AppColors.error,
    ),
    scaffoldBackgroundColor: AppColors.mapBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: AppColors.textDark,
        fontSize: AppSizes.fontXL,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: AppColors.textDark),
    ),
  );
}
