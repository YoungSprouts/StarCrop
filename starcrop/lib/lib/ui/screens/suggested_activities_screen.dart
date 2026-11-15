import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/farming/farming_db.dart' as fdb;
import '../../data/user/user_db.dart';
import '../../engine/activity_grouping.dart';
import '../../engine/i18n_text.dart';
import '../../engine/rule_engine.dart';
import '../../repository/guidance_repository.dart';
import '../format_utils.dart';
import '../theme/app_assets.dart';
import '../theme/app_theme.dart';
import '../live_refresh_mixin.dart';
import 'rule_detail_screen.dart';

/// Suggested Activities: everything the rule engine says is worth doing
/// right now (sky and/or weather matched), grouped as Plant / Spray /
/// Harvest / Prepare. Uses the same pipeline as Farmer Guidance
/// (GuidanceRepository), so results are consistent between the two screens.
///
/// A sky+weather rule can now fire off partial weather data — e.g. a
/// 3-day-ahead spray window backed only by today's manually logged rainfall,
/// with no forecast covering the other two days (see
/// RuleEngine.evaluateWeatherTriggerDetailed and
/// MatchedRule.isPartialWeatherData). That's the fix for this app's
/// offline-first guarantee actually applying to weather-gated rules, not
/// just sky-only ones — but a 1-day-backed average is a materially weaker
/// claim than a full-window forecast average, so cards flag it rather than
/// presenting the two identically.
///
/// Already had pull-to-refresh; also refreshes automatically when
/// connectivity returns or the app resumes (see LiveRefreshState), matching
/// Farmer Guidance and Home so weather-driven suggestions don't go stale
/// just because the farmer never manually pulled to refresh.
class SuggestedActivitiesScreen extends StatefulWidget {
  const SuggestedActivitiesScreen({super.key});

  @override
  State<SuggestedActivitiesScreen> createState() =>
      _SuggestedActivitiesScreenState();
}

class _SuggestedActivitiesScreenState extends State<SuggestedActivitiesScreen>
    with WidgetsBindingObserver, LiveRefreshState<SuggestedActivitiesScreen> {
  bool _loading = true;
  bool _hasLocation = true;
  String _lang = 'en';
  WeatherState _weather = WeatherState.empty;
  List<SuggestionGroup> _groups = const [];
  Map<int, String> _cropNames = const {};
  Map<int, String> _activityDescriptions = const {};

  @override
  void initState() {
    super.initState();
    _load();
    initLiveRefresh();
  }

  @override
  void dispose() {
    disposeLiveRefresh();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    handleAppLifecycleState(state);
  }

  @override
  Future<void> onLiveRefresh() => _load(showSpinner: false);

  Future<void> _load({bool showSpinner = true}) async {
    // Grab providers before any await.
    final userDb = context.read<UserDb>();
    final farmingDb = context.read<fdb.FarmingDb>();
    final repo = context.read<GuidanceRepository>();

    if (showSpinner) setState(() => _loading = true);
    try {
      final loc = await userDb.activeLocation();

      if (loc == null) {
        if (mounted) {
          setState(() {
            _hasLocation = false;
            _loading = false;
          });
        }
        return;
      }

      final lang = await repo.currentLanguage();

      final result = await repo.getGuidanceResult(
        locationId: loc.locationId,
        lat: loc.lat,
        lon: loc.lon,
        nowUtc: DateTime.now().toUtc(),
      );

      final activities = await farmingDb.select(farmingDb.activities).get();
      final crops = await farmingDb.select(farmingDb.crops).get();

      final typeById = {for (final a in activities) a.activityId: a.activityType};
      final descById = {
        for (final a in activities) a.activityId: a.descriptionI18n,
      };
      final cropNames = {for (final c in crops) c.cropId: c.name};

      if (!mounted) return;
      setState(() {
        _hasLocation = true;
        _lang = lang;
        _weather = result.weather;
        _groups = groupByActivityType(result.rules, typeById);
        _cropNames = cropNames;
        _activityDescriptions = descById;
        _loading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  static String _typeLabel(String type) {
    switch (type) {
      case 'plant':
        return 'Plant';
      case 'spray':
        return 'Spray';
      case 'harvest':
        return 'Harvest';
      case 'prepare':
        return 'Prepare';
      default:
        return 'Other';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Image.asset(AppIcons.chevronLeftWhite, width: 24, height: 24),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text('Suggested Activities'),
      ),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator(strokeWidth: 2))
            : RefreshIndicator(
                onRefresh: () => _load(showSpinner: false),
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                  children: _buildChildren(),
                ),
              ),
      ),
    );
  }

  List<Widget> _buildChildren() {
    if (!_hasLocation) {
      return const [_EmptyNote('Set your location first to see suggestions.')];
    }

    final children = <Widget>[];

    final fetchedAt = _weather.fetchedAt;
    if (_weather.isStale) {
      children.add(_Banner(
        fetchedAt == null
            ? 'No forecast available. Only sky-based suggestions are shown.'
            : 'Offline forecast, updated ${timeAgo(fetchedAt)}. May be outdated.',
      ));
      children.add(const SizedBox(height: 12));
    }

    if (_groups.isEmpty) {
      children.add(const _EmptyNote(
        'Nothing to suggest right now. Suggestions appear when today\'s sky '
        'and weather match a farming rule.',
      ));
      return children;
    }

    for (final g in _groups) {
      children.add(_SectionHeader(
        iconPath: activityIconFor(g.activityType),
        label: _typeLabel(g.activityType),
        count: g.matches.length,
      ));
      children.add(const SizedBox(height: 10));
      for (final m in g.matches) {
        final rule = m.rule;
        final text = localizedText(rule.guidance, lang: _lang).trim().isNotEmpty
            ? localizedText(rule.guidance, lang: _lang)
            : localizedText(_activityDescriptions[rule.activityId], lang: _lang);
        children.add(GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => _openDetail(g, m),
          child: _SuggestionCard(
            title: rule.cropId == null
                ? 'All crops'
                : (_cropNames[rule.cropId] ?? 'Crop #${rule.cropId}'),
            severity: rule.severity,
            body: text,
            verificationStatus: rule.verificationStatus,
            basis: _basisLabel(rule),
            isPartialWeatherData: m.isPartialWeatherData,
            weatherDaysAvailable: m.weatherDaysAvailable,
            weatherDaysExpected: m.weatherDaysExpected,
          ),
        ));
        children.add(const SizedBox(height: 12));
      }
      children.add(const SizedBox(height: 8));
    }
    return children;
  }

  void _openDetail(SuggestionGroup g, MatchedRule m) {
    final cropId = m.rule.cropId;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RuleDetailScreen(
          matched: m,
          activityLabel: g.activityType,
          cropName: cropId == null ? null : _cropNames[cropId],
        ),
      ),
    );
  }

  static String _basisLabel(FarmingRuleRow r) {
    final sky = r.skyTriggerId != null;
    final weather = r.weatherTriggerId != null;
    if (sky && weather) return 'Sky + weather';
    if (weather) return 'Weather';
    return 'Sky';
  }
}

