import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:uuid/uuid.dart';

import '../../data/reference/reference_db.dart';
import '../../data/user/user_db.dart';
import '../../data/farming/farming_db.dart' as fdb;
import '../../engine/gps_location_service.dart';
import '../theme/app_assets.dart';
import '../theme/app_theme.dart';
import 'location_search_screen.dart';

/// Settings screen — writes to UserDb.UserSettings (key/value rows: language,
/// units, text_scale, sky culture, region_id, ar_overlay_mode).
/// GuidanceRepository.currentLanguage() and i18n_text.dart already read the
/// 'language' key; main.dart's MaterialApp.builder reads 'text_scale' the
/// same way, live, so changing it here takes effect immediately without a
/// restart. camera_check_screen.dart reads 'ar_overlay_mode' once on open.
///
/// 'akl' (Aklanon) content is a best-effort draft, unlike 'en'/'fil' — see
/// starcrop_seed_loader.dart's doc comment. Flag this to farmers/reviewers
/// before treating it as accurate.
class UserSettingsScreen extends StatefulWidget {
  const UserSettingsScreen({super.key});

  @override
  State<UserSettingsScreen> createState() => _UserSettingsScreenState();
}

class _UserSettingsScreenState extends State<UserSettingsScreen> {
  static const _languages = {
    'en': 'English',
    'fil': 'Filipino',
    'akl': 'Aklanon',
  };
  static const _units = {'metric': 'Metric (°C, mm)', 'imperial': 'Imperial (°F, in)'};

  // Camera Check's overlay behavior — see camera_check_screen.dart's class
  // doc comment for what each mode actually does.
  static const _overlayModes = {
    'always': 'Always show constellation lines',
    'reveal': 'Reveal when aimed (reticle)',
  };

  // Values are read directly as the MediaQuery text scale factor by
  // main.dart's MaterialApp.builder — keep these in sync with any tuning
  // there.
  static const _textScales = {
    '0.9': 'Small',
    '1.0': 'Default',
    '1.15': 'Large',
    '1.3': 'Extra Large',
  };

  bool _loading = true;
  bool _saving = false;
  String _language = 'en';
  String _units_ = 'metric';
  String _textScale = '1.0';
  String _overlayMode = 'always';
  int? _regionId;
  List<fdb.Region> _regions = const [];
  SavedLocation? _location;
  bool _locatingGps = false;
  String? _locationError;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final userDb = context.read<UserDb>();
    final farmingDb = context.read<fdb.FarmingDb>();

    final rows = await userDb.select(userDb.userSettings).get();
    final byKey = {for (final r in rows) r.key: r.value};
    final regions = await farmingDb.select(farmingDb.regions).get();
    final location = await userDb.activeLocation();

