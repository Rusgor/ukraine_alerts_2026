import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ua_air_alerts/features/alerts/data/constants.dart';
import 'package:ua_air_alerts/features/alerts/data/service/background_alert_service.dart';
import 'package:ua_air_alerts/features/alerts/data/service/permissions_service.dart';
import 'package:ua_air_alerts/features/alerts/presentation/cubit/locale_cubit.dart';
import 'package:ua_air_alerts/l10n/app_localizations.dart';
import 'package:ua_air_alerts/router/app_router.dart';
import 'package:ua_air_alerts/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  // Save token to shared_preferences for background worker access
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(StorageKeys.apiToken, dotenv.env['API_TOKEN'] ?? '');

  await initBackgroundService();
  await requestAllPermissions();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LocaleCubit(),
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
    );
  }
}
