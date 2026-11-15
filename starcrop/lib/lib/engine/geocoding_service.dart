import 'dart:convert';
import 'package:http/http.dart' as http;

/// Best-effort reverse geocoding via Nominatim (OpenStreetMap's free reverse
/// endpoint, no API key needed) — used to upgrade a GPS fix's saved label
/// from "nearest of the ~dozen offline seed places" to the actual locality
/// name when the device has connectivity.
///
/// Offline is the *expected* case out in a field, not an edge case, so this
/// throws on any network failure/timeout/bad response rather than trying to
/// paper over it — the caller (LocationPromptScreen) always has the offline
/// nearest-place lookup as its fallback and decides when to use it. Mirrors
/// WeatherService.fetch's contract for the same reason.
class GeocodingService {
  static const _baseUrl = 'https://nominatim.openstreetmap.org/reverse';

  static Future<String> reverseGeocode({
    required double lat,
    required double lon,
    Duration timeout = const Duration(seconds: 6),
  }) async {
    final uri = Uri.parse(_baseUrl).replace(queryParameters: {
      'format': 'jsonv2',
      'lat': lat.toString(),
      'lon': lon.toString(),
      'zoom': '14', // town/village level — not house-number precision
      'addressdetails': '1',
    });

    // Nominatim's usage policy requires a descriptive User-Agent identifying
    // the calling app in place of an API key.
    final response = await http
        .get(uri, headers: {'User-Agent': 'StarCrop-FarmingApp/1.0'})
        .timeout(timeout);

    if (response.statusCode != 200) {
      throw GeocodingException('Nominatim returned ${response.statusCode}: ${response.body}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final label = parseReverseGeocodeLabel(json);
    if (label == null) {
      throw GeocodingException('Nominatim response had no usable address for $lat,$lon');
    }
    return label;
  }
}

class GeocodingException implements Exception {
  final String message;
  GeocodingException(this.message);
  @override
  String toString() => 'GeocodingException: $message';
}

// ---------------------------------------------------------------------------
// Parsing (isolated from the network call so it's unit-testable on its own,
// same split as weather_service.dart's parseDailyBlock)
// ---------------------------------------------------------------------------

/// Picks the most locality-specific name Nominatim offers and pairs it with
/// the containing province/state — e.g. "Kalibo, Aklan" — matching the
/// "Town, Province" shape the offline Places table already produces, so a
/// label looks the same to the user regardless of which source resolved it.
String? parseReverseGeocodeLabel(Map<String, dynamic> json) {
  final address = json['address'] as Map<String, dynamic>?;
  if (address == null) return null;

  const localityKeys = ['village', 'town', 'city', 'municipality', 'county', 'suburb'];
  const provinceKeys = ['state', 'province', 'region'];

  String? firstNonEmpty(List<String> keys) {
    for (final k in keys) {
      final v = address[k];
      if (v is String && v.trim().isNotEmpty) return v.trim();
    }
    return null;
  }

  final locality = firstNonEmpty(localityKeys);
  final province = firstNonEmpty(provinceKeys);

  final parts = [locality, province].whereType<String>().toList();
  if (parts.isNotEmpty) return parts.join(', ');

  // Nothing locality-shaped came back — fall back to Nominatim's own summary
  // string rather than reporting failure outright.
  final display = json['display_name'];
  return (display is String && display.trim().isNotEmpty) ? display.trim() : null;
}
