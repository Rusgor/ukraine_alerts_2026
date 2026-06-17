import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ua_air_alerts/features/alerts/data/entity/alert_entity.dart';
import 'package:ua_air_alerts/features/alerts/data/entity/oblast_assets.dart';
import 'package:ua_air_alerts/theme/app_theme.dart';

class AlertsMapBody extends StatelessWidget {
  const AlertsMapBody({super.key, required this.alerts});

  final List<AlertEntity> alerts;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _MapSection(alerts: alerts),
          const SizedBox(height: AppSizes.paddingM),
          _AlertsList(alerts: alerts),
        ],
      ),
    );
  }
}

class _MapSection extends StatelessWidget {
  const _MapSection({required this.alerts});

  final List<AlertEntity> alerts;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingM),
      child: Stack(
        children: [
          Image.asset('assets/map/ukraine.png', fit: BoxFit.contain),
          ...alerts.map((alert) {
            final path = getOblastAssetPath(alert.locationUid);
            if (path == null) return const SizedBox.shrink();
            return Positioned.fill(
              child: Image.asset(path, fit: BoxFit.contain),
            );
          }),
        ],
      ),
    );
  }
}

class _AlertsList extends StatelessWidget {
  const _AlertsList({required this.alerts});

  final List<AlertEntity> alerts;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingL),
      child: Column(
        children: alerts.map((alert) => _AlertTile(alert: alert)).toList(),
      ),
    );
  }
}

class _AlertTile extends StatelessWidget {
  const _AlertTile({required this.alert});

  final AlertEntity alert;

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('MMM d, yyyy HH:mm:ss').format(alert.startedAt);

    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.paddingS),
      padding: const EdgeInsets.all(AppSizes.paddingM),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: Colors.deepOrange),
          const SizedBox(width: AppSizes.paddingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alert.locationTitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: AppSizes.fontL,
                    color: AppColors.textDark,
                  ),
                ),
                Text(
                  dateStr,
                  style: const TextStyle(
                    fontSize: AppSizes.fontS,
                    color: AppColors.error,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
