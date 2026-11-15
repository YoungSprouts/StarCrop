import 'dart:io';
import 'package:drift/drift.dart' hide Column, Table;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/reference/reference_db.dart';
import '../../data/farming/farming_db.dart' as fdb;
import '../../data/user/user_db.dart';
import '../../engine/constellation_figure_layout.dart';
import '../../repository/sky_repository.dart';
import '../format_utils.dart';
import '../theme/app_theme.dart';
import '../theme/app_assets.dart';
import '../widgets/identified_constellation_overlay.dart';

/// "About" + "In Season" detail view for one constellation. Matches the
/// SKY CHART detail mockup (image card, name, About, In Season w/ crop icon).
///
/// If the farmer has a confirmed Camera Check photo of this specific
/// constellation (PhotoResults.matchedConstCode — see camera_check_screen's
/// _captureAndMatch and SkyRepository.nearestConstellationCode), that photo
/// replaces the static Taurus asset / generic placeholder as the hero image,
/// with the constellation drawn on top as a finished, static figure. The
/// figure comes from ConstellationFigureLayout, so it doesn't depend on the
/// camera's FOV or the heading/pitch recorded at capture time — the
/// constellation is already identified, so only its shape is needed. No
/// name label is drawn on it; the name is already shown below.
class ConstellationDetailScreen extends StatefulWidget {
  final String constCode;
  const ConstellationDetailScreen({super.key, required this.constCode});

  @override
  State<ConstellationDetailScreen> createState() => _ConstellationDetailScreenState();
}

/// The confirmed photo for this constellation, if one exists, plus its
/// figure. [figure] is null if it couldn't be built (e.g. the saved
/// location was later deleted) — the photo itself still displays either way.
class _MatchedPhoto {
  final String filePath;
  final double confidence;
  final DateTime takenAt;
  final ConstellationFigure? figure;
  final String result; // 'confirmed' or 'unclear' — never 'failed' (see _loadMatchedPhoto)

  const _MatchedPhoto({
    required this.filePath,
    required this.confidence,
    required this.takenAt,
    required this.result,
    this.figure,
  });
}

class _ConstellationDetailScreenState extends State<ConstellationDetailScreen> {
  Constellation? _constellation;
  List<String> _inSeasonCrops = [];
  _MatchedPhoto? _matchedPhoto;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final refDb = context.read<ReferenceDb>();
    final farmingDb = context.read<fdb.FarmingDb>();
    final userDb = context.read<UserDb>();

    final c = await (refDb.select(refDb.constellations)
          ..where((t) => t.code.equals(widget.constCode)))
        .getSingleOrNull();

    // Sky trigger(s) referencing this constellation -> rules -> plant-type
    // activities -> crop names. Empty until farming DB is seeded — handled
    // gracefully below rather than crashing.
    final triggers = await (farmingDb.select(farmingDb.skyTriggers)
          ..where((t) => t.constCode.equals(widget.constCode)))
        .get();
    final triggerIds = triggers.map((t) => t.triggerId).toList();

    final crops = <String>[];
    if (triggerIds.isNotEmpty) {
      final rules = await (farmingDb.select(farmingDb.farmingRules)
            ..where((t) => t.skyTriggerId.isIn(triggerIds)))
          .get();
      for (final rule in rules) {
        if (rule.cropId == null) continue;
        final activity = await (farmingDb.select(farmingDb.activities)
              ..where((t) => t.activityId.equals(rule.activityId)))
            .getSingleOrNull();
        if (activity?.activityType != 'plant') continue;
        final crop = await (farmingDb.select(farmingDb.crops)
              ..where((t) => t.cropId.equals(rule.cropId!)))
            .getSingleOrNull();
        if (crop != null) crops.add(crop.name);
      }
    }

    final matchedPhoto = await _loadMatchedPhoto(userDb);

