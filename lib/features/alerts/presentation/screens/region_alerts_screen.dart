import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ua_air_alerts/features/alerts/data/repository/alerts_repository.dart';
import 'package:ua_air_alerts/features/alerts/presentation/cubit/region_alerts_cubit.dart';
import 'package:ua_air_alerts/features/alerts/presentation/cubit/region_alerts_state.dart';
import 'package:ua_air_alerts/features/alerts/presentation/widgets/alerts_app_bar.dart';
import 'package:ua_air_alerts/features/alerts/presentation/widgets/pulse_icon_button.dart';
import 'package:ua_air_alerts/features/alerts/presentation/widgets/region_dropdown.dart';
import 'package:ua_air_alerts/features/alerts/presentation/widgets/region_status_body.dart';
import 'package:ua_air_alerts/features/alerts/presentation/widgets/star_tooltip_overlay.dart';
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

        return StarTooltipOverlay(
          enabled: state is! RegionAlertsInitial,
          child: AnimatedContainer(
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
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 600),
                color: colors.first.withValues(alpha: 0.1),
                child: AlertsAppBar(
                  title: l10n.regionAlerts,
                  onRefresh: state is RegionAlertsInitial
                      ? null
                      : () => context.read<RegionAlertsCubit>().refresh(),
                  backgroundColor: Colors.transparent,
                  foregroundColor: _getForegroundColor(state),
                  extraActions: [
                    if (state is! RegionAlertsInitial)
                      PulseIconButton(
                        icon: context.read<RegionAlertsCubit>().isMyRegion
                            ? Icons.star
                            : Icons.star_border,
                        color: _getForegroundColor(state),
                        onPressed: () {
                          final cubit = context.read<RegionAlertsCubit>();
                          final wasMyRegion = cubit.isMyRegion;
                          cubit.toggleMyRegion();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    wasMyRegion
                                        ? Icons.star_border
                                        : Icons.star,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: AppSizes.paddingS),
                                  Text(
                                    wasMyRegion
                                        ? l10n.myRegionRemoved
                                        : l10n.myRegionSaved,
                                  ),
                                ],
                              ),
                              backgroundColor: AppColors.snackBarBackground,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppSizes.radiusM,
                                ),
                              ),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(AppSizes.paddingL),
                  child: RegionDropdown(
                    selectedUid: context.read<RegionAlertsCubit>().currentUid,
                    isInitial: state is RegionAlertsInitial,
                    onSelected: (uid) {
                      if (uid == null) {
                        context.read<RegionAlertsCubit>().clearSelection();
                      } else {
                        context.read<RegionAlertsCubit>().checkAlert(uid);
                      }
                    },
                  ),
                ),
                Expanded(child: RegionStatusBody(state: state)),
              ],
            ),
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
    _ => [AppColors.regionInitialTop, AppColors.regionInitialBottom],
  };

  Color _getForegroundColor(RegionAlertsState state) => switch (state) {
    RegionAlertsLoaded() => AppColors.textWhite,
    RegionAlertsLoading(previousAlert: true) => AppColors.textWhite,
    RegionAlertsLoading(previousAlert: false) => AppColors.textWhite,
    _ => AppColors.textDark,
  };
}
