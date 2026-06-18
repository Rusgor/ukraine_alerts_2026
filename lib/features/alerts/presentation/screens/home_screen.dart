import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ua_air_alerts/features/alerts/presentation/cubit/locale_cubit.dart';
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
            padding:
                const EdgeInsets.symmetric(horizontal: AppSizes.paddingXL),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _NavButton(
                  label: l10n.alertsMap,
                  onPressed: () => context.goNamed(RouteNames.alertsMap),
                ),
                const SizedBox(height: AppSizes.paddingL),
                _NavButton(
                  label: l10n.regionAlerts,
                  onPressed: () => context.goNamed(RouteNames.regionAlerts),
                ),
                const SizedBox(height: AppSizes.buttonSpacing),
                BlocBuilder<LocaleCubit, Locale>(
                  builder: (context, locale) {
                    final isUk = locale.languageCode == 'uk';
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _FlagButton(
                          asset: 'assets/uk.png',
                          isSelected: isUk,
                          onTap: () => context
                              .read<LocaleCubit>()
                              .setLocale(const Locale('uk')),
                        ),
                        const SizedBox(width: AppSizes.paddingL),
                        _FlagButton(
                          asset: 'assets/en.png',
                          isSelected: !isUk,
                          onTap: () => context
                              .read<LocaleCubit>()
                              .setLocale(const Locale('en')),
                        ),
                      ],
                    );
                  },
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
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizes.radiusXL),
        boxShadow: const [
          BoxShadow(
            color: AppColors.dropdownShadow,
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: AppColors.textDark,
          padding: const EdgeInsets.symmetric(vertical: AppSizes.paddingL),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusXL),
          ),
          elevation: 0,
          textStyle: const TextStyle(
            fontSize: AppSizes.fontXL,
            fontWeight: FontWeight.w500,
          ),
        ),
        child: Text(label),
      ),
    );
  }
}

class _FlagButton extends StatelessWidget {
  const _FlagButton({
    required this.asset,
    required this.isSelected,
    required this.onTap,
  });

  final String asset;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          border: isSelected
              ? Border.all(color: Colors.white, width: 3)
              : null,
          borderRadius: BorderRadius.circular(AppSizes.radiusS),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Image.asset(asset, width: AppSizes.flagWidth, height: AppSizes.flagHeight, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