    if (!mounted) return;
    setState(() {
      _constellation = c;
      _inSeasonCrops = crops.toSet().toList();
      _matchedPhoto = matchedPhoto;
      _loading = false;
    });
  }

  /// Looks up the most recent confirmed photo whose identified constellation
  /// (PhotoResults.matchedConstCode) matches this screen's constCode, and if
  /// found, builds its figure — laid out from the constellation's lines as
  /// they were *at capture time* (sidereal motion means "now" would give a
  /// differently tilted figure than the one the farmer actually photographed).
  Future<_MatchedPhoto?> _loadMatchedPhoto(UserDb userDb) async {
    // Matching is purely location/Hipparcos-based (see
    // camera_check_screen.dart's _captureAndMatch): matchedConstCode is set
    // as soon as *some* seeded constellation is found near the pointing
    // direction, and result is only ever 'failed' when none was. So any
    // non-'failed' row with this constCode is a real match for this
    // constellation — 'confirmed' (plenty of its bright stars were in
    // frame) and 'unclear' (fewer were, but it's still the right patch of
    // sky) both qualify; only excluding 'failed' rows, which never carry a
    // matchedConstCode in the first place.
    final query = userDb.select(userDb.photoResults).join([
      innerJoin(
        userDb.photoObservations,
        userDb.photoObservations.obsId.equalsExp(userDb.photoResults.obsId),
      ),
    ])
      ..where(userDb.photoResults.matchedConstCode.equals(widget.constCode))
      ..orderBy([OrderingTerm.desc(userDb.photoObservations.takenAt)])
      ..limit(1);

    final row = await query.getSingleOrNull();
    if (row == null) return null;

    final obs = row.readTable(userDb.photoObservations);
    final res = row.readTable(userDb.photoResults);

    final fallback = _MatchedPhoto(
      filePath: obs.filePath,
      confidence: res.confidence ?? 0.0,
      takenAt: obs.takenAt,
      result: res.result ?? 'unclear',
    );

    final loc = await (userDb.select(userDb.savedLocations)
          ..where((t) => t.locationId.equals(obs.locationId)))
        .getSingleOrNull();
    if (loc == null) return fallback; // location since deleted — can't lay out the figure

    try {
      final skyRepo = context.read<SkyRepository>();
      // obs.takenAt was stored via plain `DateTime.now()` (local time) in
      // camera_check_screen.dart. Drift stores that as an instant and hands
      // it back as a local DateTime, and AstroEngine reads a DateTime's
      // fields as UTC — so convert with .toUtc() here, otherwise the sky is
      // computed for the wrong hour (off by the device's UTC offset).
      final lines = await skyRepo.constellationLinesAbove(
        latDeg: loc.lat,
        lonDeg: loc.lon,
        utc: obs.takenAt.toUtc(),
      );
      final figure = ConstellationFigureLayout.fromLines(
        lines.where((l) => l.constCode == widget.constCode).toList(),
      );
      return _MatchedPhoto(
        filePath: obs.filePath,
        confidence: res.confidence ?? 0.0,
        takenAt: obs.takenAt,
        result: res.result ?? 'unclear',
        figure: figure.isEmpty ? null : figure,
      );
    } catch (_) {
      return fallback;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTaurus = widget.constCode.toUpperCase() == 'TAU';
    final matched = _matchedPhoto;

    return Scaffold(
      backgroundColor: AppColors.forestGreen,
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.gold))
          : Column(
              children: [
                SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Image.asset(AppIcons.chevronLeftWhite, width: 18, height: 18),
                          onPressed: () => Navigator.of(context).maybePop(),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: matched != null
                        ? SizedBox(
                            height: 240,
                            width: double.infinity,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.file(File(matched.filePath), fit: BoxFit.cover),
                                if (matched.figure != null)
                                  IdentifiedConstellationOverlay(
                                    figure: matched.figure!,
                                    animate: false,
                                  ),
                              ],
                            ),
                          )
                        : isTaurus
                            ? Image.asset(AppImages.taurusDetail,
                                height: 240, width: double.infinity, fit: BoxFit.cover)
                            : Container(
                                height: 240,
                                width: double.infinity,
                                color: Colors.black,
                                child: const Center(
                                  child: Icon(Icons.auto_awesome, color: AppColors.gold, size: 48),
                                ),
                              ),
                  ),
                ),
                if (matched != null) ...[
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        matched.result == 'confirmed'
                            ? Image.asset(AppIcons.verified, width: 16, height: 16)
                            : const Icon(Icons.help_outline, size: 16, color: Colors.white70),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            (matched.result == 'confirmed'
                                    ? 'Confirmed from your photo · '
                                    : 'Matched from your photo · ') +
                                '${(matched.confidence * 100).round()}% match · '
                                '${dayLabel(matched.takenAt)}',
                            style: const TextStyle(color: Colors.white70, fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                Text(
                  (_constellation?.latinName ?? widget.constCode).toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.1,
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'About',
                            style: TextStyle(
                              color: AppColors.forestGreen,
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            // Placeholder narrative text — real per-constellation
                            // copy belongs in seeded content, not hardcoded here.
                            'Visible from your location right now. Farming '
                            'significance for ${_constellation?.latinName ?? widget.constCode} '
                            'will appear here once farming guidance data is loaded.',
                            style: const TextStyle(color: AppColors.gray, fontSize: 14, height: 1.5),
                          ),
                          const SizedBox(height: 20),
                          const Divider(),
                          const SizedBox(height: 12),
                          const Text(
                            'In Season',
                            style: TextStyle(
                              color: AppColors.forestGreen,
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 12),
                          if (_inSeasonCrops.isEmpty)
                            const Text(
                              'No farming rules linked to this constellation yet.',
                              style: TextStyle(color: AppColors.gray, fontSize: 13),
                            )
                          else
                            Row(
                              children: [
                                Image.asset(AppIcons.plant, width: 24, height: 24),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    '${_inSeasonCrops.join(', ')}\n(Planting season)',
                                    style: const TextStyle(
                                      color: AppColors.forestGreen,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
