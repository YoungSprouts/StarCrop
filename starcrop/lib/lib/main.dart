import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_providers.dart';
import 'data/reference/reference_db.dart';
import 'data/farming/farming_db.dart';
import 'data/user/user_db.dart';
import 'data/seed/starcrop_seed_loader.dart';
import 'ui/theme/app_theme.dart';
import 'ui/screens/splash_screen.dart';

void main() {
  runApp(const StarCropApp());
}

class StarCropApp extends StatelessWidget {
  const StarCropApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppProviders(
      child: Builder(
        builder: (context) {
          // Seed real starter content on first launch (no-op once either DB
          // has data — never touches a real shipped asset or content pack).
          return FutureBuilder<void>(
            future: StarcropSeedLoader.seedIfEmpty(
              reference: context.read<ReferenceDb>(),
              farming: context.read<FarmingDb>(),
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const MaterialApp(
                  debugShowCheckedModeBanner: false,
                  home: Scaffold(body: Center(child: CircularProgressIndicator())),
                );
              }
              return MaterialApp(
                title: 'StarCrop',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.light,
                // Applies the farmer's chosen text size (Settings -> Text
                // Size, saved to UserSettings under key 'text_scale') across
                // the whole app. This watches the row (rather than reading
                // it once at startup) so changing the setting takes effect
                // immediately, without restarting the app. Defaults to 1.0
                // (Default size) when nothing has been chosen yet.
                builder: (context, child) {
                  final userDb = context.read<UserDb>();
                  return StreamBuilder<String?>(
                    stream: (userDb.select(userDb.userSettings)
                          ..where((t) => t.key.equals('text_scale')))
                        .watchSingleOrNull()
                        .map((row) => row?.value),
                    builder: (context, snapshot) {
                      final scale = double.tryParse(snapshot.data ?? '') ?? 1.0;
                      return MediaQuery.withClampedTextScaling(
                        minScaleFactor: scale,
                        maxScaleFactor: scale,
                        child: child!,
                      );
                    },
                  );
                },
                home: const SplashScreen(),
              );
            },
          );
        },
      ),
    );
  }
}
