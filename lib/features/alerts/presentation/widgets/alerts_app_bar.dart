import 'package:flutter/material.dart';
import 'package:ua_air_alerts/features/alerts/presentation/widgets/refresh_button.dart';
import 'package:ua_air_alerts/theme/app_theme.dart';

class AlertsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AlertsAppBar({
    super.key,
    required this.title,
    this.onRefresh,
    this.backgroundColor,
    this.foregroundColor,
    this.extraActions = const [],
  });

  final String title;
  final VoidCallback? onRefresh;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final List<Widget> extraActions;

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
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: AppSizes.fontXL,
          color: fgColor,
        ),
      ),
      actions: [
        ...extraActions,
        if (onRefresh != null)
          RefreshButton(onRefresh: onRefresh!, color: fgColor),
      ],
    );
  }
}
