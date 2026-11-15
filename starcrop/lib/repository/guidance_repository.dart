import 'dart:convert';
import 'package:drift/drift.dart';

import '../data/farming/farming_db.dart' as fdb;
import '../data/cache/cache_db.dart';
import '../data/user/user_db.dart' as udb;
import '../engine/astro_engine.dart';
import '../engine/rule_engine.dart';
import '../engine/weather_service.dart';
import 'sky_repository.dart';

/// Top-level orchestration: pulls sky state (via SkyRepository), pulls
/// weather (fresh fetch or cache fallback), loads rules from FarmingDb,
/// and returns what the Farmer Guidance / Suggested Activities screens show.
class GuidanceRepository {
  final fdb.FarmingDb farmingDb;
  final CacheDb cacheDb;
  final udb.UserDb userDb;
  final SkyRepository skyRepository;

  GuidanceRepository({
    required this.farmingDb,
    required this.cacheDb,
    required this.userDb,
    required this.skyRepository,
  });

  /// Reads the user's preferred language from UserSettings (key: 'language').
  /// Defaults to 'en' when unset — matches localizedText's fallback elsewhere.
  Future<String> currentLanguage() async {
    final row = await (userDb.select(userDb.userSettings)
          ..where((t) => t.key.equals('language')))
        .getSingleOrNull();
    return row?.value ?? 'en';
  }

  /// Reads the user's selected region from UserSettings (key: 'region_id'),
  /// as set on UserSettingsScreen. Returns null when unset — matching that
  /// screen's "leave unset to see guidance from every region" semantics —
  /// so callers that need a specific region (e.g. the seasonal outlook,
  /// which is inherently per-region climatology) must decide their own
  /// fallback rather than this method guessing one.
  Future<int?> currentRegionId() async {
    final row = await (userDb.select(userDb.userSettings)
          ..where((t) => t.key.equals('region_id')))
        .getSingleOrNull();
    final raw = row?.value;
    if (raw == null || raw.isEmpty) return null;
    return int.tryParse(raw);
  }

  /// Climatology, not forecast: the SeasonalClimateNormals row for
  /// [regionId] and calendar [month] (1-12), if one has been seeded — see
  /// offline_seasonal_outlook_plan.md and SeasonalClimateNormals' doc
  /// comment in farming_db.dart. Returns null if no normal exists yet for
  /// that region/month (e.g. a region with no climate data seeded), so
  /// callers can simply omit the "Seasonal Outlook" section rather than
  /// showing a fabricated or empty one.
  Future<fdb.SeasonalClimateNormal?> getSeasonalOutlook({
    required int regionId,
    required int month,
  }) async {
    return (farmingDb.select(farmingDb.seasonalClimateNormals)
          ..where((t) => t.regionId.equals(regionId) & t.month.equals(month)))
        .getSingleOrNull();
  }

  /// Resolves a human-readable sky-calendar anchor for [outlook], if it has
  /// one — e.g. "Orion" when the row's skyTriggerId points at
  /// skyTriggerOrionVisible — so a normal can be presented as "around
  /// Orion's rise" alongside its plain calendar month, per
  /// offline_seasonal_outlook_plan.md's "anchored to a sky-calendar marker"
  /// idea. Returns null when [outlook] has no skyTriggerId (the case for
  /// every row seeded today — see starcrop_seed_data.dart's
  /// seasonalNormals, which is deliberately month-only until a real,
  /// sourced alignment between a specific trigger and a specific row is
  /// documented, rather than guessed at), or when the referenced trigger or
  /// constellation can't be resolved.
  Future<String?> seasonalOutlookAnchorLabel(fdb.SeasonalClimateNormal outlook) async {
    final triggerId = outlook.skyTriggerId;
    if (triggerId == null) return null;

    final trigger = await (farmingDb.select(farmingDb.skyTriggers)
          ..where((t) => t.triggerId.equals(triggerId)))
        .getSingleOrNull();
    final constCode = trigger?.constCode;
    if (constCode == null) return null;

    return skyRepository.constellationLatinName(constCode);
  }

