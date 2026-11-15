import '../engine/astro_engine.dart';

/// Plain data classes describing computed sky positions — no database
/// access, no drift, no Flutter/platform-plugin dependencies. Kept separate
/// from sky_repository.dart (which does depend on ReferenceDb, and
/// transitively on path_provider -> the full Flutter framework) so that
/// pure-logic consumers, like PhotoMatchingEngine, can use these types
/// without dragging in a live database connection. This is what lets
/// photo_matching_engine_test.dart run under plain `dart test` instead of
/// needing `flutter test` (which currently can't run on this Termux install
/// — see DevSetupVer7.md / PROGRESS.md for the libvk_swiftshader gap).

/// A star with its computed position for a given observer + time.
class ObservedStar {
  final int hipId;
  final String? properName;
  final double magnitude;
  final AltAz position;

  const ObservedStar({
    required this.hipId,
    required this.properName,
    required this.magnitude,
    required this.position,
  });
}

class ObservedConstellation {
  final String code;
  final String latinName;
  final AltAz centerPosition;
  final bool visible; // center above horizon

  const ObservedConstellation({
    required this.code,
    required this.latinName,
    required this.centerPosition,
    required this.visible,
  });
}

/// One line segment of a constellation figure, with both endpoint stars'
/// live positions — this is what the Sky Chart screen renders.
class ObservedLine {
  final String constCode;
  final AltAz pointA;
  final AltAz pointB;
  const ObservedLine({
    required this.constCode,
    required this.pointA,
    required this.pointB,
  });
}
