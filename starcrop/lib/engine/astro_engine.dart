import 'dart:math' as math;

/// Pure astronomy calculations. No I/O, no DB. Formulas from Meeus,
/// Astronomical Algorithms — accuracy sufficient for farmer-facing guidance,
/// not navigation-grade.
class AstroEngine {
  static const double _deg2rad = math.pi / 180.0;
  static const double _rad2deg = 180.0 / math.pi;

  /// Julian Date from a UTC DateTime.
  static double julianDate(DateTime utc) {
    final y = utc.year;
    final m = utc.month;
    final d = utc.day +
        (utc.hour + utc.minute / 60.0 + utc.second / 3600.0) / 24.0;

    int yy = y;
    int mm = m;
    if (mm <= 2) {
      yy -= 1;
      mm += 12;
    }
    final a = (yy / 100).floor();
    final b = 2 - a + (a / 4).floor();

    return (365.25 * (yy + 4716)).floor() +
        (30.6001 * (mm + 1)).floor() +
        d +
        b -
        1524.5;
  }

  /// Greenwich Mean Sidereal Time, in degrees [0, 360).
  static double gmstDegrees(DateTime utc) {
    final jd = julianDate(utc);
    final t = (jd - 2451545.0) / 36525.0;
    double gmst = 280.46061837 +
        360.98564736629 * (jd - 2451545.0) +
        0.000387933 * t * t -
        (t * t * t) / 38710000.0;
    gmst = gmst % 360.0;
    if (gmst < 0) gmst += 360.0;
    return gmst;
  }

  /// Local Sidereal Time in degrees, given observer longitude (east positive).
  static double lstDegrees(DateTime utc, double lonDeg) {
    double lst = gmstDegrees(utc) + lonDeg;
    lst = lst % 360.0;
    if (lst < 0) lst += 360.0;
    return lst;
  }

  /// Converts equatorial (RA/Dec, degrees) + observer (lat/lon, degrees) + time
  /// into horizontal coordinates: altitude and azimuth, both in degrees.
  /// Azimuth measured from North, clockwise (0=N, 90=E, 180=S, 270=W).
  static AltAz equatorialToHorizontal({
    required double raDeg,
    required double decDeg,
    required double latDeg,
    required double lonDeg,
    required DateTime utc,
  }) {
    final lst = lstDegrees(utc, lonDeg);
    final haDeg = (lst - raDeg) % 360.0;
    final ha = ((haDeg + 180) % 360 - 180) * _deg2rad; // normalize to [-180,180]

    final lat = latDeg * _deg2rad;
    final dec = decDeg * _deg2rad;

    final sinAlt = math.sin(dec) * math.sin(lat) +
        math.cos(dec) * math.cos(lat) * math.cos(ha);
    final alt = math.asin(sinAlt.clamp(-1.0, 1.0));

    final cosAz = (math.sin(dec) - math.sin(alt) * math.sin(lat)) /
        (math.cos(alt) * math.cos(lat));
    double az = math.acos(cosAz.clamp(-1.0, 1.0));
    if (math.sin(ha) > 0) az = 2 * math.pi - az;

    return AltAz(altitudeDeg: alt * _rad2deg, azimuthDeg: az * _rad2deg);
  }

  /// Approximate moon phase, 0.0 = new moon, 0.5 = full moon, 1.0 = new again.
  /// Based on a simple synodic-month offset from a known new moon epoch.
  static double moonPhase(DateTime utc) {
    const knownNewMoon = 2451550.1; // JD of a reference new moon (Jan 6 2000)
    const synodicMonth = 29.53058867;
    final jd = julianDate(utc);
    double phase = ((jd - knownNewMoon) % synodicMonth) / synodicMonth;
    if (phase < 0) phase += 1.0;
    return phase;
  }

  /// Human label for a moon phase fraction.
  static String moonPhaseLabel(double phase) {
    if (phase < 0.03 || phase > 0.97) return 'New Moon';
    if (phase < 0.22) return 'Waxing Crescent';
    if (phase < 0.28) return 'First Quarter';
    if (phase < 0.47) return 'Waxing Gibbous';
    if (phase < 0.53) return 'Full Moon';
    if (phase < 0.72) return 'Waning Gibbous';
    if (phase < 0.78) return 'Last Quarter';
    return 'Waning Crescent';
  }

  /// Sun's ecliptic longitude in degrees — used for date_range / season
  /// style sky triggers (season markers, solstice/equinox-relative rules).
  static double sunEclipticLongitude(DateTime utc) {
    final jd = julianDate(utc);
    final d = jd - 2451545.0;
    final g = (357.529 + 0.98560028 * d) % 360.0;
    final gRad = g * _deg2rad;
    double q = (280.459 + 0.98564736 * d) % 360.0;
    double l = q + 1.915 * math.sin(gRad) + 0.020 * math.sin(2 * gRad);
    l = l % 360.0;
    if (l < 0) l += 360.0;
    return l;
  }

  /// Whether a star (given alt) is above the horizon, with an optional
  /// minimum-altitude threshold to account for horizon obstruction/haze.
  static bool isVisible(double altitudeDeg, {double minAltitudeDeg = 0.0}) {
    return altitudeDeg >= minAltitudeDeg;
  }

  /// Angular separation (degrees) between two alt/az sky positions, via the
  /// spherical law of cosines on the unit sphere. Public (unlike
  /// PhotoMatchingEngine's private copy of the same formula) so other
  /// consumers — e.g. SkyRepository.nearestConstellationCode, which needs to
  /// compare a camera's pointing direction against constellation centers —
  /// can reuse it without duplicating the math a third time.
  static double angularSeparationDeg(AltAz a, AltAz b) {
    final alt1 = a.altitudeDeg * _deg2rad;
    final alt2 = b.altitudeDeg * _deg2rad;
    final dAz = (a.azimuthDeg - b.azimuthDeg) * _deg2rad;
    final cosC = math.sin(alt1) * math.sin(alt2) +
        math.cos(alt1) * math.cos(alt2) * math.cos(dAz);
    return math.acos(cosC.clamp(-1.0, 1.0)) * _rad2deg;
  }
}

class AltAz {
  final double altitudeDeg;
  final double azimuthDeg;
  const AltAz({required this.altitudeDeg, required this.azimuthDeg});

  @override
  String toString() =>
      'alt=${altitudeDeg.toStringAsFixed(2)} az=${azimuthDeg.toStringAsFixed(2)}';
}