  /// Attempts a fresh weather fetch; on failure or no network, falls back to
  /// cache; if cache is also stale/missing, returns WeatherState.empty so the
  /// rule engine simply skips weather-dependent rules (sky-only still fires).
  Future<WeatherState> resolveWeather({
    required String locationId,
    required double lat,
    required double lon,
  }) async {
    try {
      final fetched = await WeatherService.fetch(lat: lat, lon: lon);
      final validUntil = WeatherService.computeValidUntil(fetched.fetchedAt);

      await cacheDb.into(cacheDb.weatherForecastCache).insertOnConflictUpdate(
            WeatherForecastCacheCompanion.insert(
              locationId: locationId,
              fetchedAt: fetched.fetchedAt,
              validUntil: validUntil,
              payloadJson: fetched.rawPayload,
            ),
          );

      return WeatherState(
        forecastByDayOffset: fetched.forecastByDayOffset,
        isStale: false,
        fetchedAt: fetched.fetchedAt,
      );
    } catch (_) {
      // Offline or fetch failed — fall back to whatever's cached.
      final cached = await (cacheDb.select(cacheDb.weatherForecastCache)
            ..where((t) => t.locationId.equals(locationId)))
          .getSingleOrNull();

      if (cached == null) {
        return const WeatherState(
          forecastByDayOffset: {},
          isStale: true,
          fetchFailed: true,
        );
      }

      final stale = WeatherService.isStale(validUntil: cached.validUntil);
      final parsed = parseCachedPayload(cached.payloadJson, 7);
      // The cache's day-offset 0 means "the day it was fetched", not
      // "today" — without rebasing, a forecast that's a day or more stale
      // silently misreports which day is which (wrong day labels in
      // Upcoming Weather, wrong day-0 data feeding sky+weather rules).
      final rebased = rebaseForecastToToday(parsed, cached.fetchedAt);
      return WeatherState(
        forecastByDayOffset: rebased,
        isStale: stale,
        fetchedAt: cached.fetchedAt,
      );
    }
  }

  /// Merges cached/fetched forecast with the farmer's own logged observation
  /// for *today specifically* (WeatherLog row with obsDate == today, if any)
  /// into day offset 0, so a manual log can substitute when the forecast is
  /// old or absent entirely — this is the offline weather fallback described
  /// in the schema notes. Deliberately does not fall back to an older log
  /// entry when today has none; a stale log silently standing in for "today"
  /// would be worse than just leaving day 0 to the forecast (or to nothing).
  Future<WeatherState> mergeWithManualLog(
    WeatherState forecast,
    String locationId, {
    DateTime? today,
  }) async {
    final n = today ?? DateTime.now();
    final startOfDay = DateTime(n.year, n.month, n.day);
    final todayLog = await (userDb.select(userDb.weatherLog)
          ..where((t) =>
              t.locationId.equals(locationId) & t.obsDate.equals(startOfDay))
          ..limit(1))
        .getSingleOrNull();

    if (todayLog == null) return forecast;

    final merged = Map<int, Map<String, double>>.from(forecast.forecastByDayOffset);
    final existing = Map<String, double>.from(merged[0] ?? {});
    if (todayLog.rainMm != null) existing['rain'] = todayLog.rainMm!;
    if (todayLog.tempC != null) existing['temp'] = todayLog.tempC!;
    merged[0] = existing;

    return WeatherState(
      forecastByDayOffset: merged,
      isStale: forecast.isStale,
      fetchedAt: forecast.fetchedAt,
    );
  }

  Future<List<fdb.FarmingRule>> _loadRules({int? cropId, int? regionId}) {
    final query = farmingDb.select(farmingDb.farmingRules);
    if (cropId != null) {
      query.where((t) => t.cropId.equals(cropId) | t.cropId.isNull());
    }
    if (regionId != null) {
      query.where((t) => t.regionId.equals(regionId) | t.regionId.isNull());
    }
    return query.get();
  }

  FarmingRuleRow _toRuleRow(fdb.FarmingRule r) => FarmingRuleRow(
        ruleId: r.ruleId,
        skyTriggerId: r.skyTriggerId,
        weatherTriggerId: r.weatherTriggerId,
        activityId: r.activityId,
        cropId: r.cropId,
        regionId: r.regionId,
        guidance: r.guidanceI18n,
        severity: r.severity,
        verificationStatus: r.verificationStatus,
      );

