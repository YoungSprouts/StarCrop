import 'package:starcrop/engine/device_attitude.dart';
import 'package:test/test.dart';

void main() {
  group('DeviceAttitude.cameraPointing', () {
    test('phone lying flat, screen up: camera faces straight down', () {
      // Device Z axis aligned with world Up (screen facing the sky), so the
      // back camera (-Z) faces straight down regardless of azimuth.
      final result = DeviceAttitude.cameraPointing(
        gravity: [0, 0, 9.8],
        magnetic: [0, 20, -40],
      );
      expect(result, isNotNull);
      expect(result!.altitudeDeg, closeTo(-90, 0.5));
    });

    test('phone held upright, facing exactly North and level', () {
      // Hand-derived device-frame vectors for: device Y axis = world Up,
      // device Z axis = world South (so the back camera, -Z, faces exactly
      // North), device X axis = world East. See device_attitude.dart's
      // construction for the cross-product identities this relies on.
      final result = DeviceAttitude.cameraPointing(
        gravity: [0, 9.8, 0],
        magnetic: [0, -40, -20],
      );
      expect(result, isNotNull);
      expect(result!.azimuthDeg, closeTo(0, 0.5));
      expect(result.altitudeDeg, closeTo(0, 0.5));
    });

    test('returns null when gravity and magnetic vectors are parallel', () {
      final result = DeviceAttitude.cameraPointing(
        gravity: [0, 0, 9.8],
        magnetic: [0, 0, 40], // parallel to gravity -> no unique East
      );
      expect(result, isNull);
    });

    test('returns null on near-zero gravity (e.g. freefall)', () {
      final result = DeviceAttitude.cameraPointing(
        gravity: [0.01, 0.01, 0.01],
        magnetic: [0, 20, -40],
      );
      expect(result, isNull);
    });

    test('returns null on malformed input length', () {
      expect(
        DeviceAttitude.cameraPointing(gravity: [0, 0], magnetic: [0, 20, -40]),
        isNull,
      );
    });
  });
}
