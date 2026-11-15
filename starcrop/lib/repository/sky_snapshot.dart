import 'dart:convert';

import '../data/cache/cache_db.dart';
import '../engine/astro_engine.dart';
import 'sky_models.dart';

/// Small, fast-to-render summary of "what's up tonight" — cached so Home can
/// paint instantly instead of waiting on ReferenceDb + AstroEngine math.
/// Matches schema.md's cache diagram: "SKY_SNAPSHOT ... last sky, for
/// instant home screen". Sky Chart is the only screen that recomputes the
/// full picture; this just remembers its highlights for next time Home opens.
class SkySnapshot {
  final DateTime computedAt;
  final String moonPhaseLabel;
  final List<String> visibleConstellations; // latin names, a few only

  const SkySnapshot({
    required this.computedAt,
    required this.moonPhaseLabel,
    required this.visibleConstellations,
  });

  String toJson() => jsonEncode({
        'computed_at': computedAt.toIso8601String(),
        'moon_phase_label': moonPhaseLabel,
        'visible': visibleConstellations,
      });

  /// Returns null (rather than throwing) on a corrupt or old-shape payload —
  /// this is a disposable cache, so falling back to "no snapshot yet" is
  /// always the right behavior, never a crash.
  static SkySnapshot? fromJson(String raw) {
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return SkySnapshot(
        computedAt: DateTime.parse(decoded['computed_at'] as String),
        moonPhaseLabel: decoded['moon_phase_label'] as String? ?? '',
        visibleConstellations:
            (decoded['visible'] as List?)?.map((e) => e.toString()).toList() ??
                const [],
      );
    } catch (_) {
      return null;
    }
  }
}

/// Builds a snapshot from constellations Sky Chart just observed (no extra
/// DB/math work here — it already has this data right after its own load)
/// and saves it. Best-effort: failures are swallowed since this is a cache,
/// never load-bearing for correctness or for Sky Chart's own behavior.
Future<void> saveSkySnapshot({
  required CacheDb cacheDb,
  required List<ObservedConstellation> constellations,
  required double moonPhase,
}) async {
  try {
    final snapshot = SkySnapshot(
      computedAt: DateTime.now().toUtc(),
      moonPhaseLabel: AstroEngine.moonPhaseLabel(moonPhase),
      visibleConstellations: constellations
          .where((c) => c.visible)
          .map((c) => c.latinName)
          .take(6)
          .toList(),
    );
    await cacheDb.saveSkySnapshot(snapshot.toJson());
  } catch (_) {
    // Cache write only — never let this break the Sky Chart screen.
  }
}

/// Loads the last saved snapshot, if any. Returns null on first launch
/// (before Sky Chart has ever been opened) or if the cache is empty/corrupt.
Future<SkySnapshot?> loadSkySnapshot(CacheDb cacheDb) async {
  final raw = await cacheDb.latestSkySnapshotJson();
  if (raw == null) return null;
  return SkySnapshot.fromJson(raw);
}
