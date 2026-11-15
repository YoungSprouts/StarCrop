import 'package:drift/drift.dart';

import '../data/reference/reference_db.dart';
import '../engine/astro_engine.dart';
import 'sky_models.dart';

/// Bridges ReferenceDb (static star/constellation data) with AstroEngine
/// (pure math) to answer "what's in the sky right now from here" — this is
/// what makes location-based prediction work even when cloudy/daytime,
/// since it's geometry, not observation.
///
/// ObservedStar / ObservedConstellation / ObservedLine live in sky_models.dart
/// (not here) so that dependency-free consumers like PhotoMatchingEngine can
/// use the same types without pulling in ReferenceDb / path_provider / the
/// full Flutter framework. This file only adds the DB-backed methods that
/// produce those models.
class SkyRepository {
  final ReferenceDb db;
  SkyRepository(this.db);

  Future<List<ObservedStar>> starsAbove({
    required double latDeg,
    required double lonDeg,
    required DateTime utc,
    double minAltitudeDeg = 0.0,
    double? maxMagnitude, // filter dim stars if desired
  }) async {
    final query = db.select(db.stars);
    if (maxMagnitude != null) {
      query.where((t) => t.magnitude.isSmallerOrEqualValue(maxMagnitude));
    }
    final rows = await query.get();

    final result = <ObservedStar>[];
    for (final star in rows) {
      final pos = AstroEngine.equatorialToHorizontal(
        raDeg: star.raDeg,
        decDeg: star.decDeg,
        latDeg: latDeg,
        lonDeg: lonDeg,
        utc: utc,
      );
      if (AstroEngine.isVisible(pos.altitudeDeg, minAltitudeDeg: minAltitudeDeg)) {
        result.add(ObservedStar(
          hipId: star.hipId,
          properName: star.properName,
          magnitude: star.magnitude,
          position: pos,
        ));
      }
    }
    result.sort((a, b) => a.magnitude.compareTo(b.magnitude)); // brightest first
    return result;
  }

  Future<List<ObservedConstellation>> constellationsAbove({
    required double latDeg,
    required double lonDeg,
    required DateTime utc,
    double minAltitudeDeg = 0.0,
  }) async {
    final rows = await db.select(db.constellations).get();
    final result = <ObservedConstellation>[];

    for (final c in rows) {
      if (c.centerRa == null || c.centerDec == null) continue;
      final pos = AstroEngine.equatorialToHorizontal(
        raDeg: c.centerRa!,
        decDeg: c.centerDec!,
        latDeg: latDeg,
        lonDeg: lonDeg,
        utc: utc,
      );
      result.add(ObservedConstellation(
        code: c.code,
        latinName: c.latinName,
        centerPosition: pos,
        visible: AstroEngine.isVisible(pos.altitudeDeg, minAltitudeDeg: minAltitudeDeg),
      ));
    }
    return result;
  }

  /// Map of constCode -> visible bool, shaped for RuleEngine.SkyState.
  Future<Map<String, bool>> constellationVisibilityMap({
    required double latDeg,
    required double lonDeg,
    required DateTime utc,
    double minAltitudeDeg = 0.0,
  }) async {
    final list = await constellationsAbove(
      latDeg: latDeg,
      lonDeg: lonDeg,
      utc: utc,
      minAltitudeDeg: minAltitudeDeg,
    );
    return {for (final c in list) c.code: c.visible};
  }

  /// Latin name for a single constellation by IAU code, with no lat/lon/time
  /// context needed — unlike the position-computing methods above, this is
  /// a plain lookup. Used to turn a static reference (e.g. a
  /// SeasonalClimateNormals row's optional skyTriggerId — see
  /// GuidanceRepository.seasonalOutlookAnchorLabel) into a human-readable
  /// label like "Orion", without needing an observer position. Returns null
  /// if the code isn't seeded.
  Future<String?> constellationLatinName(String constCode) async {
    final row = await (db.select(db.constellations)
          ..where((t) => t.code.equals(constCode)))
        .getSingleOrNull();
    return row?.latinName;
  }

  /// Scans backward day-by-day to find the most recent date a constellation's
  /// center first became visible before dawn (a simple heliacal-rise proxy —
  /// not Meeus-precise heliacal rise, but adequate resolution for monthly-
  /// scale farming triggers). Returns null if not found within lookbackDays.
  Future<DateTime?> approximateHeliacalRise({
    required String constCode,
    required double latDeg,
    required double lonDeg,
    required DateTime nowUtc,
    int lookbackDays = 400,
  }) async {
    final row = await (db.select(db.constellations)
          ..where((t) => t.code.equals(constCode)))
        .getSingleOrNull();
    if (row == null || row.centerRa == null || row.centerDec == null) return null;

    // Check pre-dawn (e.g. 05:00 local-ish -> approximate using UTC offset-free
    // check at a fixed "dawn" hour; caller can refine with real timezone later).
    bool visibleAtDawn(DateTime day) {
      final dawn = DateTime.utc(day.year, day.month, day.day, 22); // ~pre-dawn UTC proxy
      final pos = AstroEngine.equatorialToHorizontal(
        raDeg: row.centerRa!,
        decDeg: row.centerDec!,
        latDeg: latDeg,
        lonDeg: lonDeg,
        utc: dawn,
      );
      return AstroEngine.isVisible(pos.altitudeDeg, minAltitudeDeg: 5.0);
    }

    DateTime day = nowUtc;
    bool prevVisible = visibleAtDawn(day);
    for (int i = 1; i <= lookbackDays; i++) {
      day = nowUtc.subtract(Duration(days: i));
      final visible = visibleAtDawn(day);
      if (visible && !prevVisible) {
        return day; // transition: not visible -> visible, going backward = rise date
      }
      prevVisible = visible;
    }
    return null;
  }

