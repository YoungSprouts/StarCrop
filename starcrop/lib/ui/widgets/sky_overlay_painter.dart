import 'package:flutter/material.dart';

import '../../engine/camera_sky_projector.dart';
import '../../repository/sky_models.dart';
import '../theme/app_theme.dart';

/// Draws predicted constellation lines projected onto a camera-relative (or
/// photo-relative) view, given a pointing direction (heading/pitch) and
/// field of view — via CameraSkyProjector's projection math.
///
/// Shared between two callers that both need this exact rendering:
/// - camera_check_screen.dart: live, on top of CameraPreview, updated every
///   time a new sensor reading arrives (real-time AR).
/// - constellation_detail_screen.dart: static, on top of a saved photo,
///   drawn once using the heading/pitch that was recorded at capture time
///   (see PhotoResults.recoveredHeadingDeg/recoveredPitchDeg).
///
/// Previously this was a private class duplicated inside
/// camera_check_screen.dart (`_ArOverlayPainter`) — pulled out here so the
/// two use sites can't drift apart.
class SkyOverlayPainter extends CustomPainter {
  final List<ObservedLine> lines;
  final double headingDeg;
  final double pitchDeg;
  final double fovDeg;

  SkyOverlayPainter({
    required this.lines,
    required this.headingDeg,
    required this.pitchDeg,
    required this.fovDeg,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = AppColors.arLineGreen.withValues(alpha: 0.9)
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    final starPaint = Paint()..color = AppColors.arStarYellow.withValues(alpha: 0.95);
    const starRadius = 4.5;

    for (final line in lines) {
      final a = CameraSkyProjector.project(
        target: line.pointA,
        deviceHeadingDeg: headingDeg,
        devicePitchDeg: pitchDeg,
        fovDeg: fovDeg,
        screenWidth: size.width,
        screenHeight: size.height,
      );
      final b = CameraSkyProjector.project(
        target: line.pointB,
        deviceHeadingDeg: headingDeg,
        devicePitchDeg: pitchDeg,
        fovDeg: fovDeg,
        screenWidth: size.width,
        screenHeight: size.height,
      );

      // The connecting line only makes sense when both of its stars are
      // currently in frame.
      if (a != null && b != null) {
        canvas.drawLine(Offset(a.x, a.y), Offset(b.x, b.y), linePaint);
      }

      // Each star's own dot is drawn whenever *that star* projects into
      // frame, regardless of whether the other end of this particular line
      // segment does too -- a star is often shared by more than one line
      // segment (e.g. Orion's belt stars each connect to a neighbor on
      // both sides), so it can still be genuinely on screen even while one
      // particular neighbor isn't.
      if (a != null) canvas.drawCircle(Offset(a.x, a.y), starRadius, starPaint);
      if (b != null) canvas.drawCircle(Offset(b.x, b.y), starRadius, starPaint);
    }
  }

  @override
  bool shouldRepaint(covariant SkyOverlayPainter oldDelegate) {
    return oldDelegate.headingDeg != headingDeg ||
        oldDelegate.pitchDeg != pitchDeg ||
        oldDelegate.lines != lines;
  }
}
