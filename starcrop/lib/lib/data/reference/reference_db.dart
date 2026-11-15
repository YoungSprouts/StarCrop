import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

part 'reference_db.g.dart';

class Stars extends Table {
  IntColumn get hipId => integer()();
  RealColumn get raDeg => real()();
  RealColumn get decDeg => real()();
  RealColumn get magnitude => real()();
  RealColumn get colorIndex => real().nullable()();
  TextColumn get properName => text().nullable()();

  @override
  Set<Column> get primaryKey => {hipId};
}

class Constellations extends Table {
  TextColumn get code => text()();
  TextColumn get latinName => text()();
  RealColumn get areaSqDeg => real().nullable()();
  RealColumn get centerRa => real().nullable()();
  RealColumn get centerDec => real().nullable()();

  @override
  Set<Column> get primaryKey => {code};
}

class SkyCultures extends Table {
  IntColumn get cultureId => integer()();
  TextColumn get name => text()();
  TextColumn get region => text().nullable()();
  TextColumn get license => text().nullable()();
  TextColumn get source => text().nullable()();

  @override
  Set<Column> get primaryKey => {cultureId};
}

class ConstellationLines extends Table {
  IntColumn get lineId => integer()();
  TextColumn get constCode => text().references(Constellations, #code)();
  IntColumn get cultureId => integer().references(SkyCultures, #cultureId)();
  IntColumn get starA => integer().references(Stars, #hipId)();
  IntColumn get starB => integer().references(Stars, #hipId)();

  @override
  Set<Column> get primaryKey => {lineId};
}

class ConstellationNames extends Table {
  IntColumn get nameId => integer()();
  TextColumn get constCode => text().references(Constellations, #code)();
  IntColumn get cultureId => integer().references(SkyCultures, #cultureId)();
  TextColumn get language => text()();
  TextColumn get localName => text()();
  TextColumn get pronunciationNote => text().nullable()();

  @override
  Set<Column> get primaryKey => {nameId};
}

class Timezones extends Table {
  TextColumn get zoneId => text()();
  TextColumn get rulesJson => text()();

  @override
  Set<Column> get primaryKey => {zoneId};
}

class Places extends Table {
  IntColumn get geonameId => integer()();
  TextColumn get name => text()();
  TextColumn get altNames => text().nullable()();
  TextColumn get province => text().nullable()();
  TextColumn get country => text().nullable()();
  RealColumn get lat => real()();
  RealColumn get lon => real()();
  TextColumn get timezoneId => text().references(Timezones, #zoneId)();
  IntColumn get population => integer().nullable()();

  @override
  Set<Column> get primaryKey => {geonameId};
}

@DriftDatabase(tables: [
  Stars,
  Constellations,
  SkyCultures,
  ConstellationLines,
  ConstellationNames,
  Timezones,
  Places,
])
class ReferenceDb extends _$ReferenceDb {
  ReferenceDb() : super(_open());

  @override
  int get schemaVersion => 1;

  static LazyDatabase _open() {
    return LazyDatabase(() async {
      final dir = await getApplicationDocumentsDirectory();
      final file = File(p.join(dir.path, 'reference.sqlite'));
      // CORRECTED (was previously mislabeled "shipped as a prebuilt asset,
      // copied in at first launch — not built at runtime", which doesn't
      // match what actually happens):
      //
      // This just opens (or creates) an empty SQLite file at the app's
      // documents path. There is no asset-copy step anywhere in this
      // pipeline. The DB is actually populated at runtime, on first launch,
      // by StarcropSeedLoader.seedIfEmpty() (called from main.dart) — which
      // inserts rows built from the Dart constants in starcrop_seed_data.dart.
      // It's a no-op on every subsequent launch since seedIfEmpty() checks
      // for existing rows first.
      //
      // If a real prebuilt-asset / content-pack pipeline (per the "CONTENT
      // PACKS" box in data_architecture.drawio) gets built later, this is
      // the method that needs to change — e.g. copying a bundled .sqlite
      // from `assets/` into `file` the first time it doesn't exist, instead
      // of relying on the Dart-constant seed loader.
      return NativeDatabase.createInBackground(file);
    });
  }
}
