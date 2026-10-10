import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ua_air_alerts/features/alerts/data/entity/alert_entity.dart';
import 'package:ua_air_alerts/features/alerts/data/entity/oblast_assets.dart';
import 'package:ua_air_alerts/l10n/app_localizations.dart';
import 'package:ua_air_alerts/theme/app_theme.dart';

class AlertsMapBody extends StatelessWidget {
  const AlertsMapBody({super.key, required this.alerts});

  final List<AlertEntity> alerts;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _MapSection(alerts: alerts)),
        const SliverToBoxAdapter(child: SizedBox(height: AppSizes.paddingM)),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingL),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _AlertTile(alert: alerts[index]),
              childCount: alerts.length,
            ),
          ),
        ),
      ],
    );
  }
}

class _MapSection extends StatelessWidget {
  const _MapSection({required this.alerts});

  final List<AlertEntity> alerts;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: AppLocalizations.of(context)!.alertsMap,
      image: true,
      child: Padding(
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
      ),
    );
  }
}

class _AlertTile extends StatelessWidget {
  const _AlertTile({required this.alert});

  final AlertEntity alert;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    final dateStr = DateFormat.yMMMd(locale).add_Hms().format(alert.startedAt);

    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.paddingS),
      padding: const EdgeInsets.all(AppSizes.paddingM),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
      ),
      child: Row(
        children: [
          Icon(
            _alertIcon(alert.alertType),
            color: _alertColor(alert.alertType),
          ),
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

  static IconData _alertIcon(String type) => switch (type) {
    'air_raid' => Icons.warning_amber_rounded,
    'artillery_shelling' => Icons.gps_fixed,
    'urban_fights' => Icons.dangerous,
    'chemical' => Icons.science,
    'nuclear' => Icons.radio_button_checked,
    _ => Icons.warning_amber_rounded,
  };

  static Color _alertColor(String type) => switch (type) {
    'air_raid' => AppColors.alertTypeAirRaid,
    'artillery_shelling' => AppColors.alertTypeArtillery,
    'urban_fights' => AppColors.alertTypeUrbanFights,
    'chemical' => AppColors.alertTypeChemical,
    'nuclear' => AppColors.alertTypeNuclear,
    _ => AppColors.alertTypeAirRaid,
  };
}
