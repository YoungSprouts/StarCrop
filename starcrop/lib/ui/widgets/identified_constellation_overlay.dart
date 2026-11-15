import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../engine/constellation_figure_layout.dart';
import '../theme/app_theme.dart';

/// Draws an already-identified constellation as a self-contained figure —
/// no camera FOV, heading, or pitch involved. The constellation's name and
/// shape are known, so it is simply fitted into the middle of the canvas.
///
/// [progress] runs 0.0 -> 1.0:
///   0.00 - 0.70  the star dots spread from the canvas center (where the
///                aiming reticle sits) out to their places in the figure
///   0.55 - 1.00  the connecting lines draw in from each star
///   0.75 - 1.00  the name (if [name] is given) fades in below the figure
///
/// Pass progress 1.0 for the finished static figure (e.g. on a saved photo).
class IdentifiedConstellationPainter extends CustomPainter {
  final ConstellationFigure figure;
  final double progress;
  final String? name;

  /// Fraction of the canvas' shorter side the figure's longer side spans.
  final double figureScale;

  IdentifiedConstellationPainter({
    required this.figure,
    required this.progress,
    this.name,
    this.figureScale = 0.62,
  });

  static double _clamp01(double v) => v.clamp(0.0, 1.0).toDouble();

  @override
  void paint(Canvas canvas, Size size) {
    if (figure.isEmpty || size.isEmpty) return;

    final center = Offset(size.width / 2, size.height / 2);
    final box = size.shortestSide * figureScale;

    Offset target(FigurePoint p) => center + Offset(p.x * box, p.y * box);

    // --- Phase 1: dots spread from the center to their positions.
    final spread = Curves.easeOutCubic.transform(_clamp01(progress / 0.7));
    Offset dotAt(FigurePoint p) => Offset.lerp(center, target(p), spread)!;

    // --- Phase 2: lines draw in from their first star toward the second.
    final lineT = Curves.easeInOut.transform(_clamp01((progress - 0.55) / 0.45));

    if (lineT > 0) {
      final linePaint = Paint()
        ..color = AppColors.arLineGreen.withValues(alpha: 0.9)
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round;
      for (final s in figure.segments) {
        final a = target(s.a);
        final b = target(s.b);
        canvas.drawLine(a, Offset.lerp(a, b, lineT)!, linePaint);
      }
    }

    final glowPaint = Paint()
      ..color = AppColors.arStarYellow.withValues(alpha: 0.25 * spread);
    final starPaint = Paint()
      ..color = AppColors.arStarYellow.withValues(alpha: 0.95);
    for (final s in figure.stars) {
      final p = dotAt(s);
      canvas.drawCircle(p, 9, glowPaint);
      canvas.drawCircle(p, 4.5, starPaint);
    }

    // --- Phase 3: name label under the figure.
    final label = name;
    final nameOpacity = _clamp01((progress - 0.75) / 0.25);
    if (label != null && label.isNotEmpty && nameOpacity > 0) {
      final tp = TextPainter(
        text: TextSpan(
          text: label.toUpperCase(),
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
            color: AppColors.gold.withValues(alpha: nameOpacity),
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      // Below the figure, but never pushed off the bottom of the canvas.
      final figureBottom = center.dy + (box * 0.5) + 24;
      final y = math.min(figureBottom, size.height - tp.height - 16);
      final origin = Offset(center.dx - tp.width / 2, y);

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          (origin & tp.size).inflate(8),
          const Radius.circular(14),
        ),
        Paint()..color = Colors.black.withValues(alpha: 0.55 * nameOpacity),
      );
      tp.paint(canvas, origin);
    }
  }

  @override
  bool shouldRepaint(covariant IdentifiedConstellationPainter old) =>
      old.progress != progress ||
      old.figure != figure ||
      old.name != name ||
      old.figureScale != figureScale;
}

/// Plays the spread-out animation once when it first appears, then holds the
/// finished figure. Give it a `ValueKey(constCode)` where it is used so a
/// different constellation restarts the animation instead of reusing it.
///
/// Set [animate] to false for a static figure (progress fixed at 1.0), e.g.
/// on top of a saved photo where the name is already shown elsewhere; leave
/// [name] null there to draw only the constellation.
class IdentifiedConstellationOverlay extends StatelessWidget {
  final ConstellationFigure figure;
  final String? name;
  final bool animate;
  final Duration duration;
  final double figureScale;

  const IdentifiedConstellationOverlay({
    super.key,
    required this.figure,
    this.name,
    this.animate = true,
    this.duration = const Duration(milliseconds: 1400),
    this.figureScale = 0.62,
  });

  @override
  Widget build(BuildContext context) {
    if (!animate) {
      return CustomPaint(
        painter: IdentifiedConstellationPainter(
          figure: figure,
          progress: 1.0,
          name: name,
          figureScale: figureScale,
        ),
        size: Size.infinite,
      );
    }

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: duration,
      builder: (context, t, _) => CustomPaint(
        painter: IdentifiedConstellationPainter(
          figure: figure,
          progress: t,
          name: name,
          figureScale: figureScale,
        ),
        size: Size.infinite,
      ),
    );
  }
}
