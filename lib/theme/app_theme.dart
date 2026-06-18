import 'package:flutter/material.dart';

abstract class AppColors {
  // Home screen gradient
  static const homeGradientTop = Color(0xFF1DC0F4);
  static const homeGradientBottom = Color(0xFFF2F67C);

  // Alerts Map
  static const mapBackground = Color(0xFFD6EEFF);

  // Region Alerts - initial
  static const regionInitialTop = Color(0xFF7EC8F2);
  static const regionInitialBottom = Color(0xFFAADBF7);
  static const regionInitialBackground = Color(0xFF7EC8F2);

  // Region Alerts - no alert (green)
  static const noAlertGradientTop = Color(0xFF01A558);
  static const noAlertGradientBottom = Color(0xFF7AFC68);
  static const noAlertAppBar = Color(0xFF2E7D32);

  // Region Alerts - alert active (red)
  static const alertGradientTop = Color(0xFFA30000);
  static const alertGradientBottom = Color(0xFFFF2E2E);
  static const alertAppBar = Color(0xFF8B2525);

  // Alert types
  static const alertTypeAirRaid = Colors.deepOrange;
  static const alertTypeArtillery = Colors.orange;
  static const alertTypeUrbanFights = Colors.red;
  static const alertTypeChemical = Color(0xFF388E3C);
  static const alertTypeNuclear = Colors.purple;

  // General
  static const textDark = Color(0xFF1E1E1E);
  static const textWhite = Colors.white;
  static const surface = Colors.white;
  static const error = Color(0xFFD32F2F);
  static const cityOverlay = Color(0xFF5AAAD4);
  static const dropdownShadow = Color(0x40000000);
  static const barrierColor = Colors.black38;
  static const snackBarBackground = Color(0x40000000);
  static const hintText = Color(0xFF757575);
  static const disabledIcon = Color(0xFFBDBDBD);
  static const sheetHandle = Color(0xFFE0E0E0);
  static const searchFieldBg = Color(0xFFF5F5F5);
  static const textMuted = Color(0xB3FFFFFF); // white70
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

  static const flagWidth = 72.0;
  static const flagHeight = 48.0;
  static const statusImageSize = 120.0;
  static const cityImageSize = 250.0;
  static const bottomOffset = 80.0;
  static const cityBottomOffset = 100.0;
  static const buttonSpacing = 40.0;
  static const dragHandleWidth = 40.0;
  static const dragHandleHeight = 4.0;
  static const sheetRadius = 20.0;
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
