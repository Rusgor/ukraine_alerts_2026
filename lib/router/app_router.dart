import 'package:go_router/go_router.dart';
import 'package:ua_air_alerts/features/alerts/presentation/screens/alerts_map_screen.dart';
import 'package:ua_air_alerts/features/alerts/presentation/screens/home_screen.dart';
import 'package:ua_air_alerts/features/alerts/presentation/screens/region_alerts_screen.dart';

abstract class RouteNames {
  static const home = 'home';
  static const alertsMap = 'alertsMap';
  static const regionAlerts = 'regionAlerts';
}

final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: RouteNames.home,
      builder: (context, state) => const HomeScreen(),
      routes: [
        GoRoute(
          path: 'alerts-map',
          name: RouteNames.alertsMap,
          builder: (context, state) => const AlertsMapScreen(),
        ),
        GoRoute(
          path: 'region-alerts',
          name: RouteNames.regionAlerts,
          builder: (context, state) => const RegionAlertsScreen(),
        ),
      ],
    ),
  ],
);
