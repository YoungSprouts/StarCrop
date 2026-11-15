import 'package:starcrop/engine/aim_lock_detector.dart';
import 'package:starcrop/engine/astro_engine.dart';
import 'package:starcrop/repository/sky_models.dart';
import 'package:test/test.dart';

void main() {
  ObservedConstellation const_(String code, double alt, double az, {bool visible = true}) =>
      ObservedConstellation(
        code: code,
        latinName: code,
        centerPosition: AltAz(altitudeDeg: alt, azimuthDeg: az),
        visible: visible,
      );

  group('AimLockDetector.lockedConstellationCode', () {
    test('locks onto a constellation dead-center in the pointing direction', () {
      final code = AimLockDetector.lockedConstellationCode(
        visible: [const_('ORI', 30, 90)],
        headingDeg: 90,
        pitchDeg: 30,
      );
      expect(code, 'ORI');
    });

    test('locks within tolerance, a few degrees off', () {
      final code = AimLockDetector.lockedConstellationCode(
        visible: [const_('ORI', 30, 90)],
        headingDeg: 95,
        pitchDeg: 33,
      );
      expect(code, 'ORI');
    });

    test('does not lock when outside tolerance, even if it is the nearest', () {
      final code = AimLockDetector.lockedConstellationCode(
        visible: [const_('ORI', 30, 90)],
        headingDeg: 130,
        pitchDeg: 30,
      );
      expect(code, isNull);
    });

    test('ignores constellations not currently visible', () {
      final code = AimLockDetector.lockedConstellationCode(
        visible: [const_('ORI', 30, 90, visible: false)],
        headingDeg: 90,
        pitchDeg: 30,
      );
      expect(code, isNull);
    });

    test('picks the closest of several candidates', () {
      final code = AimLockDetector.lockedConstellationCode(
        visible: [const_('TAU', 32, 95), const_('ORI', 30, 90)],
        headingDeg: 90,
        pitchDeg: 30,
      );
      expect(code, 'ORI');
    });

    test('empty list yields no lock', () {
      final code = AimLockDetector.lockedConstellationCode(
        visible: const [],
        headingDeg: 90,
        pitchDeg: 30,
      );
      expect(code, isNull);
    });
  });
}