  SkyTriggerRow _toSkyTriggerRow(fdb.SkyTrigger t) => SkyTriggerRow(
        triggerId: t.triggerId,
        triggerType: t.triggerType,
        constCode: t.constCode,
        params: _decodeParams(t.paramsJson),
      );

  /// paramsJson was previously ignored entirely, which silently broke every
  /// trigger type except 'visible' (sun_longitude/moon_phase/date_range all
  /// require a params map to evaluate to anything but false, and first_rise/
  /// last_set silently used RuleEngine's default window_days). Fixed here.
  Map<String, dynamic> _decodeParams(String? paramsJson) {
    if (paramsJson == null || paramsJson.isEmpty) return const {};
    try {
      final decoded = jsonDecode(paramsJson);
      return decoded is Map<String, dynamic> ? decoded : const {};
    } catch (_) {
      return const {};
    }
  }

  WeatherTriggerRow _toWeatherTriggerRow(fdb.WeatherTrigger t) => WeatherTriggerRow(
        triggerId: t.triggerId,
        variable: t.variable,
        operator: t.operator,
        threshold: t.threshold,
        daysAhead: t.daysAhead ?? 0,
        durationDays: t.durationDays ?? 1,
      );

  // TODO: no real content-pack version field exists yet on ReferenceDb/
  // FarmingDb (see schema.md's "ref_data_version: wipe when this changes").
  // Hardcoded until that's added — bump manually if seed data changes shape
  // in a way that would invalidate a cached heliacal-rise/set date.
  static const _contentPackVersion = 1;

  /// Computes heliacalRise/lastSet only for constellations that actually have
  /// a first_rise/last_set sky trigger loaded — the expensive ~400-day scan
  /// (SkyRepository.approximateHeliacalRise/approximateLastSet) only ever
  /// runs for constellations a rule actually depends on, and the result is
  /// cached per location per calendar day in CacheDb.visibilityCache so it
  /// isn't recomputed on every guidance load, only once per day.
  Future<({Map<String, DateTime?> heliacalRise, Map<String, DateTime?> lastSet})>
      _resolveSkyDates({
    required List<fdb.SkyTrigger> skyTriggerRows,
    required String locationId,
    required double lat,
    required double lon,
    required DateTime nowUtc,
  }) async {
    final riseCodes = skyTriggerRows
        .where((t) => t.triggerType == 'first_rise' && t.constCode != null)
        .map((t) => t.constCode!)
        .toSet();
    final setCodes = skyTriggerRows
        .where((t) => t.triggerType == 'last_set' && t.constCode != null)
        .map((t) => t.constCode!)
        .toSet();

    if (riseCodes.isEmpty && setCodes.isEmpty) {
      return (heliacalRise: <String, DateTime?>{}, lastSet: <String, DateTime?>{});
    }

    final today = DateTime.utc(nowUtc.year, nowUtc.month, nowUtc.day);
    final cached = await (cacheDb.select(cacheDb.visibilityCache)
          ..where((t) => t.locationId.equals(locationId) & t.calcDate.equals(today)))
        .getSingleOrNull();

    if (cached != null && cached.refDataVersion == _contentPackVersion) {
      final decoded = jsonDecode(cached.visibilityJson) as Map<String, dynamic>;
      final rise = (decoded['rise'] as Map<String, dynamic>? ?? {}).map(
        (k, v) => MapEntry(k, v == null ? null : DateTime.tryParse(v as String)),
      );
      final set = (decoded['set'] as Map<String, dynamic>? ?? {}).map(
        (k, v) => MapEntry(k, v == null ? null : DateTime.tryParse(v as String)),
      );
      return (heliacalRise: rise, lastSet: set);
    }

    final riseResults = <String, DateTime?>{};
    for (final code in riseCodes) {
      riseResults[code] = await skyRepository.approximateHeliacalRise(
        constCode: code, latDeg: lat, lonDeg: lon, nowUtc: nowUtc,
      );
    }
    final setResults = <String, DateTime?>{};
    for (final code in setCodes) {
      setResults[code] = await skyRepository.approximateLastSet(
        constCode: code, latDeg: lat, lonDeg: lon, nowUtc: nowUtc,
      );
    }

    final payload = jsonEncode({
      'rise': riseResults.map((k, v) => MapEntry(k, v?.toIso8601String())),
      'set': setResults.map((k, v) => MapEntry(k, v?.toIso8601String())),
    });

    await cacheDb.into(cacheDb.visibilityCache).insertOnConflictUpdate(
          VisibilityCacheCompanion.insert(
            locationId: locationId,
            calcDate: today,
            visibilityJson: payload,
            refDataVersion: _contentPackVersion,
          ),
        );

    return (heliacalRise: riseResults, lastSet: setResults);
  }

