import 'package:starcrop/engine/astro_engine.dart';
import 'package:starcrop/engine/sky_position_confirmation.dart';
import 'package:starcrop/repository/sky_models.dart';
import 'package:test/test.dart';

void main() {
  ObservedStar star(double alt, double az) => ObservedStar(
        hipId: 0,
        properName: null,
        magnitude: 1.0,
        position: AltAz(altitudeDeg: alt, azimuthDeg: az),
      );

  group('SkyPositionConfirmation.starsInFrame', () {
    test('keeps only stars that project inside the current frame', () {
      final predicted = [
        star(30, 90), // dead center of a camera pointed at (90, 30)
        star(30, 200), // far outside a 60deg FOV
        star(-5, 90), // below horizon
      ];

      final inFrame = SkyPositionConfirmation.starsInFrame(
        predicted: predicted,
        headingDeg: 90,
        pitchDeg: 30,
        fovDeg: 60,
        screenWidth: 1000,
        screenHeight: 2000,
      );

      expect(inFrame.length, 1);
      expect(inFrame.single.position.azimuthDeg, 90);
    });
  });

  group('SkyPositionConfirmation.confirmationFor', () {
    test('confirmed when enough predicted stars land in frame', () {
      final predicted = [star(30, 88), star(32, 92), star(29, 91)];
      final result = SkyPositionConfirmation.confirmationFor(
        predicted: predicted,
        headingDeg: 90,
        pitchDeg: 30,
        fovDeg: 60,
        screenWidth: 1000,
        screenHeight: 2000,
      );
      expect(result.result, 'confirmed');
      expect(result.starsInFrame.length, greaterThanOrEqualTo(2));
      expect(result.confidence, 1.0);
    });

    test('unclear when only one predicted star is in frame', () {
      final predicted = [star(30, 90), star(80, 250)];
      final result = SkyPositionConfirmation.confirmationFor(
        predicted: predicted,
        headingDeg: 90,
        pitchDeg: 30,
        fovDeg: 60,
        screenWidth: 1000,
        screenHeight: 2000,
      );
      expect(result.result, 'unclear');
      expect(result.starsInFrame.length, 1);
    });

    test('failed when nothing predicted lands in frame', () {
      final predicted = [star(80, 250), star(-10, 90)];
      final result = SkyPositionConfirmation.confirmationFor(
        predicted: predicted,
        headingDeg: 90,
        pitchDeg: 30,
        fovDeg: 60,
        screenWidth: 1000,
        screenHeight: 2000,
      );
      expect(result.result, 'failed');
      expect(result.confidence, 0.0);
    });

    test('never throws on degenerate screen size, just yields no matches', () {
      final result = SkyPositionConfirmation.confirmationFor(
        predicted: [star(30, 90)],
        headingDeg: 90,
        pitchDeg: 30,
        fovDeg: 60,
        screenWidth: 0,
        screenHeight: 0,
      );
      expect(result.result, 'failed');
    });
  });
}
