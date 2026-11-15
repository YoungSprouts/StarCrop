import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/user/user_db.dart';
import '../data/cache/cache_db.dart';
import '../data/farming/farming_db.dart' as fdb;
import '../repository/guidance_repository.dart';
import '../repository/sky_snapshot.dart' as snap;
import 'theme/app_theme.dart';
import 'theme/app_assets.dart';
import 'format_utils.dart';
import '../engine/weather_codes.dart';
import '../engine/rule_engine.dart';
import '../engine/i18n_text.dart';
import 'screens/sky_chart_screen.dart';
import 'screens/farmer_guidance_screen.dart';
import 'screens/suggested_activities_screen.dart';
import 'screens/upcoming_weather_screen.dart';
import 'screens/camera_check_screen.dart';
import 'screens/rule_data_screen.dart';
import 'screens/month_outlook_screen.dart';
import 'screens/user_settings_screen.dart';

/// Rebuilt to remove every fixed-pixel Stack/Positioned offset the previous
/// version relied on (hero height 260, spacer 190, FAB "bottom: 46", etc.).
/// Those numbers only line up on the exact screen the design was made for —
/// any other aspect ratio (a tablet, a shorter/taller phone) caused visible
/// overlap. This version uses plain widget flow (Column/SingleChildScroll-
/// View) plus Scaffold's own floatingActionButton, both of which Flutter
/// sizes and positions correctly on any device without hand-tuned numbers.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SavedLocation? _location;
  double? _todayRainMm;
  double? _todayTempC;
  int? _todayCode;
  bool _hasForecast = false;
  bool _stale = true;
  DateTime? _lastUpdated;
  bool _loading = true;
  snap.SkySnapshot? _skySnapshot;

  // Next Month Outlook card — loaded separately (best-effort, non-blocking)
  // so a slow/failed farming-DB query never delays or blanks out today's
  // weather card above it.
  static const _defaultRegionId = 1; // Western Visayas — same fallback
      // convention as upcoming_weather_screen.dart's _defaultRegionId, used
      // only when the farmer hasn't chosen a region in Settings.
  bool _nextMonthLoading = true;
  int? _nextMonthNumber; // 1-12
  fdb.SeasonalClimateNormal? _nextMonthClimate;
  String? _nextMonthAnchorLabel;
  List<MatchedRule> _nextMonthGuidance = const [];
  Map<int, String> _activityTypeById = const {};
  Map<int, String> _nextMonthCropNames = const {};
  String _nextMonthLang = 'en';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    // Cheap, cached, independent of location/weather — resolve it without
    // blocking the rest of _load, so it can paint the moment it's ready.
    final cacheDb = context.read<CacheDb>();
    snap.loadSkySnapshot(cacheDb).then((s) {
      if (mounted) setState(() => _skySnapshot = s);
    });

    final userDb = context.read<UserDb>();
    final loc = await userDb.activeLocation();

    if (loc == null) {
      if (mounted) setState(() => _loading = false);
      return;
    }

    final guidance = context.read<GuidanceRepository>();

    // Fire-and-forget: sky-only guidance for next month doesn't need to be
    // ready before today's weather card paints, and a failure in here is
    // handled entirely inside _loadNextMonthOutlook.
    _loadNextMonthOutlook(loc, guidance);

    var weather = await guidance.resolveWeather(
      locationId: loc.locationId,
      lat: loc.lat,
      lon: loc.lon,
    );
    weather = await guidance.mergeWithManualLog(weather, loc.locationId);

    if (!mounted) return;
    setState(() {
      _location = loc;
      _todayRainMm = weather.forecastByDayOffset[0]?['rain'];
      _todayTempC = weather.forecastByDayOffset[0]?['temp'];
      _todayCode = weather.forecastByDayOffset[0]?['code']?.round();
      _hasForecast = weather.forecastByDayOffset[0]?.isNotEmpty ?? false;
      _stale = weather.isStale;
      _lastUpdated = weather.fetchedAt;
      _loading = false;
    });
  }

  /// Sky-based guidance for roughly a month from now, plus the published
  /// seasonal climate normal for that calendar month, when one is seeded.
  /// Deliberately best-effort: any failure here (missing farming data,
  /// unseeded region, etc.) just leaves the card in its empty state rather
  /// than surfacing an error, since this is a preview, not core guidance.
  Future<void> _loadNextMonthOutlook(SavedLocation loc, GuidanceRepository guidance) async {
    try {
      final farmingDb = context.read<fdb.FarmingDb>();
      final now = DateTime.now().toUtc();
      final targetMonth = (now.month % 12) + 1; // 1-12, wraps Dec -> Jan

      final nextMonthGuidanceFuture = guidance.getNextMonthGuidance(
        locationId: loc.locationId,
        lat: loc.lat,
        lon: loc.lon,
        nowUtc: now,
      );
      final regionIdFuture = guidance.currentRegionId();
      final activitiesFuture = farmingDb.select(farmingDb.activities).get();
      final cropsFuture = farmingDb.select(farmingDb.crops).get();
      final langFuture = guidance.currentLanguage();

      final nextMonthGuidance = await nextMonthGuidanceFuture;
      final regionId = await regionIdFuture ?? _defaultRegionId;
      final activityRows = await activitiesFuture;
      final cropRows = await cropsFuture;
      final lang = await langFuture;
      final outlook = await guidance.getSeasonalOutlook(regionId: regionId, month: targetMonth);
      final anchorLabel =
          outlook == null ? null : await guidance.seasonalOutlookAnchorLabel(outlook);

      if (!mounted) return;
      setState(() {
        _nextMonthNumber = targetMonth;
        _nextMonthClimate = outlook;
        _nextMonthAnchorLabel = anchorLabel;
        _nextMonthGuidance = nextMonthGuidance;
        _activityTypeById = {for (final a in activityRows) a.activityId: a.activityType};
        _nextMonthCropNames = {for (final c in cropRows) c.cropId: c.name};
        _nextMonthLang = lang;
        _nextMonthLoading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _nextMonthLoading = false);
    }
  }

  // Prefer the real WMO code; fall back to a rain-mm heuristic only when the
  // value came from a manual log (which has no code). Icon and label now
  // always agree.
  String _weatherIconKey() {
    if (_todayCode != null) return weatherConditionKey(_todayCode);
    final rain = _todayRainMm;
    if (rain == null) return 'cloudy';
    if (rain >= 10) return 'light_rain';
    if (rain >= 2) return 'partly_rainy';
    return 'sun';
  }

  String _weatherLabel() {
    if (_todayCode != null) return weatherLabel(_todayCode);
    final rain = _todayRainMm;
    if (rain == null) return 'Conditions unknown';
    if (rain >= 10) return 'Rain expected';
    if (rain >= 2) return 'Light rain';
    return 'Clear skies';
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    // Scales the feature grid to the actual device width instead of a fixed
    // 2-column layout — a tablet (like the Tab A9+) gets more columns rather
    // than 2 oversized tiles, a narrow phone keeps the original 2.
    final crossAxisCount = width >= 900 ? 4 : (width >= 600 ? 3 : 2);
    final childAspectRatio = crossAxisCount == 2 ? 1.35 : 1.6;

    return Scaffold(
      backgroundColor: Colors.white,
      // Dark green footer with rounded top corners; the camera button is
      // docked on its top edge (centerDocked centers the button's midpoint
      // on that edge on every device — no hand-tuned pixel offsets).
      bottomNavigationBar: const _FooterBar(),
      floatingActionButton: _CameraButton(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const CameraCheckScreen()),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SafeArea(
        // Pull down from the very top to re-run _load(): fetches a fresh
        // forecast (falling back to cache if offline), then refreshes the
        // sky preview and next-month outlook. The spinner stays until the
        // weather step finishes.
        child: RefreshIndicator(
          color: AppColors.forestGreen,
          backgroundColor: Colors.white,
          onRefresh: _load,
          child: SingleChildScrollView(
            // Always scrollable so the pull gesture works even when the
            // content is shorter than the screen (e.g. on a tablet).
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _HeroHeader(
                locationLabel: _location?.label ?? 'Set your location',
                // Reload on return: the farmer may have changed their
                // location (GPS/manual) or region in Settings.
                onSettingsTap: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => const UserSettingsScreen()))
                    .then((_) {
                  if (mounted) _load();
                }),
              ),
              const SizedBox(height: 16),
              _WeatherSummaryCard(
                loading: _loading,
                tempC: _todayTempC,
                label: _weatherLabel(),
                iconKey: _weatherIconKey(),
                hasForecast: _hasForecast,
                stale: _stale,
                lastUpdated: _lastUpdated,
              ),
              if (_skySnapshot != null) ...[
                const SizedBox(height: 12),
                _SkyPreviewCard(
                  snapshot: _skySnapshot!,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const SkyChartScreen()),
                  ),
                ),
              ],
              if (_location != null) ...[
                const SizedBox(height: 12),
                _NextMonthOutlookCard(
                  loading: _nextMonthLoading,
                  monthNumber: _nextMonthNumber,
                  climate: _nextMonthClimate,
                  guidance: _nextMonthGuidance,
                  activityTypeById: _activityTypeById,
                  onTap: _nextMonthLoading || _nextMonthNumber == null
                      ? null
                      : () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => MonthOutlookScreen(
                                monthNumber: _nextMonthNumber!,
                                climate: _nextMonthClimate,
                                anchorLabel: _nextMonthAnchorLabel,
                                guidance: _nextMonthGuidance,
                                activityTypeById: _activityTypeById,
                                cropNames: _nextMonthCropNames,
                                lang: _nextMonthLang,
                              ),
                            ),
                          ),
                ),
              ],
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: childAspectRatio,
                  children: [
                    _FeatureTile(
                      icon: AppIcons.skyChart,
                      title: 'Sky Chart',
                      subtitle: 'Constellations & stars',
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const SkyChartScreen()),
                      ),
                    ),
                    _FeatureTile(
                      icon: AppIcons.farmerGuide,
                      title: 'Farmer',
                      subtitle: 'Guidance & Tips',
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const FarmerGuidanceScreen()),
                      ),
                    ),
                    _FeatureTile(
                      icon: AppIcons.activities,
                      title: 'Suggested Activities',
                      subtitle: 'Based on Weather',
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const SuggestedActivitiesScreen()),
                      ),
                    ),
                    _FeatureTile(
                      icon: AppIcons.weather,
                      title: 'Upcoming Weather',
                      subtitle: 'Forecast & offline',
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const UpcomingWeatherScreen()),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _AllGuidanceLink(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const RuleDataScreen()),
                  ),
                ),
              ),
              // Reserves room so the last item is never hidden behind the
              // top half of the docked camera button, on any device.
              SizedBox(height: _CameraButton.sizeFor(context) / 2 + 16),
            ],
          ),
          ),
        ),
      ),
    );
  }
}

