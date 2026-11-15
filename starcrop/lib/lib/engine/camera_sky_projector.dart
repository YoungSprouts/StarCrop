import 'astro_engine.dart' show AltAz;

/// A projected screen-space point. Kept as a plain x/y pair rather than
/// dart:ui's Offset, so this file has no Flutter dependency and can run
/// under plain `dart test` — same reasoning as sky_models.dart's split from
/// sky_repository.dart.
class ScreenPoint {
  final double x;
  final double y;
  const ScreenPoint(this.x, this.y);

  @override
  String toString() => 'ScreenPoint(${x.toStringAsFixed(1)}, ${y.toStringAsFixed(1)})';
}

/// Projects a predicted sky position (alt/az, from AstroEngine) onto
/// camera-preview screen coordinates, given where the camera is currently
/// pointed and its field of view. Shared by both overlay modes from
/// DevSetupVer7's plan:
///   - live AR (camera_check_screen): called every sensor update, with
///     [deviceHeadingDeg]/[devicePitchDeg] coming from the live compass +
///     fused device attitude.
///   - static fallback: called once, after capture, using the *matched*
///     heading/pitch recovered from PhotoMatchResult (rotation/shift)
///     rather than a live sensor feed.
///
/// Uses the same simplified "linear degrees-per-pixel" model already
/// accepted in photo_matching_engine.dart's `_pixelDistanceToDegrees`,
/// rather than a true tangent/pinhole projection — this keeps both overlay
/// math and the star-matching math on the same accuracy footing, and the
/// distortion is negligible within a typical phone's ~60-70deg FOV. Not
/// survey-grade, matches this app's existing "good enough for farmer-facing
/// guidance" bar (see astro_engine.dart's own doc comment).
///
/// NOTE: [deviceHeadingDeg]/[devicePitchDeg] here are assumed to already be
/// "the direction the camera lens is pointing" in the same convention as
/// AstroEngine's azimuth/altitude (0=N clockwise, 0=horizon/+90=straight
/// up). Turning raw compass + accelerometer readings into that resolved
/// pointing direction is sensor-fusion work that belongs to whichever
/// screen owns the live sensor stream, not to this pure projector.
class CameraSkyProjector {
  CameraSkyProjector._();

  /// Projects [target] onto a [screenWidth] x [screenHeight] canvas, given
  /// the camera is currently pointed at azimuth [deviceHeadingDeg] and
  /// pitch [devicePitchDeg] (0 = level with the horizon, positive = tilted
  /// up), with horizontal field of view [fovDeg]. Returns null if the
  /// target is below the horizon or falls outside the current frame, so
  /// callers can simply skip drawing it.
  static ScreenPoint? project({
    required AltAz target,
    required double deviceHeadingDeg,
    required double devicePitchDeg,
    required double fovDeg,
    required double screenWidth,
    required double screenHeight,
  }) {
    if (target.altitudeDeg < 0) return null; // never visible, below horizon
    if (screenWidth <= 0 || screenHeight <= 0 || fovDeg <= 0) return null;

    final degPerPixel = fovDeg / screenWidth;
    // Vertical FOV in degrees covered by the *screen's* vertical extent,
    // at the same degrees-per-pixel rate as the horizontal axis (so a
    // star's on-screen position is undistorted). A portrait phone screen
    // is taller than it is wide (screenHeight > screenWidth), so this must
    // come out *larger* than fovDeg, not smaller -- multiplying by
    // height/width does that; the previous width/height version inverted
    // the ratio and made the vertical frustum roughly 3x too narrow. That
    // silently dropped one endpoint of most constellation lines (whichever
    // star had any vertical offset from screen center), which is why the
    // AR/static overlay was rendering as a scatter of lone yellow dots
    // instead of connected constellation lines.
    final verticalFovDeg = fovDeg * screenHeight / screenWidth;

    final deltaAz = _wrapDeg(target.azimuthDeg - deviceHeadingDeg);
    final deltaAlt = target.altitudeDeg - devicePitchDeg;

    if (deltaAz.abs() > fovDeg / 2) return null;
    if (deltaAlt.abs() > verticalFovDeg / 2) return null;

    // +x = further clockwise (right) of where the camera points; -y = above
    // the pointing direction, since screen y grows downward.
    final x = screenWidth / 2 + deltaAz * degPerPixel;
    final y = screenHeight / 2 - deltaAlt * degPerPixel;
    return ScreenPoint(x, y);
  }

  /// Wraps a degree difference into (-180, 180], so a heading near the
  /// 0/360 seam (e.g. heading=350, target az=10) doesn't produce a huge
  /// spurious delta.
  static double _wrapDeg(double deg) {
    double d = deg % 360;
    if (d > 180) d -= 360;
    if (d < -180) d += 360;
    return d;
  }
}
