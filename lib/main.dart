import 'package:flutter/material.dart';
import 'package:ua_air_alerts/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UA Air Alerts',
      theme: buildAppTheme(),
      home: const Scaffold(
        body: Center(child: Text('UA Air Alerts')),
      ),
    );
  }
}