class _HeroHeader extends StatelessWidget {
  final String locationLabel;
  final VoidCallback onSettingsTap;
  const _HeroHeader({required this.locationLabel, required this.onSettingsTap});

  @override
  Widget build(BuildContext context) {
    // A proportional aspect ratio instead of a fixed pixel height — scales
    // sensibly whether this renders on a narrow phone or a wide tablet.
    return AspectRatio(
      aspectRatio: 1.5,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(AppImages.homeScreen, fit: BoxFit.cover),
          Container(color: Colors.black.withValues(alpha: 0.25)),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'StarCrop',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: AppColors.gold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: onSettingsTap,
                      icon: Image.asset(AppIcons.settingsWhite, width: 22, height: 22),
                      tooltip: 'Settings',
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                RichText(
                  text: const TextSpan(
                    style: TextStyle(fontFamily: 'Inter', fontSize: 16, height: 1.3),
                    children: [
                      TextSpan(text: 'Your Stars. ', style: TextStyle(color: Colors.white)),
                      TextSpan(text: 'Your\nFarm.', style: TextStyle(color: AppColors.gold)),
                      TextSpan(text: ' Your Guide.', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    Image.asset(AppIcons.locationPinGold, width: 16, height: 16),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        locationLabel,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WeatherSummaryCard extends StatelessWidget {
  final bool loading;
  final double? tempC;
  final String label;
  final String iconKey;
  final bool hasForecast;
  final bool stale;
  final DateTime? lastUpdated;

  const _WeatherSummaryCard({
    required this.loading,
    required this.tempC,
    required this.label,
    required this.iconKey,
    required this.hasForecast,
    required this.stale,
    this.lastUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 16, offset: const Offset(0, 6)),
        ],
      ),
      child: loading
          ? const SizedBox(
              height: 40,
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            )
          // Previously this always rendered the full icon/temp/label row on
          // the left AND a separate status line on the right — when there
          // was truly no forecast at all, that meant "--°c / No forecast"
          // next to "No forecast yet", the same fact said twice in
          // different words. Now the no-forecast state gets exactly one
          // sentence instead.
          : !hasForecast
              ? Row(
                  children: [
                    Image.asset(AppIcons.cloudy, width: 36, height: 36),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'No forecast yet. Connect to the internet once to '
                        'download it.',
                        style: TextStyle(fontSize: 13, color: AppColors.gray, height: 1.35),
                      ),
                    ),
                  ],
                )
              : Row(
                  children: [
                    Image.asset(weatherIconFor(iconKey), width: 36, height: 36),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tempC != null ? '${tempC!.round()}°c' : '--°c',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: AppColors.forestGreen,
                            ),
                          ),
                          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.gray)),
                          if (tempC != null)
                            const Text('Next 24h', style: TextStyle(fontSize: 11, color: AppColors.gray)),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          stale ? 'Offline data' : 'Live',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          stale && lastUpdated != null
                              ? 'Last updated ${timeAgo(lastUpdated!)}'
                              : (stale ? 'Offline' : 'Just updated'),
                          style: const TextStyle(fontSize: 11, color: AppColors.gray),
                        ),
                      ],
                    ),
                  ],
                ),
    );
  }
}