  /// Mirror of [approximateHeliacalRise] for the dusk side: scans backward
  /// day-by-day to find the most recent date a constellation's center was
  /// still visible just after sunset, right before it stopped being an
  /// evening-sky object (heliacal-set proxy, same accuracy caveat as the
  /// rise method — a farming-calendar-scale approximation, not Meeus-precise).
  Future<DateTime?> approximateLastSet({
    required String constCode,
    required double latDeg,
    required double lonDeg,
    required DateTime nowUtc,
    int lookbackDays = 400,
  }) async {
    final row = await (db.select(db.constellations)
          ..where((t) => t.code.equals(constCode)))
        .getSingleOrNull();
    if (row == null || row.centerRa == null || row.centerDec == null) return null;

    bool visibleAtDusk(DateTime day) {
      final dusk = DateTime.utc(day.year, day.month, day.day, 10); // ~dusk UTC proxy
      final pos = AstroEngine.equatorialToHorizontal(
        raDeg: row.centerRa!,
        decDeg: row.centerDec!,
        latDeg: latDeg,
        lonDeg: lonDeg,
        utc: dusk,
      );
      return AstroEngine.isVisible(pos.altitudeDeg, minAltitudeDeg: 5.0);
    }

    DateTime day2 = nowUtc;
    bool prevVisible = visibleAtDusk(day2);
    for (int i = 1; i <= lookbackDays; i++) {
      day2 = nowUtc.subtract(Duration(days: i));
      final visible = visibleAtDusk(day2);
      if (!visible && prevVisible) {
        return day2; // transition: visible -> not visible, going backward = the last day it was still up
      }
      prevVisible = visible;
    }
    return null;
  }

  /// One line segment of a constellation figure, with both endpoint stars'
  /// live positions — this is what the Sky Chart screen renders.
  Future<List<ObservedLine>> constellationLinesAbove({
    required double latDeg,
    required double lonDeg,
    required DateTime utc,
  }) async {
    final starA = db.alias(db.stars, 'star_a');
    final starB = db.alias(db.stars, 'star_b');

    final query = db.select(db.constellationLines).join([
      innerJoin(starA, starA.hipId.equalsExp(db.constellationLines.starA)),
      innerJoin(starB, starB.hipId.equalsExp(db.constellationLines.starB)),
    ]);

    final rows = await query.get();
    final result = <ObservedLine>[];

    for (final row in rows) {
      final line = row.readTable(db.constellationLines);
      final a = row.readTableOrNull(starA);
      final b = row.readTableOrNull(starB);
      if (a == null || b == null) continue;

      final posA = AstroEngine.equatorialToHorizontal(
        raDeg: a.raDeg, decDeg: a.decDeg, latDeg: latDeg, lonDeg: lonDeg, utc: utc,
      );
      final posB = AstroEngine.equatorialToHorizontal(
        raDeg: b.raDeg, decDeg: b.decDeg, latDeg: latDeg, lonDeg: lonDeg, utc: utc,
      );

      result.add(ObservedLine(
        constCode: line.constCode,
        pointA: posA,
        pointB: posB,
      ));
    }
    return result;
  }

  /// Given a pointing direction (heading/pitch — same alt/az convention as
  /// the rest of this class), finds whichever currently-visible
  /// constellation's center is angularly closest to it.
  ///
  /// This exists because PhotoMatchingEngine.matchPattern compares the 3
  /// brightest *overall* visible stars against the 3 brightest detected
  /// blobs — a triangle that can span more than one constellation depending
  /// on what's above the horizon (in the seeded content, Orion's Rigel and
  /// Betelgeuse are both brighter than Taurus's Aldebaran, so the top-3
  /// triangle isn't guaranteed to belong to a single named constellation).
  /// Once a match is confirmed, this instead asks "given where the camera
  /// was actually pointing, which constellation is roughly centered in the
  /// frame" — a separate, more reliable question.
  ///
  /// Returns null if nothing visible is within [maxSeparationDeg] of the
  /// pointing direction, rather than guessing at a best-effort answer that
  /// might be a completely different part of the sky.
  Future<String?> nearestConstellationCode({
    required double latDeg,
    required double lonDeg,
    required DateTime utc,
    required double headingDeg,
    required double pitchDeg,
    double maxSeparationDeg = 35,
  }) async {
    final constellations = await constellationsAbove(
      latDeg: latDeg,
      lonDeg: lonDeg,
      utc: utc,
      minAltitudeDeg: 0.0,
    );

    final pointing = AltAz(altitudeDeg: pitchDeg, azimuthDeg: headingDeg);
    String? bestCode;
    double bestSeparationDeg = double.infinity;

    for (final c in constellations) {
      if (!c.visible) continue;
      final separation = AstroEngine.angularSeparationDeg(pointing, c.centerPosition);
      if (separation < bestSeparationDeg) {
        bestSeparationDeg = separation;
        bestCode = c.code;
      }
    }

    if (bestCode == null || bestSeparationDeg > maxSeparationDeg) return null;
    return bestCode;
  }
}
