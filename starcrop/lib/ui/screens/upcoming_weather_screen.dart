import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../data/farming/farming_db.dart' as fdb;
import '../../data/user/user_db.dart';
import '../../engine/rule_engine.dart';
import '../../engine/weather_codes.dart';
import '../../repository/guidance_repository.dart';
import '../format_utils.dart';
import '../theme/app_assets.dart';
import '../theme/app_theme.dart';

/// Upcoming Weather: one row per day (up to 7), fed by the same
/// resolveWeather() path as Home (fresh -> cache -> empty).
///
/// Editing today's logged weather previously required tapping the same
/// "Log today's weather" pill a second time — it happened to detect an
/// existing row and prefill the sheet, but nothing on screen suggested that
/// the same button also meant "edit". Now, once today has a logged entry,
/// today's row itself carries a pencil icon that opens the same sheet, and
/// the bottom pill only appears when there's nothing logged yet (i.e. it's
/// purely an "add" affordance).
///
/// Also shows a "Seasonal Outlook" section below the day-by-day forecast —
/// climatology, not forecast (see offline_seasonal_outlook_plan.md): "what
/// this time of year is typically like here", sourced from published
/// climate normals (SeasonalClimateNormals), fully offline and independent
/// of the live Open-Meteo forecast above it.
class UpcomingWeatherScreen extends StatefulWidget {
  const UpcomingWeatherScreen({super.key});

  @override
  State<UpcomingWeatherScreen> createState() => _UpcomingWeatherScreenState();
}

class _UpcomingWeatherScreenState extends State<UpcomingWeatherScreen> {
  static const _dropBlue = Color(0xFF4FC3F7); // mockup rain-% blue, not in palette

  // Only region 1 (Western Visayas) has seeded SeasonalClimateNormals rows
  // today (see starcrop_seed_data.dart). Used only when the farmer hasn't
  // explicitly chosen a region in Settings — GuidanceRepository.
  // currentRegionId() returns null in that case by design, since "no
  // region chosen" means "all regions" for farming-rule filtering, but the
  // seasonal outlook is inherently region-specific and needs *some* region
  // to look up.
  static const _defaultRegionId = 1;

  SavedLocation? _location;
  WeatherState _weather = WeatherState.empty;

  /// Today's logged entry, if any — kept in state (rather than re-queried
  /// only inside the log sheet) so today's row can show an edit icon
  /// whenever a log already exists. Refreshed on every _load() and again
  /// after the log sheet saves.
  WeatherLogData? _todaysLogEntry;

  fdb.SeasonalClimateNormal? _seasonalOutlook;
  String? _seasonalRegionName;
  String? _seasonalAnchorLabel;
  bool _loading = true;

  /// Set when `_load` hits an exception *other than* the network/cache
  /// misses resolveWeather already handles internally (e.g. a DB error) —
  /// those are real bugs, not "offline", so they're surfaced instead of
  /// being folded into the same silent empty state.
  String? _loadError;

  // Defaults to the device's current date. The farmer can preview a
  // different date (see _pickPreviewDate) — the Seasonal Outlook below
  // recomputes for whatever month that date falls in, since climatology
  // isn't tied to "now" the way the live Open-Meteo forecast is.
  DateTime _previewDate = DateTime.now();

  bool get _isPreviewingToday => _isSameDate(_previewDate, DateTime.now());

