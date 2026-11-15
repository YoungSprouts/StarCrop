/// Pure logic, no DB access — takes already-fetched trigger/rule rows and
/// current computed state, returns matching rules. DB layer calls this after
/// loading FarmingRules + trigger tables.

class SkyState {
  final Map<String, bool> constellationVisible; // constCode -> visible now
  final Map<String, DateTime?> heliacalRise; // constCode -> date of first pre-dawn rise this cycle
  final Map<String, DateTime?> lastSet; // constCode -> date of last visible set
  final double sunEclipticLongitudeDeg;
  final double moonPhase; // 0..1
  final DateTime date;

  const SkyState({
    required this.constellationVisible,
    required this.heliacalRise,
    required this.lastSet,
    required this.sunEclipticLongitudeDeg,
    required this.moonPhase,
    required this.date,
  });
}

class WeatherState {
  /// day offset (0=today) -> {rain_mm, temp_c, wind_kph, humidity_pct}
  final Map<int, Map<String, double>> forecastByDayOffset;
  final bool isStale;

  /// When this forecast was fetched (fresh) or last cached (fallback).
  /// Null when there has never been a successful fetch or cache entry —
  /// e.g. WeatherState.empty, or a cache miss on first run offline.
  final DateTime? fetchedAt;

  /// True only when GuidanceRepository.resolveWeather actually attempted a
  /// live fetch, that fetch failed (offline / bad response), AND there was
  /// no cached forecast to fall back to. Distinguishes "we just tried and
  /// have nothing" from other empty states that aren't failures — e.g.
  /// WeatherState.empty used by getSkyOnlyGuidance to deliberately skip
  /// weather-gated rules, where no fetch was ever attempted. UI can use
  /// this to show "couldn't reach the internet, try again" instead of a
  /// generic "no forecast yet".
  final bool fetchFailed;

  const WeatherState({
    required this.forecastByDayOffset,
    required this.isStale,
    this.fetchedAt,
    this.fetchFailed = false,
  });

  static const empty = WeatherState(forecastByDayOffset: {}, isStale: true);
}

class SkyTriggerRow {
  final int triggerId;
  final String triggerType; // visible, first_rise, last_set, sun_longitude, moon_phase, date_range
  final String? constCode;
  final Map<String, dynamic> params;

  const SkyTriggerRow({
    required this.triggerId,
    required this.triggerType,
    this.constCode,
    this.params = const {},
  });
}

class WeatherTriggerRow {
  final int triggerId;
  final String variable; // rain, temp, wind, humidity
  final String operator; // '>', '<', '>=', '<=', '=='
  final double threshold;
  final int daysAhead;
  final int durationDays;

  const WeatherTriggerRow({
    required this.triggerId,
    required this.variable,
    required this.operator,
    required this.threshold,
    this.daysAhead = 0,
    this.durationDays = 1,
  });
}

class FarmingRuleRow {
  final int ruleId;
  final int? skyTriggerId;
  final int? weatherTriggerId;
  final int activityId;
  final int? cropId;
  final int? regionId;
  final String guidance;
  final String? severity;
  final String verificationStatus; // draft, reviewed, confirmed

  const FarmingRuleRow({
    required this.ruleId,
    this.skyTriggerId,
    this.weatherTriggerId,
    required this.activityId,
    this.cropId,
    this.regionId,
    required this.guidance,
    this.severity,
    required this.verificationStatus,
  });
}

/// Result of evaluating one WeatherTriggerRow against a WeatherState.
///
/// [matched] is null when *no* day in the trigger's window has any data at
/// all (a fully offline device with no forecast ever fetched or cached, and
/// nothing manually logged) — the rule simply can't be evaluated. Otherwise
/// it's the operator's verdict, averaged over whichever days in the window
/// actually have a value for [WeatherTriggerRow.variable].
///
/// [daysAvailable] vs [daysExpected] lets a caller distinguish a full-window
/// match (e.g. 3/3 days from a live forecast) from a partial one (e.g. 1/3
/// days, backed only by today's manually logged rainfall) — see
/// MatchedRule.isPartialWeatherData, which is what the UI actually checks.
class WeatherTriggerResult {
  final bool? matched;
  final int daysAvailable;
  final int daysExpected;

  const WeatherTriggerResult({
    required this.matched,
    required this.daysAvailable,
    required this.daysExpected,
  });
}

class MatchedRule {
  final FarmingRuleRow rule;
  final bool skyMatched;
  final bool? weatherMatched; // null if rule has no weather trigger
  final bool weatherDataAvailable;

