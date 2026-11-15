import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

part 'user_db.g.dart';

mixin _Tracked on Table {
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();
}

class SavedLocations extends Table with _Tracked {
  TextColumn get locationId => text()(); // uuid
  TextColumn get label => text()();
  RealColumn get lat => real()();
  RealColumn get lon => real()();
  IntColumn get placeId => integer().nullable()(); // ref: reference db places.geoname_id
  TextColumn get timezoneId => text().nullable()();

  // Which saved location the app should treat as "the farm right now".
  // Every screen that shows a single current location reads this flag
  // (via UserDb.activeLocation()) instead of guessing from row order.
  // Bug history: earlier versions had no such flag, so picking a new
  // location (GPS or search) just inserted another row and every screen's
  // `..limit(1)` query with no orderBy kept returning whichever row
  // happened to come back first — in practice the very first location ever
  // saved, regardless of anything picked afterward. Exactly one non-deleted
  // row should have isActive=true at a time; enforced by always going
  // through UserDb.insertAndActivateLocation() / setActiveLocation() rather
  // than inserting directly.
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {locationId};
}

class WeatherLog extends Table with _Tracked {
  TextColumn get logId => text()();
  TextColumn get locationId => text().references(SavedLocations, #locationId)();
  DateTimeColumn get obsDate => dateTime()();
  RealColumn get rainMm => real().nullable()();
  RealColumn get tempC => real().nullable()();
  TextColumn get notes => text().nullable()();

  @override
  Set<Column> get primaryKey => {logId};
}

class FarmLog extends Table with _Tracked {
  TextColumn get logId => text()();
  TextColumn get locationId => text().references(SavedLocations, #locationId)();
  DateTimeColumn get logDate => dateTime()();
  IntColumn get cropId => integer().nullable()(); // ref: farming db crops.crop_id
  IntColumn get activityId => integer().nullable()(); // ref: farming db activities.activity_id
  TextColumn get notes => text().nullable()();

  @override
  Set<Column> get primaryKey => {logId};
}

class DeviceProfiles extends Table with _Tracked {
  TextColumn get deviceId => text()();
  TextColumn get model => text().nullable()();
  RealColumn get fieldOfViewDeg => real().nullable()();
  TextColumn get distortionJson => text().nullable()();
  RealColumn get compassErrorDeg => real().nullable()();

  // Remembered result of the one-time AR capability probe (camera_check's
  // live constellation overlay): null = never probed yet, true = compass +
  // accelerometer reported stable data and live AR overlay can be used,
  // false = probe failed/unstable, so camera_check should always fall back
  // to the static (draw-after-capture) overlay for this device without
  // re-probing every time.
  BoolColumn get arSupported => boolean().nullable()();

