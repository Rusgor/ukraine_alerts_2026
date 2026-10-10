import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ua_air_alerts/main.dart';

void main() {
  testWidgets('home screen exposes navigation to alerts features', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('Карта тривог'), findsOneWidget);
    expect(find.text('Тривоги регіону'), findsOneWidget);
  });
}