  /// How many days of [rule]'s weather-trigger window actually had data,
  /// out of how many the window calls for. Both stay 0 when the rule has no
  /// weather trigger. See [isPartialWeatherData].
  final int weatherDaysAvailable;
  final int weatherDaysExpected;

  const MatchedRule({
    required this.rule,
    required this.skyMatched,
    required this.weatherMatched,
    required this.weatherDataAvailable,
    this.weatherDaysAvailable = 0,
    this.weatherDaysExpected = 0,
  });

  /// True if the rule fully fires given available data.
  bool get fires {
    if (!skyMatched) return false;
    if (rule.weatherTriggerId == null) return true; // sky-only rule
    if (!weatherDataAvailable) return false; // weather required but missing
    return weatherMatched == true;
  }

  /// True when this rule has a weather trigger, evaluated to *something*
  /// (matched or not), but did so using fewer days than its window actually
  /// calls for — e.g. a 3-day-average trigger backed only by today's
  /// manually logged rainfall, with no forecast/cache covering the other
  /// two days. The average is still the best guess available, but it's a
  /// materially weaker claim than a full-window match and callers (UI)
  /// should flag it rather than presenting it identically to one.
  bool get isPartialWeatherData =>
      rule.weatherTriggerId != null &&
      weatherDataAvailable &&
      weatherDaysAvailable > 0 &&
      weatherDaysAvailable < weatherDaysExpected;
}

class RuleEngine {
  /// Only rules at this verification status or above are shown to users.
  /// Order matters: draft < reviewed < confirmed.
  static const _statusRank = {'draft': 0, 'reviewed': 1, 'confirmed': 2};

  static bool _meetsMinStatus(String status, String minStatus) {
    return (_statusRank[status] ?? 0) >= (_statusRank[minStatus] ?? 0);
  }

  static bool evaluateSkyTrigger(SkyTriggerRow trigger, SkyState sky) {
    switch (trigger.triggerType) {
      case 'visible':
        return trigger.constCode != null &&
            (sky.constellationVisible[trigger.constCode] ?? false);

      case 'first_rise':
        if (trigger.constCode == null) return false;
        final rise = sky.heliacalRise[trigger.constCode];
        if (rise == null) return false;
        final windowDays = (trigger.params['window_days'] as num?)?.toInt() ?? 3;
        final diff = sky.date.difference(rise).inDays.abs();
        return diff <= windowDays;

      case 'last_set':
        if (trigger.constCode == null) return false;
        final set = sky.lastSet[trigger.constCode];
        if (set == null) return false;
        final windowDays = (trigger.params['window_days'] as num?)?.toInt() ?? 3;
        final diff = sky.date.difference(set).inDays.abs();
        return diff <= windowDays;

      case 'sun_longitude':
        final target = (trigger.params['degrees'] as num?)?.toDouble();
        final tolerance = (trigger.params['tolerance_deg'] as num?)?.toDouble() ?? 2.0;
        if (target == null) return false;
        final diff = (sky.sunEclipticLongitudeDeg - target).abs() % 360;
        final wrapped = diff > 180 ? 360 - diff : diff;
        return wrapped <= tolerance;

      case 'moon_phase':
        final target = (trigger.params['phase'] as num?)?.toDouble();
        final tolerance = (trigger.params['tolerance'] as num?)?.toDouble() ?? 0.05;
        if (target == null) return false;
        return (sky.moonPhase - target).abs() <= tolerance;

      case 'date_range':
        final startMonth = (trigger.params['start_month'] as num?)?.toInt();
        final endMonth = (trigger.params['end_month'] as num?)?.toInt();
        if (startMonth == null || endMonth == null) return false;
        final m = sky.date.month;
        if (startMonth <= endMonth) {
          return m >= startMonth && m <= endMonth;
        }
        return m >= startMonth || m <= endMonth; // wraps around year end
      default:
        return false;
    }
  }

