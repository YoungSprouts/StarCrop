import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/user/user_db.dart';
import '../theme/app_theme.dart';
import '../theme/app_assets.dart';
import '../home_screen.dart';
import 'location_prompt_screen.dart';

/// First screen shown on cold start. Matches "APP LAUNCH" mockup: dark green
/// background, gold constellation logo, title + tagline, gold spinner.
///
/// Behavior depends on whether this is a fresh install:
///  - Returning user (a saved location already exists): unchanged — the
///    spinner spins for a short delay and auto-advances straight to Home,
///    no user action needed.
///  - Fresh install (no saved location yet, i.e. onboarding hasn't been
///    completed): after that same delay, the spinner smoothly morphs into a
///    gold "Get Started" pill instead of auto-navigating. The user taps it
///    to move on to LocationPromptScreen. This gives first-time users a
///    deliberate entry point instead of getting swept into the app.
///
/// Layout is fully responsive: the brand block is always dead-center on the
/// screen (not approximated with flex ratios), and the logo/title scale with
/// the device's shortest side so this reads correctly from a small phone up
/// to a tablet.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _morphController;
  late final Animation<double> _morph;

  // Null while we haven't checked the DB yet. Once known: true = fresh
  // install (no saved location), so the spinner should morph into the
  // button below instead of auto-navigating; false = returning user, in
  // which case we navigate away before this ever matters.
  bool _isFreshInstall = false;

  @override
  void initState() {
    super.initState();
    _morphController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _morph = CurvedAnimation(parent: _morphController, curve: Curves.easeInOutCubic);
    _proceed();
  }

  @override
  void dispose() {
    _morphController.dispose();
    super.dispose();
  }

  Future<void> _proceed() async {
    await Future.delayed(const Duration(milliseconds: 1800));
    if (!mounted) return;

    final userDb = context.read<UserDb>();
    final existing = await userDb.activeLocation();

    if (!mounted) return;

    if (existing != null) {
      // Returning user: original behavior, no button, straight through.
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
      return;
    }

    // Fresh install: stop here and morph the spinner into a button instead
    // of navigating automatically.
    setState(() => _isFreshInstall = true);
    _morphController.forward();
  }

  void _onGetStarted() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LocationPromptScreen()),
    );
  }

  double _lerp(double a, double b, double t) => a + (b - a) * t;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.forestGreen,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Scale off the shortest side so this looks right in both
            // portrait phones and wider tablets, and clamp so it never gets
            // comically large or small.
            final shortestSide = constraints.maxWidth < constraints.maxHeight
                ? constraints.maxWidth
                : constraints.maxHeight;
            final logoSize = (shortestSide * 0.32).clamp(88.0, 160.0);
            final titleSize = (shortestSide * 0.095).clamp(28.0, 40.0);
            final buttonWidth = constraints.maxWidth - 64;

            return Stack(
              children: [
                // Truly centered brand block. Using Center (instead of
                // Spacer(flex: 3)/Spacer(flex: 5), which only "centers" by
                // coincidence on one screen height) keeps this centered on
                // every device.
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(AppIcons.logoGold, width: logoSize, height: logoSize),
                        const SizedBox(height: 24),
                        Text(
                          'StarCrop',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: titleSize,
                            fontWeight: FontWeight.w700,
                            color: AppColors.gold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Your Stars, Your Farm, Your Guide.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Spinner pinned near the bottom as a fraction of screen
                // height, not a fixed pixel offset, so it never collides
                // with the brand block on short screens. On a fresh install
                // this morphs into a "Get Started" pill once _proceed()
                // flips _isFreshInstall and starts the controller; for
                // returning users the controller never runs and this just
                // renders as the plain spinner until navigation happens.
                Align(
                  alignment: const Alignment(0, 0.82),
                  child: AnimatedBuilder(
                    animation: _morph,
                    builder: (context, _) {
                      final t = _isFreshInstall ? _morph.value : 0.0;
                      final width = _lerp(32, buttonWidth, t);
                      final height = _lerp(32, 56, t);
                      final radius = _lerp(16, 28, t);

                      // Spinner fades out over the first 40% of the morph;
                      // the label fades in over the back 40%. That overlap
                      // gap in the middle is covered by the pill's fill
                      // color itself, so nothing pops in/out abruptly.
                      final spinnerOpacity = (1 - t / 0.4).clamp(0.0, 1.0);
                      final labelOpacity = ((t - 0.6) / 0.4).clamp(0.0, 1.0);
                      final fillOpacity = t.clamp(0.0, 1.0);

                      return GestureDetector(
                        onTap: t >= 1.0 ? _onGetStarted : null,
                        child: Container(
                          width: width,
                          height: height,
                          decoration: BoxDecoration(
                            color: AppColors.gold.withOpacity(fillOpacity),
                            borderRadius: BorderRadius.circular(radius),
                          ),
                          alignment: Alignment.center,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Opacity(
                                opacity: spinnerOpacity,
                                child: const SizedBox(
                                  width: 32,
                                  height: 32,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.gold),
                                  ),
                                ),
                              ),
                              Opacity(
                                opacity: labelOpacity,
                                child: const Text(
                                  'Get Started',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.forestGreen,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
