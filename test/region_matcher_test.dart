import 'package:flutter_test/flutter_test.dart';
import 'package:ua_air_alerts/features/alerts/domain/region_matcher.dart';

void main() {
  group('RegionMatcher.match', () {
    test('matches Ukrainian oblast names and common grammatical forms', () {
      expect(RegionMatcher.match('Харківська область'), '22');
      expect(RegionMatcher.match('Харківська'), '22');
      expect(RegionMatcher.match('Київська область'), '14');
    });

    test('matches English provider variants', () {
      expect(RegionMatcher.match('Lviv Oblast'), '27');
      expect(RegionMatcher.match('Vinnytsia'), '4');
      expect(RegionMatcher.match('Kyiv City'), '31');
    });

    test('does not guess from partial or unknown names', () {
      expect(RegionMatcher.match('Харків'), isNull);
      expect(RegionMatcher.match('Somewhere in Ukraine'), isNull);
      expect(RegionMatcher.match(''), isNull);
    });
  });
}
