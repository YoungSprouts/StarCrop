import 'dart:math' as math;
import 'package:image/image.dart' as img;
import '../engine/astro_engine.dart';
import '../repository/sky_models.dart';

/// Classic star-matching pipeline, implemented in pure Dart:
/// threshold -> connected-component blob detection -> centroid extraction
/// -> triangle-pattern match against predicted bright stars.
///
/// Deliberately avoids native OpenCV bindings. This environment (Termux/
/// Flutter, per the project's dev setup) has a documented history of native-
/// plugin build pain (aapt2/AGP pinning, no native-assets support on Android
/// yet — see the sqlite3 pin in pubspec.yaml). A pure-Dart pipeline sidesteps
/// all of that at the cost of being slower on very large images and less
/// robust than a real OpenCV blob detector — acceptable for this feature's
/// "good enough, not survey-grade" accuracy bar.
///
/// Depends on sky_models.dart (not sky_repository.dart) for ObservedStar —
/// that keeps this file, and its tests, free of any dependency on a live
/// database connection or Flutter plugins (path_provider etc.), so it can
/// run under plain `dart test`.
class PhotoMatchingEngine {
  PhotoMatchingEngine._();

  /// Gate to run *before* detectStars/matchPattern. A real night-sky photo
  /// is overwhelmingly dark with a small fraction of bright points (stars);
  /// a lit room, a daytime shot, or a screen/photo of a photo is not. Without
  /// this check, detectStars will happily find "stars" in any bright-on-dark
  /// scene (ceiling lights, windows, daytime clouds against sky) and
  /// matchPattern can still report a coincidental triangle match against
  /// whatever 3 brightest blobs it finds — this rejects those before either
  /// step runs, rather than trying to make matching itself stricter.
  ///
  /// Samples on a stride rather than every pixel — cheap even on a full
  /// camera-resolution photo, and representative enough for this purpose.
  static bool looksLikeNightSky(
    img.Image image, {
    int brightPixelThreshold = 140,
    double maxAverageLuminance = 70,
    double maxBrightFraction = 0.06,
    int stride = 4,
  }) {
    final width = image.width;
    final height = image.height;
    if (width == 0 || height == 0) return false;

    double sumLum = 0;
    int brightCount = 0;
    int sampled = 0;

    for (int y = 0; y < height; y += stride) {
      for (int x = 0; x < width; x += stride) {
        final p = image.getPixel(x, y);
        final lum = 0.299 * p.r + 0.587 * p.g + 0.114 * p.b;
        sumLum += lum;
        if (lum >= brightPixelThreshold) brightCount++;
        sampled++;
      }
    }
    if (sampled == 0) return false;

    final avgLum = sumLum / sampled;
    final brightFraction = brightCount / sampled;

    return avgLum <= maxAverageLuminance && brightFraction <= maxBrightFraction;
  }