/// Instant "tonight's sky" strip, sourced entirely from the cached
/// SkySnapshot — no DB query or astronomy math runs to show this. It only
/// ever reflects whatever Sky Chart last computed, so it's labeled with how
/// long ago that was rather than implied to be live.
class _SkyPreviewCard extends StatelessWidget {
  final snap.SkySnapshot snapshot;
  final VoidCallback onTap;

  const _SkyPreviewCard({required this.snapshot, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final names = snapshot.visibleConstellations;
    final summary = names.isEmpty
        ? 'No constellations recorded as visible last time.'
        : names.join(', ');

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Image.asset(AppIcons.moon, width: 24, height: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      snapshot.moonPhaseLabel.isEmpty
                          ? "Tonight's sky"
                          : '${snapshot.moonPhaseLabel} · Tonight\'s sky',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: AppColors.forestGreen,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      summary,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12, color: AppColors.gray),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'from ${timeAgo(snapshot.computedAt)}',
                style: const TextStyle(fontSize: 10, color: AppColors.gray),
              ),
              const SizedBox(width: 6),
              Image.asset(AppIcons.chevronRightDark, width: 12, height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

/// "What's coming up" — sky-based farming guidance for roughly a month
/// from now, plus the published seasonal climate normal for that calendar
/// month, when one is seeded (SeasonalClimateNormals in farming_db.dart).
/// Weather-gated rules are deliberately left out — see
/// GuidanceRepository.getSkyOnlyGuidance's doc comment for why a monthly
/// average isn't used to fake a forecast that far out.
class _NextMonthOutlookCard extends StatelessWidget {
  final bool loading;
  final int? monthNumber; // 1-12
  final fdb.SeasonalClimateNormal? climate;
  final List<MatchedRule> guidance;
  final Map<int, String> activityTypeById;
  final VoidCallback? onTap;

  const _NextMonthOutlookCard({
    required this.loading,
    required this.monthNumber,
    required this.climate,
    required this.guidance,
    required this.activityTypeById,
    this.onTap,
  });

  static const _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  @override
  Widget build(BuildContext context) {
    final monthName = monthNumber == null ? null : _months[monthNumber! - 1];

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: loading
              ? const SizedBox(
                  height: 32,
                  child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.asset(AppIcons.moon, width: 18, height: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            monthName == null ? 'Next Month Outlook' : 'Outlook · $monthName',
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                              color: AppColors.forestGreen,
                            ),
                          ),
                        ),
                        if (onTap != null)
                          Image.asset(AppIcons.chevronRightDark, width: 12, height: 12),
                      ],
                    ),
                if (climate != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    '${climate!.classification.isEmpty ? '' : climate!.classification[0].toUpperCase() + climate!.classification.substring(1)}'
                    ' · typically ${climate!.avgRainMm.round()} mm rain · '
                    '${climate!.tempMinC.round()}–${climate!.tempMaxC.round()}°C',
                    style: const TextStyle(fontSize: 12, color: AppColors.gray),
                  ),
                ],
                const SizedBox(height: 10),
                const Divider(height: 1, color: AppColors.grayLight3),
                const SizedBox(height: 10),
                if (guidance.isEmpty)
                  const Text(
                    'No sky-based guidance flagged yet for next month.',
                    style: TextStyle(fontSize: 12, color: AppColors.gray),
                  )
                else ...[
                  for (final m in guidance.take(3))
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            activityIconFor(activityTypeById[m.rule.activityId] ?? 'note'),
                            width: 18,
                            height: 18,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              localizedText(m.rule.guidance),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.forestGreen,
                                height: 1.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (guidance.length > 3)
                    Text(
                      'and ${guidance.length - 3} more…',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.gray,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                ],
                const SizedBox(height: 4),
                const Text(
                  'Sky-based only — weather this far out can\'t be forecast reliably.',
                  style: TextStyle(fontSize: 10, color: AppColors.gray, fontStyle: FontStyle.italic),
                ),
              ],
            ),
        ),
      ),
    );
  }
}

