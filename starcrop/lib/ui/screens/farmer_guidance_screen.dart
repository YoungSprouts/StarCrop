import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/user/user_db.dart';
import '../../data/farming/farming_db.dart' as fdb;
import '../../repository/guidance_repository.dart';
import '../../engine/rule_engine.dart';
import '../../engine/i18n_text.dart';
import '../theme/app_theme.dart';
import '../theme/app_assets.dart';
import '../live_refresh_mixin.dart';
import 'rule_detail_screen.dart';

/// "Farmer Guidance" — list of currently-firing FarmingRules, each as a card
/// with activity icon, severity badge, guidance text, and a details CTA.
/// Matches the FARMER GUIDANCE mockup's card layout.
///
/// Guidance here is already weather-driven — GuidanceRepository.getGuidance
/// evaluates each rule's sky trigger AND its weather trigger (when it has
/// one) via RuleEngine — but this screen previously had no way to notice
/// when the weather half of that changed: no pull-to-refresh, and no
/// automatic reload on connectivity return or app resume. That meant "based
/// on weather data" was only true at the instant the screen first opened.
/// Both are added now via LiveRefreshMixin + a wrapping RefreshIndicator.
///
/// A card can now fire off partial weather data (see
/// RuleEngine.evaluateWeatherTriggerDetailed /
/// MatchedRule.isPartialWeatherData) — e.g. a multi-day-ahead rule backed
/// only by today's manually logged rainfall, with no forecast for the
/// remaining days. That's what lets weather-gated guidance work at all on a
/// fully offline device (the app's stated design), but a 1-day-backed
/// average is a materially weaker claim than a full forecast window, so
/// this is flagged on the card rather than shown identically.
class FarmerGuidanceScreen extends StatefulWidget {
  const FarmerGuidanceScreen({super.key});

  @override
  State<FarmerGuidanceScreen> createState() => _FarmerGuidanceScreenState();
}

class _FarmerGuidanceScreenState extends State<FarmerGuidanceScreen>
    with WidgetsBindingObserver, LiveRefreshState<FarmerGuidanceScreen> {
  List<MatchedRule> _rules = [];
  Map<int, fdb.Activity> _activities = {};
  Map<int, fdb.Crop> _crops = {};
  bool _loading = true;
  String _lang = 'en';

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
    if (showSpinner) setState(() => _loading = true);

    // Read providers before any await (use_build_context_synchronously).
    final userDb = context.read<UserDb>();
    final farmingDb = context.read<fdb.FarmingDb>();
    final guidance = context.read<GuidanceRepository>();
    final loc = await userDb.activeLocation();
    if (loc == null) {
      if (mounted) setState(() => _loading = false);
      return;
    }

    final results = await guidance.getGuidance(
      locationId: loc.locationId,
      lat: loc.lat,
      lon: loc.lon,
      nowUtc: DateTime.now().toUtc(),
    );
    final lang = await guidance.currentLanguage();

    final activityRows = await farmingDb.select(farmingDb.activities).get();
    final cropRows = await farmingDb.select(farmingDb.crops).get();

    if (!mounted) return;
    setState(() {
      _rules = results;
      _lang = lang;
      _activities = {for (final a in activityRows) a.activityId: a};
      _crops = {for (final c in cropRows) c.cropId: c};
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Farmer Guidance'),
        leading: IconButton(
          icon: Image.asset(AppIcons.chevronLeftWhite, width: 18, height: 18),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => _load(showSpinner: false),
              child: _rules.isEmpty
                  ? ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: const [
                        Padding(
                          padding: EdgeInsets.fromLTRB(32, 120, 32, 32),
                          child: Text(
                            'No guidance is firing for today yet — either conditions '
                            "aren't met, or farming rules haven't been loaded.",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: AppColors.gray),
                          ),
                        ),
                      ],
                    )
                  : ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(20),
                      itemCount: _rules.length,
                      itemBuilder: (context, i) {
                        final m = _rules[i];
                        final activity = _activities[m.rule.activityId];
                        final crop = m.rule.cropId != null ? _crops[m.rule.cropId] : null;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _GuidanceCard(
                            matched: m,
                            lang: _lang,
                            activity: activity,
                            cropName: crop?.name,
                            onViewDetails: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => RuleDetailScreen(
                                  matched: m,
                                  activityLabel: activity?.activityType ?? 'guidance',
                                  cropName: crop?.name,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
    );
  }
}

class _GuidanceCard extends StatelessWidget {
  final MatchedRule matched;
  final String lang;
  final fdb.Activity? activity;
  final String? cropName;
  final VoidCallback onViewDetails;

  const _GuidanceCard({
    required this.matched,
    required this.lang,
    required this.activity,
    required this.cropName,
    required this.onViewDetails,
  });

  Color _severityColor(String? severity) {
    switch (severity?.toLowerCase()) {
      case 'high':
      case 'severe':
        return const Color(0xFFC0453A);
      case 'moderate':
        return AppColors.badgeGold;
      case 'low':
        return AppColors.sageGreen;
      default:
        return AppColors.grayLight1;
    }
  }

  @override
  Widget build(BuildContext context) {
    final icon = activityIconFor(activity?.activityType ?? 'note');
    final title = cropName != null
        ? '${activity?.activityType.toUpperCase() ?? ''} · $cropName'
        : (activity?.activityType ?? 'Guidance').toUpperCase();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.grayLight2),
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.grayLight3,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Image.asset(icon, width: 26, height: 26),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: AppColors.forestGreen,
                      ),
                    ),
                    const SizedBox(height: 6),
                    if (matched.rule.severity != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: _severityColor(matched.rule.severity),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          matched.rule.severity![0].toUpperCase() +
                              matched.rule.severity!.substring(1),
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            localizedText(matched.rule.guidance, lang: lang),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13, color: AppColors.forestGreen, height: 1.4),
          ),
          if (matched.isPartialWeatherData) ...[
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline, size: 14, color: AppColors.gray),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Based on ${matched.weatherDaysAvailable} of '
                    '${matched.weatherDaysExpected} days of weather data — '
                    'likely a logged observation, not a full forecast.',
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
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 10),
          Row(
            children: [
              Image.asset(AppIcons.user, width: 16, height: 16),
              const SizedBox(width: 16),
              if (matched.rule.verificationStatus == 'confirmed')
                Image.asset(AppIcons.shieldCheck, width: 16, height: 16),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onViewDetails,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.sageGreen,
                foregroundColor: AppColors.forestGreen,
              ),
              icon: Image.asset(AppIcons.note, width: 18, height: 18),
              label: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text('View details')],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