    if (!mounted) return;
    setState(() {
      _language = byKey['language'] ?? 'en';
      _units_ = byKey['units'] ?? 'metric';
      _textScale = byKey['text_scale'] ?? '1.0';
      _overlayMode = byKey['ar_overlay_mode'] ?? 'always';
      _regionId = int.tryParse(byKey['region_id'] ?? '');
      _regions = regions;
      _location = location;
      _loading = false;
    });
  }

  Future<void> _saveKey(String key, String value) async {
    final userDb = context.read<UserDb>();
    await userDb.into(userDb.userSettings).insertOnConflictUpdate(
          UserSettingsCompanion.insert(key: key, value: value),
        );
  }

  Future<void> _setLanguage(String value) async {
    setState(() {
      _language = value;
      _saving = true;
    });
    await _saveKey('language', value);
    if (mounted) setState(() => _saving = false);
  }

  Future<void> _setUnits(String value) async {
    setState(() {
      _units_ = value;
      _saving = true;
    });
    await _saveKey('units', value);
    if (mounted) setState(() => _saving = false);
  }

  Future<void> _setTextScale(String value) async {
    setState(() {
      _textScale = value;
      _saving = true;
    });
    await _saveKey('text_scale', value);
    if (mounted) setState(() => _saving = false);
  }

  Future<void> _setOverlayMode(String value) async {
    setState(() {
      _overlayMode = value;
      _saving = true;
    });
    await _saveKey('ar_overlay_mode', value);
    if (mounted) setState(() => _saving = false);
  }

  Future<void> _setRegion(int? regionId) async {
    setState(() {
      _regionId = regionId;
      _saving = true;
    });
    await _saveKey('region_id', regionId?.toString() ?? '');
    if (mounted) setState(() => _saving = false);
  }

  /// Re-fixes the location from GPS and makes it the active one. Stays on
  /// the Settings screen; Home reloads when Settings is popped.
  Future<void> _useGps() async {
    setState(() {
      _locatingGps = true;
      _locationError = null;
    });
    try {
      final fix = await GpsLocationService.locate(context.read<ReferenceDb>());
      if (!mounted) return;
      final userDb = context.read<UserDb>();
      final nearest = fix.nearest;
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
      final updated = await userDb.activeLocation();
      if (!mounted) return;
      setState(() => _location = updated);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location updated to ${fix.label}')),
      );
    } catch (e) {
      if (mounted) {
        setState(() => _locationError = e.toString().replaceFirst('Exception: ', ''));
      }
    } finally {
      if (mounted) setState(() => _locatingGps = false);
    }
  }

  /// LocationSearchScreen saves the picked place and then resets the stack
  /// to HomeScreen, so there is nothing to refresh here afterwards.
  void _searchManually() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const LocationSearchScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: Image.asset(AppIcons.chevronLeftWhite, width: 18, height: 18),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                if (_saving) const LinearProgressIndicator(color: AppColors.gold),
                const SizedBox(height: 12),
                const _SectionLabel('Location'),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.grayLight3,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Image.asset(AppIcons.locationPinDark, width: 20, height: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _location?.label ?? 'No location set',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppColors.forestGreen,
                              ),
                            ),
                            if (_location != null)
                              Text(
                                '${_location!.lat.toStringAsFixed(4)}°, '
                                '${_location!.lon.toStringAsFixed(4)}°',
                                style: const TextStyle(fontSize: 12, color: AppColors.gray),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _locatingGps ? null : _useGps,
                    icon: _locatingGps
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Image.asset(AppIcons.locationPinWhite, width: 20, height: 20),
                    label: Text(_locatingGps ? 'Finding location…' : 'Use current location (GPS)'),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _locatingGps ? null : _searchManually,
                    icon: Image.asset(AppIcons.searchDark, width: 20, height: 20),
                    label: const Text('Enter location manually'),
                  ),
                ),
                if (_locationError != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    _locationError!,
                    style: const TextStyle(color: Colors.redAccent, fontSize: 13),
                  ),
                ],
                const SizedBox(height: 24),
                const _SectionLabel('Language'),
                _OptionGroup<String>(
                  value: _language,
                  options: _languages,
                  onChanged: _setLanguage,
                ),
                const SizedBox(height: 24),
                const _SectionLabel('Text Size'),
                _OptionGroup<String>(
                  value: _textScale,
                  options: _textScales,
                  onChanged: _setTextScale,
                ),
                const SizedBox(height: 24),
                const _SectionLabel('Units'),
                _OptionGroup<String>(
                  value: _units_,
                  options: _units,
                  onChanged: _setUnits,
                ),
                const SizedBox(height: 24),
                const _SectionLabel('Camera Check Overlay'),
                const SizedBox(height: 8),
                const Text(
                  "How Camera Check shows predicted constellations. \"Always "
                  "show\" draws every visible constellation continuously. "
                  "\"Reveal when aimed\" keeps the screen clear and shows a "
                  "circle that turns green once you're pointed at one, then "
                  "draws it in with its name.",
                  style: TextStyle(fontSize: 12, color: AppColors.gray),
                ),
                const SizedBox(height: 10),
                _OptionGroup<String>(
                  value: _overlayMode,
                  options: _overlayModes,
                  onChanged: _setOverlayMode,
                ),
                const SizedBox(height: 24),
                const _SectionLabel('Region'),
                const SizedBox(height: 8),
                const Text(
                  'Used to filter farming guidance to rules written for your area. '
                  'Leave unset to see guidance from every region.',
                  style: TextStyle(fontSize: 12, color: AppColors.gray),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.grayLight3,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int?>(
                      isExpanded: true,
                      value: _regionId,
                      hint: const Text('All regions'),
                      items: [
                        const DropdownMenuItem<int?>(value: null, child: Text('All regions')),
                        for (final r in _regions)
                          DropdownMenuItem<int?>(value: r.regionId, child: Text(r.name)),
                      ],
                      onChanged: _setRegion,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: AppColors.forestGreen,
      ),
    );
  }
}

class _OptionGroup<T> extends StatelessWidget {
  final T value;
  final Map<T, String> options;
  final ValueChanged<T> onChanged;

  const _OptionGroup({
    required this.value,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final entry in options.entries)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Material(
              color: value == entry.key ? AppColors.forestGreen : AppColors.grayLight3,
              borderRadius: BorderRadius.circular(14),
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () => onChanged(entry.key),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      Icon(
                        value == entry.key
                            ? Icons.radio_button_checked
                            : Icons.radio_button_unchecked,
                        color: value == entry.key ? Colors.white : AppColors.gray,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        entry.value,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: value == entry.key ? Colors.white : AppColors.forestGreen,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
