import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ua_air_alerts/features/alerts/data/repository/alerts_repository.dart';
import 'package:ua_air_alerts/features/alerts/presentation/cubit/region_alerts_cubit.dart';
import 'package:ua_air_alerts/features/alerts/presentation/cubit/region_alerts_state.dart';
import 'package:ua_air_alerts/features/alerts/presentation/widgets/alerts_app_bar.dart';
import 'package:ua_air_alerts/features/alerts/presentation/widgets/region_dropdown.dart';
import 'package:ua_air_alerts/features/alerts/presentation/widgets/region_status_body.dart';
import 'package:ua_air_alerts/l10n/app_localizations.dart';
import 'package:ua_air_alerts/theme/app_theme.dart';

class RegionAlertsScreen extends StatelessWidget {
  const RegionAlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RegionAlertsCubit(AlertsRepository())..init(),
      child: const _RegionAlertsView(),
    );
  }
}

class _RegionAlertsView extends StatelessWidget {
  const _RegionAlertsView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<RegionAlertsCubit, RegionAlertsState>(
      builder: (context, state) {
        final colors = _getColors(state);

        return AnimatedContainer(
          duration: const Duration(milliseconds: 600),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: colors,
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AlertsAppBar(
              title: l10n.regionAlerts,
              onRefresh: () => context.read<RegionAlertsCubit>().refresh(),
              backgroundColor: colors.first.withValues(alpha: 0.7),
              foregroundColor: _getForegroundColor(state),
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(AppSizes.paddingL),
                  child: RegionDropdown(
                    selectedUid: context.read<RegionAlertsCubit>().currentUid,
                    onSelected: (uid) {
                      context.read<RegionAlertsCubit>().checkAlert(uid);
                    },
                  ),
                ),
                Expanded(child: RegionStatusBody(state: state)),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Color> _getColors(RegionAlertsState state) => switch (state) {
        RegionAlertsLoaded(isAlert: true) => [
            AppColors.alertGradientTop,
            AppColors.alertGradientBottom,
          ],
        RegionAlertsLoaded(isAlert: false) => [
            AppColors.noAlertGradientTop,
            AppColors.noAlertGradientBottom,
          ],
        RegionAlertsLoading(previousAlert: true) => [
            AppColors.alertGradientTop,
            AppColors.alertGradientBottom,
          ],
        RegionAlertsLoading(previousAlert: false) => [
            AppColors.noAlertGradientTop,
            AppColors.noAlertGradientBottom,
          ],
        _ => [
            AppColors.regionInitialBackground,
            AppColors.regionInitialBackground,
          ],
      };

  Color _getForegroundColor(RegionAlertsState state) => switch (state) {
        RegionAlertsLoaded() => AppColors.textWhite,
        RegionAlertsLoading(previousAlert: true) => AppColors.textWhite,
        RegionAlertsLoading(previousAlert: false) => AppColors.textWhite,
        _ => AppColors.textDark,
      };
}
