import '../../engine/astro_engine.dart';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/user/user_db.dart';
import '../../data/cache/cache_db.dart';
import '../../repository/sky_repository.dart';
import '../../repository/sky_snapshot.dart';
import '../theme/app_theme.dart';
import '../theme/app_assets.dart';
import 'constellation_detail_screen.dart';
import '../../repository/sky_models.dart';
/// "Sky Chart" — live star-field rendered from real alt/az math (SkyRepository),
/// not a static image. Works cloudy/day/night since it's pure geometry.
class SkyChartScreen extends StatefulWidget {
  /// If set (e.g. coming from Camera Check's "Sky confirmed" card), this
  /// constellation starts out selected so its name and "View constellation
  /// details" button are ready. Ignored if it isn't currently above the
  /// horizon, since Sky Chart only lists visible constellations.
  final String? initialConstCode;

  const SkyChartScreen({super.key, this.initialConstCode});

  @override
  State<SkyChartScreen> createState() => _SkyChartScreenState();
}

class _SkyChartScreenState extends State<SkyChartScreen> {
  List<ObservedLine> _lines = [];
  List<ObservedConstellation> _constellations = [];
  ObservedConstellation? _selected;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final userDb = context.read<UserDb>();
    final loc = await userDb.activeLocation();
    if (loc == null) {
      setState(() => _loading = false);
      return;
    }

    final skyRepo = context.read<SkyRepository>();
    final now = DateTime.now().toUtc();

    final lines = await skyRepo.constellationLinesAbove(
      latDeg: loc.lat, lonDeg: loc.lon, utc: now,
    );
    final constellations = await skyRepo.constellationsAbove(
      latDeg: loc.lat, lonDeg: loc.lon, utc: now, minAltitudeDeg: 0,
    );

    // Cache a small summary of what's visible right now so Home can show an
    // instant preview next time it opens, instead of recomputing this same
    // math just to render one line of text (schema.md's SKY_SNAPSHOT table).
    final cacheDb = context.read<CacheDb>();
    await saveSkySnapshot(
      cacheDb: cacheDb,
      constellations: constellations,
      moonPhase: AstroEngine.moonPhase(now),
    );

    if (!mounted) return;
    setState(() {
      _lines = lines.where((l) => l.pointA.altitudeDeg > 0 || l.pointB.altitudeDeg > 0).toList();
      _constellations = constellations.where((c) => c.visible).toList();
      final initial = widget.initialConstCode;
      if (initial != null && _selected == null) {
        final match = _constellations.where((c) => c.code == initial);
        if (match.isNotEmpty) _selected = match.first;
      }
      _loading = false;
    });
  }

  void _selectNear(Offset tapPos, Size canvasSize) {
    ObservedConstellation? closest;
    double closestDist = 40; // tap tolerance in px
    for (final c in _constellations) {
      final p = _project(c.centerPosition, canvasSize);
      if (p == null) continue;
      final d = (p - tapPos).distance;
      if (d < closestDist) {
        closestDist = d;
        closest = c;
      }
    }
    if (closest != null) setState(() => _selected = closest);
  }

  Offset? _project(AltAz pos, Size size) {
    if (pos.altitudeDeg < 0) return null;
    final radius = (90 - pos.altitudeDeg) / 90 * (size.shortestSide / 2);
    final angle = (pos.azimuthDeg - 90) * math.pi / 180; // az 0=N at top
    final center = Offset(size.width / 2, size.height / 2);
    return center + Offset(radius * math.cos(angle), radius * math.sin(angle));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.forestGreen,
      appBar: AppBar(
        title: const Text('Sky Chart'),
        leading: IconButton(
          icon: Image.asset(AppIcons.chevronLeftWhite, width: 18, height: 18),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator(color: AppColors.gold))
                : LayoutBuilder(
                    builder: (context, constraints) {
                      final size = Size(constraints.maxWidth, constraints.maxHeight);
                      return GestureDetector(
                        onTapUp: (details) => _selectNear(details.localPosition, size),
                        child: CustomPaint(
                          size: size,
                          painter: _StarFieldPainter(
                            lines: _lines,
                            constellations: _constellations,
                            selectedCode: _selected?.code,
                          ),
                        ),
                      );
                    },
                  ),
          ),
          _BottomCard(
            selected: _selected,
            onViewDetails: _selected == null
                ? null
                : () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ConstellationDetailScreen(constCode: _selected!.code),
                      ),
                    ),
          ),
        ],
      ),
    );
  }
}

class _StarFieldPainter extends CustomPainter {
  final List<ObservedLine> lines;
  final List<ObservedConstellation> constellations;
  final String? selectedCode;

  _StarFieldPainter({required this.lines, required this.constellations, this.selectedCode});

