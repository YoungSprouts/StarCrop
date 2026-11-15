import 'package:starcrop/engine/astro_engine.dart';
import 'package:starcrop/engine/sky_position_description.dart';
import 'package:test/test.dart';

void main() {
  group('SkyPositionDescription.compassName', () {
    test('cardinal directions', () {
      expect(SkyPositionDescription.compassName(0), 'North');
      expect(SkyPositionDescription.compassName(90), 'East');
      expect(SkyPositionDescription.compassName(180), 'South');
      expect(SkyPositionDescription.compassName(270), 'West');
    });

    test('intercardinal directions', () {
      expect(SkyPositionDescription.compassName(45), 'Northeast');
      expect(SkyPositionDescription.compassName(135), 'Southeast');
      expect(SkyPositionDescription.compassName(225), 'Southwest');
      expect(SkyPositionDescription.compassName(315), 'Northwest');
    });

    test('boundaries sit at 22.5 degrees either side', () {
      expect(SkyPositionDescription.compassName(22.4), 'North');
      expect(SkyPositionDescription.compassName(22.5), 'Northeast');
      expect(SkyPositionDescription.compassName(67.4), 'Northeast');
      expect(SkyPositionDescription.compassName(67.5), 'East');
    });

    test('wraps across the 0/360 seam and tolerates out-of-range input', () {
      expect(SkyPositionDescription.compassName(359), 'North');
      expect(SkyPositionDescription.compassName(337.4), 'Northwest');
      expect(SkyPositionDescription.compassName(337.5), 'North'); // wraps to index 0
      expect(SkyPositionDescription.compassName(-45), 'Northwest');
      expect(SkyPositionDescription.compassName(405), 'Northeast');
    });
  });

  group('SkyPositionDescription.heightLabel', () {
    test('typical altitude is a rounded degree count', () {
      expect(SkyPositionDescription.heightLabel(42.4), '42° above the horizon');
      expect(SkyPositionDescription.heightLabel(42.6), '43° above the horizon');
    });

    test('near the horizon, near the zenith, and below', () {
      expect(SkyPositionDescription.heightLabel(3), 'just above the horizon');
      expect(SkyPositionDescription.heightLabel(85), 'almost straight overhead');
      expect(SkyPositionDescription.heightLabel(-2), 'below the horizon');
    });
  });

  group('SkyPositionDescription.describe', () {
    test('builds compass, rounded azimuth, height and summary', () {
      final p = SkyPositionDescription.describe(
        const AltAz(altitudeDeg: 42.0, azimuthDeg: 47.6),
      );
      expect(p.compass, 'Northeast');
      expect(p.azimuthDeg, 48);
      expect(p.summary, 'Northeast, 42° above the horizon');
      expect(p.headline('Orion'), 'Orion spotted in the northeast');
    });

    test('azimuth that rounds up to 360 reports as 0', () {
      final p = SkyPositionDescription.describe(
        const AltAz(altitudeDeg: 30, azimuthDeg: 359.7),
      );
      expect(p.azimuthDeg, 0);
      expect(p.compass, 'North');
    });
  });

  group('SkyPositionDescription.dateTimeLabel', () {
    test('evening time', () {
      expect(
        SkyPositionDescription.dateTimeLabel(DateTime(2026, 9, 28, 20, 5)),
        'Sep 28, 2026 · 8:05 PM',
      );
    });

    test('midnight and noon use 12, not 0', () {
      expect(
        SkyPositionDescription.dateTimeLabel(DateTime(2026, 1, 3, 0, 9)),
        'Jan 3, 2026 · 12:09 AM',
      );
      expect(
        SkyPositionDescription.dateTimeLabel(DateTime(2026, 1, 3, 12, 0)),
        'Jan 3, 2026 · 12:00 PM',
      );
    });
  });
}
