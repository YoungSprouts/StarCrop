import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:geolocator/geolocator.dart';
import 'package:drift/drift.dart' hide Column, Table;

import '../data/reference/reference_db.dart';
import 'geocoding_service.dart';

/// Result of one GPS fix plus the place-name lookups around it. The debug
/// fields exist so LocationPromptScreen's temporary "GPS check" dialog can
/// keep showing where the label came from.
class GpsFix {
  final double lat;
  final double lon;
  final double accuracyM;
  final String label;
  final String source;
  final Place? nearest;
  final double? nearestMeters;
  final String? deviceLabel, deviceRaw, deviceErr, onlineLabel, onlineErr;

  const GpsFix({
    required this.lat,
    required this.lon,
    required this.accuracyM,
    required this.label,
    required this.source,
    required this.nearest,
    required this.nearestMeters,
    this.deviceLabel,
    this.deviceRaw,
    this.deviceErr,
    this.onlineLabel,
    this.onlineErr,
  });
}

/// GPS fix + reverse geocoding, shared by the first-run location prompt and
/// the Settings "Location" section. Throws an [Exception] with a
/// farmer-readable message when GPS is off or permission is denied.
class GpsLocationService {
  static Future<GpsFix> locate(ReferenceDb referenceDb) async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are off. Enable GPS or enter your location manually.');
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw Exception('Location permission denied. Enter your location manually instead.');
    }

    // High accuracy = real GPS, not just cell-tower/Wi-Fi (which can be
    // 10-20 km off and put a farm in the wrong town). Time-limited so it
    // can't spin forever indoors.
    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 25),
      ),
    );
    debugPrint('[GPS] fix lat=${position.latitude} lon=${position.longitude} '
        'accuracy=${position.accuracy.round()}m');

    // Three lookups run concurrently:
    //  1. The phone's own geocoder: best coverage of small PH towns.
    //  2. Nominatim / OpenStreetMap: second choice.
    //  3. Offline nearest-place match against the seeded Places table: last
    //     resort for the label, and the source of placeId/timezoneId.
    String? deviceLabel, deviceRaw, deviceErr, onlineLabel, onlineErr;

    final deviceFuture = _deviceGeocode(position.latitude, position.longitude).then((r) {
      deviceLabel = r.label;
      deviceRaw = r.raw;
    }).catchError((Object e) {
      deviceErr = '$e';
      debugPrint('[GPS] device geocoder failed: $e');
    });
    final onlineFuture = GeocodingService.reverseGeocode(
      lat: position.latitude,
      lon: position.longitude,
    ).then((label) {
      onlineLabel = label;
    }).catchError((Object e) {
      onlineErr = '$e';
      debugPrint('[GPS] Nominatim failed: $e');
    });
    final nearestFuture = _findNearestPlace(referenceDb, position.latitude, position.longitude);

    await Future.wait([deviceFuture, onlineFuture]);
    final nearestHit = await nearestFuture;
    final nearest = nearestHit?.place;

    // The offline match is only the nearest of a handful of seeded cities,
    // so it must not be shown as the user's actual town: close enough ->
    // the name, farther -> "Near ...", far -> raw coordinates.
    String? offlineLabel;
    if (nearest != null && nearestHit != null) {
      final base =
          [nearest.name, nearest.province].where((s) => s != null && s.isNotEmpty).join(', ');
      final km = nearestHit.meters / 1000;
      if (km <= 3) {
        offlineLabel = base;
      } else if (km <= 50) {
        offlineLabel = 'Near $base';
      }
    }

    final String source;
    final String label;
    if (deviceLabel != null) {
      source = 'phone geocoder';
      label = deviceLabel!;
    } else if (onlineLabel != null) {
      source = 'Nominatim (online)';
      label = onlineLabel!;
    } else if (offlineLabel != null) {
      source = 'offline seed list (approximate)';
      label = offlineLabel;
    } else {
      source = 'raw coordinates';
      label = '${position.latitude.toStringAsFixed(4)}°, '
          '${position.longitude.toStringAsFixed(4)}°';
    }
    debugPrint('[GPS] label="$label" source=$source');

    return GpsFix(
      lat: position.latitude,
      lon: position.longitude,
      accuracyM: position.accuracy,
      label: label,
      source: source,
      nearest: nearest,
      nearestMeters: nearestHit?.meters,
      deviceLabel: deviceLabel,
      deviceRaw: deviceRaw,
      deviceErr: deviceErr,
      onlineLabel: onlineLabel,
      onlineErr: onlineErr,
    );
  }

  static Future<({String? label, String raw})> _deviceGeocode(double lat, double lon) async {
    final marks =
        await geo.placemarkFromCoordinates(lat, lon).timeout(const Duration(seconds: 8));
    if (marks.isEmpty) return (label: null, raw: 'no placemarks returned');

    final p = marks.first;
    final raw = 'locality=${p.locality} | subLocality=${p.subLocality} | '
        'subAdmin=${p.subAdministrativeArea} | admin=${p.administrativeArea}';

    String? pick(List<String?> options) {
      for (final o in options) {
        if (o != null && o.trim().isNotEmpty) return o.trim();
      }
      return null;
    }

    final town = pick([p.locality, p.subLocality]);
    final province = pick([p.subAdministrativeArea, p.administrativeArea]);
    final parts = <String>[];
    if (town != null) parts.add(town);
    if (province != null && province != town) parts.add(province);
    return (label: parts.isEmpty ? null : parts.join(', '), raw: raw);
  }

  /// Nearest-neighbor scan over the offline seed table.
  static Future<({Place place, double meters})?> _findNearestPlace(
      ReferenceDb referenceDb, double lat, double lon) async {
    final places = await referenceDb.select(referenceDb.places).get();

    Place? nearest;
    double nearestDistanceM = double.infinity;
    for (final place in places) {
      final d = Geolocator.distanceBetween(lat, lon, place.lat, place.lon);
      if (d < nearestDistanceM) {
        nearestDistanceM = d;
        nearest = place;
      }
    }
    return nearest == null ? null : (place: nearest, meters: nearestDistanceM);
  }
}
