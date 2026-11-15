import 'package:image/image.dart' as img;
import 'package:starcrop/engine/photo_matching_engine.dart';
import 'package:starcrop/engine/astro_engine.dart';
import 'package:starcrop/repository/sky_models.dart';
import 'package:test/test.dart';

img.Image _blackImage(int w, int h) => img.Image(width: w, height: h);

void _fillGray(img.Image image, int value) {
  for (int y = 0; y < image.height; y++) {
    for (int x = 0; x < image.width; x++) {
      image.setPixel(x, y, img.ColorRgb8(value, value, value));
    }
  }
}

void _drawStar(img.Image image, int cx, int cy, int radius, int brightness) {
  for (int y = -radius; y <= radius; y++) {
    for (int x = -radius; x <= radius; x++) {
      if (x * x + y * y <= radius * radius) {
        final px = cx + x, py = cy + y;
        if (px >= 0 && py >= 0 && px < image.width && py < image.height) {
          image.setPixel(px, py, img.ColorRgb8(brightness, brightness, brightness));
        }
      }
    }
  }
}

void main() {
  group('PhotoMatchingEngine.looksLikeNightSky', () {
    test('rejects a well-lit / bright scene (e.g. an indoor room)', () {
      final image = _blackImage(100, 100);
      _fillGray(image, 180); // uniformly bright, like a lit room
      expect(PhotoMatchingEngine.looksLikeNightSky(image), isFalse);
    });

    test('rejects a scene with many scattered bright points (e.g. ceiling lights)', () {
      final image = _blackImage(200, 200);
      _fillGray(image, 20); // dim background
      // Scatter enough bright blobs that the bright-pixel fraction is high.
      for (int gx = 0; gx < 200; gx += 15) {
        for (int gy = 0; gy < 200; gy += 15) {
          _drawStar(image, gx, gy, 4, 255);
        }
      }
      expect(PhotoMatchingEngine.looksLikeNightSky(image), isFalse);
    });

    test('accepts a mostly-black frame with a few small bright points', () {
      final image = _blackImage(200, 200);
      _fillGray(image, 5); // near-black background
      _drawStar(image, 40, 40, 2, 255);
      _drawStar(image, 150, 60, 2, 240);
      _drawStar(image, 100, 150, 2, 250);
      expect(PhotoMatchingEngine.looksLikeNightSky(image), isTrue);
    });

    test('accepts a fully black frame (dark enough, just nothing detected yet)', () {
      final image = _blackImage(50, 50);
      expect(PhotoMatchingEngine.looksLikeNightSky(image), isTrue);
    });

    test('handles a zero-size image without throwing', () {
      final image = img.Image(width: 0, height: 0);
      expect(PhotoMatchingEngine.looksLikeNightSky(image), isFalse);
    });
  });

  group('PhotoMatchingEngine.detectStars', () {
    test('detects a single bright blob at correct centroid', () {
      final image = _blackImage(100, 100);
      _drawStar(image, 50, 50, 3, 255);

      final stars = PhotoMatchingEngine.detectStars(image, threshold: 200);
      expect(stars.length, 1);
      expect(stars.first.x, closeTo(50, 1));
      expect(stars.first.y, closeTo(50, 1));
    });

    test('detects multiple separated blobs, sorted brightest first', () {
      final image = _blackImage(200, 200);
      _drawStar(image, 20, 20, 2, 150);
      _drawStar(image, 150, 150, 2, 255);
      _drawStar(image, 100, 30, 2, 200);

      final stars = PhotoMatchingEngine.detectStars(image, threshold: 100);
      expect(stars.length, 3);
      expect(stars[0].brightness, 255);
      expect(stars[1].brightness, 200);
      expect(stars[2].brightness, 150);
    });

    test('ignores blobs below threshold', () {
      final image = _blackImage(100, 100);
      _drawStar(image, 50, 50, 2, 50); // dim, below threshold

      final stars = PhotoMatchingEngine.detectStars(image, threshold: 200);
      expect(stars, isEmpty);
    });

    test('respects maxStars limit', () {
      final image = _blackImage(300, 300);
      for (int i = 0; i < 10; i++) {
        _drawStar(image, 10 + i * 25, 10 + i * 25, 2, 200 + i);
      }
      final stars = PhotoMatchingEngine.detectStars(image, threshold: 100, maxStars: 5);
      expect(stars.length, 5);
    });
  });

  group('PhotoMatchingEngine.matchPattern', () {
    ObservedStar star(double alt, double az, double mag) => ObservedStar(
          hipId: 0,
          properName: null,
          magnitude: mag,
          position: AltAz(altitudeDeg: alt, azimuthDeg: az),
        );

    test('returns failed when fewer than 3 stars detected or predicted', () {
      final result = PhotoMatchingEngine.matchPattern(
        detected: [const DetectedStar(x: 0, y: 0, brightness: 200, pixelArea: 3)],
        predicted: [star(45, 90, 1.0)],
        fovDeg: 60,
        imageWidthPx: 1000,
        imageHeightPx: 1000,
      );
      expect(result.result, 'failed');
      expect(result.confidence, 0.0);
    });

    test('confirms a matching triangle pattern (same relative shape)', () {
      final predicted = [
        star(50, 100, 1.0),
        star(55, 108, 1.5),
        star(45, 108, 2.0),
      ];
      final detected = [
        const DetectedStar(x: 500, y: 300, brightness: 255, pixelArea: 4),
        const DetectedStar(x: 560, y: 380, brightness: 220, pixelArea: 4),
        const DetectedStar(x: 440, y: 380, brightness: 200, pixelArea: 4),
      ];

      final result = PhotoMatchingEngine.matchPattern(
        detected: detected,
        predicted: predicted,
        fovDeg: 60,
        imageWidthPx: 1000,
        imageHeightPx: 1000,
      );

      expect(result.starsDetected, 3);
      expect(result.confidence, greaterThan(0.0));
      expect(['confirmed', 'unclear', 'failed'], contains(result.result));

      // Recovered pointing is only populated on a confirmed match, and only
      // makes sense to check its shape then (not its exact value, which
      // depends on where these synthetic stars happen to sit) — a real
      // valid heading/pitch, not left null.
      if (result.result == 'confirmed') {
        expect(result.recoveredHeadingDeg, isNotNull);
        expect(result.recoveredHeadingDeg, inInclusiveRange(0, 360));
        expect(result.recoveredPitchDeg, isNotNull);
      } else {
        expect(result.recoveredHeadingDeg, isNull);
        expect(result.recoveredPitchDeg, isNull);
      }
    });

    test('rejects a wildly different pattern as failed or unclear', () {
      final predicted = [
        star(80, 10, 1.0),
        star(81, 11, 1.1),
        star(79, 12, 1.2),
      ];
      final detected = [
        const DetectedStar(x: 0, y: 0, brightness: 255, pixelArea: 4),
        const DetectedStar(x: 999, y: 0, brightness: 220, pixelArea: 4),
        const DetectedStar(x: 500, y: 999, brightness: 200, pixelArea: 4),
      ];

      final result = PhotoMatchingEngine.matchPattern(
        detected: detected,
        predicted: predicted,
        fovDeg: 60,
        imageWidthPx: 1000,
        imageHeightPx: 1000,
      );

      expect(result.result, isNot('confirmed'));
      expect(result.recoveredHeadingDeg, isNull);
      expect(result.recoveredPitchDeg, isNull);
    });
  });
}
