import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/farming/farming_db.dart' as fdb;
import '../../engine/i18n_text.dart';
import '../theme/app_theme.dart';
import '../theme/app_assets.dart';

/// "All Guidance" — browses every FarmingRule in the content pack,
/// regardless of whether it's firing today. Farmer Guidance and Suggested
/// Activities both only ever show rules matching *today's* sky/weather, so
/// there was previously no way to see the whole content pack: check what a
/// draft/unreviewed rule says, browse guidance for an out-of-season crop, or
/// just audit what's actually in FarmingDb.
///
/// ASSUMPTION: this file existed but was empty, with no spec elsewhere in
/// the codebase for what it was supposed to be. This is a reasonable
/// default reading of the name ("rule data") given the rest of the app's
/// patterns — a full reference/browse list, filterable by verification
/// status and activity type. If the original intent was an editor/admin
/// view for content-pack authors instead, the data-loading below is still
/// the right starting point; only the widget tree would need to change.
class RuleDataScreen extends StatefulWidget {
  const RuleDataScreen({super.key});

  @override
  State<RuleDataScreen> createState() => _RuleDataScreenState();
}

class _RuleDataScreenState extends State<RuleDataScreen> {
  bool _loading = true;
  final String _lang = 'en'; // TODO: wire to GuidanceRepository.currentLanguage() if this screen gets a real home

  List<fdb.FarmingRule> _rules = const [];
  Map<int, fdb.Activity> _activities = {};
  Map<int, fdb.Crop> _crops = {};
  Map<int, fdb.Region> _regions = {};
  Map<int, fdb.Source> _sources = {};

  String? _statusFilter; // null = all
  int? _activityFilter; // activityId, null = all

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final farmingDb = context.read<fdb.FarmingDb>();

    final rules = await farmingDb.select(farmingDb.farmingRules).get();
    final activities = await farmingDb.select(farmingDb.activities).get();
    final crops = await farmingDb.select(farmingDb.crops).get();
    final regions = await farmingDb.select(farmingDb.regions).get();
    final sources = await farmingDb.select(farmingDb.sources).get();

    if (!mounted) return;
    setState(() {
      _rules = rules;
      _activities = {for (final a in activities) a.activityId: a};
      _crops = {for (final c in crops) c.cropId: c};
      _regions = {for (final r in regions) r.regionId: r};
      _sources = {for (final s in sources) s.sourceId: s};
      _loading = false;
    });
  }

  List<fdb.FarmingRule> get _filtered {
    final list = _rules.where((r) {
      if (_statusFilter != null && r.verificationStatus != _statusFilter) {
        return false;
      }
      if (_activityFilter != null && r.activityId != _activityFilter) {
        return false;
      }
      return true;
    }).toList();
    list.sort((a, b) => a.ruleId.compareTo(b.ruleId));
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    final activityList = _activities.values.toList()
      ..sort((a, b) => a.activityId.compareTo(b.activityId));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Image.asset(AppIcons.chevronLeftWhite, width: 18, height: 18),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text('All Guidance'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _FilterBar(
                  activities: activityList,
                  statusFilter: _statusFilter,
                  activityFilter: _activityFilter,
                  onStatusChanged: (s) => setState(() => _statusFilter = s),
                  onActivityChanged: (a) => setState(() => _activityFilter = a),
                ),
                Expanded(
                  child: filtered.isEmpty
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(32),
                            child: Text(
                              'No rules match this filter.',
                              style: TextStyle(color: AppColors.gray),
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(20),
                          itemCount: filtered.length,
                          itemBuilder: (context, i) {
                            final r = filtered[i];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 14),
                              child: _RuleCard(
                                rule: r,
                                lang: _lang,
                                activity: _activities[r.activityId],
                                cropName:
                                    r.cropId == null ? null : _crops[r.cropId]?.name,
                                regionName: r.regionId == null
                                    ? null
                                    : _regions[r.regionId]?.name,
                                source: _sources[r.sourceId],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  final List<fdb.Activity> activities;
  final String? statusFilter;
  final int? activityFilter;
  final ValueChanged<String?> onStatusChanged;
  final ValueChanged<int?> onActivityChanged;

  const _FilterBar({
    required this.activities,
    required this.statusFilter,
    required this.activityFilter,
    required this.onStatusChanged,
    required this.onActivityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _Chip(
              label: 'All statuses',
              selected: statusFilter == null,
              onTap: () => onStatusChanged(null),
            ),
            for (final s in const ['confirmed', 'reviewed', 'draft'])
              _Chip(
                label: s[0].toUpperCase() + s.substring(1),
                selected: statusFilter == s,
                onTap: () => onStatusChanged(s),
              ),
            const SizedBox(width: 12),
            _Chip(
              label: 'All activities',
              selected: activityFilter == null,
              onTap: () => onActivityChanged(null),
            ),
            for (final a in activities)
              _Chip(
                label: a.activityType,
                selected: activityFilter == a.activityId,
                onTap: () => onActivityChanged(a.activityId),
              ),
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _Chip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
        selectedColor: AppColors.forestGreen,
        labelStyle: TextStyle(
          color: selected ? Colors.white : AppColors.forestGreen,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        backgroundColor: AppColors.grayLight3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}

class _RuleCard extends StatelessWidget {
  final fdb.FarmingRule rule;
  final String lang;
  final fdb.Activity? activity;
  final String? cropName;
  final String? regionName;
  final fdb.Source? source;

  const _RuleCard({
    required this.rule,
    required this.lang,
    required this.activity,
    required this.cropName,
    required this.regionName,
    required this.source,
  });

  static String _statusLabel(String s) {
    switch (s) {
      case 'confirmed':
        return 'Confirmed by farmers';
      case 'reviewed':
        return 'Reviewed by extension office';
      default:
        return 'Draft, not yet reviewed';
    }
  }

  @override
  Widget build(BuildContext context) {
    final titleParts = <String>[
      activity?.activityType.toUpperCase() ?? 'GUIDANCE',
      if (cropName != null) cropName!,
      if (regionName != null) regionName!,
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.grayLight3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                activityIconFor(activity?.activityType ?? 'note'),
                width: 22,
                height: 22,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  titleParts.join(' · '),
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: AppColors.forestGreen,
                  ),
                ),
              ),
              if (rule.severity != null && rule.severity!.trim().isNotEmpty)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.badgeGold,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    rule.severity![0].toUpperCase() + rule.severity!.substring(1),
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            localizedText(rule.guidanceI18n, lang: lang),
            style: const TextStyle(
              fontSize: 13,
              height: 1.35,
              color: AppColors.forestGreen,
            ),
          ),
          const SizedBox(height: 10),
          const Divider(height: 1, color: AppColors.grayLight3),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  _statusLabel(rule.verificationStatus),
                  style: const TextStyle(fontSize: 11, color: AppColors.gray),
                ),
              ),
              if (source != null)
                Flexible(
                  child: Text(
                    source!.name,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.gray,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
