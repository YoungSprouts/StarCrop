import 'package:starcrop/engine/activity_grouping.dart';
import 'package:starcrop/engine/i18n_text.dart';
import 'package:starcrop/engine/rule_engine.dart';
import 'package:test/test.dart';

MatchedRule _match(
  int ruleId,
  int activityId, {
  String? severity,
  String status = 'reviewed',
}) =>
    MatchedRule(
      rule: FarmingRuleRow(
        ruleId: ruleId,
        activityId: activityId,
        guidance: 'g$ruleId',
        severity: severity,
        verificationStatus: status,
      ),
      skyMatched: true,
      weatherMatched: null,
      weatherDataAvailable: true,
    );

void main() {
  group('groupByActivityType', () {
    const types = {1: 'harvest', 2: 'plant', 3: 'spray', 4: 'prepare'};

    test('orders groups plant, spray, harvest, prepare; unknown last', () {
      final groups = groupByActivityType([
        _match(1, 1), // harvest
        _match(2, 2), // plant
        _match(3, 3), // spray
        _match(4, 4), // prepare
        _match(5, 99), // unknown activity id -> other
      ], types);
      expect(groups.map((g) => g.activityType),
          ['plant', 'spray', 'harvest', 'prepare', 'other']);
    });

    test('is case-insensitive on activity type', () {
      final groups = groupByActivityType([_match(1, 1)], {1: 'Plant'});
      expect(groups.single.activityType, 'plant');
    });

    test('sorts within a group: severity, then verification, then rule id', () {
      final groups = groupByActivityType([
        _match(10, 2, severity: 'Low'),
        _match(11, 2, severity: 'High', status: 'draft'),
        _match(12, 2, severity: 'High', status: 'confirmed'),
        _match(13, 2, severity: 'Moderate'),
        _match(14, 2), // no severity -> last
      ], types);
      expect(groups.single.matches.map((m) => m.rule.ruleId),
          [12, 11, 13, 10, 14]);
    });

    test('empty input gives no groups', () {
      expect(groupByActivityType([], types), isEmpty);
    });
  });

  group('localizedText', () {
    test('plain text is returned unchanged', () {
      expect(localizedText('Plant now'), 'Plant now');
    });

    test('JSON map picks the requested language', () {
      const raw = '{"en":"Plant now","fil":"Magtanim na"}';
      expect(localizedText(raw, lang: 'fil'), 'Magtanim na');
    });

    test('JSON map falls back to en, then first value', () {
      expect(localizedText('{"en":"Hi","fil":"Kumusta"}', lang: 'ilo'), 'Hi');
      expect(localizedText('{"fil":"Kumusta"}', lang: 'ilo'), 'Kumusta');
    });

    test('broken JSON and null are safe', () {
      expect(localizedText('{not json'), '{not json');
      expect(localizedText(null), '');
    });
  });
}
