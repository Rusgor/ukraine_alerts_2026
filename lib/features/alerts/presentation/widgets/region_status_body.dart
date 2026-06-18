import 'package:flutter/material.dart';
import 'package:ua_air_alerts/features/alerts/presentation/cubit/region_alerts_state.dart';
import 'package:ua_air_alerts/l10n/app_localizations.dart';
import 'package:ua_air_alerts/theme/app_theme.dart';

class RegionStatusBody extends StatelessWidget {
  const RegionStatusBody({super.key, required this.state});

  final RegionAlertsState state;

  @override
  Widget build(BuildContext context) {
    return switch (state) {
      RegionAlertsInitial() => _InitialBody(),
      RegionAlertsLoading() => const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      RegionAlertsLoaded(:final isAlert, :final alertType) =>
        _LoadedBody(isAlert: isAlert, alertType: alertType),
      RegionAlertsError(:final message) => _ErrorBody(message: message),
    };
  }
}

class _InitialBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.cityBottomOffset),
      child: Center(
        child: Image.asset(
          'assets/image_city.png',
          width: AppSizes.cityImageSize,
          height: AppSizes.cityImageSize,
          color: AppColors.cityOverlay,
          colorBlendMode: BlendMode.srcIn,
        ),
      ),
    );
  }
}

class _LoadedBody extends StatelessWidget {
  const _LoadedBody({required this.isAlert, this.alertType});

  final bool isAlert;
  final String? alertType;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.bottomOffset),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              isAlert ? 'assets/image_alarm.png' : 'assets/image_done.png',
              width: AppSizes.statusImageSize,
              height: AppSizes.statusImageSize,
            ),
            const SizedBox(height: AppSizes.paddingXL),
            Text(
              isAlert ? _alertTitle(l10n, alertType) : l10n.noAlert,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: AppSizes.fontXXL,
                fontWeight: FontWeight.w600,
                color: AppColors.textWhite,
              ),
            ),
            if (isAlert) ...[
              const SizedBox(height: AppSizes.paddingS),
              Text(
                _alertSubtitle(l10n, alertType),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: AppSizes.fontL,
                  color: AppColors.textWhite,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _alertTitle(AppLocalizations l10n, String? type) => switch (type) {
        'air_raid' => l10n.alertTypeAirRaid,
        'artillery_shelling' => l10n.alertTypeArtillery,
        'urban_fights' => l10n.alertTypeUrbanFights,
        'chemical' => l10n.alertTypeChemical,
        'nuclear' => l10n.alertTypeNuclear,
        _ => l10n.alertTypeAirRaid,
      };

  String _alertSubtitle(AppLocalizations l10n, String? type) => switch (type) {
        'chemical' => l10n.alertChemicalShelter,
        'nuclear' => l10n.alertNuclearShelter,
        _ => l10n.alertShelter,
      };
}

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 64, color: AppColors.textMuted),
          const SizedBox(height: AppSizes.paddingL),
          Text(
            l10n.errorLoading,
            style: const TextStyle(
              fontSize: AppSizes.fontXL,
              color: AppColors.textWhite,
            ),
          ),
          const SizedBox(height: AppSizes.paddingS),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}