  /// Finds bright blobs in [image] via luminance threshold + flood-fill
  /// connected-component labeling, returns their centroids sorted brightest
  /// first. [threshold] is 0-255 luminance; raise it for noisy/light-polluted
  /// photos, lower it for genuinely dark-sky conditions.
  static List<DetectedStar> detectStars(
    img.Image image, {
    int threshold = 200,
    int maxStars = 30,
    int minBlobSize = 1,
    int maxBlobSize = 500,
  }) {
    final width = image.width;
    final height = image.height;
    final visited = List.generate(height, (_) => List.filled(width, false));
    final blobs = <DetectedStar>[];

    int luminanceAt(int x, int y) {
      final p = image.getPixel(x, y);
      // Rec. 601 luma approximation, cheap and good enough for star blobs.
      return ((0.299 * p.r + 0.587 * p.g + 0.114 * p.b)).round();
    }

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        if (visited[y][x]) continue;
        if (luminanceAt(x, y) < threshold) {
          visited[y][x] = true;
          continue;
        }

        // Flood fill (BFS) this blob.
        final queue = <List<int>>[[x, y]];
        visited[y][x] = true;
        double sumX = 0, sumY = 0, sumBrightness = 0;
        int count = 0;
        int maxLum = 0;

        while (queue.isNotEmpty) {
          final p = queue.removeLast();
          final px = p[0], py = p[1];
          final lum = luminanceAt(px, py);
          sumX += px * lum;
          sumY += py * lum;
          sumBrightness += lum;
          maxLum = math.max(maxLum, lum);
          count++;

          for (final d in const [[1, 0], [-1, 0], [0, 1], [0, -1]]) {
            final nx = px + d[0], ny = py + d[1];
            if (nx < 0 || ny < 0 || nx >= width || ny >= height) continue;
            if (visited[ny][nx]) continue;
            if (luminanceAt(nx, ny) < threshold) {
              visited[ny][nx] = true;
              continue;
            }
            visited[ny][nx] = true;
            queue.add([nx, ny]);
          }
        }

        if (count >= minBlobSize && count <= maxBlobSize && sumBrightness > 0) {
          blobs.add(DetectedStar(
            x: sumX / sumBrightness,
            y: sumY / sumBrightness,
            brightness: maxLum.toDouble(),
            pixelArea: count,
          ));
        }
      }
    }

    blobs.sort((a, b) => b.brightness.compareTo(a.brightness));
    return blobs.take(maxStars).toList();
  }

  /// Angular separation (degrees) between two alt/az sky positions, via the
  /// spherical law of cosines on the unit sphere.
  static double _angularSeparation(AltAz a, AltAz b) {
    final alt1 = a.altitudeDeg * math.pi / 180;
    final alt2 = b.altitudeDeg * math.pi / 180;
    final dAz = (a.azimuthDeg - b.azimuthDeg) * math.pi / 180;
    final cosC = math.sin(alt1) * math.sin(alt2) +
        math.cos(alt1) * math.cos(alt2) * math.cos(dAz);
    return math.acos(cosC.clamp(-1.0, 1.0)) * 180 / math.pi;
  }

  /// Pixel distance between two detected blobs, converted to degrees using
  /// the device's horizontal field of view and image width. Assumes roughly
  /// uniform (non-fisheye) projection — fine for the accuracy bar here.
  static double _pixelDistanceToDegrees(
    DetectedStar a,
    DetectedStar b,
    double fovDeg,
    int imageWidthPx,
  ) {
    final dx = a.x - b.x;
    final dy = a.y - b.y;
    final pixelDist = math.sqrt(dx * dx + dy * dy);
    final degPerPixel = fovDeg / imageWidthPx;
    return pixelDist * degPerPixel;
  }

  /// Compares the triangle formed by the 3 brightest detected blobs against
  /// the triangle formed by the 3 brightest predicted stars, using side-
  /// length ratios (scale/rotation-invariant) — this is what lets matching
  /// work without knowing exactly which direction the camera is pointed,
  /// as long as roughly the right patch of sky is in frame.
  static PhotoMatchResult matchPattern({
    required List<DetectedStar> detected,
    required List<ObservedStar> predicted,
    required double fovDeg,
    required int imageWidthPx,
    required int imageHeightPx,
    double toleranceRatio = 0.25,
  }) {
    if (detected.length < 3 || predicted.length < 3) {
      return PhotoMatchResult(
        starsDetected: detected.length,
        starsMatched: 0,
        confidence: 0.0,
        rotationDeg: 0.0,
        shiftXPx: 0.0,
        shiftYPx: 0.0,
        result: 'failed',
      );
    }

    final d = detected.take(3).toList();
    final p = predicted.take(3).toList();

    final detectedSides = [
      _pixelDistanceToDegrees(d[0], d[1], fovDeg, imageWidthPx),
      _pixelDistanceToDegrees(d[1], d[2], fovDeg, imageWidthPx),
      _pixelDistanceToDegrees(d[0], d[2], fovDeg, imageWidthPx),
    ];
    final predictedSides = [
      _angularSeparation(p[0].position, p[1].position),
      _angularSeparation(p[1].position, p[2].position),
      _angularSeparation(p[0].position, p[2].position),
    ];

    // Normalize both triangles by their largest side, then compare shape.
    final dMax = detectedSides.reduce(math.max);
    final pMax = predictedSides.reduce(math.max);
    if (dMax == 0 || pMax == 0) {
      return PhotoMatchResult(
        starsDetected: detected.length,
        starsMatched: 0,
        confidence: 0.0,
        rotationDeg: 0.0,
        shiftXPx: 0.0,
        shiftYPx: 0.0,
        result: 'failed',
      );
    }

    double errorSum = 0;
    for (int i = 0; i < 3; i++) {
      final dNorm = detectedSides[i] / dMax;
      final pNorm = predictedSides[i] / pMax;
      errorSum += (dNorm - pNorm).abs();
    }
    final avgError = errorSum / 3;
    final confidence = (1.0 - (avgError / toleranceRatio)).clamp(0.0, 1.0);

    final centroidX = (d[0].x + d[1].x + d[2].x) / 3;
    final centroidY = (d[0].y + d[1].y + d[2].y) / 3;

    String result;
    int matched;
    // Only populated on a confirmed match: below that confidence bar the
    // brightest-pair correspondence itself isn't trustworthy enough to
    // recover a pointing direction from, so no overlay should be drawn
    // (see camera_check_screen's static-overlay fallback, which checks for
    // these being non-null).
    double? recoveredHeadingDeg;
    double? recoveredPitchDeg;
    if (confidence >= 0.75) {
      result = 'confirmed';
      matched = 3;
      final recovered = _recoverCameraPointing(
        detectedStar: d[0],
        predictedStar: p[0],
        fovDeg: fovDeg,
        imageWidthPx: imageWidthPx,
        imageHeightPx: imageHeightPx,
      );
      recoveredHeadingDeg = recovered.headingDeg;
      recoveredPitchDeg = recovered.pitchDeg;
    } else if (confidence >= 0.4) {
      result = 'unclear';
      matched = 2;
    } else {
      result = 'failed';
      matched = 0;
    }

    return PhotoMatchResult(
      starsDetected: detected.length,
      starsMatched: matched,
      confidence: confidence,
      rotationDeg: 0.0, // not computed by this simplified pipeline
      shiftXPx: centroidX,
      shiftYPx: centroidY,
      result: result,
      recoveredHeadingDeg: recoveredHeadingDeg,
      recoveredPitchDeg: recoveredPitchDeg,
    );
  }

  /// Recovers an approximate camera pointing direction (heading + pitch)
  /// from a single matched star correspondence — the brightest detected
  /// blob and its corresponding brightest predicted star. This inverts the
  /// same linear degrees-per-pixel model CameraSkyProjector uses to *draw*
  /// an overlay (see camera_sky_projector.dart), so a still photo can be
  /// annotated after the fact with the same math a live AR device uses in
  /// real time — one correspondence is enough to solve for the two unknowns
  /// (heading, pitch), which is why only the single brightest pair is used
  /// here rather than all three.
  ///
  /// Ignores camera roll, the same simplification the rest of this pipeline
  /// already makes (matchPattern's own `rotationDeg` is hardcoded to 0.0,
  /// "not computed by this simplified pipeline").
  static ({double headingDeg, double pitchDeg}) _recoverCameraPointing({
    required DetectedStar detectedStar,
    required ObservedStar predictedStar,
    required double fovDeg,
    required int imageWidthPx,
    required int imageHeightPx,
  }) {
    final degPerPixel = fovDeg / imageWidthPx;
    final az = predictedStar.position.azimuthDeg;
    final alt = predictedStar.position.altitudeDeg;

    final heading = az - (detectedStar.x - imageWidthPx / 2) / degPerPixel;
    final pitch = alt - (imageHeightPx / 2 - detectedStar.y) / degPerPixel;

    return (headingDeg: (heading + 360) % 360, pitchDeg: pitch);
  }
}

class DetectedStar {
  final double x;
  final double y;
  final double brightness; // 0-255 luminance at peak
  final int pixelArea;

  const DetectedStar({
    required this.x,
    required this.y,
    required this.brightness,
    required this.pixelArea,
  });
}

class PhotoMatchResult {
  final int starsDetected;
  final int starsMatched;
  final double confidence; // 0.0-1.0
  final double rotationDeg;
  final double shiftXPx;
  final double shiftYPx;
  final String result; // confirmed, unclear, failed

  // Recovered camera pointing direction (see _recoverCameraPointing), only
  // non-null when result == 'confirmed'. This is what lets a non-AR device
  // draw a static overlay after capture, and what Sky Chart later needs to
  // redraw the same overlay on top of the saved photo.
  final double? recoveredHeadingDeg;
  final double? recoveredPitchDeg;

  const PhotoMatchResult({
    required this.starsDetected,
    required this.starsMatched,
    required this.confidence,
    required this.rotationDeg,
    required this.shiftXPx,
    required this.shiftYPx,
    required this.result,
    this.recoveredHeadingDeg,
    this.recoveredPitchDeg,
  });
}
