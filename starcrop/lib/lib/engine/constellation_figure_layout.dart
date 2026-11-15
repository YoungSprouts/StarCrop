import 'dart:math' as math;

import '../repository/sky_models.dart';

/// A point in the figure's own unit box. x grows right, y grows DOWN (screen
/// convention). The figure's longer side spans exactly 1.0, centered on
/// (0, 0), so coordinates land in roughly [-0.5, 0.5].
class FigurePoint {
  final double x;
  final double y;
  const FigurePoint(this.x, this.y);

  @override
  String toString() => 'FigurePoint(${x.toStringAsFixed(3)}, ${y.toStringAsFixed(3)})';
}

class FigureSegment {
  final FigurePoint a;
  final FigurePoint b;
  const FigureSegment(this.a, this.b);
}

/// A constellation's shape, independent of any camera field of view.
///
/// Once a constellation is identified (aim lock, or a saved photo's matched
/// constellation code), its name and shape are already known, so there is no
/// need to project each star against the camera's FOV. Instead the figure is
/// laid out around its own center and scaled to whatever size the UI wants
/// to draw it at. Orientation stays sky-true (up = toward zenith, right =
/// increasing azimuth), so it still looks like the real thing.
class ConstellationFigure {
  /// Unique star points (a star shared by several lines appears once), so a
  /// painter can animate each dot exactly once.
  final List<FigurePoint> stars;
  final List<FigureSegment> segments;

  /// Width / height of the figure's bounding box before it was fitted into
  /// the unit box. Lets callers size a drawing area with the right shape.
  final double aspectRatio;

  const ConstellationFigure({
    required this.stars,
    required this.segments,
    required this.aspectRatio,
  });

  static const empty =
      ConstellationFigure(stars: [], segments: [], aspectRatio: 1.0);

  bool get isEmpty => segments.isEmpty;
}

class ConstellationFigureLayout {
  ConstellationFigureLayout._();

  /// Builds a [ConstellationFigure] from one constellation's lines.
  ///
  /// [lines] should all belong to the same constellation (filter by
  /// constCode before calling). Endpoints below the horizon are kept: the
  /// figure is about the shape, not about what is currently visible.
  static ConstellationFigure fromLines(List<ObservedLine> lines) {
    if (lines.isEmpty) return ConstellationFigure.empty;

    // 1. Unit vectors (east, north, up) for every endpoint.
    final vecs = <_V3>[];
    for (final l in lines) {
      vecs.add(_toVector(l.pointA.altitudeDeg, l.pointA.azimuthDeg));
      vecs.add(_toVector(l.pointB.altitudeDeg, l.pointB.azimuthDeg));
    }

    // 2. Center direction = normalized mean of all endpoints.
    var sum = const _V3(0, 0, 0);
    for (final v in vecs) {
      sum = sum + v;
    }
    final sumLen = sum.length;
    if (sumLen < 1e-6) return ConstellationFigure.empty; // spans the whole sky
    final c = sum * (1 / sumLen);

    // 3. Tangent-plane basis at the center: right = direction of increasing
    // azimuth, up = toward zenith (both perpendicular to c).
    final centerAz = math.atan2(c.e, c.n);
    final right = _V3(math.cos(centerAz), -math.sin(centerAz), 0);
    var up = const _V3(0, 0, 1) - c * c.u;
    if (up.length < 1e-6) {
      // Centered on the zenith: fall back to north as "up".
      up = const _V3(0, 1, 0) - c * c.n;
    }
    up = up * (1 / up.length);

    // 4. Gnomonic projection of each endpoint onto that plane.
    final raw = <_P>[];
    for (final v in vecs) {
      final d = v.dot(c);
      if (d <= 0.05) return ConstellationFigure.empty; // too spread out to flatten
      raw.add(_P(v.dot(right) / d, -v.dot(up) / d)); // y flipped for screen
    }

    // 5. Fit into a centered unit box, preserving aspect ratio.
    var minX = double.infinity, maxX = -double.infinity;
    var minY = double.infinity, maxY = -double.infinity;
    for (final p in raw) {
      minX = math.min(minX, p.x);
      maxX = math.max(maxX, p.x);
      minY = math.min(minY, p.y);
      maxY = math.max(maxY, p.y);
    }
    final w = maxX - minX;
    final h = maxY - minY;
    final scale = math.max(w, h);
    if (scale < 1e-9) return ConstellationFigure.empty;
    final cx = (minX + maxX) / 2;
    final cy = (minY + maxY) / 2;

    FigurePoint fit(_P p) => FigurePoint((p.x - cx) / scale, (p.y - cy) / scale);

    // 6. Segments, plus each distinct star once.
    final segments = <FigureSegment>[];
    final stars = <FigurePoint>[];
    final seen = <String>{};

    void addStar(FigurePoint p, String key) {
      if (seen.add(key)) stars.add(p);
    }

    for (var i = 0; i < lines.length; i++) {
      final a = fit(raw[i * 2]);
      final b = fit(raw[i * 2 + 1]);
      segments.add(FigureSegment(a, b));
      addStar(a, _key(lines[i].pointA.altitudeDeg, lines[i].pointA.azimuthDeg));
      addStar(b, _key(lines[i].pointB.altitudeDeg, lines[i].pointB.azimuthDeg));
    }

    return ConstellationFigure(
      stars: stars,
      segments: segments,
      aspectRatio: w / math.max(h, 1e-6),
    );
  }

  static String _key(double altDeg, double azDeg) =>
      '${altDeg.toStringAsFixed(4)}|${azDeg.toStringAsFixed(4)}';

  static _V3 _toVector(double altDeg, double azDeg) {
    final alt = altDeg * math.pi / 180;
    final az = azDeg * math.pi / 180;
    return _V3(
      math.cos(alt) * math.sin(az), // east
      math.cos(alt) * math.cos(az), // north
      math.sin(alt), // up
    );
  }
}

class _P {
  final double x;
  final double y;
  const _P(this.x, this.y);
}

class _V3 {
  final double e;
  final double n;
  final double u;
  const _V3(this.e, this.n, this.u);

  _V3 operator +(_V3 o) => _V3(e + o.e, n + o.n, u + o.u);
  _V3 operator -(_V3 o) => _V3(e - o.e, n - o.n, u - o.u);
  _V3 operator *(double k) => _V3(e * k, n * k, u * k);
  double dot(_V3 o) => e * o.e + n * o.n + u * o.u;
  double get length => math.sqrt(dot(this));
}
