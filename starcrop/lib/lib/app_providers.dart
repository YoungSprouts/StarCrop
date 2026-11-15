import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'data/reference/reference_db.dart';
import 'data/farming/farming_db.dart';
import 'data/user/user_db.dart';
import 'data/cache/cache_db.dart';
import 'repository/sky_repository.dart';
import 'repository/guidance_repository.dart';
import 'repository/ar_capability_repository.dart';

/// Single place that constructs the four DBs and both repositories, then
/// exposes them via Provider. Widgets read these with context.read/watch —
/// nothing else in the app should call a DB constructor directly.
class AppProviders extends StatelessWidget {
  final Widget child;
  const AppProviders({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ReferenceDb>(
          create: (_) => ReferenceDb(),
          dispose: (_, db) => db.close(),
        ),
        Provider<FarmingDb>(
          create: (_) => FarmingDb(),
          dispose: (_, db) => db.close(),
        ),
        Provider<UserDb>(
          create: (_) => UserDb(),
          dispose: (_, db) => db.close(),
        ),
        Provider<CacheDb>(
          create: (_) => CacheDb(),
          dispose: (_, db) => db.close(),
        ),
        ProxyProvider<ReferenceDb, SkyRepository>(
          update: (_, referenceDb, __) => SkyRepository(referenceDb),
        ),
        ProxyProvider4<FarmingDb, CacheDb, UserDb, SkyRepository, GuidanceRepository>(
          update: (_, farmingDb, cacheDb, userDb, skyRepo, __) => GuidanceRepository(
            farmingDb: farmingDb,
            cacheDb: cacheDb,
            userDb: userDb,
            skyRepository: skyRepo,
          ),
        ),
        ProxyProvider<UserDb, ArCapabilityRepository>(
          update: (_, userDb, __) => ArCapabilityRepository(userDb),
        ),
      ],
      child: child,
    );
  }
}
