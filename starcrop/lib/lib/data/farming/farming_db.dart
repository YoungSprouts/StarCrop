import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

part 'farming_db.g.dart';

class SkyTriggers extends Table {
  IntColumn get triggerId => integer()();
  TextColumn get triggerType => text()(); // visible, first_rise, last_set, sun_longitude, moon_phase, date_range
  TextColumn get constCode => text().nullable()(); // ref: constellations.code (other db)
  TextColumn get paramsJson => text().nullable()();

  @override
  Set<Column> get primaryKey => {triggerId};
}

class WeatherTriggers extends Table {
  IntColumn get triggerId => integer()();
  TextColumn get variable => text()(); // rain, temp, wind, humidity
  TextColumn get operator => text()();
  RealColumn get threshold => real()();
  IntColumn get daysAhead => integer().nullable()();
  IntColumn get durationDays => integer().nullable()();

  @override
  Set<Column> get primaryKey => {triggerId};
}

class Activities extends Table {
  IntColumn get activityId => integer()();
  TextColumn get activityType => text()(); // plant, spray, harvest, prepare
  TextColumn get descriptionI18n => text()();

  @override
  Set<Column> get primaryKey => {activityId};
}

class Crops extends Table {
  IntColumn get cropId => integer()();
  TextColumn get name => text()();
  TextColumn get localNames => text().nullable()();
  TextColumn get category => text().nullable()();

  @override
  Set<Column> get primaryKey => {cropId};
}

class Regions extends Table {
  IntColumn get regionId => integer()();
  TextColumn get name => text()();
  RealColumn get latMin => real()();
  RealColumn get latMax => real()();
  RealColumn get lonMin => real()();
  RealColumn get lonMax => real()();
  TextColumn get climateZone => text().nullable()();

  @override
  Set<Column> get primaryKey => {regionId};
}

class Sources extends Table {
  IntColumn get sourceId => integer()();
  TextColumn get sourceType => text()(); // farmer, extension_office, publication
  TextColumn get name => text()();
  TextColumn get citation => text().nullable()();
  DateTimeColumn get sourceDate => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {sourceId};
}

/// Climatology, not forecast: "what this time of year is typically like
/// here", month by month, sourced from published climate normals (e.g.
/// PAGASA station data) — never estimated. See
/// offline_seasonal_outlook_plan.md for the full rationale.
///
/// [month] is 1-12 and is the primary key alongside [regionId]: one row per
/// region per calendar month. [skyTriggerId] is optional and lets a row
/// additionally be presented anchored to a sky-calendar marker (e.g. "around
/// Balatik's rise") instead of only a bare month name, without forcing every
/// row to have one — most published climate normals are monthly, not tied
/// to a ~2-week sky-trigger window, so inventing sub-monthly numbers to
/// match trigger windows would violate the "don't estimate" rule.
class SeasonalClimateNormals extends Table {
  IntColumn get regionId => integer().references(Regions, #regionId)();
  IntColumn get month => integer()(); // 1=Jan .. 12=Dec
  IntColumn get skyTriggerId => integer().nullable().references(SkyTriggers, #triggerId)();
  RealColumn get avgRainMm => real()();
  RealColumn get tempMinC => real()();
  RealColumn get tempMaxC => real()();
  TextColumn get classification => text()(); // e.g. "dry season", "wet season", "transition"
  IntColumn get sourceId => integer().references(Sources, #sourceId)();
  TextColumn get verificationStatus =>
      text().withDefault(const Constant('draft'))(); // draft, reviewed, confirmed

  @override
  Set<Column> get primaryKey => {regionId, month};
}

class FarmingRules extends Table {
  IntColumn get ruleId => integer()();
  IntColumn get skyTriggerId => integer().nullable().references(SkyTriggers, #triggerId)();
  IntColumn get weatherTriggerId => integer().nullable().references(WeatherTriggers, #triggerId)();
  IntColumn get activityId => integer().references(Activities, #activityId)();
  IntColumn get cropId => integer().nullable().references(Crops, #cropId)();
  IntColumn get regionId => integer().nullable().references(Regions, #regionId)();
  IntColumn get sourceId => integer().references(Sources, #sourceId)();
  TextColumn get guidanceI18n => text()();
  TextColumn get severity => text().nullable()();
  TextColumn get verificationStatus => text().withDefault(const Constant('draft'))(); // draft, reviewed, confirmed

  @override
  Set<Column> get primaryKey => {ruleId};
}

@DriftDatabase(tables: [
  SkyTriggers,
  WeatherTriggers,
  Activities,
  Crops,
  Regions,
  Sources,
  FarmingRules,
  SeasonalClimateNormals,
])
class FarmingDb extends _$FarmingDb {
  FarmingDb() : super(_open());

  // v1 -> v2: added SeasonalClimateNormals for the offline seasonal outlook
  // (see offline_seasonal_outlook_plan.md). Existing installs get the new
  // table created empty; StarcropSeedLoader re-seeds it the same way it
  // seeds everything else, keyed off SeasonalClimateNormals being empty.
  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.createTable(seasonalClimateNormals);
          }
        },
      );

  static LazyDatabase _open() {
    return LazyDatabase(() async {
      final dir = await getApplicationDocumentsDirectory();
      final file = File(p.join(dir.path, 'farming.sqlite'));
      return NativeDatabase.createInBackground(file);
    });
  }
}