  static bool _isSameDate(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  /// Day offset of [_previewDate] relative to *real* today — this is the
  /// same offset convention _weather.forecastByDayOffset already uses
  /// (fetched relative to whenever Open-Meteo was actually called, never
  /// relative to a previewed date). Can be negative (past) or well beyond
  /// the ~7-day forecast window (future) — those cases just won't have a
  /// matching key in forecastByDayOffset, handled in _buildPreviewSingleDay.
  int get _previewOffsetFromToday {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(_previewDate.year, _previewDate.month, _previewDate.day);
    return target.difference(today).inDays;
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _loadError = null;
    });
    try {
      final userDb = context.read<UserDb>();
      final repo = context.read<GuidanceRepository>();

      final loc = await userDb.activeLocation();

      if (loc == null) {
        if (mounted) setState(() => _loading = false);
        return;
      }

      // resolveWeather already handles "offline" / "no cache yet" itself
      // (falls back to cache, then to an empty+fetchFailed state) — nothing
      // thrown past this point should be a normal offline case, so anything
      // caught below is worth logging and telling the farmer about.
      var weather = await repo.resolveWeather(
        locationId: loc.locationId,
        lat: loc.lat,
        lon: loc.lon,
      );
      weather = await repo.mergeWithManualLog(weather, loc.locationId);

      // Queried directly against `loc` rather than via _todaysLog() (which
      // reads _location from state) — _location isn't set until the
      // setState below, so _todaysLog() would still see the previous
      // location (or null) at this point in _load().
      final todaysLog = await _fetchTodaysLog(loc);

      if (!mounted) return;
      setState(() {
        _location = loc;
        _weather = weather;
        _todaysLogEntry = todaysLog;
        _loading = false;
      });

      await _loadSeasonalOutlook(_previewDate.month);
    } catch (e, st) {
      debugPrint('UpcomingWeatherScreen._load failed: $e\n$st');
      if (mounted) {
        setState(() {
          _loading = false;
          _loadError = 'Something went wrong loading weather: $e';
        });
      }
    }
  }

  /// Loads (or clears) the Seasonal Outlook for [month], independent of the
  /// live weather fetch above — this is what lets _pickPreviewDate refresh
  /// just the outlook without re-fetching or re-caching anything. Best
  /// effort: a failure here (e.g. an older install mid-migration) just
  /// leaves the section absent, same reasoning as the cache write in
  /// sky_snapshot.dart — it should never blank out a forecast that already
  /// loaded successfully.
  Future<void> _loadSeasonalOutlook(int month) async {
    try {
      final farmingDb = context.read<fdb.FarmingDb>();
      final repo = context.read<GuidanceRepository>();

      final regionId = await repo.currentRegionId() ?? _defaultRegionId;
      final outlook = await repo.getSeasonalOutlook(regionId: regionId, month: month);

      if (outlook == null) {
        if (!mounted) return;
        setState(() {
          _seasonalOutlook = null;
          _seasonalRegionName = null;
          _seasonalAnchorLabel = null;
        });
        return;
      }

      final region = await (farmingDb.select(farmingDb.regions)
            ..where((t) => t.regionId.equals(regionId)))
          .getSingleOrNull();
      final anchorLabel = await repo.seasonalOutlookAnchorLabel(outlook);

      if (!mounted) return;
      setState(() {
        _seasonalOutlook = outlook;
        _seasonalRegionName = region?.name;
        _seasonalAnchorLabel = anchorLabel;
      });
    } catch (_) {
      // Leave the Seasonal Outlook section simply absent.
    }
  }

  /// Opens a date picker defaulting to the currently previewed date (device
  /// time on first open), a decade in either direction — wide on purpose,
  /// since the Seasonal Outlook can answer "what's typical" for any month
  /// regardless of how far out it is, even though the live forecast below
  /// it can't.
  Future<void> _pickPreviewDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _previewDate,
      firstDate: DateTime(now.year - 10),
      lastDate: DateTime(now.year + 10),
      helpText: 'Preview a date',
    );
    if (picked == null) return;
    setState(() => _previewDate = picked);
    await _loadSeasonalOutlook(picked.month);
  }

  Future<void> _resetToToday() async {
    final today = DateTime.now();
    setState(() => _previewDate = today);
    await _loadSeasonalOutlook(today.month);
  }

  /// Today's already-logged entry for [loc]. Split out from [_todaysLog] so
  /// _load() can call it before _location is set in state (see the comment
  /// at that call site).
  Future<WeatherLogData?> _fetchTodaysLog(SavedLocation loc) async {
    final userDb = context.read<UserDb>();
    final n = DateTime.now();
    final startOfDay = DateTime(n.year, n.month, n.day);
    return (userDb.select(userDb.weatherLog)
          ..where((t) =>
              t.locationId.equals(loc.locationId) & t.obsDate.equals(startOfDay))
          ..limit(1))
        .getSingleOrNull();
  }

  /// Convenience wrapper over [_fetchTodaysLog] using the current
  /// [_location] — used to pre-fill the log sheet right before it opens.
  Future<WeatherLogData?> _todaysLog() async {
    final loc = _location;
    if (loc == null) return null;
    return _fetchTodaysLog(loc);
  }

  /// Upserts today's log. When [existingLogId] is given (there's already a
  /// row for today), updates that row in place — including clearing a field
  /// the farmer erased — instead of inserting another row for the same day.
  Future<void> _saveLog(
    double? rainMm,
    double? tempC,
    String? notes, {
    String? existingLogId,
  }) async {
    final loc = _location;
    if (loc == null) return;
    final userDb = context.read<UserDb>();
    final cleanNotes = (notes == null || notes.isEmpty) ? null : notes;

    if (existingLogId != null) {
      await (userDb.update(userDb.weatherLog)
            ..where((t) => t.logId.equals(existingLogId)))
          .write(WeatherLogCompanion(
        rainMm: Value(rainMm),
        tempC: Value(tempC),
        notes: Value(cleanNotes),
        updatedAt: Value(DateTime.now()),
      ));
      return;
    }

    final n = DateTime.now();
    await userDb.into(userDb.weatherLog).insert(
          WeatherLogCompanion.insert(
            logId: const Uuid().v4(),
            locationId: loc.locationId,
            obsDate: DateTime(n.year, n.month, n.day),
            rainMm: rainMm == null ? const Value.absent() : Value(rainMm),
            tempC: tempC == null ? const Value.absent() : Value(tempC),
            notes: cleanNotes == null ? const Value.absent() : Value(cleanNotes),
          ),
        );
  }

  Future<void> _openLogSheet() async {
    if (_location == null) return;
    final existing = await _todaysLog();
    if (!mounted) return;
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _LogSheet(
        onSave: (rain, temp, notes) =>
            _saveLog(rain, temp, notes, existingLogId: existing?.logId),
        initialRainMm: existing?.rainMm,
        initialTempC: existing?.tempC,
        initialNotes: existing?.notes,
      ),
    );
    if (saved == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(existing == null
              ? "Today's weather saved"
              : "Today's weather updated"),
        ),
      );
      _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    final offsets = _weather.forecastByDayOffset.keys.toList()..sort();
    final hasForecast = offsets.isNotEmpty;
    final fetchedAt = _weather.fetchedAt;

    // The bottom pill is now purely an "add a log" affordance — once today
    // already has an entry, editing happens via the pencil icon on today's
    // row instead (see _buildRow), so the pill is hidden rather than
    // duplicating that action.
    final showAddLogButton =
        _location != null && _isPreviewingToday && _todaysLogEntry == null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Image.asset(AppIcons.chevronLeftWhite, width: 24, height: 24),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text('Upcoming Weather'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _PreviewDateBar(
              date: _previewDate,
              isToday: _isPreviewingToday,
              onPick: _pickPreviewDate,
              onReset: _resetToToday,
            ),
            if (hasForecast && _weather.isStale && fetchedAt != null)
              Container(
                width: double.infinity,
                color: AppColors.grayLight3,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  'Offline forecast, updated ${timeAgo(fetchedAt)}. May be outdated.',
                  style: const TextStyle(fontSize: 12, color: AppColors.gray),
                ),
              ),
            if (_loadError != null)
              Container(
                width: double.infinity,
                color: Colors.red.shade50,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _loadError!,
                        style: TextStyle(fontSize: 12, color: Colors.red.shade700),
                      ),
                    ),
                    TextButton(onPressed: _load, child: const Text('Retry')),
                  ],
                ),
              ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _load,
                child: _loading
                    ? _scrollableCenter(
                        const Center(child: CircularProgressIndicator(strokeWidth: 2)))
                    : _location == null
                        ? _scrollableCenter(const _EmptyNote(
                            'Set your location first to see the forecast.'))
                        : !_isPreviewingToday
                            ? _buildPreviewSingleDay()
                            : !hasForecast
                                ? _scrollableCenter(_EmptyNote(
                                    _weather.fetchFailed
                                        ? "Couldn't reach the internet just now. Pull down "
                                            "to try again, or log today's weather below."
                                        : 'No forecast yet. Connect to the internet once to '
                                            "download it, or log today's weather below.",
                                    actionLabel: 'Retry now',
                                    onAction: _load,
                                  ))
                                : ListView.separated(
                                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                                    itemCount: offsets.length,
                                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                                    itemBuilder: (_, i) => _buildRow(
                                      offsets[i],
                                      // Only today's row (offset 0) can carry
                                      // a manual log, and only once one
                                      // actually exists.
                                      isEditable:
                                          offsets[i] == 0 && _todaysLogEntry != null,
                                      onEdit: _openLogSheet,
                                    ),
                                  ),
              ),
            ),
            if (_seasonalOutlook != null)
              _SeasonalOutlookCard(
                outlook: _seasonalOutlook!,
                regionName: _seasonalRegionName,
                anchorLabel: _seasonalAnchorLabel,
              ),
            if (showAddLogButton)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                child: _LogButton(onTap: _openLogSheet),
              ),
          ],
        ),
      ),
    );
  }

  /// RefreshIndicator only recognizes a pull gesture over a scrollable
  /// descendant. The loading spinner, "no forecast" note, and "set your
  /// location" note are all just a Center/_EmptyNote with no scrollable of
  /// their own, so pull-to-refresh would silently do nothing over them
  /// without this — wraps [child] in a scrollable that always accepts the
  /// drag (AlwaysScrollableScrollPhysics) even though its content is short.
  Widget _scrollableCenter(Widget child) {
    return LayoutBuilder(
      builder: (context, constraints) => ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(child: child),
          ),
        ],
      ),
    );
  }

  /// Shown instead of the full 7-day list whenever the farmer is previewing
  /// a date other than today. Open-Meteo only ever returns ~7 days from
  /// whenever it was last fetched (see _weather.forecastByDayOffset), so a
  /// previewed date can fall outside that window in either direction —
  /// unlike the Seasonal Outlook below, which answers for any month.
  Widget _buildPreviewSingleDay() {
    final offset = _previewOffsetFromToday;
    if (!_weather.forecastByDayOffset.containsKey(offset)) {
      return _scrollableCenter(const _EmptyNote(
        "No live forecast for this date — Open-Meteo only covers about a "
        "week ahead. The Seasonal Outlook below still shows what this time "
        "of year is typically like.",
      ));
    }
    return _scrollableCenter(
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        // Never editable here: manual logging only ever applies to today,
        // not to an arbitrary previewed date.
        child: _buildRow(offset),
      ),
    );
  }

  Widget _buildRow(int offset, {bool isEditable = false, VoidCallback? onEdit}) {
    final d = _weather.forecastByDayOffset[offset]!;
    final n = DateTime.now();
    final date = DateTime(n.year, n.month, n.day + offset);
    final code = d['code']?.round();

    final hi = d['temp_max'];
    final lo = d['temp_min'];
    final temp = (hi != null && lo != null)
        ? '${lo.round()}–${hi.round()}°C'
        : (d['temp'] != null ? '${d['temp']!.round()}°C' : '');
    final subtitle = [weatherLabel(code), if (temp.isNotEmpty) temp].join(' · ');

    final prob = d['rain_prob'];
    final rain = d['rain'];

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.grayLight3),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: AppColors.forestGreen,
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(10),
            child: Image.asset(weatherIconFor(weatherConditionKey(code))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      dayLabel(date),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.forestGreen,
                      ),
                    ),
                    if (isEditable) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.sageGreen.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Logged',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppColors.forestGreen,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: AppColors.forestGreen),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (prob != null)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(AppIcons.waterDrop2, width: 14, height: 14),
                    const SizedBox(width: 4),
                    Text(
                      '${prob.round()}%',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _dropBlue,
                      ),
                    ),
                  ],
                ),
              if (rain != null && rain > 0)
                Text(
                  '${rain.toStringAsFixed(1)} mm',
                  style: const TextStyle(fontSize: 11, color: AppColors.gray),
                ),
            ],
          ),
          // Edit affordance lives on the row itself now — pressing it opens
          // the exact same sheet _LogButton used to, prefilled with today's
          // values, so there's no behavior change, only a clearer, more
          // discoverable entry point for "edit" versus "add".
          if (isEditable && onEdit != null) ...[
            const SizedBox(width: 4),
            IconButton(
              onPressed: onEdit,
              icon: const Icon(Icons.edit_outlined, size: 18, color: AppColors.gray),
              tooltip: "Edit today's logged weather",
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            ),
          ],
        ],
      ),
    );
  }
}

