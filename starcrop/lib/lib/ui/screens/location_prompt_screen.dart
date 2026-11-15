import 'package:drift/drift.dart' hide Column, Table;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../data/reference/reference_db.dart';
import '../../data/user/user_db.dart';
import '../../engine/gps_location_service.dart';
import '../theme/app_theme.dart';
import '../theme/app_assets.dart';
import '../home_screen.dart';
import 'location_search_screen.dart';

/// TEMPORARY: shows a pop-up after each GPS fix with the coordinates, the
/// accuracy and where the place name came from, so a wrong label can be
/// diagnosed with a screenshot. Set to false (or delete the dialog call)
/// once the GPS label is confirmed working.
const bool _showGpsDebug = true;

/// "Where is your farm?" — GPS or manual entry. Matches LOCATION PROMPT
/// mockup: white card, dark-green GPS button, outlined search button.
class LocationPromptScreen extends StatefulWidget {
  const LocationPromptScreen({super.key});

  @override
  State<LocationPromptScreen> createState() => _LocationPromptScreenState();
}

class _LocationPromptScreenState extends State<LocationPromptScreen> {
  bool _loadingGps = false;
  String? _error;


  Future<void> _useCurrentLocation() async {
    setState(() {
      _loadingGps = true;
      _error = null;
    });
    try {
      final fix = await GpsLocationService.locate(context.read<ReferenceDb>());
      final nearest = fix.nearest;

      if (_showGpsDebug && mounted) {
        await showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => AlertDialog(
            title: const Text('GPS check'),
            content: SingleChildScrollView(
              child: SelectableText(
                'Coordinates: ${fix.lat.toStringAsFixed(5)}, '
                '${fix.lon.toStringAsFixed(5)}\n'
                'Accuracy: ${fix.accuracyM.round()} m\n\n'
                'Saved label: ${fix.label}\n'
                'Source: ${fix.source}\n\n'
                'Phone geocoder: ${fix.deviceLabel ?? 'failed'}\n'
                '${fix.deviceRaw != null ? '  (${fix.deviceRaw})\n' : ''}'
                '${fix.deviceErr != null ? '  error: ${fix.deviceErr}\n' : ''}'
                'Nominatim: ${fix.onlineLabel ?? 'failed'}\n'
                '${fix.onlineErr != null ? '  error: ${fix.onlineErr}\n' : ''}'
                'Nearest seeded place: ${nearest?.name ?? '-'}'
                '${fix.nearestMeters == null ? '' : ' (${(fix.nearestMeters! / 1000).toStringAsFixed(1)} km away)'}',
                style: const TextStyle(fontSize: 13, height: 1.4),
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Continue')),
            ],
          ),
        );
      }

      if (!mounted) return;
      final userDb = context.read<UserDb>();
      await userDb.insertAndActivateLocation(
        SavedLocationsCompanion.insert(
          locationId: const Uuid().v4(),
          label: fix.label,
          lat: fix.lat,
          lon: fix.lon,
          placeId: nearest == null ? const Value.absent() : Value(nearest.geonameId),
          timezoneId: nearest == null ? const Value.absent() : Value(nearest.timezoneId),
        ),
      );

      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } catch (e) {
      if (mounted) setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _loadingGps = false);
    }
  }

  void _enterManually() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const LocationSearchScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              IconButton(
                onPressed: () => Navigator.of(context).maybePop(),
                icon: Image.asset(AppIcons.chevronLeftDark, width: 20, height: 20),
              ),
              const Spacer(flex: 3),
              const Text(
                'Where is your farm?',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.forestGreen,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Enter your location or use your current location.',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  color: AppColors.gray,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _loadingGps ? null : _useCurrentLocation,
                  icon: _loadingGps
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Image.asset(AppIcons.locationPinWhite, width: 20, height: 20),
                  label: const Text('Use current location (GPS)'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _loadingGps ? null : _enterManually,
                  icon: Image.asset(AppIcons.searchDark, width: 20, height: 20),
                  label: const Text('Enter location'),
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: 16),
                Text(
                  _error!,
                  style: const TextStyle(color: Colors.redAccent, fontSize: 13),
                ),
              ],
              const Spacer(flex: 6),
            ],
          ),
        ),
      ),
    );
  }
}
