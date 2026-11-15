import 'package:starcrop/engine/rule_engine.dart';
import 'package:test/test.dart';

void main() {
  group('RuleEngine', () {
    final skyTriggers = {
      1: const SkyTriggerRow(triggerId: 1, triggerType: 'visible', constCode: 'ORI'),
      2: const SkyTriggerRow(
        triggerId: 2,
        triggerType: 'first_rise',
        constCode: 'PLE',
        params: {'window_days': 5},
      ),
    };

    final weatherTriggers = {
      10: const WeatherTriggerRow(
        triggerId: 10,
        variable: 'rain',
        operator: '<',
        threshold: 5.0,
        daysAhead: 0,
        durationDays: 3,
      ),
    };

    SkyState sky({DateTime? date, Map<String, bool>? visible, Map<String, DateTime?>? rise}) {
      return SkyState(
        constellationVisible: visible ?? {'ORI': true},
        heliacalRise: rise ?? {'PLE': DateTime.utc(2026, 9, 22)},
        lastSet: const {},
        sunEclipticLongitudeDeg: 180.0,
        moonPhase: 0.5,
        date: date ?? DateTime.utc(2026, 9, 23),
      );
    }

    test('sky-only rule fires when sky matches, regardless of weather', () {
      final rule = const FarmingRuleRow(
        ruleId: 1,
        skyTriggerId: 1,
        activityId: 1,
        guidance: 'Prepare fields',
        verificationStatus: 'confirmed',
      );
      final result = RuleEngine.evaluate(
        rules: [rule],
        skyTriggers: skyTriggers,
        weatherTriggers: weatherTriggers,
        sky: sky(),
        weather: WeatherState.empty,
      );
      expect(result.single.fires, isTrue);
    });

    test('sky+weather rule does NOT fire when weather data is entirely missing', () {
      final rule = const FarmingRuleRow(
        ruleId: 2,
        skyTriggerId: 1,
        weatherTriggerId: 10,
        activityId: 2,
        guidance: 'Plant now',
        verificationStatus: 'confirmed',
      );
      final result = RuleEngine.evaluate(
        rules: [rule],
        skyTriggers: skyTriggers,
        weatherTriggers: weatherTriggers,
        sky: sky(),
        weather: WeatherState.empty,
      );
      expect(result.single.fires, isFalse);
      expect(result.single.weatherDataAvailable, isFalse);
      expect(result.single.weatherDaysAvailable, 0);
    });

    test('sky+weather rule fires when both conditions true (AND), full window', () {
      final rule = const FarmingRuleRow(
        ruleId: 3,
        skyTriggerId: 1,
        weatherTriggerId: 10,
        activityId: 2,
        guidance: 'Plant now',
        verificationStatus: 'confirmed',
      );
      final weather = WeatherState(
        forecastByDayOffset: {
          0: {'rain': 1.0},
          1: {'rain': 2.0},
          2: {'rain': 0.5},
        },
        isStale: false,
      );
      final result = RuleEngine.evaluate(
        rules: [rule],
        skyTriggers: skyTriggers,
        weatherTriggers: weatherTriggers,
        sky: sky(),
        weather: weather,
      );
      expect(result.single.fires, isTrue);
      expect(result.single.weatherDaysAvailable, 3);
      expect(result.single.weatherDaysExpected, 3);
      expect(result.single.isPartialWeatherData, isFalse);
    });

    test(
        'sky+weather rule CAN fire off a single manually-logged day when the '
        'other days in the window have no forecast at all (offline-first fix)',
        () {
      final rule = const FarmingRuleRow(
        ruleId: 30,
        skyTriggerId: 1,
        weatherTriggerId: 10, // rain < 5.0 over 3 days
        activityId: 2,
        guidance: 'Plant now',
        verificationStatus: 'confirmed',
      );
      // Only today (offset 0) has data — as if the farmer manually logged
      // today's rain via WeatherLog and nothing was ever fetched/cached for
      // day 1 or day 2 (GuidanceRepository.mergeWithManualLog only ever
      // populates offset 0).
      final weather = WeatherState(
        forecastByDayOffset: {
          0: {'rain': 1.0},
        },
        isStale: true,
      );
      final result = RuleEngine.evaluate(
        rules: [rule],
        skyTriggers: skyTriggers,
        weatherTriggers: weatherTriggers,
        sky: sky(),
        weather: weather,
      );
      expect(result.single.fires, isTrue);
      expect(result.single.weatherDaysAvailable, 1);
      expect(result.single.weatherDaysExpected, 3);
      expect(result.single.isPartialWeatherData, isTrue);
    });

    test('partial weather data can also fail to match, and is still flagged partial', () {
      final rule = const FarmingRuleRow(
        ruleId: 31,
        skyTriggerId: 1,
        weatherTriggerId: 10, // rain < 5.0
        activityId: 2,
        guidance: 'Plant now',
        verificationStatus: 'confirmed',
      );
      final weather = WeatherState(
        forecastByDayOffset: {
          0: {'rain': 12.0}, // too much rain -> trigger false
        },
        isStale: true,
      );
      final result = RuleEngine.evaluate(
        rules: [rule],
        skyTriggers: skyTriggers,
        weatherTriggers: weatherTriggers,
        sky: sky(),
        weather: weather,
      );
      expect(result.single.fires, isFalse);
      expect(result.single.weatherDataAvailable, isTrue); // evaluated, just false
      expect(result.single.isPartialWeatherData, isTrue);
    });

    test('a sky-only rule never reports partial weather data', () {
      final rule = const FarmingRuleRow(
        ruleId: 32,
        skyTriggerId: 1,
        activityId: 1,
        guidance: 'sky only',
        verificationStatus: 'confirmed',
      );
      final result = RuleEngine.evaluate(
        rules: [rule],
        skyTriggers: skyTriggers,
        weatherTriggers: weatherTriggers,
        sky: sky(),
        weather: WeatherState.empty,
      );
      expect(result.single.isPartialWeatherData, isFalse);
    });

    test('rule does not fire when sky condition fails even if weather passes', () {
      final rule = const FarmingRuleRow(
        ruleId: 4,
        skyTriggerId: 1,
        weatherTriggerId: 10,
        activityId: 2,
        guidance: 'Plant now',
        verificationStatus: 'confirmed',
      );
      final weather = WeatherState(
        forecastByDayOffset: {
          0: {'rain': 1.0},
          1: {'rain': 1.0},
          2: {'rain': 1.0},
        },
        isStale: false,
      );
      final result = RuleEngine.evaluate(
        rules: [rule],
        skyTriggers: skyTriggers,
        weatherTriggers: weatherTriggers,
        sky: sky(visible: {'ORI': false}),
        weather: weather,
      );
      expect(result.single.fires, isFalse);
    });

    test('draft rules excluded when minStatus is reviewed', () {
      final rule = const FarmingRuleRow(
        ruleId: 5,
        skyTriggerId: 1,
        activityId: 1,
        guidance: 'Unverified guidance',
        verificationStatus: 'draft',
      );
      final result = RuleEngine.evaluate(
        rules: [rule],
        skyTriggers: skyTriggers,
        weatherTriggers: weatherTriggers,
        sky: sky(),
        weather: WeatherState.empty,
        minStatus: 'reviewed',
      );
      expect(result, isEmpty);
    });

    test('firingRules sorts sky-only rules before sky+weather rules', () {
      final skyOnly = const FarmingRuleRow(
        ruleId: 6,
        skyTriggerId: 1,
        activityId: 1,
        guidance: 'sky only',
        verificationStatus: 'confirmed',
      );
      final skyPlusWeather = const FarmingRuleRow(
        ruleId: 7,
        skyTriggerId: 1,
        weatherTriggerId: 10,
        activityId: 1,
        guidance: 'sky + weather',
        verificationStatus: 'confirmed',
      );
      final weather = WeatherState(
        forecastByDayOffset: {
          0: {'rain': 1.0},
          1: {'rain': 1.0},
          2: {'rain': 1.0},
        },
        isStale: false,
      );
      final evaluated = RuleEngine.evaluate(
        rules: [skyPlusWeather, skyOnly],
        skyTriggers: skyTriggers,
        weatherTriggers: weatherTriggers,
        sky: sky(),
        weather: weather,
      );
      final firing = RuleEngine.firingRules(evaluated);
      expect(firing.first.rule.ruleId, 6);
      expect(firing.last.rule.ruleId, 7);
    });

    test('crop filter excludes rules for a different crop', () {
      final rule = const FarmingRuleRow(
        ruleId: 8,
        skyTriggerId: 1,
        activityId: 1,
        cropId: 99,
        guidance: 'rice specific',
        verificationStatus: 'confirmed',
      );
      final result = RuleEngine.evaluate(
        rules: [rule],
        skyTriggers: skyTriggers,
        weatherTriggers: weatherTriggers,
        sky: sky(),
        weather: WeatherState.empty,
        cropId: 5,
      );
      expect(result, isEmpty);
    });
  });

  group('RuleEngine.evaluateWeatherTriggerDetailed', () {
    const trigger = WeatherTriggerRow(
      triggerId: 100,
      variable: 'rain',
      operator: '<',
      threshold: 5.0,
      daysAhead: 0,
      durationDays: 3,
    );

    test('null verdict when the window has no data at all', () {
      final result = RuleEngine.evaluateWeatherTriggerDetailed(trigger, WeatherState.empty);
      expect(result.matched, isNull);
      expect(result.daysAvailable, 0);
      expect(result.daysExpected, 3);
    });

    test('averages only the days that are present, skipping gaps', () {
      // Day 1 missing entirely; day 0 and day 2 present.
      final weather = WeatherState(
        forecastByDayOffset: {
          0: {'rain': 2.0},
          2: {'rain': 2.0},
        },
        isStale: false,
      );
      final result = RuleEngine.evaluateWeatherTriggerDetailed(trigger, weather);
      expect(result.matched, isTrue); // avg 2.0 < 5.0
      expect(result.daysAvailable, 2);
      expect(result.daysExpected, 3);
    });

    test('evaluateWeatherTrigger wrapper still returns the plain bool?', () {
      final weather = WeatherState(
        forecastByDayOffset: {
          0: {'rain': 20.0},
        },
        isStale: false,
      );
      expect(RuleEngine.evaluateWeatherTrigger(trigger, weather), isFalse);
    });
  });
}
