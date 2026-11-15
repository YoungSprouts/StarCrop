import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

part 'cache_db.g.dart';

class WeatherForecastCache extends Table {
  TextColumn get locationId => text()(); // ref: user db saved_locations.location_id
  DateTimeColumn get fetchedAt => dateTime()();
  DateTimeColumn get validUntil => dateTime()();
  TextColumn get payloadJson => text()();

  @override
  Set<Column> get primaryKey => {locationId};
}

class VisibilityCache extends Table {
  TextColumn get locationId => text()();
  DateTimeColumn get calcDate => dateTime()();
  TextColumn get visibilityJson => text()();
  IntColumn get refDataVersion => integer()(); // wipe cache when this changes

  @override
  Set<Column> get primaryKey => {locationId, calcDate};
}

class SkySnapshot extends Table {
  DateTimeColumn get computedAt => dateTime()();
  TextColumn get snapshotJson => text()();

  @override
  Set<Column> get primaryKey => {computedAt};
}

@DriftDatabase(tables: [
  WeatherForecastCache,
  VisibilityCache,
  SkySnapshot,
])
class CacheDb extends _$CacheDb {
  CacheDb() : super(_open());

  @override
  int get schemaVersion => 1;

  static LazyDatabase _open() {
    return LazyDatabase(() async {
      final dir = await getApplicationDocumentsDirectory();
      final file = File(p.join(dir.path, 'cache.sqlite'));
      return NativeDatabase.createInBackground(file);
    });
  }

  /// Safe to delete and rebuild entirely — call this instead of manual DROP TABLEs.
  Future<void> wipeAll() async {
    await transaction(() async {
      await delete(weatherForecastCache).go();
      await delete(visibilityCache).go();
      await delete(skySnapshot).go();
    });
  }

  Future<void> wipeVisibilityForVersionChange(int currentRefDataVersion) async {
    await (delete(visibilityCache)
          ..where((t) => t.refDataVersion.isNotValue(currentRefDataVersion)))
        .go();
  }

  /// Saves the current computed sky as *the* latest snapshot, replacing any
  /// previous one. Only ever one row is kept — this table exists purely so
  /// Home can paint something instantly (schema.md: "last sky, for instant
  /// home screen"), not as a history log.
  Future<void> saveSkySnapshot(String snapshotJson) async {
    await transaction(() async {
      await delete(skySnapshot).go();
      await into(skySnapshot).insert(
        SkySnapshotCompanion.insert(
          computedAt: DateTime.now().toUtc(),
          snapshotJson: snapshotJson,
        ),
      );
    });
  }

  /// The most recently saved snapshot's raw JSON, or null if none exists yet
  /// (e.g. first launch, before Sky Chart has ever been opened).
  Future<String?> latestSkySnapshotJson() async {
    final row = await (select(skySnapshot)
          ..orderBy([(t) => OrderingTerm.desc(t.computedAt)])
          ..limit(1))
        .getSingleOrNull();
    return row?.snapshotJson;
  }
}
