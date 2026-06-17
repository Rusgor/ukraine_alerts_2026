import 'package:flutter/material.dart';
import 'package:ua_air_alerts/theme/app_theme.dart';

class AlertsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AlertsAppBar({
    super.key,
    required this.title,
    required this.onRefresh,
    this.backgroundColor,
    this.foregroundColor,
  });

  final String title;
  final VoidCallback onRefresh;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final fgColor = foregroundColor ?? AppColors.textDark;

    return AppBar(
      backgroundColor: backgroundColor ?? Colors.transparent,
      foregroundColor: fgColor,
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: AppSizes.fontXL,
          color: fgColor,
        ),
      ),
      actions: [
        IconButton(
          onPressed: onRefresh,
          icon: Icon(Icons.refresh, color: fgColor),
        ),
      ],
    );
  }
}
