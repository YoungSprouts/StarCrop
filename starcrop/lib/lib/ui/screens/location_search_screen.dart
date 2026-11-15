import 'package:drift/drift.dart' hide Column, Table;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' show OrderingTerm, Value;
import 'package:uuid/uuid.dart';

import '../../data/reference/reference_db.dart';
import '../../data/user/user_db.dart';
import '../theme/app_theme.dart';
import '../theme/app_assets.dart';
import '../home_screen.dart';

/// Typed-location fallback for when GPS isn't available or wanted. Searches
/// the shipped Places table (GeoNames-based, offline) by name substring.
class LocationSearchScreen extends StatefulWidget {
  const LocationSearchScreen({super.key});

  @override
  State<LocationSearchScreen> createState() => _LocationSearchScreenState();
}

class _LocationSearchScreenState extends State<LocationSearchScreen> {
  final _controller = TextEditingController();
  List<Place> _results = [];
  bool _searching = false;

  Future<void> _search(String query) async {
    if (query.trim().length < 2) {
      setState(() => _results = []);
      return;
    }
    setState(() => _searching = true);
    final db = context.read<ReferenceDb>();
    final rows = await (db.select(db.places)
          ..where((t) => t.name.like('%$query%'))
          ..orderBy([(t) => OrderingTerm.desc(t.population)])
          ..limit(20))
        .get();
    if (!mounted) return;
    setState(() {
      _results = rows;
      _searching = false;
    });
  }

  Future<void> _selectPlace(Place place) async {
    final userDb = context.read<UserDb>();
    // insertAndActivateLocation (not a raw insert) also deactivates any
    // previously saved location, so this manually-entered place becomes the
    // one every screen reads back as "current".
    await userDb.insertAndActivateLocation(
      SavedLocationsCompanion.insert(
        locationId: const Uuid().v4(),
        label: place.name,
        lat: place.lat,
        lon: place.lon,
        placeId: Value(place.geonameId),
        timezoneId: Value(place.timezoneId),
      ),
    );
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
      (route) => false,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.forestGreen,
        elevation: 0,
        title: const Text(
          'Enter location',
          style: TextStyle(color: AppColors.forestGreen, fontWeight: FontWeight.w600),
        ),
        iconTheme: const IconThemeData(color: AppColors.forestGreen),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              autofocus: true,
              onChanged: _search,
              decoration: InputDecoration(
                hintText: 'Search town or province',
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Image.asset(AppIcons.searchDark, width: 18, height: 18),
                ),
                filled: true,
                fillColor: AppColors.grayLight3,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_searching) const LinearProgressIndicator(color: AppColors.gold),
            Expanded(
              child: ListView.separated(
                itemCount: _results.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, i) {
                  final p = _results[i];
                  return ListTile(
                    leading: Image.asset(AppIcons.locationPinDark, width: 20, height: 20),
                    title: Text(p.name),
                    subtitle: Text([p.province, p.country]
                        .where((s) => s != null && s.isNotEmpty)
                        .join(', ')),
                    onTap: () => _selectPlace(p),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
