import 'package:starcrop/engine/weather_codes.dart';
import 'package:starcrop/engine/weather_service.dart';
import 'package:test/test.dart';

void main() {
  group('WeatherService', () {
    test('parseCachedPayload extracts rain/temp/wind/humidity by day offset', () {
      const payload = '''
      {
        "daily": {
          "precipitation_sum": [0.0, 5.2, 12.0],
          "temperature_2m_max": [30.0, 29.0, 27.0],
          "temperature_2m_min": [22.0, 21.0, 20.0],
          "windspeed_10m_max": [10.0, 15.0, 20.0],
          "relative_humidity_2m_mean": [70.0, 75.0, 80.0]
        }
      }
      ''';
      final parsed = parseCachedPayload(payload, 3);
      expect(parsed[0]!['rain'], 0.0);
      expect(parsed[1]!['rain'], 5.2);
      expect(parsed[0]!['temp'], 26.0); // (30+22)/2
      expect(parsed[2]!['wind'], 20.0);
      expect(parsed[2]!['humidity'], 80.0);
    });

    test('parseCachedPayload returns empty map when daily block missing', () {
      final parsed = parseCachedPayload('{}', 3);
      expect(parsed, isEmpty);
    });

    test('parse exposes rain probability, weather code and min/max temp', () {
      const payload = '''
      {
        "daily": {
          "precipitation_sum": [1.0, 0.0],
          "precipitation_probability_max": [60, 20],
          "weather_code": [61, 2],
          "temperature_2m_max": [30.0, 31.0],
          "temperature_2m_min": [24.0, 25.0]
        }
      }
      ''';
      final parsed = parseCachedPayload(payload, 2);
      expect(parsed[0]!['rain_prob'], 60.0);
      expect(parsed[1]!['rain_prob'], 20.0);
      expect(parsed[0]!['code'], 61.0);
      expect(parsed[0]!['temp_max'], 30.0);
      expect(parsed[1]!['temp_min'], 25.0);
    });

    test('parse accepts legacy "weathercode" key', () {
      const payload = '{"daily":{"precipitation_sum":[0.0],"weathercode":[3]}}';
      expect(parseCachedPayload(payload, 1)[0]!['code'], 3.0);
    });

    test('parse tolerates null entries and omits those keys', () {
      const payload = '''
      {
        "daily": {
          "precipitation_sum": [0.0, null],
          "precipitation_probability_max": [10, null],
          "temperature_2m_max": [30.0, 29.0],
          "temperature_2m_min": [22.0, null]
        }
      }
      ''';
      final parsed = parseCachedPayload(payload, 2);
      expect(parsed[0]!['rain_prob'], 10.0);
      expect(parsed[1]!.containsKey('rain'), isFalse);
      expect(parsed[1]!.containsKey('rain_prob'), isFalse);
      expect(parsed[1]!.containsKey('temp'), isFalse); // min missing
      expect(parsed[1]!['temp_max'], 29.0);
    });

    test('isStale returns true when now is past validUntil', () {
      final validUntil = DateTime.utc(2026, 9, 23, 12, 0, 0);
      final now = DateTime.utc(2026, 9, 23, 18, 0, 0);
      expect(WeatherService.isStale(validUntil: validUntil, now: now), isTrue);
    });

    test('isStale returns false when now is before validUntil', () {
      final validUntil = DateTime.utc(2026, 9, 23, 12, 0, 0);
      final now = DateTime.utc(2026, 9, 23, 6, 0, 0);
      expect(WeatherService.isStale(validUntil: validUntil, now: now), isFalse);
    });

    test('computeValidUntil adds the freshness window', () {
      final fetchedAt = DateTime.utc(2026, 9, 23, 12, 0, 0);
      final validUntil = WeatherService.computeValidUntil(fetchedAt);
      expect(validUntil.difference(fetchedAt), WeatherService.freshnessWindow);
    });
  });

  group('rebaseForecastToToday', () {
    final forecast = {
      0: {'rain': 1.0},
      1: {'rain': 2.0},
      2: {'rain': 3.0},
    };

    test('same day: unchanged', () {
      final r = rebaseForecastToToday(
        forecast,
        DateTime(2026, 9, 24, 6),
        now: DateTime(2026, 9, 24, 20),
      );
      expect(r.keys, [0, 1, 2]);
    });

    test('one day old: shifts offsets down by one', () {
      final r = rebaseForecastToToday(
        forecast,
        DateTime(2026, 9, 23, 6),
        now: DateTime(2026, 9, 24, 9),
      );
      expect(r.keys.toList()..sort(), [0, 1]);
      expect(r[0]!['rain'], 2.0);
    });

    test('older than the forecast window: empty', () {
      final r = rebaseForecastToToday(
        forecast,
        DateTime(2026, 9, 10),
        now: DateTime(2026, 9, 24),
      );
      expect(r, isEmpty);
    });
  });

  group('weather codes', () {
    test('clear -> sun, rain -> rain icon, unknown -> cloudy', () {
      expect(weatherConditionKey(0), 'sun');
      expect(weatherConditionKey(63), 'light_rain');
      expect(weatherConditionKey(999), 'cloudy');
      expect(weatherConditionKey(null), 'cloudy');
    });

    test('labels', () {
      expect(weatherLabel(0), 'Clear skies');
      expect(weatherLabel(61), 'Light rain');
    });
  });
}