  Offset? _project(AltAz pos, Size size) {
    if (pos.altitudeDeg < 0) return null;
    final radius = (90 - pos.altitudeDeg) / 90 * (size.shortestSide / 2);
    final angle = (pos.azimuthDeg - 90) * math.pi / 180;
    final center = Offset(size.width / 2, size.height / 2);
    return center + Offset(radius * math.cos(angle), radius * math.sin(angle));
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Night-sky background gradient
    final bgPaint = Paint()
      ..shader = const RadialGradient(
        colors: [Color(0xFF0D1F14), Color(0xFF000000)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    final linePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.5)
      ..strokeWidth = 1;
    final starPaint = Paint()..color = Colors.white;
    final selectedLinePaint = Paint()
      ..color = AppColors.gold.withValues(alpha: 0.9)
      ..strokeWidth = 1.5;

    for (final line in lines) {
      final a = _project(line.pointA, size);
      final b = _project(line.pointB, size);
      if (a == null || b == null) continue;
      final isSelected = line.constCode == selectedCode;
      canvas.drawLine(a, b, isSelected ? selectedLinePaint : linePaint);
      canvas.drawCircle(a, isSelected ? 3 : 2, starPaint);
      canvas.drawCircle(b, isSelected ? 3 : 2, starPaint);
    }

    // Greedy label placement: each label is tried at a handful of anchor
    // offsets around its star point, in order, and the first one that
    // doesn't intersect an already-placed label wins. Cheap and only
    // approximate, but this app only ever has a handful of constellations
    // visible at once, so a full layout-solver would be overkill — this is
    // what actually fixes labels landing on top of each other when two
    // constellation centers happen to project close together.
    final placedLabelRects = <Rect>[];

    for (final c in constellations) {
      final p = _project(c.centerPosition, size);
      if (p == null) continue;
      final isSelected = c.code == selectedCode;

      // Always yellow/gold — selection is now shown via size/weight/backing
      // highlight instead of a color swap, so the name itself reads the
      // same color whether selected or not.
      final textPainter = TextPainter(
        text: TextSpan(
          text: c.latinName,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: isSelected ? 14 : 13,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            color: AppColors.gold,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      const candidateOffsets = [
        Offset(8, -8), // default: upper-right of the star
        Offset(8, 10), // lower-right
        Offset(-8, -8), // upper-left
        Offset(-8, 10), // lower-left
        Offset(8, -26), // further up
        Offset(8, 26), // further down
      ];

      Rect chosenRect = (p + candidateOffsets.first) & textPainter.size;
      Offset chosenOrigin = p + candidateOffsets.first;
      var placed = false;

      for (final candidate in candidateOffsets) {
        var origin = p + candidate;
        // A "left" candidate needs the label's own width subtracted so it
        // actually lands to the left of the point, not just less-far-right.
        if (candidate.dx < 0) {
          origin = Offset(origin.dx - textPainter.width, origin.dy);
        }
        final rect = origin & textPainter.size;
        if (!placed) {
          // Keep the very first candidate as the fallback, in case every
          // option below still overlaps something.
          chosenRect = rect;
          chosenOrigin = origin;
        }
        if (!placedLabelRects.any((r) => r.overlaps(rect))) {
          chosenRect = rect;
          chosenOrigin = origin;
          placed = true;
          break;
        }
      }

      placedLabelRects.add(chosenRect);

      // Translucent backing so the label stays legible over bright lines or
      // another label it still had to sit close to; selected gets a
      // gold-tinted highlight instead of plain dark backing.
      canvas.drawRRect(
        RRect.fromRectAndRadius(chosenRect.inflate(3), const Radius.circular(4)),
        Paint()
          ..color = isSelected
              ? AppColors.gold.withValues(alpha: 0.22)
              : Colors.black.withValues(alpha: 0.35),
      );

      textPainter.paint(canvas, chosenOrigin);
    }
  }

  @override
  bool shouldRepaint(covariant _StarFieldPainter oldDelegate) {
    return oldDelegate.lines != lines || oldDelegate.selectedCode != selectedCode;
  }
}

class _BottomCard extends StatelessWidget {
  final ObservedConstellation? selected;
  final VoidCallback? onViewDetails;
  const _BottomCard({required this.selected, required this.onViewDetails});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
      decoration: const BoxDecoration(
        color: AppColors.forestGreen,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            selected?.latinName ?? 'Tap a constellation',
            style: const TextStyle(
              color: AppColors.gold,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            selected == null
                ? 'Select a labeled constellation above to see details.'
                : 'Visible now from your location.',
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onViewDetails,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withValues(alpha: 0.12),
                foregroundColor: Colors.white,
              ),
              child: const Text('View constellation details'),
            ),
          ),
        ],
      ),
    );
  }
}
