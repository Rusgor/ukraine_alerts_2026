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
      RegionAlertsLoaded(:final isAlert) => _LoadedBody(isAlert: isAlert),
      RegionAlertsError(:final message) => _ErrorBody(message: message),
    };
  }
}

class _InitialBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Opacity(
        opacity: 0.3,
        child: Image.asset(
          'assets/image_city.png',
          width: 250,
          height: 250,
        ),
      ),
    );
  }
}

class _LoadedBody extends StatelessWidget {
  const _LoadedBody({required this.isAlert});

  final bool isAlert;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            isAlert ? 'assets/image_alarm.png' : 'assets/image_done.png',
            width: 120,
            height: 120,
          ),
          const SizedBox(height: AppSizes.paddingXL),
          Text(
            isAlert ? l10n.alertActive : l10n.noAlert,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: AppSizes.fontXXL,
              fontWeight: FontWeight.w600,
              color: AppColors.textWhite,
            ),
          ),
        ],
      ),
    );
  }
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
          const Icon(Icons.error_outline, size: 64, color: Colors.white70),
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
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
