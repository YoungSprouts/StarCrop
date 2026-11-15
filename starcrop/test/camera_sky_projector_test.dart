import 'package:starcrop/engine/astro_engine.dart';
import 'package:starcrop/engine/camera_sky_projector.dart';
import 'package:test/test.dart';

void main() {
  group('CameraSkyProjector.project', () {
    const screenW = 1000.0;
    const screenH = 2000.0;
    const fov = 60.0;

    test('a target exactly where the camera points lands at screen center', () {
      final p = CameraSkyProjector.project(
        target: const AltAz(altitudeDeg: 30, azimuthDeg: 90),
        deviceHeadingDeg: 90,
        devicePitchDeg: 30,
        fovDeg: fov,
        screenWidth: screenW,
        screenHeight: screenH,
      );
      expect(p, isNotNull);
      expect(p!.x, closeTo(screenW / 2, 0.01));
      expect(p.y, closeTo(screenH / 2, 0.01));
    });

    test('a target to the right (higher azimuth) projects right of center', () {
      final p = CameraSkyProjector.project(
        target: const AltAz(altitudeDeg: 30, azimuthDeg: 100),
        deviceHeadingDeg: 90,
        devicePitchDeg: 30,
        fovDeg: fov,
        screenWidth: screenW,
        screenHeight: screenH,
      );
      expect(p, isNotNull);
      expect(p!.x, greaterThan(screenW / 2));
    });

    test('a target above where the camera points projects above center', () {
      final p = CameraSkyProjector.project(
        target: const AltAz(altitudeDeg: 40, azimuthDeg: 90),
        deviceHeadingDeg: 90,
        devicePitchDeg: 30,
        fovDeg: fov,
        screenWidth: screenW,
        screenHeight: screenH,
      );
      expect(p, isNotNull);
      expect(p!.y, lessThan(screenH / 2));
    });

    test('below the horizon is always null, regardless of pointing', () {
      final p = CameraSkyProjector.project(
        target: const AltAz(altitudeDeg: -5, azimuthDeg: 90),
        deviceHeadingDeg: 90,
        devicePitchDeg: 30,
        fovDeg: fov,
        screenWidth: screenW,
        screenHeight: screenH,
      );
      expect(p, isNull);
    });

    test('a target well outside the horizontal FOV is null', () {
      final p = CameraSkyProjector.project(
        target: const AltAz(altitudeDeg: 30, azimuthDeg: 200),
        deviceHeadingDeg: 90,
        devicePitchDeg: 30,
        fovDeg: fov,
        screenWidth: screenW,
        screenHeight: screenH,
      );
      expect(p, isNull);
    });

    test('a target well outside the vertical FOV is null', () {
      // With screenW=1000, screenH=2000, fov=60, the (corrected) vertical
      // FOV is fov * screenHeight / screenWidth = 120deg, i.e. +/-60deg
      // from center. altitudeDeg 85 vs pitch 30 is only a 55deg delta --
      // inside that window -- so it's no longer a valid "well outside"
      // case now that the vertical-FOV bug is fixed. A target at the
      // zenith (90deg) against a level pointing direction gives a 90deg
      // delta, safely outside the 60deg half-window either way.
      final p = CameraSkyProjector.project(
        target: const AltAz(altitudeDeg: 90, azimuthDeg: 90),
        deviceHeadingDeg: 90,
        devicePitchDeg: 0,
        fovDeg: fov,
        screenWidth: screenW,
        screenHeight: screenH,
      );
      expect(p, isNull);
    });

    test('a target within the (correctly wider) vertical FOV on a tall '
        'portrait screen is not incorrectly rejected', () {
      // Regression test for the vertical-FOV bug: a portrait screen
      // (taller than wide) must have a *larger* vertical FOV than the
      // horizontal fovDeg, not smaller. This target sits 55deg above the
      // pointing direction -- outside a naive +/-30deg (horizontal-FOV)
      // window, but well inside the correct +/-60deg vertical window for
      // this 1000x2000 screen -- so it must still project successfully.
      final p = CameraSkyProjector.project(
        target: const AltAz(altitudeDeg: 85, azimuthDeg: 90),
        deviceHeadingDeg: 90,
        devicePitchDeg: 30,
        fovDeg: fov,
        screenWidth: screenW,
        screenHeight: screenH,
      );
      expect(p, isNotNull);
    });

    test('heading wraparound at the 0/360 seam resolves to a small delta', () {
      final p = CameraSkyProjector.project(
        target: const AltAz(altitudeDeg: 30, azimuthDeg: 10),
        deviceHeadingDeg: 350,
        devicePitchDeg: 30,
        fovDeg: fov,
        screenWidth: screenW,
        screenHeight: screenH,
      );
      // True delta is +20deg (350 -> 10 going forward), well within a
      // 60deg FOV, so this must NOT be rejected as if the delta were -340.
      expect(p, isNotNull);
      expect(p!.x, greaterThan(screenW / 2));
    });

    test('degenerate screen size or FOV is handled without throwing', () {
      expect(
        CameraSkyProjector.project(
          target: const AltAz(altitudeDeg: 30, azimuthDeg: 90),
          deviceHeadingDeg: 90,
          devicePitchDeg: 30,
          fovDeg: 0,
          screenWidth: screenW,
          screenHeight: screenH,
        ),
        isNull,
      );
      expect(
        CameraSkyProjector.project(
          target: const AltAz(altitudeDeg: 30, azimuthDeg: 90),
          deviceHeadingDeg: 90,
          devicePitchDeg: 30,
          fovDeg: fov,
          screenWidth: 0,
          screenHeight: screenH,
        ),
        isNull,
      );
    });
  });
}