  /// Evaluates [trigger] against [weather], averaging over whichever days in
  /// the [WeatherTriggerRow.daysAhead, daysAhead + durationDays) window
  /// actually have a value for [WeatherTriggerRow.variable] — rather than
  /// requiring every day to be present.
  ///
  /// This is what lets a fully offline device, with no forecast ever
  /// fetched or cached, still have a multi-day weather rule fire off of
  /// nothing but today's manually logged observation (see
  /// GuidanceRepository.mergeWithManualLog, which only ever populates day
  /// offset 0): previously any single missing day anywhere in the window
  /// made the whole rule un-evaluatable, which meant a 3-day-ahead spray
  /// rule could never fire without at least one successful network fetch,
  /// contradicting this app's offline-first design (see README.md's
  /// "Offline first" principle and the Weather engine's documented
  /// fallback to `weather_log`).
  ///
  /// [WeatherTriggerResult.matched] is null only when *no* day in the
  /// window has any data at all — genuinely nothing to evaluate.
  /// [WeatherTriggerResult.daysAvailable] vs [daysExpected] tells the
  /// caller whether a non-null verdict is a full-window match or a partial
  /// one, so the UI can flag partial matches rather than presenting a
  /// 1-day-backed average identically to a real 3-day forecast average
  /// (see MatchedRule.isPartialWeatherData).
  static WeatherTriggerResult evaluateWeatherTriggerDetailed(
    WeatherTriggerRow trigger,
    WeatherState weather,
  ) {
    final values = <double>[];
    for (int d = trigger.daysAhead; d < trigger.daysAhead + trigger.durationDays; d++) {
      final v = weather.forecastByDayOffset[d]?[trigger.variable];
      if (v != null) values.add(v);
    }
    final daysExpected = trigger.durationDays;

    if (values.isEmpty) {
      return WeatherTriggerResult(matched: null, daysAvailable: 0, daysExpected: daysExpected);
    }

    final avg = values.reduce((a, b) => a + b) / values.length;

    bool? matched;
    switch (trigger.operator) {
      case '>':
        matched = avg > trigger.threshold;
        break;
      case '>=':
        matched = avg >= trigger.threshold;
        break;
      case '<':
        matched = avg < trigger.threshold;
        break;
      case '<=':
        matched = avg <= trigger.threshold;
        break;
      case '==':
        matched = avg == trigger.threshold;
        break;
      default:
        matched = null; // unknown operator — same "can't evaluate" outcome
    }

    return WeatherTriggerResult(
      matched: matched,
      daysAvailable: values.length,
      daysExpected: daysExpected,
    );
  }

  /// Kept for any external caller that only needs the plain pass/fail/
  /// unknown verdict without the days-available/days-expected detail.
  static bool? evaluateWeatherTrigger(WeatherTriggerRow trigger, WeatherState weather) =>
      evaluateWeatherTriggerDetailed(trigger, weather).matched;

  /// Main entry point. Pass all candidate rules + trigger lookup maps.
  static List<MatchedRule> evaluate({
    required List<FarmingRuleRow> rules,
    required Map<int, SkyTriggerRow> skyTriggers,
    required Map<int, WeatherTriggerRow> weatherTriggers,
    required SkyState sky,
    required WeatherState weather,
    String minStatus = 'reviewed',
    int? cropId,
    int? regionId,
  }) {
    final results = <MatchedRule>[];

    for (final rule in rules) {
      if (!_meetsMinStatus(rule.verificationStatus, minStatus)) continue;
      if (cropId != null && rule.cropId != null && rule.cropId != cropId) continue;
      if (regionId != null && rule.regionId != null && rule.regionId != regionId) continue;

      bool skyMatched = true;
      if (rule.skyTriggerId != null) {
        final trig = skyTriggers[rule.skyTriggerId];
        skyMatched = trig != null && evaluateSkyTrigger(trig, sky);
      }

      bool? weatherMatched;
      bool weatherAvailable = true;
      int weatherDaysAvailable = 0;
      int weatherDaysExpected = 0;
      if (rule.weatherTriggerId != null) {
        final trig = weatherTriggers[rule.weatherTriggerId];
        if (trig == null) {
          weatherAvailable = false;
        } else {
          final result = evaluateWeatherTriggerDetailed(trig, weather);
          weatherMatched = result.matched;
          weatherAvailable = result.matched != null;
          weatherDaysAvailable = result.daysAvailable;
          weatherDaysExpected = result.daysExpected;
        }
      }

      results.add(MatchedRule(
        rule: rule,
        skyMatched: skyMatched,
        weatherMatched: weatherMatched,
        weatherDataAvailable: weatherAvailable,
        weatherDaysAvailable: weatherDaysAvailable,
        weatherDaysExpected: weatherDaysExpected,
      ));
    }

    return results;
  }

  /// Convenience: only rules that actually fire, sky-only rules first
  /// (since they're the reliable offline backbone), then sky+weather rules.
  static List<MatchedRule> firingRules(List<MatchedRule> evaluated) {
    final firing = evaluated.where((m) => m.fires).toList();
    firing.sort((a, b) {
      final aSkyOnly = a.rule.weatherTriggerId == null ? 0 : 1;
      final bSkyOnly = b.rule.weatherTriggerId == null ? 0 : 1;
      return aSkyOnly.compareTo(bSkyOnly);
    });
    return firing;
  }
}
