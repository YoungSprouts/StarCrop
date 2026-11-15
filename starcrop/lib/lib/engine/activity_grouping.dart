import 'rule_engine.dart';

/// Display order of activity types on the Suggested Activities screen.
/// Anything not listed here goes last, under 'other'.
const activityTypeOrder = ['plant', 'spray', 'harvest', 'prepare'];

class SuggestionGroup {
  final String activityType; // plant, spray, harvest, prepare, other
  final List<MatchedRule> matches;

  const SuggestionGroup(this.activityType, this.matches);
}

/// Lower = more urgent. Unknown/missing severity sorts last.
int severityRank(String? severity) {
  switch (severity?.trim().toLowerCase()) {
    case 'high':
    case 'severe':
      return 0;
    case 'moderate':
    case 'medium':
      return 1;
    case 'low':
      return 2;
    default:
      return 3;
  }
}

int _verificationRank(String status) {
  switch (status) {
    case 'confirmed':
      return 0;
    case 'reviewed':
      return 1;
    default:
      return 2; // draft / unknown
  }
}

int _typeRank(String type) {
  final i = activityTypeOrder.indexOf(type);
  return i == -1 ? activityTypeOrder.length : i;
}

/// Groups firing rules by their activity's type, in a fixed display order,
/// and sorts each group: severity, then verification status (confirmed
/// first), then rule id (stable).
List<SuggestionGroup> groupByActivityType(
  List<MatchedRule> firing,
  Map<int, String> activityTypeById,
) {
  final buckets = <String, List<MatchedRule>>{};
  for (final m in firing) {
    final type =
        (activityTypeById[m.rule.activityId] ?? 'other').trim().toLowerCase();
    (buckets[type] ??= []).add(m);
  }

  final types = buckets.keys.toList()
    ..sort((a, b) {
      final c = _typeRank(a).compareTo(_typeRank(b));
      return c != 0 ? c : a.compareTo(b);
    });

  return [
    for (final t in types)
      SuggestionGroup(
        t,
        buckets[t]!
          ..sort((a, b) {
            var c = severityRank(a.rule.severity)
                .compareTo(severityRank(b.rule.severity));
            if (c != 0) return c;
            c = _verificationRank(a.rule.verificationStatus)
                .compareTo(_verificationRank(b.rule.verificationStatus));
            if (c != 0) return c;
            return a.rule.ruleId.compareTo(b.rule.ruleId);
          }),
      ),
  ];
}