/// "Typical for this time of year" strip — climatology, not forecast. Kept
/// visually distinct (different background, italic disclaimer) from the
/// day-by-day forecast rows above so it's never mistaken for a live
/// Open-Meteo prediction, per offline_seasonal_outlook_plan.md step 4.
class _SeasonalOutlookCard extends StatelessWidget {
  final fdb.SeasonalClimateNormal outlook;
  final String? regionName;
  final String? anchorLabel;

  const _SeasonalOutlookCard({
    required this.outlook,
    this.regionName,
    this.anchorLabel,
  });

  static const _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  // Worded for climate-normal data specifically (source: a published
  // station's normals, applied region-wide) rather than reusing
  // farmer_guidance_screen/rule_data_screen's rule-oriented copy verbatim
  // ("Reviewed by extension office" doesn't fit — no extension office
  // reviewed this, PAGASA published it and it's pending per-province
  // review; see starcrop_seed_data.dart's climateNormalsSourceCitation).
  static String _statusLabel(String status) {
    switch (status) {
      case 'confirmed':
        return 'Confirmed for this area';
      case 'reviewed':
        return 'Published climate data — pending per-province review';
      default:
        return 'Draft, not yet reviewed';
    }
  }

  @override
  Widget build(BuildContext context) {
    final monthName = _months[outlook.month - 1];
    final classification = outlook.classification.isEmpty
        ? ''
        : outlook.classification[0].toUpperCase() + outlook.classification.substring(1);

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.grayLight4,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.grayLight2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(AppIcons.waterDrop3, width: 18, height: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  regionName == null
                      ? 'Seasonal Outlook'
                      : 'Seasonal Outlook · $regionName',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: AppColors.forestGreen,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '$monthName: $classification',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: AppColors.forestGreen,
            ),
          ),
          if (anchorLabel != null) ...[
            const SizedBox(height: 2),
            Text(
              "Around $anchorLabel's rise",
              style: const TextStyle(fontSize: 11, color: AppColors.gray),
            ),
          ],
          const SizedBox(height: 4),
          Text(
            'Typically ${outlook.avgRainMm.round()} mm rain · '
            '${outlook.tempMinC.round()}–${outlook.tempMaxC.round()}°C',
            style: const TextStyle(fontSize: 12, color: AppColors.gray),
          ),
          const SizedBox(height: 8),
          const Text(
            'Typical for this time of year, based on historical climate '
            'data — not a forecast.',
            style: TextStyle(
              fontSize: 11,
              color: AppColors.gray,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 10),
          const Divider(height: 1, color: AppColors.grayLight2),
          const SizedBox(height: 8),
          Row(
            children: [
              if (outlook.verificationStatus == 'confirmed') ...[
                Image.asset(AppIcons.shieldCheck, width: 14, height: 14),
                const SizedBox(width: 6),
              ],
              Expanded(
                child: Text(
                  _statusLabel(outlook.verificationStatus),
                  style: const TextStyle(fontSize: 11, color: AppColors.gray),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmptyNote extends StatelessWidget {
  final String text;
  final String? actionLabel;
  final VoidCallback? onAction;
  const _EmptyNote(this.text, {this.actionLabel, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: AppColors.gray, height: 1.4),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 12),
              OutlinedButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}

/// Bar at the top of the screen showing which date is being previewed —
/// "Today" by default (device time), or a picked date once the farmer taps
/// to change it. Tapping the date opens a picker; a "Reset" action appears
/// only once a non-today date is active, jumping straight back to today
/// rather than making the farmer re-pick it.
class _PreviewDateBar extends StatelessWidget {
  final DateTime date;
  final bool isToday;
  final VoidCallback onPick;
  final VoidCallback onReset;

  const _PreviewDateBar({
    required this.date,
    required this.isToday,
    required this.onPick,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: onPick,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 16, color: AppColors.forestGreen),
                    const SizedBox(width: 8),
                    Text(
                      isToday ? 'Today' : dayLabel(date),
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: AppColors.forestGreen,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isToday ? '· tap to preview another date' : '· previewing',
                      style: const TextStyle(fontSize: 11, color: AppColors.gray),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (!isToday)
            TextButton(
              onPressed: onReset,
              child: const Text('Reset', style: TextStyle(color: AppColors.forestGreen)),
            ),
        ],
      ),
    );
  }
}

/// Sage-green pill from the mockup. Purely an "add a log" affordance now —
/// only ever shown when today has no logged entry yet (see build() in
/// _UpcomingWeatherScreenState). Editing an existing entry happens via the
/// pencil icon on today's row instead.
class _LogButton extends StatelessWidget {
  final VoidCallback? onTap;
  const _LogButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: onTap == null ? 0.5 : 1,
      child: Material(
        color: AppColors.sageGreen,
        elevation: 4,
        borderRadius: BorderRadius.circular(28),
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: onTap,
          child: SizedBox(
            height: 56,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(AppIcons.addSign, width: 22, height: 22),
                const SizedBox(width: 10),
                const Text(
                  "Log today's weather",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: AppColors.forestGreen,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LogSheet extends StatefulWidget {
  final Future<void> Function(double? rainMm, double? tempC, String? notes) onSave;
  final double? initialRainMm;
  final double? initialTempC;
  final String? initialNotes;
  const _LogSheet({
    required this.onSave,
    this.initialRainMm,
    this.initialTempC,
    this.initialNotes,
  });

  @override
  State<_LogSheet> createState() => _LogSheetState();
}

class _LogSheetState extends State<_LogSheet> {
  final _rain = TextEditingController();
  final _temp = TextEditingController();
  final _notes = TextEditingController();
  String? _error;
  bool _saving = false;

  bool get _isEditing =>
      widget.initialRainMm != null ||
      widget.initialTempC != null ||
      (widget.initialNotes?.isNotEmpty ?? false);

  static String _formatNum(double v) =>
      v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toString();

  @override
  void initState() {
    super.initState();
    // Field initializers run before `widget` is attached, so the initial
    // text has to be set here instead of at controller-declaration time.
    if (widget.initialRainMm != null) _rain.text = _formatNum(widget.initialRainMm!);
    if (widget.initialTempC != null) _temp.text = _formatNum(widget.initialTempC!);
    if (widget.initialNotes != null) _notes.text = widget.initialNotes!;
  }

  @override
  void dispose() {
    _rain.dispose();
    _temp.dispose();
    _notes.dispose();
    super.dispose();
  }

  double? _num(String s) => double.tryParse(s.trim().replaceAll(',', '.'));

  Future<void> _submit() async {
    final rain = _num(_rain.text);
    final temp = _num(_temp.text);
    if (_rain.text.trim().isNotEmpty && rain == null ||
        _temp.text.trim().isNotEmpty && temp == null) {
      setState(() => _error = 'Please enter numbers only.');
      return;
    }
    if (rain == null && temp == null) {
      setState(() => _error = 'Enter the rain or the temperature (or both).');
      return;
    }
    if (rain != null && rain < 0) {
      setState(() => _error = "Rain can't be negative.");
      return;
    }
    setState(() {
      _error = null;
      _saving = true;
    });
    await widget.onSave(rain, temp, _notes.text.trim());
    if (mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          20, 20, 20, 20 + MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isEditing ? "Edit today's weather" : "Log today's weather",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              _isEditing
                  ? "You've already logged today — this updates that entry."
                  : 'Used when the forecast is old or missing.',
              style: const TextStyle(fontSize: 12, color: AppColors.gray),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _rain,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Rain today (mm)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _temp,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true, signed: true),
              decoration: const InputDecoration(
                labelText: 'Temperature (°C)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _notes,
              decoration: const InputDecoration(
                labelText: 'Notes (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 10),
              Text(_error!, style: const TextStyle(color: Colors.red, fontSize: 12)),
            ],
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saving ? null : _submit,
                child: Text(_saving
                    ? (_isEditing ? 'Updating…' : 'Saving…')
                    : (_isEditing ? 'Update' : 'Save')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
