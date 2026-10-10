import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ua_air_alerts/core/settings/app_settings.dart';
import 'package:ua_air_alerts/features/alerts/data/repository/alerts_repository.dart';
import 'package:ua_air_alerts/features/alerts/data/service/region_location_service.dart';
import 'package:ua_air_alerts/features/alerts/domain/alerts_gateway.dart';
import 'package:ua_air_alerts/features/alerts/presentation/cubit/locale_cubit.dart';
import 'package:ua_air_alerts/l10n/app_localizations.dart';
import 'package:ua_air_alerts/router/app_router.dart';
import 'package:ua_air_alerts/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load();
  } on Exception {
    // Optional local configuration must not prevent the first frame.
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AppSettings>(
          create: (_) => const SharedPreferencesAppSettings(),
        ),
        RepositoryProvider<AlertsGateway>(create: (_) => AlertsRepository()),
        RepositoryProvider<RegionLocationService>(
          create: (_) => const GeolocatorRegionLocationService(),
        ),
      ],
      child: BlocProvider(
        create: (context) => LocaleCubit(context.read<AppSettings>())..load(),
        child: BlocBuilder<LocaleCubit, Locale>(
          builder: (context, locale) {
            return MaterialApp.router(
              title: 'UA Air Alerts',
              theme: buildAppTheme(),
              locale: locale,
              supportedLocales: const [Locale('uk'), Locale('en')],
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              routerConfig: appRouter,
            );
          },
        ),
      ),
    );
  }
}