class _FeatureTile extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _FeatureTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.grayLight3,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(icon, width: 26, height: 26),
              const Spacer(),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: AppColors.forestGreen,
                ),
              ),
              const SizedBox(height: 2),
              Text(subtitle, style: const TextStyle(fontSize: 11, color: AppColors.gray)),
            ],
          ),
        ),
      ),
    );
  }
}

/// Entry point to RuleDataScreen ("All Guidance").
class _AllGuidanceLink extends StatelessWidget {
  final VoidCallback onTap;
  const _AllGuidanceLink({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.grayLight3,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Image.asset(AppIcons.note, width: 22, height: 22),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Browse all guidance',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: AppColors.forestGreen,
                  ),
                ),
              ),
              Image.asset(AppIcons.chevronRightDark, width: 14, height: 14),
            ],
          ),
        ),
      ),
    );
  }
}


/// Dark green footer bar with rounded top corners. Its height includes the
/// device's bottom inset (gesture bar / nav buttons), so it fills all the
/// way to the screen edge on every device. The area beside the rounded
/// corners shows the screen's white background.
class _FooterBar extends StatelessWidget {
  const _FooterBar();

  static const _height = 44.0;
  static const _radius = 28.0;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    return Container(
      height: _height + bottomInset,
      decoration: const BoxDecoration(
        color: AppColors.forestGreen,
        borderRadius: BorderRadius.vertical(top: Radius.circular(_radius)),
      ),
    );
  }
}

/// Round camera button that opens Camera Check. Same look as Camera Check's
/// shutter (white disc, gold ring, dark green camera icon). Sized from the
/// screen's shorter side (clamped) so it stays comfortably tappable on a
/// small phone and doesn't look tiny on a tablet.
class _CameraButton extends StatelessWidget {
  final VoidCallback onTap;
  const _CameraButton({required this.onTap});

  static double sizeFor(BuildContext context) =>
      (MediaQuery.sizeOf(context).shortestSide * 0.2).clamp(68.0, 92.0);

  @override
  Widget build(BuildContext context) {
    final size = sizeFor(context);

    return SizedBox(
      width: size,
      height: size,
      child: Material(
        color: Colors.white,
        shape: const CircleBorder(side: BorderSide(color: AppColors.gold, width: 3)),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: Center(
            child: Image.asset(AppIcons.cameraDark, width: size * 0.42, height: size * 0.42),
          ),
        ),
      ),
    );
  }
}
