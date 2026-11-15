import 'package:starcrop/engine/astro_engine.dart';
import 'package:test/test.dart';

void main() {
  group('AstroEngine', () {
    test('julianDate matches known value (2000-01-01 12:00 UTC = JD 2451545.0)', () {
      final jd = AstroEngine.julianDate(DateTime.utc(2000, 1, 1, 12, 0, 0));
      expect(jd, closeTo(2451545.0, 0.0001));
    });

    test('gmstDegrees returns value in [0,360)', () {
      final gmst = AstroEngine.gmstDegrees(DateTime.utc(2026, 9, 23, 12, 0, 0));
      expect(gmst, greaterThanOrEqualTo(0));
      expect(gmst, lessThan(360));
    });

    test('moonPhase stays within [0,1)', () {
      final phase = AstroEngine.moonPhase(DateTime.utc(2026, 9, 23));
      expect(phase, greaterThanOrEqualTo(0));
      expect(phase, lessThan(1));
    });

    test('equatorialToHorizontal: Polaris stays near lat altitude from northern latitude', () {
      // Polaris ~ RA 37.95deg, Dec +89.26deg. From mid-northern latitude,
      // altitude should be roughly equal to observer's latitude, any time of day.
      final result = AstroEngine.equatorialToHorizontal(
        raDeg: 37.95,
        decDeg: 89.26,
        latDeg: 40.0,
        lonDeg: -75.0,
        utc: DateTime.utc(2026, 9, 23, 4, 0, 0),
      );
      expect(result.altitudeDeg, closeTo(40.0, 2.0));
    });

    test('isVisible respects minAltitude threshold', () {
      expect(AstroEngine.isVisible(5.0, minAltitudeDeg: 0.0), isTrue);
      expect(AstroEngine.isVisible(-1.0, minAltitudeDeg: 0.0), isFalse);
      expect(AstroEngine.isVisible(3.0, minAltitudeDeg: 10.0), isFalse);
    });

    test('moonPhaseLabel covers full cycle without throwing', () {
      for (double p = 0.0; p < 1.0; p += 0.05) {
        expect(AstroEngine.moonPhaseLabel(p), isNotEmpty);
      }
    });
  });
}