class _SectionHeader extends StatelessWidget {
  final String iconPath;
  final String label;
  final int count;

  const _SectionHeader({
    required this.iconPath,
    required this.label,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(iconPath, width: 28, height: 28),
        const SizedBox(width: 10),
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.forestGreen,
          ),
        ),
        const SizedBox(width: 8),
        Text('$count', style: const TextStyle(fontSize: 13, color: AppColors.gray)),
      ],
    );
  }
}

class _SuggestionCard extends StatelessWidget {
  final String title;
  final String? severity;
  final String body;
  final String verificationStatus;
  final String basis;

  /// See MatchedRule.isPartialWeatherData — true when this card's weather
  /// condition was evaluated from fewer days than its rule's window calls
  /// for (e.g. only today's manually logged rainfall standing in for a
  /// 3-day average), rather than a full live/cached forecast window.
  final bool isPartialWeatherData;
  final int weatherDaysAvailable;
  final int weatherDaysExpected;

  const _SuggestionCard({
    required this.title,
    required this.severity,
    required this.body,
    required this.verificationStatus,
    required this.basis,
    this.isPartialWeatherData = false,
    this.weatherDaysAvailable = 0,
    this.weatherDaysExpected = 0,
  });

  static String _statusLabel(String s) {
    switch (s) {
      case 'confirmed':
        return 'Confirmed by farmers';
      case 'reviewed':
        return 'Reviewed by extension office';
      default:
        return 'Draft';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.grayLight3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.forestGreen,
                  ),
                ),
              ),
              if (severity != null && severity!.trim().isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.badgeGold,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    severity![0].toUpperCase() + severity!.substring(1),
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.forestGreen,
                    ),
                  ),
                ),
            ],
          ),
          if (body.trim().isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              body,
              style: const TextStyle(fontSize: 13, height: 1.35, color: AppColors.forestGreen),
            ),
          ],
          if (isPartialWeatherData) ...[
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline, size: 14, color: AppColors.gray),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Based on $weatherDaysAvailable of $weatherDaysExpected days of '
                    'weather data — likely from a logged observation rather than a '
                    'full forecast. Treat with extra caution.',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.gray,
                      fontStyle: FontStyle.italic,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 10),
          const Divider(height: 1, color: AppColors.grayLight3),
          const SizedBox(height: 10),
          Row(
            children: [
              Image.asset(AppIcons.shieldCheck, width: 16, height: 16),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  _statusLabel(verificationStatus),
                  style: const TextStyle(fontSize: 11, color: AppColors.gray),
                ),
              ),
              Text(basis, style: const TextStyle(fontSize: 11, color: AppColors.gray)),
              const SizedBox(width: 8),
              Image.asset(AppIcons.chevronRightDark, width: 14, height: 14),
            ],
          ),
        ],
      ),
    );
  }
}

class _Banner extends StatelessWidget {
  final String text;
  const _Banner(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.grayLight3,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(text, style: const TextStyle(fontSize: 12, color: AppColors.gray)),
    );
  }
}

class _EmptyNote extends StatelessWidget {
  final String text;
  const _EmptyNote(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 80),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14, color: AppColors.gray, height: 1.4),
        ),
      ),
    );
  }
}
