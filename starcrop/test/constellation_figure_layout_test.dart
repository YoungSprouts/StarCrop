import 'package:starcrop/engine/astro_engine.dart';
import 'package:starcrop/engine/constellation_figure_layout.dart';
import 'package:starcrop/repository/sky_models.dart';
import 'package:test/test.dart';

void main() {
  ObservedLine line(double altA, double azA, double altB, double azB) =>
      ObservedLine(
        constCode: 'TST',
        pointA: AltAz(altitudeDeg: altA, azimuthDeg: azA),
        pointB: AltAz(altitudeDeg: altB, azimuthDeg: azB),
      );

  group('ConstellationFigureLayout.fromLines', () {
    test('empty input gives an empty figure', () {
      expect(ConstellationFigureLayout.fromLines([]).isEmpty, isTrue);
    });

    test('longer side spans exactly 1 and the figure is centered', () {
      final fig = ConstellationFigureLayout.fromLines([
        line(40, 80, 50, 100),
        line(50, 100, 45, 110),
      ]);
      final xs = fig.stars.map((s) => s.x);
      final ys = fig.stars.map((s) => s.y);
      final minX = xs.reduce((a, b) => a < b ? a : b);
      final maxX = xs.reduce((a, b) => a > b ? a : b);
      final minY = ys.reduce((a, b) => a < b ? a : b);
      final maxY = ys.reduce((a, b) => a > b ? a : b);
      final longest = (maxX - minX) > (maxY - minY) ? (maxX - minX) : (maxY - minY);
      expect(longest, closeTo(1.0, 1e-9));
      expect((minX + maxX) / 2, closeTo(0, 1e-9));
      expect((minY + maxY) / 2, closeTo(0, 1e-9));
    });

    test('higher altitude lands higher on screen (smaller y)', () {
      final fig = ConstellationFigureLayout.fromLines([line(30, 90, 50, 90)]);
      final low = fig.segments.single.a; // alt 30
      final high = fig.segments.single.b; // alt 50
      expect(high.y, lessThan(low.y));
    });

    test('higher azimuth lands further right (larger x)', () {
      final fig = ConstellationFigureLayout.fromLines([line(40, 80, 40, 100)]);
      final left = fig.segments.single.a; // az 80
      final right = fig.segments.single.b; // az 100
      expect(right.x, greaterThan(left.x));
    });

    test('works across the 0/360 azimuth seam', () {
      final fig = ConstellationFigureLayout.fromLines([line(40, 350, 40, 10)]);
      final a = fig.segments.single.a; // az 350
      final b = fig.segments.single.b; // az 10
      expect(b.x, greaterThan(a.x));
    });

    test('a star shared by two lines appears only once in stars', () {
      final fig = ConstellationFigureLayout.fromLines([
        line(40, 80, 50, 100),
        line(50, 100, 45, 110),
      ]);
      expect(fig.segments.length, 2);
      expect(fig.stars.length, 3);
    });

    test('a single wide line reports an aspect ratio above 1', () {
      final fig = ConstellationFigureLayout.fromLines([
        line(40, 80, 42, 100),
      ]);
      expect(fig.aspectRatio, greaterThan(1));
    });

    test('keeps below-horizon endpoints (shape matters, not visibility)', () {
      final fig = ConstellationFigureLayout.fromLines([line(-5, 90, 10, 95)]);
      expect(fig.isEmpty, isFalse);
      expect(fig.stars.length, 2);
    });

    test('zero-extent input (both endpoints identical) gives an empty figure', () {
      final fig = ConstellationFigureLayout.fromLines([line(40, 90, 40, 90)]);
      expect(fig.isEmpty, isTrue);
    });
  });
}
