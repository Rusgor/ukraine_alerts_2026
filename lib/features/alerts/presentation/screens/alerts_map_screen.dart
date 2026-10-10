import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ua_air_alerts/features/alerts/domain/alerts_gateway.dart';
import 'package:ua_air_alerts/features/alerts/presentation/cubit/alerts_map_cubit.dart';
import 'package:ua_air_alerts/features/alerts/presentation/cubit/alerts_map_state.dart';
import 'package:ua_air_alerts/features/alerts/presentation/widgets/alerts_map_body.dart';
import 'package:ua_air_alerts/features/alerts/presentation/widgets/alerts_app_bar.dart';
import 'package:ua_air_alerts/l10n/app_localizations.dart';
import 'package:ua_air_alerts/theme/app_theme.dart';

class AlertsMapScreen extends StatelessWidget {
  const AlertsMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AlertsMapCubit(context.read<AlertsGateway>())..loadAlerts(),
      child: const _AlertsMapView(),
    );
  }
}

class _AlertsMapView extends StatelessWidget {
  const _AlertsMapView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.mapBackground,
      appBar: AlertsAppBar(
        title: l10n.alertsMap,
        onRefresh: () => context.read<AlertsMapCubit>().refresh(),
      ),
      body: BlocBuilder<AlertsMapCubit, AlertsMapState>(
        builder: (context, state) => switch (state) {
          AlertsMapLoading() => const Center(
            child: CircularProgressIndicator(),
          ),
          AlertsMapLoaded() => AlertsMapBody(alerts: state.alerts),
          AlertsMapError() => _ErrorView(
            message: state.message,
            onRetry: () => context.read<AlertsMapCubit>().loadAlerts(),
          ),
        },
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingXL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 64, color: AppColors.error),
            const SizedBox(height: AppSizes.paddingL),
            Text(l10n.errorLoading, textAlign: TextAlign.center),
            if (message.isNotEmpty) ...[
              const SizedBox(height: AppSizes.paddingS),
              Text(message, textAlign: TextAlign.center),
            ],
            const SizedBox(height: AppSizes.paddingXL),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text(l10n.retry),
            ),
          ],
        ),
      ),
    );
  }
}
