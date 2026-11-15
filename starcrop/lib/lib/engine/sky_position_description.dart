import 'astro_engine.dart' show AltAz;

/// A constellation's real position in the sky, turned into plain words.
/// All values come from AstroEngine's alt/az math for a specific place and
/// time — nothing here is estimated or hardcoded.
class SpottedPosition {
  /// Capitalized 8-point compass name: "Northeast", "South", ...
  final String compass;

  /// Azimuth rounded to whole degrees, 0-359 (0 = North, clockwise).
  final int azimuthDeg;

  /// Altitude in words: "42° above the horizon", "just above the horizon",
  /// "almost straight overhead", or "below the horizon".
  final String heightLabel;

  const SpottedPosition({
    required this.compass,
    required this.azimuthDeg,
    required this.heightLabel,
  });

  /// "Northeast, 42° above the horizon"
  String get summary => '$compass, $heightLabel';

  /// "Orion spotted in the northeast"
  String headline(String constellationName) =>
      '$constellationName spotted in the ${compass.toLowerCase()}';
}

class SkyPositionDescription {
  SkyPositionDescription._();

  static const _compassNames = [
    'North',
    'Northeast',
    'East',
    'Southeast',
    'South',
    'Southwest',
    'West',
    'Northwest',
  ];

  /// 8-point compass name for an azimuth in degrees (0 = North, 90 = East,
  /// clockwise — same convention as AstroEngine). Accepts any real value,
  /// including negatives and values above 360.
  static String compassName(double azimuthDeg) {
    final a = ((azimuthDeg % 360) + 360) % 360;
    final index = ((a + 22.5) / 45).floor() % 8;
    return _compassNames[index];
  }

  /// Altitude in everyday words.
  static String heightLabel(double altitudeDeg) {
    if (altitudeDeg < 0) return 'below the horizon';
    if (altitudeDeg < 5) return 'just above the horizon';
    if (altitudeDeg >= 80) return 'almost straight overhead';
    return '${altitudeDeg.round()}° above the horizon';
  }

  /// Describes where [position] is in the sky.
  static SpottedPosition describe(AltAz position) {
    final az = ((position.azimuthDeg % 360) + 360) % 360;
    return SpottedPosition(
      compass: compassName(az),
      azimuthDeg: az.round() % 360,
      heightLabel: heightLabel(position.altitudeDeg),
    );
  }

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  /// "Sep 28, 2026 · 8:15 PM" for a DateTime already in the time zone that
  /// should be shown (pass `.toLocal()` for the phone's clock). No intl
  /// dependency, matching format_utils.dart.
  static String dateTimeLabel(DateTime t) {
    final hour12 = t.hour % 12 == 0 ? 12 : t.hour % 12;
    final minute = t.minute.toString().padLeft(2, '0');
    final period = t.hour < 12 ? 'AM' : 'PM';
    return '${_months[t.month - 1]} ${t.day}, ${t.year} · $hour12:$minute $period';
  }
}
