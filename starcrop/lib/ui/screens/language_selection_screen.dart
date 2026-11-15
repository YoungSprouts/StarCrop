import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/user/user_db.dart';
import '../theme/app_assets.dart';
import '../theme/app_theme.dart';
import 'location_prompt_screen.dart';

/// First onboarding step after "Get Started" on the splash screen — lets a
/// new farmer pick their language before anything else, since every screen
/// after this (Farmer Guidance, Suggested Activities, etc.) renders text
/// via i18n_text.dart's localizedText() keyed off this same choice.
///
/// Saves straight to UserSettings under the 'language' key — the same key
/// user_settings_screen.dart reads/writes — so this is just an earlier
/// entry point to the same setting, not a separate onboarding-only value.
/// Defaults to English selected; the farmer can always change it again
/// later in Settings.
///
/// 'akl' (Aklanon) is a best-effort draft translation, unlike 'en'/'fil' —
/// see starcrop_seed_loader.dart's doc comment.
class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  // Keep in sync with user_settings_screen.dart's _languages map — same
  // key space and ordering.
  static const _languages = {
    'en': 'English',
    'fil': 'Filipino',
    'akl': 'Aklanon',
  };

  String _selected = 'en';
  bool _saving = false;

  Future<void> _continue() async {
    setState(() => _saving = true);
    final userDb = context.read<UserDb>();
    await userDb.into(userDb.userSettings).insertOnConflictUpdate(
          UserSettingsCompanion.insert(key: 'language', value: _selected),
        );
    if (!mounted) return;
    // pushReplacement, matching splash_screen.dart's own onboarding
    // navigation — keeps the back stack from growing during first-run
    // setup (there's nothing meaningful to go "back" to here anyway).
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LocationPromptScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(flex: 3),
              const Text(
                'Choose your language',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.forestGreen,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'You can change this later in Settings.',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  color: AppColors.gray,
                ),
              ),
              const SizedBox(height: 24),
              for (final entry in _languages.entries)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _LanguageOption(
                    label: entry.value,
                    selected: _selected == entry.key,
                    onTap: () => setState(() => _selected = entry.key),
                  ),
                ),
              const Spacer(flex: 2),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saving ? null : _continue,
                  child: Text(_saving ? 'Saving…' : 'Continue'),
                ),
              ),
              const Spacer(flex: 4),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.forestGreen : AppColors.grayLight3,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(
                selected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                color: selected ? Colors.white : AppColors.gray,
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: selected ? Colors.white : AppColors.forestGreen,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
