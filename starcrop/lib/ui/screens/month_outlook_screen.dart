import 'package:flutter/material.dart';

import '../../data/farming/farming_db.dart' as fdb;
import '../../engine/i18n_text.dart';
import '../../engine/rule_engine.dart';
import '../theme/app_assets.dart';
import '../theme/app_theme.dart';
import 'rule_detail_screen.dart';

/// Full detail view behind the Home screen's "Next Month Outlook" preview
/// card — the published seasonal climate normal for that month (when one is
/// seeded), plus every sky-based farming rule firing for a date roughly a
/// month from now (see GuidanceRepository.getNextMonthGuidance). All data is
/// handed in from HomeScreen, which already loaded it for the preview card,
/// so this screen does no querying of its own.
class MonthOutlookScreen extends StatelessWidget {
  final int monthNumber; // 1-12
  final fdb.SeasonalClimateNormal? climate;
  final String? anchorLabel;
  final List<MatchedRule> guidance;
  final Map<int, String> activityTypeById;
  final Map<int, String> cropNames;
  final String lang;

  const MonthOutlookScreen({
    super.key,
    required this.monthNumber,
    required this.climate,
    required this.anchorLabel,
    required this.guidance,
    required this.activityTypeById,
    required this.cropNames,
    this.lang = 'en',
  });

  static const _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  @override
  Widget build(BuildContext context) {
    final monthName = _months[monthNumber - 1];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Outlook · $monthName'),
        leading: IconButton(
          icon: Image.asset(AppIcons.chevronLeftWhite, width: 18, height: 18),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            if (climate != null) ...[
              _ClimateCard(climate: climate!, anchorLabel: anchorLabel),
              const SizedBox(height: 24),
            ],
            const Text(
              'Sky-based guidance',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: AppColors.forestGreen,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              "Weather-gated rules aren't included here — there's no real "
              "forecast this far out, only a monthly average, so this list "
              "only shows guidance based on the sky itself (moon phase, "
              "constellations, the planting calendar).",
              style: TextStyle(fontSize: 12, color: AppColors.gray, height: 1.4),
            ),
            const SizedBox(height: 16),
            if (guidance.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 24),
                child: Center(
                  child: Text(
                    'No sky-based guidance is flagged for this month yet.',
                    style: TextStyle(color: AppColors.gray),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            else
              for (final m in guidance)
                Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: _GuidanceRow(
                    matched: m,
                    lang: lang,
                    activityType: activityTypeById[m.rule.activityId],
                    cropName: m.rule.cropId == null ? null : cropNames[m.rule.cropId],
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => RuleDetailScreen(
                          matched: m,
                          activityLabel: activityTypeById[m.rule.activityId] ?? 'guidance',
                          cropName: m.rule.cropId == null ? null : cropNames[m.rule.cropId],
                        ),
                      ),
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

class _ClimateCard extends StatelessWidget {
  final fdb.SeasonalClimateNormal climate;
  final String? anchorLabel;

  const _ClimateCard({required this.climate, required this.anchorLabel});

  // Same wording as upcoming_weather_screen.dart's equivalent card — this is
  // published climate-normal data, not a rule an extension office reviewed,
  // so it gets its own status copy rather than reusing the rule labels.
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
    final classification = climate.classification.isEmpty
        ? ''
        : climate.classification[0].toUpperCase() + climate.classification.substring(1);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.grayLight4,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.grayLight2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(AppIcons.waterDrop3, width: 20, height: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  classification,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: AppColors.forestGreen,
                  ),
                ),
              ),
            ],
          ),
          if (anchorLabel != null) ...[
            const SizedBox(height: 4),
            Text(
              "Around $anchorLabel's rise",
              style: const TextStyle(fontSize: 12, color: AppColors.gray),
            ),
          ],
          const SizedBox(height: 10),
          Text(
            'Typically ${climate.avgRainMm.round()} mm rain · '
            '${climate.tempMinC.round()}–${climate.tempMaxC.round()}°C',
            style: const TextStyle(fontSize: 14, color: AppColors.gray),
          ),
          const SizedBox(height: 10),
          const Text(
            'Typical for this time of year, based on historical climate '
            'data — not a forecast.',
            style: TextStyle(fontSize: 11, color: AppColors.gray, fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.grayLight2),
          const SizedBox(height: 10),
          Row(
            children: [
              if (climate.verificationStatus == 'confirmed') ...[
                Image.asset(AppIcons.shieldCheck, width: 14, height: 14),
                const SizedBox(width: 6),
              ],
              Expanded(
                child: Text(
                  _statusLabel(climate.verificationStatus),
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

class _GuidanceRow extends StatelessWidget {
  final MatchedRule matched;
  final String lang;
  final String? activityType;
  final String? cropName;
  final VoidCallback onTap;

  const _GuidanceRow({
    required this.matched,
    required this.lang,
    required this.activityType,
    required this.cropName,
    required this.onTap,
  });

  static Color _severityColor(String? severity) {
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
    final title = cropName != null
        ? '${(activityType ?? 'guidance').toUpperCase()} · $cropName'
        : (activityType ?? 'Guidance').toUpperCase();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 12,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(activityIconFor(activityType ?? 'note'), width: 22, height: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                              color: AppColors.forestGreen,
                            ),
                          ),
                        ),
                        if (matched.rule.severity != null)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: _severityColor(matched.rule.severity),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              matched.rule.severity![0].toUpperCase() +
                                  matched.rule.severity!.substring(1),
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      localizedText(matched.rule.guidance, lang: lang),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.forestGreen,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
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
