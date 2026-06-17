import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ua_air_alerts/l10n/app_localizations.dart';
import 'package:ua_air_alerts/router/app_router.dart';
import 'package:ua_air_alerts/theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.homeGradientTop, AppColors.homeGradientBottom],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingXL),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _NavButton(
                  icon: Icons.map_outlined,
                  label: l10n.alertsMap,
                  onPressed: () => context.goNamed(RouteNames.alertsMap),
                ),
                const SizedBox(height: AppSizes.paddingL),
                _NavButton(
                  icon: Icons.location_city_outlined,
                  label: l10n.regionAlerts,
                  onPressed: () => context.goNamed(RouteNames.regionAlerts),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: AppColors.textDark,
          padding: const EdgeInsets.symmetric(vertical: AppSizes.paddingL),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusXL),
          ),
          textStyle: const TextStyle(
            fontSize: AppSizes.fontXL,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
