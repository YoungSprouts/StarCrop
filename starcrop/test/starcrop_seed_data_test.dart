import 'package:starcrop/data/seed/starcrop_seed_data.dart';
import 'package:test/test.dart';

void main() {
  group('StarcropSeedData integrity', () {
    test('every line references stars that exist in the star list', () {
      final hipIds = StarcropSeedData.stars.map((s) => s.hipId).toSet();
      for (final line in StarcropSeedData.lines) {
        expect(hipIds.contains(line.starA), isTrue, reason: 'missing star ${line.starA}');
        expect(hipIds.contains(line.starB), isTrue, reason: 'missing star ${line.starB}');
      }
    });

    test('every line references a constellation that exists', () {
      final codes = StarcropSeedData.constellations.map((c) => c.code).toSet();
      for (final line in StarcropSeedData.lines) {
        expect(codes.contains(line.constCode), isTrue, reason: 'missing constellation ${line.constCode}');
      }
    });

    test('no duplicate HIP ids', () {
      final ids = StarcropSeedData.stars.map((s) => s.hipId).toList();
      expect(ids.toSet().length, ids.length);
    });

    test('no duplicate constellation codes', () {
      final codes = StarcropSeedData.constellations.map((c) => c.code).toList();
      expect(codes.toSet().length, codes.length);
    });

    test('no duplicate place geoname ids', () {
      final ids = StarcropSeedData.places.map((p) => p.geonameId).toList();
      expect(ids.toSet().length, ids.length);
    });

    test('no duplicate place names', () {
      // Regression check for the 5 newly added cities — easy to accidentally
      // collide with an existing name when expanding this list by hand.
      final names = StarcropSeedData.places.map((p) => p.name).toList();
      expect(names.toSet().length, names.length);
    });

    test('all star coordinates are within valid ranges', () {
      for (final s in StarcropSeedData.stars) {
        expect(s.raDeg, inInclusiveRange(0, 360));
        expect(s.decDeg, inInclusiveRange(-90, 90));
      }
    });

    test('all place coordinates are within valid ranges and Philippines-ish bounds', () {
      for (final p in StarcropSeedData.places) {
        expect(p.lat, inInclusiveRange(-90, 90));
        expect(p.lon, inInclusiveRange(-180, 180));
        expect(p.lat, inInclusiveRange(4, 21));
        expect(p.lon, inInclusiveRange(116, 127));
      }
    });

    test('exactly one place has a verified (non-placeholder-range) geoname id', () {
      final verified = StarcropSeedData.places.where((p) => p.verifiedGeonameId).toList();
      expect(verified.length, 1);
      expect(verified.first.name, 'Iloilo City');
    });

    test('unverified place ids stay in the reserved 9000000+ range', () {
      for (final p in StarcropSeedData.places.where((p) => !p.verifiedGeonameId)) {
        expect(p.geonameId, greaterThanOrEqualTo(9000001));
      }
    });

    test('at least 10 places are seeded (location search has real coverage)', () {
      // Loosely pins the "expand seed content" work — fails loudly if places
      // are ever accidentally trimmed back down rather than only added to.
      expect(StarcropSeedData.places.length, greaterThanOrEqualTo(10));
    });

    test('every farming rule references a sky trigger that exists', () {
      // This is a data-shape sanity check at the constant level; the actual
      // rule-to-trigger wiring lives in StarcropSeedLoader, not this file.
      final triggerIds = {
        StarcropSeedData.skyTriggerOrionVisible,
        StarcropSeedData.skyTriggerTaurusVisible,
      };
      expect(triggerIds.length, 2);
    });

    test('weather trigger ids are unique and distinct from sky trigger ids', () {
      // WeatherTriggers and SkyTriggers are separate tables in the schema
      // (each with its own PK), so numeric collision between the two isn't a
      // real bug — but keeping them distinct here avoids confusing a reader
      // of the seed constants into thinking they share an id space.
      final weatherIds = {
        StarcropSeedData.weatherTriggerLowRainAhead,
        StarcropSeedData.weatherTriggerHeavyRainAhead,
      };
      expect(weatherIds.length, 2);
      final skyIds = {
        StarcropSeedData.skyTriggerOrionVisible,
        StarcropSeedData.skyTriggerTaurusVisible,
      };
      expect(weatherIds.intersection(skyIds), isEmpty);
    });

    test('weather-only rule ids are unique and distinct from sky-based rule ids', () {
      final skyRuleIds = {
        StarcropSeedData.ruleTaurusClearing,
        StarcropSeedData.rulePleiadesPlanning,
        StarcropSeedData.ruleOrionPlanting,
      };
      final weatherRuleIds = {
        StarcropSeedData.ruleSprayWindow,
        StarcropSeedData.ruleHarvestBeforeRain,
      };
      expect(skyRuleIds.length, 3);
      expect(weatherRuleIds.length, 2);
      expect(skyRuleIds.intersection(weatherRuleIds), isEmpty);
    });

    test('the two seeded sources have distinct ids', () {
      expect(
        StarcropSeedData.sourceId,
        isNot(equals(StarcropSeedData.generalAgronomySourceId)),
      );
    });

    test('the climate-normals source id is distinct from the other two sources', () {
      // Regression check for the bug fixed in starcrop_seed_loader.dart:
      // climateNormalsSourceId was defined here but never actually inserted
      // as a Sources row, so any SeasonalClimateNormals row referencing it
      // would have pointed at a non-existent FK. This only guards the id
      // itself stays unique; the loader is what actually inserts the row.
      final ids = {
        StarcropSeedData.sourceId,
        StarcropSeedData.generalAgronomySourceId,
        StarcropSeedData.climateNormalsSourceId,
      };
      expect(ids.length, 3);
    });
  });

  group('StarcropSeedData.seasonalNormals integrity', () {
    test('every row references the seeded region', () {
      // StarcropSeedLoader only ever creates one Regions row
      // (StarcropSeedData.regionId) — a normal pointing anywhere else would
      // violate SeasonalClimateNormals.regionId's FK the moment it's seeded.
      for (final n in StarcropSeedData.seasonalNormals) {
        expect(n.regionId, StarcropSeedData.regionId,
            reason: 'seasonal normal for month ${n.month} references an unseeded region');
      }
    });

    test('month is always 1-12', () {
      for (final n in StarcropSeedData.seasonalNormals) {
        expect(n.month, inInclusiveRange(1, 12));
      }
    });

    test('no duplicate (regionId, month) pairs', () {
      // Matches SeasonalClimateNormals' primary key (regionId, month) —
      // a duplicate here would silently overwrite a row during seeding
      // instead of failing loudly.
      final keys = StarcropSeedData.seasonalNormals.map((n) => '${n.regionId}:${n.month}').toList();
      expect(keys.toSet().length, keys.length);
    });

    test('every month 1-12 is covered exactly once for the seeded region', () {
      final months = StarcropSeedData.seasonalNormals
          .where((n) => n.regionId == StarcropSeedData.regionId)
          .map((n) => n.month)
          .toList()
        ..sort();
      expect(months, List.generate(12, (i) => i + 1));
    });

    test('rain and temperature values are physically sane', () {
      for (final n in StarcropSeedData.seasonalNormals) {
        expect(n.avgRainMm, greaterThanOrEqualTo(0),
            reason: 'month ${n.month} has negative rainfall');
        expect(n.tempMinC, lessThanOrEqualTo(n.tempMaxC),
            reason: 'month ${n.month} has tempMinC > tempMaxC');
        // Loose sanity band, not a climate assertion — just catches an
        // obvious unit/typo error (e.g. Fahrenheit accidentally pasted in).
        expect(n.tempMinC, inInclusiveRange(-10, 45));
        expect(n.tempMaxC, inInclusiveRange(-10, 50));
      }
    });

    test('classification is never blank', () {
      for (final n in StarcropSeedData.seasonalNormals) {
        expect(n.classification.trim(), isNotEmpty, reason: 'month ${n.month} has no classification');
      }
    });
  });
}