  /// Shared pipeline used by both getGuidance and getGuidanceResult:
  /// computes sky state, resolves weather, evaluates rules. Returns the
  /// evaluated (not yet filtered-to-firing) rules plus the resolved weather,
  /// so callers can pick what they need without recomputing anything twice.
  Future<({WeatherState weather, List<MatchedRule> evaluated})> _runPipeline({
    required String locationId,
    required double lat,
    required double lon,
    required DateTime nowUtc,
    int? cropId,
    int? regionId,
    String minStatus = 'reviewed',
  }) async {
    final visibilityMap = await skyRepository.constellationVisibilityMap(
      latDeg: lat,
      lonDeg: lon,
      utc: nowUtc,
    );

    final skyTriggerRows = await farmingDb.select(farmingDb.skyTriggers).get();

    final skyDates = await _resolveSkyDates(
      skyTriggerRows: skyTriggerRows,
      locationId: locationId,
      lat: lat,
      lon: lon,
      nowUtc: nowUtc,
    );

    final sky = SkyState(
      constellationVisible: visibilityMap,
      heliacalRise: skyDates.heliacalRise,
      lastSet: skyDates.lastSet,
      sunEclipticLongitudeDeg: AstroEngine.sunEclipticLongitude(nowUtc),
      moonPhase: AstroEngine.moonPhase(nowUtc),
      date: nowUtc,
    );

    var weather = await resolveWeather(locationId: locationId, lat: lat, lon: lon);
    weather = await mergeWithManualLog(weather, locationId);

    final ruleRows = await _loadRules(cropId: cropId, regionId: regionId);
    final weatherTriggerRows = await farmingDb.select(farmingDb.weatherTriggers).get();

    final evaluated = RuleEngine.evaluate(
      rules: ruleRows.map(_toRuleRow).toList(),
      skyTriggers: {for (final t in skyTriggerRows) t.triggerId: _toSkyTriggerRow(t)},
      weatherTriggers: {for (final t in weatherTriggerRows) t.triggerId: _toWeatherTriggerRow(t)},
      sky: sky,
      weather: weather,
      minStatus: minStatus,
      cropId: cropId,
      regionId: regionId,
    );

    return (weather: weather, evaluated: evaluated);
  }

  /// Full pipeline: sky state + weather state + rules -> firing guidance.
  Future<List<MatchedRule>> getGuidance({
    required String locationId,
    required double lat,
    required double lon,
    required DateTime nowUtc,
    int? cropId,
    int? regionId,
    String minStatus = 'reviewed',
  }) async {
    final result = await _runPipeline(
      locationId: locationId,
      lat: lat,
      lon: lon,
      nowUtc: nowUtc,
      cropId: cropId,
      regionId: regionId,
      minStatus: minStatus,
    );
    return RuleEngine.firingRules(result.evaluated);
  }

  /// Same pipeline as getGuidance, but also hands back the resolved
  /// WeatherState — Suggested Activities needs both the firing rules and
  /// the weather (for the "offline/stale forecast" banner).
  Future<GuidanceResult> getGuidanceResult({
    required String locationId,
    required double lat,
    required double lon,
    required DateTime nowUtc,
    int? cropId,
    int? regionId,
    String minStatus = 'reviewed',
  }) async {
    final result = await _runPipeline(
      locationId: locationId,
      lat: lat,
      lon: lon,
      nowUtc: nowUtc,
      cropId: cropId,
      regionId: regionId,
      minStatus: minStatus,
    );
    return GuidanceResult(
      weather: result.weather,
      rules: RuleEngine.firingRules(result.evaluated),
    );
  }

