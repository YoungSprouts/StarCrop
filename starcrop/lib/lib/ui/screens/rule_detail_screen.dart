import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

// Prefixed: user_db.dart defines a table class named `Feedback`, which would
// clash with Flutter's own `Feedback` widget if imported unprefixed.
import '../../data/user/user_db.dart' as udb;
import '../../engine/i18n_text.dart';
import '../../engine/rule_engine.dart';
import '../../repository/guidance_repository.dart';
import '../theme/app_assets.dart';
import '../theme/app_theme.dart';

/// Full view of one firing rule: complete guidance text, why it fired
/// (sky / weather), how well verified it is, and a feedback box that saves a
/// note against the rule in UserDb.Feedback (on-device only for now).
///
/// Opened from Farmer Guidance ("View details") and Suggested Activities.
class RuleDetailScreen extends StatefulWidget {
  final MatchedRule matched;
  final String activityLabel; // activity type, e.g. 'plant'
  final String? cropName;

  const RuleDetailScreen({
    super.key,
    required this.matched,
    required this.activityLabel,
    this.cropName,
  });

  @override
  State<RuleDetailScreen> createState() => _RuleDetailScreenState();
}

class _RuleDetailScreenState extends State<RuleDetailScreen> {
  final _note = TextEditingController();
  String _lang = 'en';
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    _loadLang();
    _note.addListener(() => setState(() {})); // enable/disable Send button
  }

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  Future<void> _loadLang() async {
    final repo = context.read<GuidanceRepository>();
    final lang = await repo.currentLanguage();
    if (mounted) setState(() => _lang = lang);
  }

  Future<void> _send() async {
    final text = _note.text.trim();
    if (text.isEmpty || _sending) return;

    // Read everything from context before the await.
    final userDb = context.read<udb.UserDb>();
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _sending = true);

    try {
      await userDb.into(userDb.feedback).insert(
            udb.FeedbackCompanion.insert(
              feedbackId: const Uuid().v4(),
              ruleId: Value(widget.matched.rule.ruleId),
              note: Value(text),
            ),
          );
      if (!mounted) return;
      _note.clear();
      messenger.showSnackBar(
        const SnackBar(content: Text('Thank you. Your note was saved on this device.')),
      );
    } catch (_) {
      messenger.showSnackBar(
        const SnackBar(content: Text("Couldn't save your note. Please try again.")),
      );
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

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
    final rule = widget.matched.rule;
    final type = widget.activityLabel.toLowerCase();
    final title = widget.cropName != null
        ? '${widget.activityLabel.toUpperCase()} · ${widget.cropName}'
        : widget.activityLabel.toUpperCase();
    final severity = rule.severity;
    final hasSeverity = severity != null && severity.trim().isNotEmpty;

    final reasons = <String>[
      if (rule.skyTriggerId != null) "Today's sky matches this rule.",
      if (rule.weatherTriggerId != null && !widget.matched.isPartialWeatherData)
        'The weather forecast matches this rule.',
      if (rule.weatherTriggerId != null && widget.matched.isPartialWeatherData)
        'The weather condition matches, but only ${widget.matched.weatherDaysAvailable} '
            'of ${widget.matched.weatherDaysExpected} days had data available — likely '
            'from a manually logged observation rather than a full forecast. Treat '
            'this guidance with extra caution until more days of weather are known.',
      if (rule.skyTriggerId == null && rule.weatherTriggerId == null)
        'This is general guidance, not tied to a specific sky or weather condition.',
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Guidance details'),
        leading: IconButton(
          icon: Image.asset(AppIcons.chevronLeftWhite, width: 18, height: 18),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
              20, 20, 20, 20 + MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.grayLight3,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Image.asset(activityIconFor(type), width: 30, height: 30),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 17,
                            color: AppColors.forestGreen,
                          ),
                        ),
                        if (hasSeverity) ...[
                          const SizedBox(height: 8),
                          Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: _severityColor(severity),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              severity[0].toUpperCase() + severity.substring(1),
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                localizedText(rule.guidance, lang: _lang),
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.45,
                  color: AppColors.forestGreen,
                ),
              ),
              const SizedBox(height: 20),
              const Divider(height: 1, color: AppColors.grayLight3),
              const SizedBox(height: 16),
              const _SectionTitle('Why you are seeing this'),
              const SizedBox(height: 8),
              for (final r in reasons)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(
                    r,
                    style: const TextStyle(fontSize: 13, color: AppColors.forestGreen),
                  ),
                ),
              const SizedBox(height: 12),
              Row(
                children: [
                  if (rule.verificationStatus == 'confirmed') ...[
                    Image.asset(AppIcons.shieldCheck, width: 18, height: 18),
                    const SizedBox(width: 8),
                  ],
                  Expanded(
                    child: Text(
                      _statusLabel(rule.verificationStatus),
                      style: const TextStyle(fontSize: 13, color: AppColors.gray),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Divider(height: 1, color: AppColors.grayLight3),
              const SizedBox(height: 16),
              const _SectionTitle('Was this useful on your farm?'),
              const SizedBox(height: 4),
              const Text(
                'Your note is saved on this device.',
                style: TextStyle(fontSize: 12, color: AppColors.gray),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _note,
                minLines: 3,
                maxLines: 6,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  hintText: 'Tell us what happened when you tried this.',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (_note.text.trim().isEmpty || _sending) ? null : _send,
                  child: Text(_sending ? 'Saving…' : 'Send feedback'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: AppColors.forestGreen,
      ),
    );
  }
}
