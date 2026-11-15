import 'astro_engine.dart' show AltAz;
import 'camera_sky_projector.dart';
import '../repository/sky_models.dart';

/// Confirms "what's the sky doing right now" purely from where the device
/// is pointed (compass + accelerometer -> DeviceAttitude, fused into a
/// heading/pitch reading) and where AstroEngine/SkyRepository predict
/// bright stars to be — never from analyzing the camera's pixels.
///
/// This replaces PhotoMatchingEngine as the thing camera_check_screen.dart
/// calls to decide whether the farmer's phone is actually pointed at a
/// recognizable patch of sky. Reasoning for the switch:
///
/// PhotoMatchingEngine's pixel-based star detection needs a genuinely dark
/// sky and a camera sensor good enough to resolve faint points a few
/// arcminutes across. In the field, on the budget phones this app's farmer
/// users actually carry, that combination rarely holds — haze, phone
/// camera noise floors, and handheld shake mean real stars are often too
/// dim or too smeared to show up as distinct blobs at all, even on an
/// otherwise clear night. That made "Camera Check" fail constantly for the
/// exact users it's meant to serve.
///
/// The sky's geometry doesn't have that problem: AstroEngine's alt/az math
/// is exact regardless of camera quality, clouds, haze, or moonlight — the
/// only real-world input it needs is "which way is the phone pointing",
/// and that's already resolved from raw accelerometer + magnetometer
/// samples (see DeviceAttitude, and ArCapabilityChecker's floor test for
/// when that pipeline is even usable on a given device). So this class
/// treats "how many predicted bright stars currently project into the
/// camera's field of view, given the phone's actual pointing direction" as
/// the confirmation signal, instead of "how many were detected in the
/// pixels". Fully offline, and unaffected by weather, ambient light, or
/// lens quality — the same accuracy bar astro_engine.dart's own doc
/// comment sets ("good enough for farmer-facing guidance, not
/// survey-grade").
class SkyPositionConfirmation {
  SkyPositionConfirmation._();

  /// Minimum number of predicted bright stars that must currently project
  /// into frame for this to count as a confident fix. Below this, the
  /// pointing reading might still be perfectly valid, but there's too
  /// little sky content in view to call it "confirmed" (e.g. pointed at a
  /// patch of sky with nothing bright in it right now).
  static const minStarsForConfident = 2;

  /// Given the predicted bright stars currently above the horizon (from
  /// SkyRepository.starsAbove) and where the device is pointed, returns
  /// whichever of them fall inside the current camera frame. This is the
  /// same projection SkyOverlayPainter draws with — [confirmationFor] just
  /// scores how many of them landed in frame.
  static List<ObservedStar> starsInFrame({
    required List<ObservedStar> predicted,
    required double headingDeg,
    required double pitchDeg,
    required double fovDeg,
    required double screenWidth,
    required double screenHeight,
  }) {
    return predicted.where((s) {
      final p = CameraSkyProjector.project(
        target: s.position,
        deviceHeadingDeg: headingDeg,
        devicePitchDeg: pitchDeg,
        fovDeg: fovDeg,
        screenWidth: screenWidth,
        screenHeight: screenHeight,
      );
      return p != null;
    }).toList();
  }

  /// Turns a device pointing reading + predicted sky into a
  /// [PositionConfirmationResult] — purely from geometry, no pixels
  /// involved. Pass a stabilized reading (e.g. camera_check_screen's
  /// smoothed live attitude), not a single raw sample, so one noisy tick
  /// doesn't flip the result.
  static PositionConfirmationResult confirmationFor({
    required List<ObservedStar> predicted,
    required double headingDeg,
    required double pitchDeg,
    required double fovDeg,
    required double screenWidth,
    required double screenHeight,
  }) {
    final inFrame = starsInFrame(
      predicted: predicted,
      headingDeg: headingDeg,
      pitchDeg: pitchDeg,
      fovDeg: fovDeg,
      screenWidth: screenWidth,
      screenHeight: screenHeight,
    );

    final confidence =
        (inFrame.length / minStarsForConfident).clamp(0.0, 1.0).toDouble();
    final result = inFrame.length >= minStarsForConfident
        ? 'confirmed'
        : (inFrame.isNotEmpty ? 'unclear' : 'failed');

    return PositionConfirmationResult(
      starsInFrame: inFrame,
      totalPredicted: predicted.length,
      confidence: confidence,
      result: result,
      headingDeg: headingDeg,
      pitchDeg: pitchDeg,
    );
  }
}

class PositionConfirmationResult {
  final List<ObservedStar> starsInFrame;
  final int totalPredicted; // how many bright stars were above the horizon at all
  final double confidence; // 0.0-1.0
  final String result; // confirmed, unclear, failed
  final double headingDeg;
  final double pitchDeg;

  const PositionConfirmationResult({
    required this.starsInFrame,
    required this.totalPredicted,
    required this.confidence,
    required this.result,
    required this.headingDeg,
    required this.pitchDeg,
  });
}
