import 'package:flutter/material.dart';

abstract class AppColors {
  static const primary = Color(0xFF1565C0);
  static const primaryDark = Color(0xFF0D47A1);
  static const secondary = Color(0xFFFFC107);
  static const background = Color(0xFFF5F5F5);
  static const surface = Colors.white;
  static const error = Color(0xFFD32F2F);
  static const textPrimary = Color(0xFF212121);
  static const textSecondary = Color(0xFF757575);
  static const divider = Color(0xFFBDBDBD);
}

abstract class AppSizes {
  // Paddings
  static const paddingXS = 4.0;
  static const paddingS = 8.0;
  static const paddingM = 12.0;
  static const paddingL = 16.0;
  static const paddingXL = 24.0;

  // Border radius
  static const radiusS = 8.0;
  static const radiusM = 12.0;
  static const radiusL = 16.0;

  // Font sizes
  static const fontS = 12.0;
  static const fontM = 14.0;
  static const fontL = 16.0;
  static const fontXL = 20.0;
  static const fontXXL = 24.0;

  // Icon sizes
  static const iconS = 16.0;
  static const iconM = 24.0;
  static const iconL = 32.0;
}

ThemeData buildAppTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.surface,
      error: AppColors.error,
    ),
    scaffoldBackgroundColor: AppColors.background,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
    ),
    dividerTheme: const DividerThemeData(color: AppColors.divider),
  );
}
