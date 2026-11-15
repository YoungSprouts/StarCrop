import 'dart:convert';
import 'dart:math' as math;
import 'package:http/http.dart' as http;

/// Fetches forecast from Open-Meteo (free, no API key) and shapes it into
/// the day-offset map RuleEngine.WeatherState expects.
class WeatherService {
  static const _baseUrl = 'https://api.open-meteo.com/v1/forecast';

  static const _dailyVars = 'precipitation_sum,precipitation_probability_max,'
      'weather_code,temperature_2m_max,temperature_2m_min,'
      'windspeed_10m_max,relative_humidity_2m_mean';

  /// Raw fetch. Throws on network failure — caller decides fallback
  /// (use cache / weather_log) since this class has no DB access.
  static Future<WeatherFetchResult> fetch({
    required double lat,
    required double lon,
    int forecastDays = 7,
  }) async {
    final uri = Uri.parse(_baseUrl).replace(queryParameters: {
      'latitude': lat.toString(),
      'longitude': lon.toString(),
      'daily': _dailyVars,
      'timezone': 'auto',
      'forecast_days': forecastDays.toString(),
    });

    final response = await http.get(uri).timeout(const Duration(seconds: 15));
    if (response.statusCode != 200) {
      throw WeatherFetchException(
          'Open-Meteo returned ${response.statusCode}: ${response.body}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final daily = json['daily'] as Map<String, dynamic>?;
    if (daily == null) {
      throw WeatherFetchException('Open-Meteo response missing "daily" block');
    }

    return WeatherFetchResult(
      forecastByDayOffset: parseDailyBlock(daily, forecastDays),
      fetchedAt: DateTime.now().toUtc(),
      rawPayload: response.body,
    );
  }

  /// How long a fetched forecast should be considered fresh before it's
  /// flagged stale in the UI. Open-Meteo updates roughly hourly; a few hours
  /// of staleness tolerance is reasonable for farming-guidance purposes.
  static Duration freshnessWindow = const Duration(hours: 6);

  static DateTime computeValidUntil(DateTime fetchedAt) =>
      fetchedAt.add(freshnessWindow);

  static bool isStale({required DateTime validUntil, DateTime? now}) {
    return (now ?? DateTime.now().toUtc()).isAfter(validUntil);
  }
}

class WeatherFetchResult {
  final Map<int, Map<String, double>> forecastByDayOffset;
  final DateTime fetchedAt;
  final String rawPayload; // store as-is into WeatherForecastCache.payloadJson

  const WeatherFetchResult({
    required this.forecastByDayOffset,
    required this.fetchedAt,
    required this.rawPayload,
  });
}

class WeatherFetchException implements Exception {
  final String message;
  WeatherFetchException(this.message);
  @override
  String toString() => 'WeatherFetchException: $message';
}

// ---------------------------------------------------------------------------
// Parsing (single source of truth — used for fresh fetches AND cached blobs)
// ---------------------------------------------------------------------------

/// Open-Meteo can return null entries inside the arrays (e.g. probability
/// beyond the model range), so every series is read as List<num?>.
List<num?> _series(Map<String, dynamic> daily, List<String> keys) {
  for (final k in keys) {
    final raw = daily[k];
    if (raw is List) return raw.map((e) => e is num ? e : null).toList();
  }
  return const [];
}

double? _at(List<num?> s, int i) => i < s.length ? s[i]?.toDouble() : null;

/// Turns Open-Meteo's `daily` block into day-offset -> values.
/// Keys: rain, temp (avg), temp_max, temp_min, wind, humidity, rain_prob, code.
/// A key is simply absent when Open-Meteo had no value for that day.
Map<int, Map<String, double>> parseDailyBlock(
    Map<String, dynamic> daily, int forecastDays) {
  final rain = _series(daily, ['precipitation_sum']);
  final prob = _series(daily, ['precipitation_probability_max']);
  final code = _series(daily, ['weather_code', 'weathercode']);
  final tMax = _series(daily, ['temperature_2m_max']);
  final tMin = _series(daily, ['temperature_2m_min']);
  final wind = _series(daily, ['windspeed_10m_max', 'wind_speed_10m_max']);
  final humidity = _series(daily, ['relative_humidity_2m_mean']);

  final available = math.max(rain.length, tMax.length);
  final days = math.min(available, forecastDays);

  final out = <int, Map<String, double>>{};
  for (int i = 0; i < days; i++) {
    final r = _at(rain, i);
    final hi = _at(tMax, i);
    final lo = _at(tMin, i);
    final w = _at(wind, i);
    final h = _at(humidity, i);
    final p = _at(prob, i);
    final c = _at(code, i);
    out[i] = {
      if (r != null) 'rain': r,
      if (hi != null && lo != null) 'temp': (hi + lo) / 2.0,
      if (hi != null) 'temp_max': hi,
      if (lo != null) 'temp_min': lo,
      if (w != null) 'wind': w,
      if (h != null) 'humidity': h,
      if (p != null) 'rain_prob': p,
      if (c != null) 'code': c,
    };
  }
  return out;
}

/// Rebuilds forecastByDayOffset from a cached payload_json blob, so the app
/// can reuse the same parsing when reading WeatherForecastCache instead of
/// hitting the network.
Map<int, Map<String, double>> parseCachedPayload(
    String payloadJson, int forecastDays) {
  final json = jsonDecode(payloadJson) as Map<String, dynamic>;
  final daily = json['daily'] as Map<String, dynamic>?;
  if (daily == null) return {};
  return parseDailyBlock(daily, forecastDays);
}

/// A cached forecast's "day 0" is the day it was downloaded, not necessarily
/// today. Shift offsets so 0 == today again and drop days already past.
/// (Uses calendar days in local time; a few hours of timezone skew between
/// device and farm location is acceptable here.)
Map<int, Map<String, double>> rebaseForecastToToday(
  Map<int, Map<String, double>> forecast,
  DateTime fetchedAt, {
  DateTime? now,
}) {
  final f = fetchedAt.toLocal();
  final n = (now ?? DateTime.now()).toLocal();
  final shift = DateTime.utc(n.year, n.month, n.day)
      .difference(DateTime.utc(f.year, f.month, f.day))
      .inDays;
  if (shift <= 0) return forecast;
  return {
    for (final e in forecast.entries)
      if (e.key - shift >= 0) e.key - shift: e.value,
  };
}