  @override
  Set<Column> get primaryKey => {deviceId};
}

class PhotoObservations extends Table with _Tracked {
  TextColumn get obsId => text()();
  TextColumn get locationId => text().references(SavedLocations, #locationId)();
  TextColumn get deviceId => text().references(DeviceProfiles, #deviceId)();
  TextColumn get filePath => text()();
  DateTimeColumn get takenAt => dateTime()();
  IntColumn get exposureMs => integer().nullable()();
  IntColumn get iso => integer().nullable()();

  @override
  Set<Column> get primaryKey => {obsId};
}

class PhotoResults extends Table with _Tracked {
  TextColumn get obsId => text().references(PhotoObservations, #obsId)();
  IntColumn get starsDetected => integer().nullable()();
  IntColumn get starsMatched => integer().nullable()();
  RealColumn get confidence => real().nullable()();
  RealColumn get rotationDeg => real().nullable()();
  RealColumn get shiftXPx => real().nullable()();
  RealColumn get shiftYPx => real().nullable()();
  TextColumn get result => text().nullable()(); // confirmed, unclear, failed

  // Camera pointing direction used for this match's overlay — prefers the
  // live AR reading frozen at capture time when available, else the value
  // recovered from the single best star correspondence (see
  // PhotoMatchingEngine._recoverCameraPointing). Only populated when result
  // == 'confirmed'. This is what lets Sky Chart / Constellation Detail
  // redraw the overlay on top of this saved photo later, without re-running
  // the match.
  RealColumn get recoveredHeadingDeg => real().nullable()();
  RealColumn get recoveredPitchDeg => real().nullable()();

  // Which constellation this confirmed photo is actually of. Not derivable
  // from starsMatched/confidence alone: matchPattern compares the 3
  // brightest *overall* visible stars, which can span more than one
  // constellation depending on what's above the horizon — so identity is
  // resolved separately (SkyRepository.nearestConstellationCode, using the
  // heading/pitch above) and stored here. Nullable: null until resolved, or
  // if no visible constellation was close enough to the pointing direction
  // to identify with confidence. Cross-database reference by code only (see
  // schema.md's "by ID, not enforced by foreign keys" convention) — no
  // `.references()`, since Constellations lives in ReferenceDb.
  TextColumn get matchedConstCode => text().nullable()();

  @override
  Set<Column> get primaryKey => {obsId};
}

class Feedback extends Table with _Tracked {
  TextColumn get feedbackId => text()();
  IntColumn get ruleId => integer().nullable()(); // ref: farming db farming_rules.rule_id
  TextColumn get note => text().nullable()();

  @override
  Set<Column> get primaryKey => {feedbackId};
}

class UserSettings extends Table with _Tracked {
  TextColumn get key => text()();
  TextColumn get value => text()(); // language, units, sky culture, region

  @override
  Set<Column> get primaryKey => {key};
}

@DriftDatabase(tables: [
  SavedLocations,
  WeatherLog,
  FarmLog,
  DeviceProfiles,
  PhotoObservations,
  PhotoResults,
  Feedback,
  UserSettings,
])
class UserDb extends _$UserDb {
  UserDb() : super(_open());

  @override
  int get schemaVersion => 6;

  // v1 -> v2: added DeviceProfiles.arSupported (nullable, so existing rows
  // just get NULL = "not yet probed" rather than needing a backfill value).
  // v2 -> v3: added PhotoResults.recoveredHeadingDeg/recoveredPitchDeg
  // (also nullable — only ever populated going forward, on a confirmed
  // match; existing rows just get NULL, same reasoning as v2).
  // v3 -> v4: added PhotoResults.matchedConstCode, so Constellation Detail
  // can look up "is there a confirmed photo of this specific constellation"
  // instead of only knowing a match happened with no identity attached.
  // Nullable, same backfill-free reasoning as the previous two columns.
  // v4 -> v5: added SavedLocations.isActive (bug fix — see the column's doc
  // comment). The new column defaults every existing row to true, which on
  // an install that already accumulated several saved locations would leave
  // more than one row "active" at once. So after adding the column, collapse
  // that down: keep only the most recently created non-deleted row active,
  // matching the single-active-row invariant this flag is meant to hold
  // from now on. A fresh install only ever has zero or one row at this
  // point, so this is a no-op for new users.
  // v5 -> v6: no schema change — this is a data-only migration to fix a
  // separate bug. DeviceProfiles.arSupported was cached using a probe that
  // tested a different sensor pipeline (flutter_compass) than the one the
  // live AR overlay actually depends on (raw accelerometer + magnetometer
  // via DeviceAttitude, see ar_capability_repository.dart's doc comment).
  // Any device that already probed under the old logic has a cached
  // arSupported value that isn't a reliable promise the overlay will
  // actually draw. Reset it to null so ArCapabilityRepository.resolveArSupport
  // re-probes with the corrected pipeline on next camera_check open, instead
  // of trusting a stale result forever.
  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (Migrator m, int from, int to) async {
          if (from < 2) {
            await m.addColumn(deviceProfiles, deviceProfiles.arSupported);
          }
          if (from < 3) {
            await m.addColumn(photoResults, photoResults.recoveredHeadingDeg);
            await m.addColumn(photoResults, photoResults.recoveredPitchDeg);
          }
          if (from < 4) {
            await m.addColumn(photoResults, photoResults.matchedConstCode);
          }
          if (from < 5) {
            await m.addColumn(savedLocations, savedLocations.isActive);
            final existing = await (select(savedLocations)
                  ..where((t) => t.deleted.equals(false))
                  ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
                .get();
            if (existing.length > 1) {
              final staleIds = existing.skip(1).map((r) => r.locationId).toList();
              await (update(savedLocations)..where((t) => t.locationId.isIn(staleIds)))
                  .write(const SavedLocationsCompanion(isActive: Value(false)));
            }
          }
          if (from < 6) {
            await update(deviceProfiles).write(
              const DeviceProfilesCompanion(arSupported: Value(null)),
            );
          }
        },
      );

  /// The single saved location every "what's my current location" screen
  /// should use. Centralized here so no call site can regress back to an
  /// unordered `..limit(1)` guess (the original bug).
  Future<SavedLocation?> activeLocation() {
    return (select(savedLocations)
          ..where((t) => t.deleted.equals(false) & t.isActive.equals(true))
          ..limit(1))
        .getSingleOrNull();
  }

  /// Inserts a new saved location and atomically makes it the active one,
  /// deactivating every other saved location first so at most one row is
  /// ever active. Both onboarding flows (GPS and manual search) should call
  /// this instead of `into(savedLocations).insert(...)` directly.
  Future<void> insertAndActivateLocation(SavedLocationsCompanion location) {
    return transaction(() async {
      await (update(savedLocations)..where((t) => t.isActive.equals(true)))
          .write(const SavedLocationsCompanion(isActive: Value(false)));
      await into(savedLocations).insert(location.copyWith(isActive: const Value(true)));
    });
  }

  /// Switches the active location to an already-saved one (e.g. picking a
  /// previously used farm from a locations list), without inserting a new
  /// row. Not yet wired into any screen — added alongside the fix above so
  /// a future "saved locations" list can reuse it instead of re-inserting.
  Future<void> setActiveLocation(String locationId) {
    return transaction(() async {
      await (update(savedLocations)..where((t) => t.isActive.equals(true)))
          .write(const SavedLocationsCompanion(isActive: Value(false)));
      await (update(savedLocations)..where((t) => t.locationId.equals(locationId)))
          .write(const SavedLocationsCompanion(isActive: Value(true)));
    });
  }

  static LazyDatabase _open() {
    return LazyDatabase(() async {
      final dir = await getApplicationDocumentsDirectory();
      final file = File(p.join(dir.path, 'user.sqlite'));
      return NativeDatabase.createInBackground(file);
    });
  }
}
