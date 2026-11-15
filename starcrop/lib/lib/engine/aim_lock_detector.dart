import 'astro_engine.dart';
import '../repository/sky_models.dart';

/// Decides whether the device is currently "aimed at" a specific visible
/// constellation closely enough for the Camera Check reticle to lock onto
/// it and reveal that constellation's lines + name.
///
/// Kept separate from the two other sky/pointing questions this app
/// already answers, since each has a different tolerance and purpose:
///   - SkyPositionConfirmation.confirmationFor: "are enough predicted stars
///     somewhere in frame at all" (confirming a captured photo).
///   - SkyRepository.nearestConstellationCode: "which constellation is
///     roughly in this direction" (identifying a captured photo, 35deg
///     default tolerance).
///   - This class: "is the reticle centered tightly enough on one specific
///     constellation right now to reveal it" — a live, continuous aiming
///     question, answered every sensor sample, so its tolerance is much
///     tighter than the other two.
class AimLockDetector {
  AimLockDetector._();

  /// Degrees of separation from a constellation's center still counted as
  /// "aimed at it" for the reticle-lock UI. Tighter than
  /// SkyRepository.nearestConstellationCode's 35deg default: a solid green
  /// lock should mean the constellation's own bright stars are genuinely
  /// centered in frame, not merely somewhere in the same rough direction.
  static const lockToleranceDeg = 10.0;

  /// Returns the code of whichever currently-visible constellation's center
  /// is within [lockToleranceDeg] of the device's pointing direction, or
  /// null if nothing is that close right now.
  static String? lockedConstellationCode({
    required List<ObservedConstellation> visible,
    required double headingDeg,
    required double pitchDeg,
  }) {
    final pointing = AltAz(altitudeDeg: pitchDeg, azimuthDeg: headingDeg);
    String? bestCode;
    double bestSeparationDeg = double.infinity;

    for (final c in visible) {
      if (!c.visible) continue;
      final separation = AstroEngine.angularSeparationDeg(pointing, c.centerPosition);
      if (separation < bestSeparationDeg) {
        bestSeparationDeg = separation;
        bestCode = c.code;
      }
    }

    if (bestCode == null || bestSeparationDeg > lockToleranceDeg) return null;
    return bestCode;
  }
}