  /// Sky-only farming guidance for an arbitrary future [targetUtc] — powers
  /// the Home screen's "Next Month Outlook" card. Reliable regardless of how
  /// far out because sky triggers (visibility, first/last rise, moon phase,
  /// sun longitude, date range) are pure astronomy — the same math that
  /// makes today's guidance work also works for a date a month from now.
  ///
  /// Weather-gated rules are deliberately excluded rather than approximated
  /// from a monthly climate average: there's no real forecast that far out,
  /// only SeasonalClimateNormals' average rainfall/temperature for the
  /// month, and a rule reported as "firing" against that average would
  /// overstate how reliable the guidance actually is. Passing an empty
  /// weatherTriggers map and WeatherState.empty makes every weather-gated
  /// rule fail to fire (RuleEngine.MatchedRule.fires needs
  /// weatherDataAvailable), the same mechanism _runPipeline already relies
  /// on elsewhere — no separate filtering needed here.
  Future<List<MatchedRule>> getSkyOnlyGuidance({
    required String locationId,
    required double lat,
    required double lon,
    required DateTime targetUtc,
    int? cropId,
    int? regionId,
    String minStatus = 'reviewed',
  }) async {
    final visibilityMap = await skyRepository.constellationVisibilityMap(
      latDeg: lat,
      lonDeg: lon,
      utc: targetUtc,
    );

    final skyTriggerRows = await farmingDb.select(farmingDb.skyTriggers).get();

    final skyDates = await _resolveSkyDates(
      skyTriggerRows: skyTriggerRows,
      locationId: locationId,
      lat: lat,
      lon: lon,
      nowUtc: targetUtc,
    );

    final sky = SkyState(
      constellationVisible: visibilityMap,
      heliacalRise: skyDates.heliacalRise,
      lastSet: skyDates.lastSet,
      sunEclipticLongitudeDeg: AstroEngine.sunEclipticLongitude(targetUtc),
      moonPhase: AstroEngine.moonPhase(targetUtc),
      date: targetUtc,
    );

    final ruleRows = await _loadRules(cropId: cropId, regionId: regionId);

    final evaluated = RuleEngine.evaluate(
      rules: ruleRows.map(_toRuleRow).toList(),
      skyTriggers: {for (final t in skyTriggerRows) t.triggerId: _toSkyTriggerRow(t)},
      weatherTriggers: const {},
      sky: sky,
      weather: WeatherState.empty,
      minStatus: minStatus,
      cropId: cropId,
      regionId: regionId,
    );

    return RuleEngine.firingRules(evaluated);
  }

  /// Convenience wrapper over [getSkyOnlyGuidance]: "one month from now",
  /// same day-of-month/time-of-day as [nowUtc] (defaults to now), normalized
  /// by Dart's DateTime constructor — e.g. Jan 31 lands on Mar 3 in a
  /// non-leap year, since Feb 31 doesn't exist. Good enough for a "roughly
  /// next month" preview card; not meant to pin down an exact calendar date.
  Future<List<MatchedRule>> getNextMonthGuidance({
    required String locationId,
    required double lat,
    required double lon,
    DateTime? nowUtc,
    int? cropId,
    int? regionId,
    String minStatus = 'reviewed',
  }) {
    final now = nowUtc ?? DateTime.now().toUtc();
    final target = DateTime.utc(now.year, now.month + 1, now.day, now.hour, now.minute);
    return getSkyOnlyGuidance(
      locationId: locationId,
      lat: lat,
      lon: lon,
      targetUtc: target,
      cropId: cropId,
      regionId: regionId,
      minStatus: minStatus,
    );
  }
}

/// Bundles the resolved weather alongside the firing rules, so screens like
/// Suggested Activities can show a stale/offline banner without a second
/// call to resolveWeather (which would just re-hit cache/network for the
/// same location).
class GuidanceResult {
  final WeatherState weather;
  final List<MatchedRule> rules;

  const GuidanceResult({required this.weather, required this.rules});
}
