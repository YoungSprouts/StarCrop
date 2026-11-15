import 'package:flutter/material.dart';

/// Palette pulled directly from the design file (COLORS.png).
class AppColors {
  AppColors._();

  static const forestGreen = Color(0xFF1B3D26); // primary — headers, buttons, home bg
  static const gold = Color(0xFFC8AA35); // accent — highlights, active states, logo
  static const gray = Color(0xFF8D8F91); // secondary text, inactive icons
  static const grayLight1 = Color(0xFFC8C9CA); // borders, dividers
  static const grayLight2 = Color(0xFFCFD1D3); // subtle backgrounds
  static const grayLight3 = Color(0xFFE8E9EA); // card backgrounds
  static const grayLight4 = Color(0xFFECF0F4); // screen background

  // Convenience derived tones seen in the mockups (soft green for CTA pills,
  // moderate-severity badge gold, etc.) — not in the raw swatch list but
  // consistent with the palette's hue.
  static const sageGreen = Color(0xFF8FB89C); // "Add"/CTA pill green in guidance screens
  static const badgeGold = Color(0xFFD4B94A); // "Moderate" severity badge

  // AR camera overlay tones (Camera Check's live/static constellation
  // overlay — see SkyOverlayPainter). A live camera feed can be anything
  // from a bright daytime sky to a near-black night sky, so these are
  // deliberately more saturated/high-contrast than the rest of the palette
  // rather than reusing forestGreen/gold, which can read as muted or
  // nearly invisible drawn on top of a live preview.
  static const arLineGreen = Color(0xFF3DDC66); // constellation lines
  static const arStarYellow = Color(0xFFFFD84D); // individual star points
}

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      fontFamily: 'Inter',
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.forestGreen,
        primary: AppColors.forestGreen,
        secondary: AppColors.gold,
        surface: Colors.white,
        // `background` removed — deprecated in Material 3's ColorScheme.
        // The screen background is already controlled explicitly via
        // `scaffoldBackgroundColor` below (AppColors.grayLight4), so nothing
        // relied on this value.
      ),
      scaffoldBackgroundColor: AppColors.grayLight4,
    );

    return base.copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.forestGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      textTheme: base.textTheme.apply(
        fontFamily: 'Inter',
        bodyColor: AppColors.forestGreen,
        displayColor: AppColors.forestGreen,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      // Every primary button gets a real resting shadow (elevation 4) so it
      // reads as a raised, tappable surface instead of a flat colored rect
      // — plus state-based feedback so a press is felt immediately:
      // elevation rises on hover/focus (lifts toward the finger), sinks low
      // on press (looks physically pushed in), and the fill itself darkens
      // on press so there's a visible color change even before the press
      // animation finishes. This is a ButtonStyle (not the .styleFrom
      // shortcut) specifically so elevation/background can vary per
      // WidgetState instead of being pinned to one flat value.
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) return AppColors.grayLight2;
            if (states.contains(WidgetState.pressed)) {
              return Color.lerp(AppColors.forestGreen, Colors.black, 0.15);
            }
            return AppColors.forestGreen;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            return states.contains(WidgetState.disabled) ? AppColors.gray : Colors.white;
          }),
          elevation: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) return 0;
            if (states.contains(WidgetState.pressed)) return 1; // pushed in
            if (states.contains(WidgetState.hovered) ||
                states.contains(WidgetState.focused)) {
              return 6; // lifts up
            }
            return 4; // resting shadow — the "this is clickable" cue
          }),
          shadowColor: WidgetStateProperty.all(Colors.black.withValues(alpha: 0.35)),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          ),
          textStyle: WidgetStateProperty.all(
            const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
        ),
      ),
      // Outlined buttons stay flat by Material convention (they're the
      // secondary action, not the raised one) but still get a visible
      // press-state fill so tapping one is unmistakable, not just a border
      // color tweak.
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.all(AppColors.forestGreen),
          overlayColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) {
              return AppColors.forestGreen.withValues(alpha: 0.16);
            }
            if (states.contains(WidgetState.hovered)) {
              return AppColors.forestGreen.withValues(alpha: 0.08);
            }
            return null;
          }),
          side: WidgetStateProperty.all(const BorderSide(color: AppColors.grayLight1)),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          ),
          textStyle: WidgetStateProperty.all(
            const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
        ),
      ),
      // The camera-check FAB on Home is the other real "button" in the app
      // — same lift-on-hover/sink-on-press treatment as ElevatedButton above.
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        elevation: 6,
        focusElevation: 8,
        hoverElevation: 8,
        highlightElevation: 2,
        disabledElevation: 0,
      ),
    );
  }
}
