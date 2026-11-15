// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_db.dart';

// ignore_for_file: type=lint
class $SavedLocationsTable extends SavedLocations
    with TableInfo<$SavedLocationsTable, SavedLocation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SavedLocationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _deletedMeta =
      const VerificationMeta('deleted');
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
      'deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _locationIdMeta =
      const VerificationMeta('locationId');
  @override
  late final GeneratedColumn<String> locationId = GeneratedColumn<String>(
      'location_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
      'label', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _latMeta = const VerificationMeta('lat');
  @override
  late final GeneratedColumn<double> lat = GeneratedColumn<double>(
      'lat', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _lonMeta = const VerificationMeta('lon');
  @override
  late final GeneratedColumn<double> lon = GeneratedColumn<double>(
      'lon', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _placeIdMeta =
      const VerificationMeta('placeId');
  @override
  late final GeneratedColumn<int> placeId = GeneratedColumn<int>(
      'place_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _timezoneIdMeta =
      const VerificationMeta('timezoneId');
  @override
  late final GeneratedColumn<String> timezoneId = GeneratedColumn<String>(
      'timezone_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns => [
        createdAt,
        updatedAt,
        deleted,
        locationId,
        label,
        lat,
        lon,
        placeId,
        timezoneId,
        isActive
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'saved_locations';
  @override
  VerificationContext validateIntegrity(Insertable<SavedLocation> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('deleted')) {
      context.handle(_deletedMeta,
          deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta));
    }
    if (data.containsKey('location_id')) {
      context.handle(
          _locationIdMeta,
          locationId.isAcceptableOrUnknown(
              data['location_id']!, _locationIdMeta));
    } else if (isInserting) {
      context.missing(_locationIdMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
          _labelMeta, label.isAcceptableOrUnknown(data['label']!, _labelMeta));
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('lat')) {
      context.handle(
          _latMeta, lat.isAcceptableOrUnknown(data['lat']!, _latMeta));
    } else if (isInserting) {
      context.missing(_latMeta);
    }
    if (data.containsKey('lon')) {
      context.handle(
          _lonMeta, lon.isAcceptableOrUnknown(data['lon']!, _lonMeta));
    } else if (isInserting) {
      context.missing(_lonMeta);
    }
    if (data.containsKey('place_id')) {
      context.handle(_placeIdMeta,
          placeId.isAcceptableOrUnknown(data['place_id']!, _placeIdMeta));
    }
    if (data.containsKey('timezone_id')) {
      context.handle(
          _timezoneIdMeta,
          timezoneId.isAcceptableOrUnknown(
              data['timezone_id']!, _timezoneIdMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {locationId};
  @override
  SavedLocation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SavedLocation(
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      deleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}deleted'])!,
      locationId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}location_id'])!,
      label: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}label'])!,
      lat: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}lat'])!,
      lon: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}lon'])!,
      placeId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}place_id']),
      timezoneId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}timezone_id']),
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
    );
  }

  @override
  $SavedLocationsTable createAlias(String alias) {
    return $SavedLocationsTable(attachedDatabase, alias);
  }
}

class SavedLocation extends DataClass implements Insertable<SavedLocation> {
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool deleted;
  final String locationId;
  final String label;
  final double lat;
  final double lon;
  final int? placeId;
  final String? timezoneId;
  final bool isActive;
  const SavedLocation(
      {required this.createdAt,
      required this.updatedAt,
      required this.deleted,
      required this.locationId,
      required this.label,
      required this.lat,
      required this.lon,
      this.placeId,
      this.timezoneId,
      required this.isActive});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['deleted'] = Variable<bool>(deleted);
    map['location_id'] = Variable<String>(locationId);
    map['label'] = Variable<String>(label);
    map['lat'] = Variable<double>(lat);
    map['lon'] = Variable<double>(lon);
    if (!nullToAbsent || placeId != null) {
      map['place_id'] = Variable<int>(placeId);
    }
    if (!nullToAbsent || timezoneId != null) {
      map['timezone_id'] = Variable<String>(timezoneId);
    }
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  SavedLocationsCompanion toCompanion(bool nullToAbsent) {
    return SavedLocationsCompanion(
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deleted: Value(deleted),
      locationId: Value(locationId),
      label: Value(label),
      lat: Value(lat),
      lon: Value(lon),
      placeId: placeId == null && nullToAbsent
          ? const Value.absent()
          : Value(placeId),
      timezoneId: timezoneId == null && nullToAbsent
          ? const Value.absent()
          : Value(timezoneId),
      isActive: Value(isActive),
    );
  }

  factory SavedLocation.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SavedLocation(
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      locationId: serializer.fromJson<String>(json['locationId']),
      label: serializer.fromJson<String>(json['label']),
      lat: serializer.fromJson<double>(json['lat']),
      lon: serializer.fromJson<double>(json['lon']),
      placeId: serializer.fromJson<int?>(json['placeId']),
      timezoneId: serializer.fromJson<String?>(json['timezoneId']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deleted': serializer.toJson<bool>(deleted),
      'locationId': serializer.toJson<String>(locationId),
      'label': serializer.toJson<String>(label),
      'lat': serializer.toJson<double>(lat),
      'lon': serializer.toJson<double>(lon),
      'placeId': serializer.toJson<int?>(placeId),
      'timezoneId': serializer.toJson<String?>(timezoneId),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  SavedLocation copyWith(
          {DateTime? createdAt,
          DateTime? updatedAt,
          bool? deleted,
          String? locationId,
          String? label,
          double? lat,
          double? lon,
          Value<int?> placeId = const Value.absent(),
          Value<String?> timezoneId = const Value.absent(),
          bool? isActive}) =>
      SavedLocation(
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deleted: deleted ?? this.deleted,
        locationId: locationId ?? this.locationId,
        label: label ?? this.label,
        lat: lat ?? this.lat,
        lon: lon ?? this.lon,
        placeId: placeId.present ? placeId.value : this.placeId,
        timezoneId: timezoneId.present ? timezoneId.value : this.timezoneId,
        isActive: isActive ?? this.isActive,
      );
  SavedLocation copyWithCompanion(SavedLocationsCompanion data) {
    return SavedLocation(
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      locationId:
          data.locationId.present ? data.locationId.value : this.locationId,
      label: data.label.present ? data.label.value : this.label,
      lat: data.lat.present ? data.lat.value : this.lat,
      lon: data.lon.present ? data.lon.value : this.lon,
      placeId: data.placeId.present ? data.placeId.value : this.placeId,
      timezoneId:
          data.timezoneId.present ? data.timezoneId.value : this.timezoneId,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SavedLocation(')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('locationId: $locationId, ')
          ..write('label: $label, ')
          ..write('lat: $lat, ')
          ..write('lon: $lon, ')
          ..write('placeId: $placeId, ')
          ..write('timezoneId: $timezoneId, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(createdAt, updatedAt, deleted, locationId,
      label, lat, lon, placeId, timezoneId, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SavedLocation &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deleted == this.deleted &&
          other.locationId == this.locationId &&
          other.label == this.label &&
          other.lat == this.lat &&
          other.lon == this.lon &&
          other.placeId == this.placeId &&
          other.timezoneId == this.timezoneId &&
          other.isActive == this.isActive);
}

class SavedLocationsCompanion extends UpdateCompanion<SavedLocation> {
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> deleted;
  final Value<String> locationId;
  final Value<String> label;
  final Value<double> lat;
  final Value<double> lon;
  final Value<int?> placeId;
  final Value<String?> timezoneId;
  final Value<bool> isActive;
  final Value<int> rowid;
  const SavedLocationsCompanion({
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.locationId = const Value.absent(),
    this.label = const Value.absent(),
    this.lat = const Value.absent(),
    this.lon = const Value.absent(),
    this.placeId = const Value.absent(),
    this.timezoneId = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SavedLocationsCompanion.insert({
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    required String locationId,
    required String label,
    required double lat,
    required double lon,
    this.placeId = const Value.absent(),
    this.timezoneId = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : locationId = Value(locationId),
        label = Value(label),
        lat = Value(lat),
        lon = Value(lon);
  static Insertable<SavedLocation> custom({
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? deleted,
    Expression<String>? locationId,
    Expression<String>? label,
    Expression<double>? lat,
    Expression<double>? lon,
    Expression<int>? placeId,
    Expression<String>? timezoneId,
    Expression<bool>? isActive,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deleted != null) 'deleted': deleted,
      if (locationId != null) 'location_id': locationId,
      if (label != null) 'label': label,
      if (lat != null) 'lat': lat,
      if (lon != null) 'lon': lon,
      if (placeId != null) 'place_id': placeId,
      if (timezoneId != null) 'timezone_id': timezoneId,
      if (isActive != null) 'is_active': isActive,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SavedLocationsCompanion copyWith(
      {Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<bool>? deleted,
      Value<String>? locationId,
      Value<String>? label,
      Value<double>? lat,
      Value<double>? lon,
      Value<int?>? placeId,
      Value<String?>? timezoneId,
      Value<bool>? isActive,
      Value<int>? rowid}) {
    return SavedLocationsCompanion(
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
      locationId: locationId ?? this.locationId,
      label: label ?? this.label,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      placeId: placeId ?? this.placeId,
      timezoneId: timezoneId ?? this.timezoneId,
      isActive: isActive ?? this.isActive,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (locationId.present) {
      map['location_id'] = Variable<String>(locationId.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (lat.present) {
      map['lat'] = Variable<double>(lat.value);
    }
    if (lon.present) {
      map['lon'] = Variable<double>(lon.value);
    }
    if (placeId.present) {
      map['place_id'] = Variable<int>(placeId.value);
    }
    if (timezoneId.present) {
      map['timezone_id'] = Variable<String>(timezoneId.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SavedLocationsCompanion(')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('locationId: $locationId, ')
          ..write('label: $label, ')
          ..write('lat: $lat, ')
          ..write('lon: $lon, ')
          ..write('placeId: $placeId, ')
          ..write('timezoneId: $timezoneId, ')
          ..write('isActive: $isActive, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WeatherLogTable extends WeatherLog
    with TableInfo<$WeatherLogTable, WeatherLogData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeatherLogTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _deletedMeta =
      const VerificationMeta('deleted');
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
      'deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _logIdMeta = const VerificationMeta('logId');
  @override
  late final GeneratedColumn<String> logId = GeneratedColumn<String>(
      'log_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _locationIdMeta =
      const VerificationMeta('locationId');
  @override
  late final GeneratedColumn<String> locationId = GeneratedColumn<String>(
      'location_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _obsDateMeta =
      const VerificationMeta('obsDate');
  @override
  late final GeneratedColumn<DateTime> obsDate = GeneratedColumn<DateTime>(
      'obs_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _rainMmMeta = const VerificationMeta('rainMm');
  @override
  late final GeneratedColumn<double> rainMm = GeneratedColumn<double>(
      'rain_mm', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _tempCMeta = const VerificationMeta('tempC');
  @override
  late final GeneratedColumn<double> tempC = GeneratedColumn<double>(
      'temp_c', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        createdAt,
        updatedAt,
        deleted,
        logId,
        locationId,
        obsDate,
        rainMm,
        tempC,
        notes
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'weather_log';
  @override
  VerificationContext validateIntegrity(Insertable<WeatherLogData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('deleted')) {
      context.handle(_deletedMeta,
          deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta));
    }
    if (data.containsKey('log_id')) {
      context.handle(
          _logIdMeta, logId.isAcceptableOrUnknown(data['log_id']!, _logIdMeta));
    } else if (isInserting) {
      context.missing(_logIdMeta);
    }
    if (data.containsKey('location_id')) {
      context.handle(
          _locationIdMeta,
          locationId.isAcceptableOrUnknown(
              data['location_id']!, _locationIdMeta));
    } else if (isInserting) {
      context.missing(_locationIdMeta);
    }
    if (data.containsKey('obs_date')) {
      context.handle(_obsDateMeta,
          obsDate.isAcceptableOrUnknown(data['obs_date']!, _obsDateMeta));
    } else if (isInserting) {
      context.missing(_obsDateMeta);
    }
    if (data.containsKey('rain_mm')) {
      context.handle(_rainMmMeta,
          rainMm.isAcceptableOrUnknown(data['rain_mm']!, _rainMmMeta));
    }
    if (data.containsKey('temp_c')) {
      context.handle(
          _tempCMeta, tempC.isAcceptableOrUnknown(data['temp_c']!, _tempCMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {logId};
  @override
  WeatherLogData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeatherLogData(
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      deleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}deleted'])!,
      logId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}log_id'])!,
      locationId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}location_id'])!,
      obsDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}obs_date'])!,
      rainMm: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}rain_mm']),
      tempC: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}temp_c']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
    );
  }

  @override
  $WeatherLogTable createAlias(String alias) {
    return $WeatherLogTable(attachedDatabase, alias);
  }
}

class WeatherLogData extends DataClass implements Insertable<WeatherLogData> {
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool deleted;
  final String logId;
  final String locationId;
  final DateTime obsDate;
  final double? rainMm;
  final double? tempC;
  final String? notes;
  const WeatherLogData(
      {required this.createdAt,
      required this.updatedAt,
      required this.deleted,
      required this.logId,
      required this.locationId,
      required this.obsDate,
      this.rainMm,
      this.tempC,
      this.notes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['deleted'] = Variable<bool>(deleted);
    map['log_id'] = Variable<String>(logId);
    map['location_id'] = Variable<String>(locationId);
    map['obs_date'] = Variable<DateTime>(obsDate);
    if (!nullToAbsent || rainMm != null) {
      map['rain_mm'] = Variable<double>(rainMm);
    }
    if (!nullToAbsent || tempC != null) {
      map['temp_c'] = Variable<double>(tempC);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  WeatherLogCompanion toCompanion(bool nullToAbsent) {
    return WeatherLogCompanion(
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deleted: Value(deleted),
      logId: Value(logId),
      locationId: Value(locationId),
      obsDate: Value(obsDate),
      rainMm:
          rainMm == null && nullToAbsent ? const Value.absent() : Value(rainMm),
      tempC:
          tempC == null && nullToAbsent ? const Value.absent() : Value(tempC),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
    );
  }

  factory WeatherLogData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeatherLogData(
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      logId: serializer.fromJson<String>(json['logId']),
      locationId: serializer.fromJson<String>(json['locationId']),
      obsDate: serializer.fromJson<DateTime>(json['obsDate']),
      rainMm: serializer.fromJson<double?>(json['rainMm']),
      tempC: serializer.fromJson<double?>(json['tempC']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deleted': serializer.toJson<bool>(deleted),
      'logId': serializer.toJson<String>(logId),
      'locationId': serializer.toJson<String>(locationId),
      'obsDate': serializer.toJson<DateTime>(obsDate),
      'rainMm': serializer.toJson<double?>(rainMm),
      'tempC': serializer.toJson<double?>(tempC),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  WeatherLogData copyWith(
          {DateTime? createdAt,
          DateTime? updatedAt,
          bool? deleted,
          String? logId,
          String? locationId,
          DateTime? obsDate,
          Value<double?> rainMm = const Value.absent(),
          Value<double?> tempC = const Value.absent(),
          Value<String?> notes = const Value.absent()}) =>
      WeatherLogData(
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deleted: deleted ?? this.deleted,
        logId: logId ?? this.logId,
        locationId: locationId ?? this.locationId,
        obsDate: obsDate ?? this.obsDate,
        rainMm: rainMm.present ? rainMm.value : this.rainMm,
        tempC: tempC.present ? tempC.value : this.tempC,
        notes: notes.present ? notes.value : this.notes,
      );
  WeatherLogData copyWithCompanion(WeatherLogCompanion data) {
    return WeatherLogData(
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      logId: data.logId.present ? data.logId.value : this.logId,
      locationId:
          data.locationId.present ? data.locationId.value : this.locationId,
      obsDate: data.obsDate.present ? data.obsDate.value : this.obsDate,
      rainMm: data.rainMm.present ? data.rainMm.value : this.rainMm,
      tempC: data.tempC.present ? data.tempC.value : this.tempC,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WeatherLogData(')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('logId: $logId, ')
          ..write('locationId: $locationId, ')
          ..write('obsDate: $obsDate, ')
          ..write('rainMm: $rainMm, ')
          ..write('tempC: $tempC, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(createdAt, updatedAt, deleted, logId,
      locationId, obsDate, rainMm, tempC, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeatherLogData &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deleted == this.deleted &&
          other.logId == this.logId &&
          other.locationId == this.locationId &&
          other.obsDate == this.obsDate &&
          other.rainMm == this.rainMm &&
          other.tempC == this.tempC &&
          other.notes == this.notes);
}

class WeatherLogCompanion extends UpdateCompanion<WeatherLogData> {
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> deleted;
  final Value<String> logId;
  final Value<String> locationId;
  final Value<DateTime> obsDate;
  final Value<double?> rainMm;
  final Value<double?> tempC;
  final Value<String?> notes;
  final Value<int> rowid;
  const WeatherLogCompanion({
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.logId = const Value.absent(),
    this.locationId = const Value.absent(),
    this.obsDate = const Value.absent(),
    this.rainMm = const Value.absent(),
    this.tempC = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WeatherLogCompanion.insert({
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    required String logId,
    required String locationId,
    required DateTime obsDate,
    this.rainMm = const Value.absent(),
    this.tempC = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : logId = Value(logId),
        locationId = Value(locationId),
        obsDate = Value(obsDate);
  static Insertable<WeatherLogData> custom({
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? deleted,
    Expression<String>? logId,
    Expression<String>? locationId,
    Expression<DateTime>? obsDate,
    Expression<double>? rainMm,
    Expression<double>? tempC,
    Expression<String>? notes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deleted != null) 'deleted': deleted,
      if (logId != null) 'log_id': logId,
      if (locationId != null) 'location_id': locationId,
      if (obsDate != null) 'obs_date': obsDate,
      if (rainMm != null) 'rain_mm': rainMm,
      if (tempC != null) 'temp_c': tempC,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WeatherLogCompanion copyWith(
      {Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<bool>? deleted,
      Value<String>? logId,
      Value<String>? locationId,
      Value<DateTime>? obsDate,
      Value<double?>? rainMm,
      Value<double?>? tempC,
      Value<String?>? notes,
      Value<int>? rowid}) {
    return WeatherLogCompanion(
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
      logId: logId ?? this.logId,
      locationId: locationId ?? this.locationId,
      obsDate: obsDate ?? this.obsDate,
      rainMm: rainMm ?? this.rainMm,
      tempC: tempC ?? this.tempC,
      notes: notes ?? this.notes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (logId.present) {
      map['log_id'] = Variable<String>(logId.value);
    }
    if (locationId.present) {
      map['location_id'] = Variable<String>(locationId.value);
    }
    if (obsDate.present) {
      map['obs_date'] = Variable<DateTime>(obsDate.value);
    }
    if (rainMm.present) {
      map['rain_mm'] = Variable<double>(rainMm.value);
    }
    if (tempC.present) {
      map['temp_c'] = Variable<double>(tempC.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeatherLogCompanion(')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('logId: $logId, ')
          ..write('locationId: $locationId, ')
          ..write('obsDate: $obsDate, ')
          ..write('rainMm: $rainMm, ')
          ..write('tempC: $tempC, ')
          ..write('notes: $notes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FarmLogTable extends FarmLog with TableInfo<$FarmLogTable, FarmLogData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FarmLogTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _deletedMeta =
      const VerificationMeta('deleted');
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
      'deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _logIdMeta = const VerificationMeta('logId');
  @override
  late final GeneratedColumn<String> logId = GeneratedColumn<String>(
      'log_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _locationIdMeta =
      const VerificationMeta('locationId');
  @override
  late final GeneratedColumn<String> locationId = GeneratedColumn<String>(
      'location_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _logDateMeta =
      const VerificationMeta('logDate');
  @override
  late final GeneratedColumn<DateTime> logDate = GeneratedColumn<DateTime>(
      'log_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _cropIdMeta = const VerificationMeta('cropId');
  @override
  late final GeneratedColumn<int> cropId = GeneratedColumn<int>(
      'crop_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _activityIdMeta =
      const VerificationMeta('activityId');
  @override
  late final GeneratedColumn<int> activityId = GeneratedColumn<int>(
      'activity_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        createdAt,
        updatedAt,
        deleted,
        logId,
        locationId,
        logDate,
        cropId,
        activityId,
        notes
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'farm_log';
  @override
  VerificationContext validateIntegrity(Insertable<FarmLogData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('deleted')) {
      context.handle(_deletedMeta,
          deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta));
    }
    if (data.containsKey('log_id')) {
      context.handle(
          _logIdMeta, logId.isAcceptableOrUnknown(data['log_id']!, _logIdMeta));
    } else if (isInserting) {
      context.missing(_logIdMeta);
    }
    if (data.containsKey('location_id')) {
      context.handle(
          _locationIdMeta,
          locationId.isAcceptableOrUnknown(
              data['location_id']!, _locationIdMeta));
    } else if (isInserting) {
      context.missing(_locationIdMeta);
    }
    if (data.containsKey('log_date')) {
      context.handle(_logDateMeta,
          logDate.isAcceptableOrUnknown(data['log_date']!, _logDateMeta));
    } else if (isInserting) {
      context.missing(_logDateMeta);
    }
    if (data.containsKey('crop_id')) {
      context.handle(_cropIdMeta,
          cropId.isAcceptableOrUnknown(data['crop_id']!, _cropIdMeta));
    }
    if (data.containsKey('activity_id')) {
      context.handle(
          _activityIdMeta,
          activityId.isAcceptableOrUnknown(
              data['activity_id']!, _activityIdMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {logId};
  @override
  FarmLogData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FarmLogData(
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      deleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}deleted'])!,
      logId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}log_id'])!,
      locationId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}location_id'])!,
      logDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}log_date'])!,
      cropId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}crop_id']),
      activityId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}activity_id']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
    );
  }

  @override
  $FarmLogTable createAlias(String alias) {
    return $FarmLogTable(attachedDatabase, alias);
  }
}

class FarmLogData extends DataClass implements Insertable<FarmLogData> {
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool deleted;
  final String logId;
  final String locationId;
  final DateTime logDate;
  final int? cropId;
  final int? activityId;
  final String? notes;
  const FarmLogData(
      {required this.createdAt,
      required this.updatedAt,
      required this.deleted,
      required this.logId,
      required this.locationId,
      required this.logDate,
      this.cropId,
      this.activityId,
      this.notes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['deleted'] = Variable<bool>(deleted);
    map['log_id'] = Variable<String>(logId);
    map['location_id'] = Variable<String>(locationId);
    map['log_date'] = Variable<DateTime>(logDate);
    if (!nullToAbsent || cropId != null) {
      map['crop_id'] = Variable<int>(cropId);
    }
    if (!nullToAbsent || activityId != null) {
      map['activity_id'] = Variable<int>(activityId);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  FarmLogCompanion toCompanion(bool nullToAbsent) {
    return FarmLogCompanion(
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deleted: Value(deleted),
      logId: Value(logId),
      locationId: Value(locationId),
      logDate: Value(logDate),
      cropId:
          cropId == null && nullToAbsent ? const Value.absent() : Value(cropId),
      activityId: activityId == null && nullToAbsent
          ? const Value.absent()
          : Value(activityId),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
    );
  }

  factory FarmLogData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FarmLogData(
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      logId: serializer.fromJson<String>(json['logId']),
      locationId: serializer.fromJson<String>(json['locationId']),
      logDate: serializer.fromJson<DateTime>(json['logDate']),
      cropId: serializer.fromJson<int?>(json['cropId']),
      activityId: serializer.fromJson<int?>(json['activityId']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deleted': serializer.toJson<bool>(deleted),
      'logId': serializer.toJson<String>(logId),
      'locationId': serializer.toJson<String>(locationId),
      'logDate': serializer.toJson<DateTime>(logDate),
      'cropId': serializer.toJson<int?>(cropId),
      'activityId': serializer.toJson<int?>(activityId),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  FarmLogData copyWith(
          {DateTime? createdAt,
          DateTime? updatedAt,
          bool? deleted,
          String? logId,
          String? locationId,
          DateTime? logDate,
          Value<int?> cropId = const Value.absent(),
          Value<int?> activityId = const Value.absent(),
          Value<String?> notes = const Value.absent()}) =>
      FarmLogData(
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deleted: deleted ?? this.deleted,
        logId: logId ?? this.logId,
        locationId: locationId ?? this.locationId,
        logDate: logDate ?? this.logDate,
        cropId: cropId.present ? cropId.value : this.cropId,
        activityId: activityId.present ? activityId.value : this.activityId,
        notes: notes.present ? notes.value : this.notes,
      );
  FarmLogData copyWithCompanion(FarmLogCompanion data) {
    return FarmLogData(
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      logId: data.logId.present ? data.logId.value : this.logId,
      locationId:
          data.locationId.present ? data.locationId.value : this.locationId,
      logDate: data.logDate.present ? data.logDate.value : this.logDate,
      cropId: data.cropId.present ? data.cropId.value : this.cropId,
      activityId:
          data.activityId.present ? data.activityId.value : this.activityId,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FarmLogData(')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('logId: $logId, ')
          ..write('locationId: $locationId, ')
          ..write('logDate: $logDate, ')
          ..write('cropId: $cropId, ')
          ..write('activityId: $activityId, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(createdAt, updatedAt, deleted, logId,
      locationId, logDate, cropId, activityId, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FarmLogData &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deleted == this.deleted &&
          other.logId == this.logId &&
          other.locationId == this.locationId &&
          other.logDate == this.logDate &&
          other.cropId == this.cropId &&
          other.activityId == this.activityId &&
          other.notes == this.notes);
}

class FarmLogCompanion extends UpdateCompanion<FarmLogData> {
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> deleted;
  final Value<String> logId;
  final Value<String> locationId;
  final Value<DateTime> logDate;
  final Value<int?> cropId;
  final Value<int?> activityId;
  final Value<String?> notes;
  final Value<int> rowid;
  const FarmLogCompanion({
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.logId = const Value.absent(),
    this.locationId = const Value.absent(),
    this.logDate = const Value.absent(),
    this.cropId = const Value.absent(),
    this.activityId = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FarmLogCompanion.insert({
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    required String logId,
    required String locationId,
    required DateTime logDate,
    this.cropId = const Value.absent(),
    this.activityId = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : logId = Value(logId),
        locationId = Value(locationId),
        logDate = Value(logDate);
  static Insertable<FarmLogData> custom({
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? deleted,
    Expression<String>? logId,
    Expression<String>? locationId,
    Expression<DateTime>? logDate,
    Expression<int>? cropId,
    Expression<int>? activityId,
    Expression<String>? notes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deleted != null) 'deleted': deleted,
      if (logId != null) 'log_id': logId,
      if (locationId != null) 'location_id': locationId,
      if (logDate != null) 'log_date': logDate,
      if (cropId != null) 'crop_id': cropId,
      if (activityId != null) 'activity_id': activityId,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FarmLogCompanion copyWith(
      {Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<bool>? deleted,
      Value<String>? logId,
      Value<String>? locationId,
      Value<DateTime>? logDate,
      Value<int?>? cropId,
      Value<int?>? activityId,
      Value<String?>? notes,
      Value<int>? rowid}) {
    return FarmLogCompanion(
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
      logId: logId ?? this.logId,
      locationId: locationId ?? this.locationId,
      logDate: logDate ?? this.logDate,
      cropId: cropId ?? this.cropId,
      activityId: activityId ?? this.activityId,
      notes: notes ?? this.notes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (logId.present) {
      map['log_id'] = Variable<String>(logId.value);
    }
    if (locationId.present) {
      map['location_id'] = Variable<String>(locationId.value);
    }
    if (logDate.present) {
      map['log_date'] = Variable<DateTime>(logDate.value);
    }
    if (cropId.present) {
      map['crop_id'] = Variable<int>(cropId.value);
    }
    if (activityId.present) {
      map['activity_id'] = Variable<int>(activityId.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FarmLogCompanion(')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('logId: $logId, ')
          ..write('locationId: $locationId, ')
          ..write('logDate: $logDate, ')
          ..write('cropId: $cropId, ')
          ..write('activityId: $activityId, ')
          ..write('notes: $notes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DeviceProfilesTable extends DeviceProfiles
    with TableInfo<$DeviceProfilesTable, DeviceProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DeviceProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _deletedMeta =
      const VerificationMeta('deleted');
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
      'deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _deviceIdMeta =
      const VerificationMeta('deviceId');
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
      'device_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _modelMeta = const VerificationMeta('model');
  @override
  late final GeneratedColumn<String> model = GeneratedColumn<String>(
      'model', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _fieldOfViewDegMeta =
      const VerificationMeta('fieldOfViewDeg');
  @override
  late final GeneratedColumn<double> fieldOfViewDeg = GeneratedColumn<double>(
      'field_of_view_deg', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _distortionJsonMeta =
      const VerificationMeta('distortionJson');
  @override
  late final GeneratedColumn<String> distortionJson = GeneratedColumn<String>(
      'distortion_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _compassErrorDegMeta =
      const VerificationMeta('compassErrorDeg');
  @override
  late final GeneratedColumn<double> compassErrorDeg = GeneratedColumn<double>(
      'compass_error_deg', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _arSupportedMeta =
      const VerificationMeta('arSupported');
  @override
  late final GeneratedColumn<bool> arSupported = GeneratedColumn<bool>(
      'ar_supported', aliasedName, true,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("ar_supported" IN (0, 1))'));
  @override
  List<GeneratedColumn> get $columns => [
        createdAt,
        updatedAt,
        deleted,
        deviceId,
        model,
        fieldOfViewDeg,
        distortionJson,
        compassErrorDeg,
        arSupported
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'device_profiles';
  @override
  VerificationContext validateIntegrity(Insertable<DeviceProfile> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('deleted')) {
      context.handle(_deletedMeta,
          deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta));
    }
    if (data.containsKey('device_id')) {
      context.handle(_deviceIdMeta,
          deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta));
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('model')) {
      context.handle(
          _modelMeta, model.isAcceptableOrUnknown(data['model']!, _modelMeta));
    }
    if (data.containsKey('field_of_view_deg')) {
      context.handle(
          _fieldOfViewDegMeta,
          fieldOfViewDeg.isAcceptableOrUnknown(
              data['field_of_view_deg']!, _fieldOfViewDegMeta));
    }
    if (data.containsKey('distortion_json')) {
      context.handle(
          _distortionJsonMeta,
          distortionJson.isAcceptableOrUnknown(
              data['distortion_json']!, _distortionJsonMeta));
    }
    if (data.containsKey('compass_error_deg')) {
      context.handle(
          _compassErrorDegMeta,
          compassErrorDeg.isAcceptableOrUnknown(
              data['compass_error_deg']!, _compassErrorDegMeta));
    }
    if (data.containsKey('ar_supported')) {
      context.handle(
          _arSupportedMeta,
          arSupported.isAcceptableOrUnknown(
              data['ar_supported']!, _arSupportedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {deviceId};
  @override
  DeviceProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DeviceProfile(
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      deleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}deleted'])!,
      deviceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}device_id'])!,
      model: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}model']),
      fieldOfViewDeg: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}field_of_view_deg']),
      distortionJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}distortion_json']),
      compassErrorDeg: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}compass_error_deg']),
      arSupported: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}ar_supported']),
    );
  }

  @override
  $DeviceProfilesTable createAlias(String alias) {
    return $DeviceProfilesTable(attachedDatabase, alias);
  }
}

class DeviceProfile extends DataClass implements Insertable<DeviceProfile> {
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool deleted;
  final String deviceId;
  final String? model;
  final double? fieldOfViewDeg;
  final String? distortionJson;
  final double? compassErrorDeg;
  final bool? arSupported;
  const DeviceProfile(
      {required this.createdAt,
      required this.updatedAt,
      required this.deleted,
      required this.deviceId,
      this.model,
      this.fieldOfViewDeg,
      this.distortionJson,
      this.compassErrorDeg,
      this.arSupported});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['deleted'] = Variable<bool>(deleted);
    map['device_id'] = Variable<String>(deviceId);
    if (!nullToAbsent || model != null) {
      map['model'] = Variable<String>(model);
    }
    if (!nullToAbsent || fieldOfViewDeg != null) {
      map['field_of_view_deg'] = Variable<double>(fieldOfViewDeg);
    }
    if (!nullToAbsent || distortionJson != null) {
      map['distortion_json'] = Variable<String>(distortionJson);
    }
    if (!nullToAbsent || compassErrorDeg != null) {
      map['compass_error_deg'] = Variable<double>(compassErrorDeg);
    }
    if (!nullToAbsent || arSupported != null) {
      map['ar_supported'] = Variable<bool>(arSupported);
    }
    return map;
  }

  DeviceProfilesCompanion toCompanion(bool nullToAbsent) {
    return DeviceProfilesCompanion(
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deleted: Value(deleted),
      deviceId: Value(deviceId),
      model:
          model == null && nullToAbsent ? const Value.absent() : Value(model),
      fieldOfViewDeg: fieldOfViewDeg == null && nullToAbsent
          ? const Value.absent()
          : Value(fieldOfViewDeg),
      distortionJson: distortionJson == null && nullToAbsent
          ? const Value.absent()
          : Value(distortionJson),
      compassErrorDeg: compassErrorDeg == null && nullToAbsent
          ? const Value.absent()
          : Value(compassErrorDeg),
      arSupported: arSupported == null && nullToAbsent
          ? const Value.absent()
          : Value(arSupported),
    );
  }

  factory DeviceProfile.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DeviceProfile(
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      model: serializer.fromJson<String?>(json['model']),
      fieldOfViewDeg: serializer.fromJson<double?>(json['fieldOfViewDeg']),
      distortionJson: serializer.fromJson<String?>(json['distortionJson']),
      compassErrorDeg: serializer.fromJson<double?>(json['compassErrorDeg']),
      arSupported: serializer.fromJson<bool?>(json['arSupported']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deleted': serializer.toJson<bool>(deleted),
      'deviceId': serializer.toJson<String>(deviceId),
      'model': serializer.toJson<String?>(model),
      'fieldOfViewDeg': serializer.toJson<double?>(fieldOfViewDeg),
      'distortionJson': serializer.toJson<String?>(distortionJson),
      'compassErrorDeg': serializer.toJson<double?>(compassErrorDeg),
      'arSupported': serializer.toJson<bool?>(arSupported),
    };
  }

  DeviceProfile copyWith(
          {DateTime? createdAt,
          DateTime? updatedAt,
          bool? deleted,
          String? deviceId,
          Value<String?> model = const Value.absent(),
          Value<double?> fieldOfViewDeg = const Value.absent(),
          Value<String?> distortionJson = const Value.absent(),
          Value<double?> compassErrorDeg = const Value.absent(),
          Value<bool?> arSupported = const Value.absent()}) =>
      DeviceProfile(
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deleted: deleted ?? this.deleted,
        deviceId: deviceId ?? this.deviceId,
        model: model.present ? model.value : this.model,
        fieldOfViewDeg:
            fieldOfViewDeg.present ? fieldOfViewDeg.value : this.fieldOfViewDeg,
        distortionJson:
            distortionJson.present ? distortionJson.value : this.distortionJson,
        compassErrorDeg: compassErrorDeg.present
            ? compassErrorDeg.value
            : this.compassErrorDeg,
        arSupported: arSupported.present ? arSupported.value : this.arSupported,
      );
  DeviceProfile copyWithCompanion(DeviceProfilesCompanion data) {
    return DeviceProfile(
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      model: data.model.present ? data.model.value : this.model,
      fieldOfViewDeg: data.fieldOfViewDeg.present
          ? data.fieldOfViewDeg.value
          : this.fieldOfViewDeg,
      distortionJson: data.distortionJson.present
          ? data.distortionJson.value
          : this.distortionJson,
      compassErrorDeg: data.compassErrorDeg.present
          ? data.compassErrorDeg.value
          : this.compassErrorDeg,
      arSupported:
          data.arSupported.present ? data.arSupported.value : this.arSupported,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DeviceProfile(')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('deviceId: $deviceId, ')
          ..write('model: $model, ')
          ..write('fieldOfViewDeg: $fieldOfViewDeg, ')
          ..write('distortionJson: $distortionJson, ')
          ..write('compassErrorDeg: $compassErrorDeg, ')
          ..write('arSupported: $arSupported')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(createdAt, updatedAt, deleted, deviceId,
      model, fieldOfViewDeg, distortionJson, compassErrorDeg, arSupported);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DeviceProfile &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deleted == this.deleted &&
          other.deviceId == this.deviceId &&
          other.model == this.model &&
          other.fieldOfViewDeg == this.fieldOfViewDeg &&
          other.distortionJson == this.distortionJson &&
          other.compassErrorDeg == this.compassErrorDeg &&
          other.arSupported == this.arSupported);
}

class DeviceProfilesCompanion extends UpdateCompanion<DeviceProfile> {
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> deleted;
  final Value<String> deviceId;
  final Value<String?> model;
  final Value<double?> fieldOfViewDeg;
  final Value<String?> distortionJson;
  final Value<double?> compassErrorDeg;
  final Value<bool?> arSupported;
  final Value<int> rowid;
  const DeviceProfilesCompanion({
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.model = const Value.absent(),
    this.fieldOfViewDeg = const Value.absent(),
    this.distortionJson = const Value.absent(),
    this.compassErrorDeg = const Value.absent(),
    this.arSupported = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DeviceProfilesCompanion.insert({
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    required String deviceId,
    this.model = const Value.absent(),
    this.fieldOfViewDeg = const Value.absent(),
    this.distortionJson = const Value.absent(),
    this.compassErrorDeg = const Value.absent(),
    this.arSupported = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : deviceId = Value(deviceId);
  static Insertable<DeviceProfile> custom({
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? deleted,
    Expression<String>? deviceId,
    Expression<String>? model,
    Expression<double>? fieldOfViewDeg,
    Expression<String>? distortionJson,
    Expression<double>? compassErrorDeg,
    Expression<bool>? arSupported,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deleted != null) 'deleted': deleted,
      if (deviceId != null) 'device_id': deviceId,
      if (model != null) 'model': model,
      if (fieldOfViewDeg != null) 'field_of_view_deg': fieldOfViewDeg,
      if (distortionJson != null) 'distortion_json': distortionJson,
      if (compassErrorDeg != null) 'compass_error_deg': compassErrorDeg,
      if (arSupported != null) 'ar_supported': arSupported,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DeviceProfilesCompanion copyWith(
      {Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<bool>? deleted,
      Value<String>? deviceId,
      Value<String?>? model,
      Value<double?>? fieldOfViewDeg,
      Value<String?>? distortionJson,
      Value<double?>? compassErrorDeg,
      Value<bool?>? arSupported,
      Value<int>? rowid}) {
    return DeviceProfilesCompanion(
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
      deviceId: deviceId ?? this.deviceId,
      model: model ?? this.model,
      fieldOfViewDeg: fieldOfViewDeg ?? this.fieldOfViewDeg,
      distortionJson: distortionJson ?? this.distortionJson,
      compassErrorDeg: compassErrorDeg ?? this.compassErrorDeg,
      arSupported: arSupported ?? this.arSupported,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (model.present) {
      map['model'] = Variable<String>(model.value);
    }
    if (fieldOfViewDeg.present) {
      map['field_of_view_deg'] = Variable<double>(fieldOfViewDeg.value);
    }
    if (distortionJson.present) {
      map['distortion_json'] = Variable<String>(distortionJson.value);
    }
    if (compassErrorDeg.present) {
      map['compass_error_deg'] = Variable<double>(compassErrorDeg.value);
    }
    if (arSupported.present) {
      map['ar_supported'] = Variable<bool>(arSupported.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DeviceProfilesCompanion(')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('deviceId: $deviceId, ')
          ..write('model: $model, ')
          ..write('fieldOfViewDeg: $fieldOfViewDeg, ')
          ..write('distortionJson: $distortionJson, ')
          ..write('compassErrorDeg: $compassErrorDeg, ')
          ..write('arSupported: $arSupported, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PhotoObservationsTable extends PhotoObservations
    with TableInfo<$PhotoObservationsTable, PhotoObservation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PhotoObservationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _deletedMeta =
      const VerificationMeta('deleted');
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
      'deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _obsIdMeta = const VerificationMeta('obsId');
  @override
  late final GeneratedColumn<String> obsId = GeneratedColumn<String>(
      'obs_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _locationIdMeta =
      const VerificationMeta('locationId');
  @override
  late final GeneratedColumn<String> locationId = GeneratedColumn<String>(
      'location_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _deviceIdMeta =
      const VerificationMeta('deviceId');
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
      'device_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _filePathMeta =
      const VerificationMeta('filePath');
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
      'file_path', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _takenAtMeta =
      const VerificationMeta('takenAt');
  @override
  late final GeneratedColumn<DateTime> takenAt = GeneratedColumn<DateTime>(
      'taken_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _exposureMsMeta =
      const VerificationMeta('exposureMs');
  @override
  late final GeneratedColumn<int> exposureMs = GeneratedColumn<int>(
      'exposure_ms', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _isoMeta = const VerificationMeta('iso');
  @override
  late final GeneratedColumn<int> iso = GeneratedColumn<int>(
      'iso', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        createdAt,
        updatedAt,
        deleted,
        obsId,
        locationId,
        deviceId,
        filePath,
        takenAt,
        exposureMs,
        iso
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'photo_observations';
  @override
  VerificationContext validateIntegrity(Insertable<PhotoObservation> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('deleted')) {
      context.handle(_deletedMeta,
          deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta));
    }
    if (data.containsKey('obs_id')) {
      context.handle(
          _obsIdMeta, obsId.isAcceptableOrUnknown(data['obs_id']!, _obsIdMeta));
    } else if (isInserting) {
      context.missing(_obsIdMeta);
    }
    if (data.containsKey('location_id')) {
      context.handle(
          _locationIdMeta,
          locationId.isAcceptableOrUnknown(
              data['location_id']!, _locationIdMeta));
    } else if (isInserting) {
      context.missing(_locationIdMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(_deviceIdMeta,
          deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta));
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('file_path')) {
      context.handle(_filePathMeta,
          filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta));
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('taken_at')) {
      context.handle(_takenAtMeta,
          takenAt.isAcceptableOrUnknown(data['taken_at']!, _takenAtMeta));
    } else if (isInserting) {
      context.missing(_takenAtMeta);
    }
    if (data.containsKey('exposure_ms')) {
      context.handle(
          _exposureMsMeta,
          exposureMs.isAcceptableOrUnknown(
              data['exposure_ms']!, _exposureMsMeta));
    }
    if (data.containsKey('iso')) {
      context.handle(
          _isoMeta, iso.isAcceptableOrUnknown(data['iso']!, _isoMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {obsId};
  @override
  PhotoObservation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PhotoObservation(
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      deleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}deleted'])!,
      obsId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}obs_id'])!,
      locationId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}location_id'])!,
      deviceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}device_id'])!,
      filePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}file_path'])!,
      takenAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}taken_at'])!,
      exposureMs: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}exposure_ms']),
      iso: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}iso']),
    );
  }

  @override
  $PhotoObservationsTable createAlias(String alias) {
    return $PhotoObservationsTable(attachedDatabase, alias);
  }
}

class PhotoObservation extends DataClass
    implements Insertable<PhotoObservation> {
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool deleted;
  final String obsId;
  final String locationId;
  final String deviceId;
  final String filePath;
  final DateTime takenAt;
  final int? exposureMs;
  final int? iso;
  const PhotoObservation(
      {required this.createdAt,
      required this.updatedAt,
      required this.deleted,
      required this.obsId,
      required this.locationId,
      required this.deviceId,
      required this.filePath,
      required this.takenAt,
      this.exposureMs,
      this.iso});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['deleted'] = Variable<bool>(deleted);
    map['obs_id'] = Variable<String>(obsId);
    map['location_id'] = Variable<String>(locationId);
    map['device_id'] = Variable<String>(deviceId);
    map['file_path'] = Variable<String>(filePath);
    map['taken_at'] = Variable<DateTime>(takenAt);
    if (!nullToAbsent || exposureMs != null) {
      map['exposure_ms'] = Variable<int>(exposureMs);
    }
    if (!nullToAbsent || iso != null) {
      map['iso'] = Variable<int>(iso);
    }
    return map;
  }

  PhotoObservationsCompanion toCompanion(bool nullToAbsent) {
    return PhotoObservationsCompanion(
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deleted: Value(deleted),
      obsId: Value(obsId),
      locationId: Value(locationId),
      deviceId: Value(deviceId),
      filePath: Value(filePath),
      takenAt: Value(takenAt),
      exposureMs: exposureMs == null && nullToAbsent
          ? const Value.absent()
          : Value(exposureMs),
      iso: iso == null && nullToAbsent ? const Value.absent() : Value(iso),
    );
  }

  factory PhotoObservation.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PhotoObservation(
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      obsId: serializer.fromJson<String>(json['obsId']),
      locationId: serializer.fromJson<String>(json['locationId']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      filePath: serializer.fromJson<String>(json['filePath']),
      takenAt: serializer.fromJson<DateTime>(json['takenAt']),
      exposureMs: serializer.fromJson<int?>(json['exposureMs']),
      iso: serializer.fromJson<int?>(json['iso']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deleted': serializer.toJson<bool>(deleted),
      'obsId': serializer.toJson<String>(obsId),
      'locationId': serializer.toJson<String>(locationId),
      'deviceId': serializer.toJson<String>(deviceId),
      'filePath': serializer.toJson<String>(filePath),
      'takenAt': serializer.toJson<DateTime>(takenAt),
      'exposureMs': serializer.toJson<int?>(exposureMs),
      'iso': serializer.toJson<int?>(iso),
    };
  }

  PhotoObservation copyWith(
          {DateTime? createdAt,
          DateTime? updatedAt,
          bool? deleted,
          String? obsId,
          String? locationId,
          String? deviceId,
          String? filePath,
          DateTime? takenAt,
          Value<int?> exposureMs = const Value.absent(),
          Value<int?> iso = const Value.absent()}) =>
      PhotoObservation(
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deleted: deleted ?? this.deleted,
        obsId: obsId ?? this.obsId,
        locationId: locationId ?? this.locationId,
        deviceId: deviceId ?? this.deviceId,
        filePath: filePath ?? this.filePath,
        takenAt: takenAt ?? this.takenAt,
        exposureMs: exposureMs.present ? exposureMs.value : this.exposureMs,
        iso: iso.present ? iso.value : this.iso,
      );
  PhotoObservation copyWithCompanion(PhotoObservationsCompanion data) {
    return PhotoObservation(
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      obsId: data.obsId.present ? data.obsId.value : this.obsId,
      locationId:
          data.locationId.present ? data.locationId.value : this.locationId,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      takenAt: data.takenAt.present ? data.takenAt.value : this.takenAt,
      exposureMs:
          data.exposureMs.present ? data.exposureMs.value : this.exposureMs,
      iso: data.iso.present ? data.iso.value : this.iso,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PhotoObservation(')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('obsId: $obsId, ')
          ..write('locationId: $locationId, ')
          ..write('deviceId: $deviceId, ')
          ..write('filePath: $filePath, ')
          ..write('takenAt: $takenAt, ')
          ..write('exposureMs: $exposureMs, ')
          ..write('iso: $iso')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(createdAt, updatedAt, deleted, obsId,
      locationId, deviceId, filePath, takenAt, exposureMs, iso);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PhotoObservation &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deleted == this.deleted &&
          other.obsId == this.obsId &&
          other.locationId == this.locationId &&
          other.deviceId == this.deviceId &&
          other.filePath == this.filePath &&
          other.takenAt == this.takenAt &&
          other.exposureMs == this.exposureMs &&
          other.iso == this.iso);
}

class PhotoObservationsCompanion extends UpdateCompanion<PhotoObservation> {
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> deleted;
  final Value<String> obsId;
  final Value<String> locationId;
  final Value<String> deviceId;
  final Value<String> filePath;
  final Value<DateTime> takenAt;
  final Value<int?> exposureMs;
  final Value<int?> iso;
  final Value<int> rowid;
  const PhotoObservationsCompanion({
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.obsId = const Value.absent(),
    this.locationId = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.filePath = const Value.absent(),
    this.takenAt = const Value.absent(),
    this.exposureMs = const Value.absent(),
    this.iso = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PhotoObservationsCompanion.insert({
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    required String obsId,
    required String locationId,
    required String deviceId,
    required String filePath,
    required DateTime takenAt,
    this.exposureMs = const Value.absent(),
    this.iso = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : obsId = Value(obsId),
        locationId = Value(locationId),
        deviceId = Value(deviceId),
        filePath = Value(filePath),
        takenAt = Value(takenAt);
  static Insertable<PhotoObservation> custom({
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? deleted,
    Expression<String>? obsId,
    Expression<String>? locationId,
    Expression<String>? deviceId,
    Expression<String>? filePath,
    Expression<DateTime>? takenAt,
    Expression<int>? exposureMs,
    Expression<int>? iso,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deleted != null) 'deleted': deleted,
      if (obsId != null) 'obs_id': obsId,
      if (locationId != null) 'location_id': locationId,
      if (deviceId != null) 'device_id': deviceId,
      if (filePath != null) 'file_path': filePath,
      if (takenAt != null) 'taken_at': takenAt,
      if (exposureMs != null) 'exposure_ms': exposureMs,
      if (iso != null) 'iso': iso,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PhotoObservationsCompanion copyWith(
      {Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<bool>? deleted,
      Value<String>? obsId,
      Value<String>? locationId,
      Value<String>? deviceId,
      Value<String>? filePath,
      Value<DateTime>? takenAt,
      Value<int?>? exposureMs,
      Value<int?>? iso,
      Value<int>? rowid}) {
    return PhotoObservationsCompanion(
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
      obsId: obsId ?? this.obsId,
      locationId: locationId ?? this.locationId,
      deviceId: deviceId ?? this.deviceId,
      filePath: filePath ?? this.filePath,
      takenAt: takenAt ?? this.takenAt,
      exposureMs: exposureMs ?? this.exposureMs,
      iso: iso ?? this.iso,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (obsId.present) {
      map['obs_id'] = Variable<String>(obsId.value);
    }
    if (locationId.present) {
      map['location_id'] = Variable<String>(locationId.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (takenAt.present) {
      map['taken_at'] = Variable<DateTime>(takenAt.value);
    }
    if (exposureMs.present) {
      map['exposure_ms'] = Variable<int>(exposureMs.value);
    }
    if (iso.present) {
      map['iso'] = Variable<int>(iso.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PhotoObservationsCompanion(')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('obsId: $obsId, ')
          ..write('locationId: $locationId, ')
          ..write('deviceId: $deviceId, ')
          ..write('filePath: $filePath, ')
          ..write('takenAt: $takenAt, ')
          ..write('exposureMs: $exposureMs, ')
          ..write('iso: $iso, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PhotoResultsTable extends PhotoResults
    with TableInfo<$PhotoResultsTable, PhotoResult> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PhotoResultsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _deletedMeta =
      const VerificationMeta('deleted');
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
      'deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _obsIdMeta = const VerificationMeta('obsId');
  @override
  late final GeneratedColumn<String> obsId = GeneratedColumn<String>(
      'obs_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _starsDetectedMeta =
      const VerificationMeta('starsDetected');
  @override
  late final GeneratedColumn<int> starsDetected = GeneratedColumn<int>(
      'stars_detected', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _starsMatchedMeta =
      const VerificationMeta('starsMatched');
  @override
  late final GeneratedColumn<int> starsMatched = GeneratedColumn<int>(
      'stars_matched', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _confidenceMeta =
      const VerificationMeta('confidence');
  @override
  late final GeneratedColumn<double> confidence = GeneratedColumn<double>(
      'confidence', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _rotationDegMeta =
      const VerificationMeta('rotationDeg');
  @override
  late final GeneratedColumn<double> rotationDeg = GeneratedColumn<double>(
      'rotation_deg', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _shiftXPxMeta =
      const VerificationMeta('shiftXPx');
  @override
  late final GeneratedColumn<double> shiftXPx = GeneratedColumn<double>(
      'shift_x_px', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _shiftYPxMeta =
      const VerificationMeta('shiftYPx');
  @override
  late final GeneratedColumn<double> shiftYPx = GeneratedColumn<double>(
      'shift_y_px', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _resultMeta = const VerificationMeta('result');
  @override
  late final GeneratedColumn<String> result = GeneratedColumn<String>(
      'result', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _recoveredHeadingDegMeta =
      const VerificationMeta('recoveredHeadingDeg');
  @override
  late final GeneratedColumn<double> recoveredHeadingDeg =
      GeneratedColumn<double>('recovered_heading_deg', aliasedName, true,
          type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _recoveredPitchDegMeta =
      const VerificationMeta('recoveredPitchDeg');
  @override
  late final GeneratedColumn<double> recoveredPitchDeg =
      GeneratedColumn<double>('recovered_pitch_deg', aliasedName, true,
          type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _matchedConstCodeMeta =
      const VerificationMeta('matchedConstCode');
  @override
  late final GeneratedColumn<String> matchedConstCode = GeneratedColumn<String>(
      'matched_const_code', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        createdAt,
        updatedAt,
        deleted,
        obsId,
        starsDetected,
        starsMatched,
        confidence,
        rotationDeg,
        shiftXPx,
        shiftYPx,
        result,
        recoveredHeadingDeg,
        recoveredPitchDeg,
        matchedConstCode
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'photo_results';
  @override
  VerificationContext validateIntegrity(Insertable<PhotoResult> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('deleted')) {
      context.handle(_deletedMeta,
          deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta));
    }
    if (data.containsKey('obs_id')) {
      context.handle(
          _obsIdMeta, obsId.isAcceptableOrUnknown(data['obs_id']!, _obsIdMeta));
    } else if (isInserting) {
      context.missing(_obsIdMeta);
    }
    if (data.containsKey('stars_detected')) {
      context.handle(
          _starsDetectedMeta,
          starsDetected.isAcceptableOrUnknown(
              data['stars_detected']!, _starsDetectedMeta));
    }
    if (data.containsKey('stars_matched')) {
      context.handle(
          _starsMatchedMeta,
          starsMatched.isAcceptableOrUnknown(
              data['stars_matched']!, _starsMatchedMeta));
    }
    if (data.containsKey('confidence')) {
      context.handle(
          _confidenceMeta,
          confidence.isAcceptableOrUnknown(
              data['confidence']!, _confidenceMeta));
    }
    if (data.containsKey('rotation_deg')) {
      context.handle(
          _rotationDegMeta,
          rotationDeg.isAcceptableOrUnknown(
              data['rotation_deg']!, _rotationDegMeta));
    }
    if (data.containsKey('shift_x_px')) {
      context.handle(_shiftXPxMeta,
          shiftXPx.isAcceptableOrUnknown(data['shift_x_px']!, _shiftXPxMeta));
    }
    if (data.containsKey('shift_y_px')) {
      context.handle(_shiftYPxMeta,
          shiftYPx.isAcceptableOrUnknown(data['shift_y_px']!, _shiftYPxMeta));
    }
    if (data.containsKey('result')) {
      context.handle(_resultMeta,
          result.isAcceptableOrUnknown(data['result']!, _resultMeta));
    }
    if (data.containsKey('recovered_heading_deg')) {
      context.handle(
          _recoveredHeadingDegMeta,
          recoveredHeadingDeg.isAcceptableOrUnknown(
              data['recovered_heading_deg']!, _recoveredHeadingDegMeta));
    }
    if (data.containsKey('recovered_pitch_deg')) {
      context.handle(
          _recoveredPitchDegMeta,
          recoveredPitchDeg.isAcceptableOrUnknown(
              data['recovered_pitch_deg']!, _recoveredPitchDegMeta));
    }
    if (data.containsKey('matched_const_code')) {
      context.handle(
          _matchedConstCodeMeta,
          matchedConstCode.isAcceptableOrUnknown(
              data['matched_const_code']!, _matchedConstCodeMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {obsId};
  @override
  PhotoResult map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PhotoResult(
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      deleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}deleted'])!,
      obsId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}obs_id'])!,
      starsDetected: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}stars_detected']),
      starsMatched: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}stars_matched']),
      confidence: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}confidence']),
      rotationDeg: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}rotation_deg']),
      shiftXPx: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}shift_x_px']),
      shiftYPx: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}shift_y_px']),
      result: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}result']),
      recoveredHeadingDeg: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}recovered_heading_deg']),
      recoveredPitchDeg: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}recovered_pitch_deg']),
      matchedConstCode: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}matched_const_code']),
    );
  }

  @override
  $PhotoResultsTable createAlias(String alias) {
    return $PhotoResultsTable(attachedDatabase, alias);
  }
}

class PhotoResult extends DataClass implements Insertable<PhotoResult> {
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool deleted;
  final String obsId;
  final int? starsDetected;
  final int? starsMatched;
  final double? confidence;
  final double? rotationDeg;
  final double? shiftXPx;
  final double? shiftYPx;
  final String? result;
  final double? recoveredHeadingDeg;
  final double? recoveredPitchDeg;
  final String? matchedConstCode;
  const PhotoResult(
      {required this.createdAt,
      required this.updatedAt,
      required this.deleted,
      required this.obsId,
      this.starsDetected,
      this.starsMatched,
      this.confidence,
      this.rotationDeg,
      this.shiftXPx,
      this.shiftYPx,
      this.result,
      this.recoveredHeadingDeg,
      this.recoveredPitchDeg,
      this.matchedConstCode});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['deleted'] = Variable<bool>(deleted);
    map['obs_id'] = Variable<String>(obsId);
    if (!nullToAbsent || starsDetected != null) {
      map['stars_detected'] = Variable<int>(starsDetected);
    }
    if (!nullToAbsent || starsMatched != null) {
      map['stars_matched'] = Variable<int>(starsMatched);
    }
    if (!nullToAbsent || confidence != null) {
      map['confidence'] = Variable<double>(confidence);
    }
    if (!nullToAbsent || rotationDeg != null) {
      map['rotation_deg'] = Variable<double>(rotationDeg);
    }
    if (!nullToAbsent || shiftXPx != null) {
      map['shift_x_px'] = Variable<double>(shiftXPx);
    }
    if (!nullToAbsent || shiftYPx != null) {
      map['shift_y_px'] = Variable<double>(shiftYPx);
    }
    if (!nullToAbsent || result != null) {
      map['result'] = Variable<String>(result);
    }
    if (!nullToAbsent || recoveredHeadingDeg != null) {
      map['recovered_heading_deg'] = Variable<double>(recoveredHeadingDeg);
    }
    if (!nullToAbsent || recoveredPitchDeg != null) {
      map['recovered_pitch_deg'] = Variable<double>(recoveredPitchDeg);
    }
    if (!nullToAbsent || matchedConstCode != null) {
      map['matched_const_code'] = Variable<String>(matchedConstCode);
    }
    return map;
  }

  PhotoResultsCompanion toCompanion(bool nullToAbsent) {
    return PhotoResultsCompanion(
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deleted: Value(deleted),
      obsId: Value(obsId),
      starsDetected: starsDetected == null && nullToAbsent
          ? const Value.absent()
          : Value(starsDetected),
      starsMatched: starsMatched == null && nullToAbsent
          ? const Value.absent()
          : Value(starsMatched),
      confidence: confidence == null && nullToAbsent
          ? const Value.absent()
          : Value(confidence),
      rotationDeg: rotationDeg == null && nullToAbsent
          ? const Value.absent()
          : Value(rotationDeg),
      shiftXPx: shiftXPx == null && nullToAbsent
          ? const Value.absent()
          : Value(shiftXPx),
      shiftYPx: shiftYPx == null && nullToAbsent
          ? const Value.absent()
          : Value(shiftYPx),
      result:
          result == null && nullToAbsent ? const Value.absent() : Value(result),
      recoveredHeadingDeg: recoveredHeadingDeg == null && nullToAbsent
          ? const Value.absent()
          : Value(recoveredHeadingDeg),
      recoveredPitchDeg: recoveredPitchDeg == null && nullToAbsent
          ? const Value.absent()
          : Value(recoveredPitchDeg),
      matchedConstCode: matchedConstCode == null && nullToAbsent
          ? const Value.absent()
          : Value(matchedConstCode),
    );
  }

  factory PhotoResult.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PhotoResult(
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      obsId: serializer.fromJson<String>(json['obsId']),
      starsDetected: serializer.fromJson<int?>(json['starsDetected']),
      starsMatched: serializer.fromJson<int?>(json['starsMatched']),
      confidence: serializer.fromJson<double?>(json['confidence']),
      rotationDeg: serializer.fromJson<double?>(json['rotationDeg']),
      shiftXPx: serializer.fromJson<double?>(json['shiftXPx']),
      shiftYPx: serializer.fromJson<double?>(json['shiftYPx']),
      result: serializer.fromJson<String?>(json['result']),
      recoveredHeadingDeg:
          serializer.fromJson<double?>(json['recoveredHeadingDeg']),
      recoveredPitchDeg:
          serializer.fromJson<double?>(json['recoveredPitchDeg']),
      matchedConstCode: serializer.fromJson<String?>(json['matchedConstCode']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deleted': serializer.toJson<bool>(deleted),
      'obsId': serializer.toJson<String>(obsId),
      'starsDetected': serializer.toJson<int?>(starsDetected),
      'starsMatched': serializer.toJson<int?>(starsMatched),
      'confidence': serializer.toJson<double?>(confidence),
      'rotationDeg': serializer.toJson<double?>(rotationDeg),
      'shiftXPx': serializer.toJson<double?>(shiftXPx),
      'shiftYPx': serializer.toJson<double?>(shiftYPx),
      'result': serializer.toJson<String?>(result),
      'recoveredHeadingDeg': serializer.toJson<double?>(recoveredHeadingDeg),
      'recoveredPitchDeg': serializer.toJson<double?>(recoveredPitchDeg),
      'matchedConstCode': serializer.toJson<String?>(matchedConstCode),
    };
  }

  PhotoResult copyWith(
          {DateTime? createdAt,
          DateTime? updatedAt,
          bool? deleted,
          String? obsId,
          Value<int?> starsDetected = const Value.absent(),
          Value<int?> starsMatched = const Value.absent(),
          Value<double?> confidence = const Value.absent(),
          Value<double?> rotationDeg = const Value.absent(),
          Value<double?> shiftXPx = const Value.absent(),
          Value<double?> shiftYPx = const Value.absent(),
          Value<String?> result = const Value.absent(),
          Value<double?> recoveredHeadingDeg = const Value.absent(),
          Value<double?> recoveredPitchDeg = const Value.absent(),
          Value<String?> matchedConstCode = const Value.absent()}) =>
      PhotoResult(
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deleted: deleted ?? this.deleted,
        obsId: obsId ?? this.obsId,
        starsDetected:
            starsDetected.present ? starsDetected.value : this.starsDetected,
        starsMatched:
            starsMatched.present ? starsMatched.value : this.starsMatched,
        confidence: confidence.present ? confidence.value : this.confidence,
        rotationDeg: rotationDeg.present ? rotationDeg.value : this.rotationDeg,
        shiftXPx: shiftXPx.present ? shiftXPx.value : this.shiftXPx,
        shiftYPx: shiftYPx.present ? shiftYPx.value : this.shiftYPx,
        result: result.present ? result.value : this.result,
        recoveredHeadingDeg: recoveredHeadingDeg.present
            ? recoveredHeadingDeg.value
            : this.recoveredHeadingDeg,
        recoveredPitchDeg: recoveredPitchDeg.present
            ? recoveredPitchDeg.value
            : this.recoveredPitchDeg,
        matchedConstCode: matchedConstCode.present
            ? matchedConstCode.value
            : this.matchedConstCode,
      );
  PhotoResult copyWithCompanion(PhotoResultsCompanion data) {
    return PhotoResult(
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      obsId: data.obsId.present ? data.obsId.value : this.obsId,
      starsDetected: data.starsDetected.present
          ? data.starsDetected.value
          : this.starsDetected,
      starsMatched: data.starsMatched.present
          ? data.starsMatched.value
          : this.starsMatched,
      confidence:
          data.confidence.present ? data.confidence.value : this.confidence,
      rotationDeg:
          data.rotationDeg.present ? data.rotationDeg.value : this.rotationDeg,
      shiftXPx: data.shiftXPx.present ? data.shiftXPx.value : this.shiftXPx,
      shiftYPx: data.shiftYPx.present ? data.shiftYPx.value : this.shiftYPx,
      result: data.result.present ? data.result.value : this.result,
      recoveredHeadingDeg: data.recoveredHeadingDeg.present
          ? data.recoveredHeadingDeg.value
          : this.recoveredHeadingDeg,
      recoveredPitchDeg: data.recoveredPitchDeg.present
          ? data.recoveredPitchDeg.value
          : this.recoveredPitchDeg,
      matchedConstCode: data.matchedConstCode.present
          ? data.matchedConstCode.value
          : this.matchedConstCode,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PhotoResult(')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('obsId: $obsId, ')
          ..write('starsDetected: $starsDetected, ')
          ..write('starsMatched: $starsMatched, ')
          ..write('confidence: $confidence, ')
          ..write('rotationDeg: $rotationDeg, ')
          ..write('shiftXPx: $shiftXPx, ')
          ..write('shiftYPx: $shiftYPx, ')
          ..write('result: $result, ')
          ..write('recoveredHeadingDeg: $recoveredHeadingDeg, ')
          ..write('recoveredPitchDeg: $recoveredPitchDeg, ')
          ..write('matchedConstCode: $matchedConstCode')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      createdAt,
      updatedAt,
      deleted,
      obsId,
      starsDetected,
      starsMatched,
      confidence,
      rotationDeg,
      shiftXPx,
      shiftYPx,
      result,
      recoveredHeadingDeg,
      recoveredPitchDeg,
      matchedConstCode);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PhotoResult &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deleted == this.deleted &&
          other.obsId == this.obsId &&
          other.starsDetected == this.starsDetected &&
          other.starsMatched == this.starsMatched &&
          other.confidence == this.confidence &&
          other.rotationDeg == this.rotationDeg &&
          other.shiftXPx == this.shiftXPx &&
          other.shiftYPx == this.shiftYPx &&
          other.result == this.result &&
          other.recoveredHeadingDeg == this.recoveredHeadingDeg &&
          other.recoveredPitchDeg == this.recoveredPitchDeg &&
          other.matchedConstCode == this.matchedConstCode);
}

class PhotoResultsCompanion extends UpdateCompanion<PhotoResult> {
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> deleted;
  final Value<String> obsId;
  final Value<int?> starsDetected;
  final Value<int?> starsMatched;
  final Value<double?> confidence;
  final Value<double?> rotationDeg;
  final Value<double?> shiftXPx;
  final Value<double?> shiftYPx;
  final Value<String?> result;
  final Value<double?> recoveredHeadingDeg;
  final Value<double?> recoveredPitchDeg;
  final Value<String?> matchedConstCode;
  final Value<int> rowid;
  const PhotoResultsCompanion({
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.obsId = const Value.absent(),
    this.starsDetected = const Value.absent(),
    this.starsMatched = const Value.absent(),
    this.confidence = const Value.absent(),
    this.rotationDeg = const Value.absent(),
    this.shiftXPx = const Value.absent(),
    this.shiftYPx = const Value.absent(),
    this.result = const Value.absent(),
    this.recoveredHeadingDeg = const Value.absent(),
    this.recoveredPitchDeg = const Value.absent(),
    this.matchedConstCode = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PhotoResultsCompanion.insert({
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    required String obsId,
    this.starsDetected = const Value.absent(),
    this.starsMatched = const Value.absent(),
    this.confidence = const Value.absent(),
    this.rotationDeg = const Value.absent(),
    this.shiftXPx = const Value.absent(),
    this.shiftYPx = const Value.absent(),
    this.result = const Value.absent(),
    this.recoveredHeadingDeg = const Value.absent(),
    this.recoveredPitchDeg = const Value.absent(),
    this.matchedConstCode = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : obsId = Value(obsId);
  static Insertable<PhotoResult> custom({
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? deleted,
    Expression<String>? obsId,
    Expression<int>? starsDetected,
    Expression<int>? starsMatched,
    Expression<double>? confidence,
    Expression<double>? rotationDeg,
    Expression<double>? shiftXPx,
    Expression<double>? shiftYPx,
    Expression<String>? result,
    Expression<double>? recoveredHeadingDeg,
    Expression<double>? recoveredPitchDeg,
    Expression<String>? matchedConstCode,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deleted != null) 'deleted': deleted,
      if (obsId != null) 'obs_id': obsId,
      if (starsDetected != null) 'stars_detected': starsDetected,
      if (starsMatched != null) 'stars_matched': starsMatched,
      if (confidence != null) 'confidence': confidence,
      if (rotationDeg != null) 'rotation_deg': rotationDeg,
      if (shiftXPx != null) 'shift_x_px': shiftXPx,
      if (shiftYPx != null) 'shift_y_px': shiftYPx,
      if (result != null) 'result': result,
      if (recoveredHeadingDeg != null)
        'recovered_heading_deg': recoveredHeadingDeg,
      if (recoveredPitchDeg != null) 'recovered_pitch_deg': recoveredPitchDeg,
      if (matchedConstCode != null) 'matched_const_code': matchedConstCode,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PhotoResultsCompanion copyWith(
      {Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<bool>? deleted,
      Value<String>? obsId,
      Value<int?>? starsDetected,
      Value<int?>? starsMatched,
      Value<double?>? confidence,
      Value<double?>? rotationDeg,
      Value<double?>? shiftXPx,
      Value<double?>? shiftYPx,
      Value<String?>? result,
      Value<double?>? recoveredHeadingDeg,
      Value<double?>? recoveredPitchDeg,
      Value<String?>? matchedConstCode,
      Value<int>? rowid}) {
    return PhotoResultsCompanion(
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
      obsId: obsId ?? this.obsId,
      starsDetected: starsDetected ?? this.starsDetected,
      starsMatched: starsMatched ?? this.starsMatched,
      confidence: confidence ?? this.confidence,
      rotationDeg: rotationDeg ?? this.rotationDeg,
      shiftXPx: shiftXPx ?? this.shiftXPx,
      shiftYPx: shiftYPx ?? this.shiftYPx,
      result: result ?? this.result,
      recoveredHeadingDeg: recoveredHeadingDeg ?? this.recoveredHeadingDeg,
      recoveredPitchDeg: recoveredPitchDeg ?? this.recoveredPitchDeg,
      matchedConstCode: matchedConstCode ?? this.matchedConstCode,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (obsId.present) {
      map['obs_id'] = Variable<String>(obsId.value);
    }
    if (starsDetected.present) {
      map['stars_detected'] = Variable<int>(starsDetected.value);
    }
    if (starsMatched.present) {
      map['stars_matched'] = Variable<int>(starsMatched.value);
    }
    if (confidence.present) {
      map['confidence'] = Variable<double>(confidence.value);
    }
    if (rotationDeg.present) {
      map['rotation_deg'] = Variable<double>(rotationDeg.value);
    }
    if (shiftXPx.present) {
      map['shift_x_px'] = Variable<double>(shiftXPx.value);
    }
    if (shiftYPx.present) {
      map['shift_y_px'] = Variable<double>(shiftYPx.value);
    }
    if (result.present) {
      map['result'] = Variable<String>(result.value);
    }
    if (recoveredHeadingDeg.present) {
      map['recovered_heading_deg'] =
          Variable<double>(recoveredHeadingDeg.value);
    }
    if (recoveredPitchDeg.present) {
      map['recovered_pitch_deg'] = Variable<double>(recoveredPitchDeg.value);
    }
    if (matchedConstCode.present) {
      map['matched_const_code'] = Variable<String>(matchedConstCode.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PhotoResultsCompanion(')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('obsId: $obsId, ')
          ..write('starsDetected: $starsDetected, ')
          ..write('starsMatched: $starsMatched, ')
          ..write('confidence: $confidence, ')
          ..write('rotationDeg: $rotationDeg, ')
          ..write('shiftXPx: $shiftXPx, ')
          ..write('shiftYPx: $shiftYPx, ')
          ..write('result: $result, ')
          ..write('recoveredHeadingDeg: $recoveredHeadingDeg, ')
          ..write('recoveredPitchDeg: $recoveredPitchDeg, ')
          ..write('matchedConstCode: $matchedConstCode, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FeedbackTable extends Feedback
    with TableInfo<$FeedbackTable, FeedbackData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FeedbackTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _deletedMeta =
      const VerificationMeta('deleted');
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
      'deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _feedbackIdMeta =
      const VerificationMeta('feedbackId');
  @override
  late final GeneratedColumn<String> feedbackId = GeneratedColumn<String>(
      'feedback_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _ruleIdMeta = const VerificationMeta('ruleId');
  @override
  late final GeneratedColumn<int> ruleId = GeneratedColumn<int>(
      'rule_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [createdAt, updatedAt, deleted, feedbackId, ruleId, note];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'feedback';
  @override
  VerificationContext validateIntegrity(Insertable<FeedbackData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('deleted')) {
      context.handle(_deletedMeta,
          deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta));
    }
    if (data.containsKey('feedback_id')) {
      context.handle(
          _feedbackIdMeta,
          feedbackId.isAcceptableOrUnknown(
              data['feedback_id']!, _feedbackIdMeta));
    } else if (isInserting) {
      context.missing(_feedbackIdMeta);
    }
    if (data.containsKey('rule_id')) {
      context.handle(_ruleIdMeta,
          ruleId.isAcceptableOrUnknown(data['rule_id']!, _ruleIdMeta));
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {feedbackId};
  @override
  FeedbackData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FeedbackData(
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      deleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}deleted'])!,
      feedbackId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}feedback_id'])!,
      ruleId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}rule_id']),
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
    );
  }

  @override
  $FeedbackTable createAlias(String alias) {
    return $FeedbackTable(attachedDatabase, alias);
  }
}

class FeedbackData extends DataClass implements Insertable<FeedbackData> {
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool deleted;
  final String feedbackId;
  final int? ruleId;
  final String? note;
  const FeedbackData(
      {required this.createdAt,
      required this.updatedAt,
      required this.deleted,
      required this.feedbackId,
      this.ruleId,
      this.note});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['deleted'] = Variable<bool>(deleted);
    map['feedback_id'] = Variable<String>(feedbackId);
    if (!nullToAbsent || ruleId != null) {
      map['rule_id'] = Variable<int>(ruleId);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  FeedbackCompanion toCompanion(bool nullToAbsent) {
    return FeedbackCompanion(
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deleted: Value(deleted),
      feedbackId: Value(feedbackId),
      ruleId:
          ruleId == null && nullToAbsent ? const Value.absent() : Value(ruleId),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory FeedbackData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FeedbackData(
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      feedbackId: serializer.fromJson<String>(json['feedbackId']),
      ruleId: serializer.fromJson<int?>(json['ruleId']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deleted': serializer.toJson<bool>(deleted),
      'feedbackId': serializer.toJson<String>(feedbackId),
      'ruleId': serializer.toJson<int?>(ruleId),
      'note': serializer.toJson<String?>(note),
    };
  }

  FeedbackData copyWith(
          {DateTime? createdAt,
          DateTime? updatedAt,
          bool? deleted,
          String? feedbackId,
          Value<int?> ruleId = const Value.absent(),
          Value<String?> note = const Value.absent()}) =>
      FeedbackData(
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deleted: deleted ?? this.deleted,
        feedbackId: feedbackId ?? this.feedbackId,
        ruleId: ruleId.present ? ruleId.value : this.ruleId,
        note: note.present ? note.value : this.note,
      );
  FeedbackData copyWithCompanion(FeedbackCompanion data) {
    return FeedbackData(
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      feedbackId:
          data.feedbackId.present ? data.feedbackId.value : this.feedbackId,
      ruleId: data.ruleId.present ? data.ruleId.value : this.ruleId,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FeedbackData(')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('feedbackId: $feedbackId, ')
          ..write('ruleId: $ruleId, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(createdAt, updatedAt, deleted, feedbackId, ruleId, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FeedbackData &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deleted == this.deleted &&
          other.feedbackId == this.feedbackId &&
          other.ruleId == this.ruleId &&
          other.note == this.note);
}

class FeedbackCompanion extends UpdateCompanion<FeedbackData> {
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> deleted;
  final Value<String> feedbackId;
  final Value<int?> ruleId;
  final Value<String?> note;
  final Value<int> rowid;
  const FeedbackCompanion({
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.feedbackId = const Value.absent(),
    this.ruleId = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FeedbackCompanion.insert({
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    required String feedbackId,
    this.ruleId = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : feedbackId = Value(feedbackId);
  static Insertable<FeedbackData> custom({
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? deleted,
    Expression<String>? feedbackId,
    Expression<int>? ruleId,
    Expression<String>? note,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deleted != null) 'deleted': deleted,
      if (feedbackId != null) 'feedback_id': feedbackId,
      if (ruleId != null) 'rule_id': ruleId,
      if (note != null) 'note': note,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FeedbackCompanion copyWith(
      {Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<bool>? deleted,
      Value<String>? feedbackId,
      Value<int?>? ruleId,
      Value<String?>? note,
      Value<int>? rowid}) {
    return FeedbackCompanion(
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
      feedbackId: feedbackId ?? this.feedbackId,
      ruleId: ruleId ?? this.ruleId,
      note: note ?? this.note,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (feedbackId.present) {
      map['feedback_id'] = Variable<String>(feedbackId.value);
    }
    if (ruleId.present) {
      map['rule_id'] = Variable<int>(ruleId.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FeedbackCompanion(')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('feedbackId: $feedbackId, ')
          ..write('ruleId: $ruleId, ')
          ..write('note: $note, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserSettingsTable extends UserSettings
    with TableInfo<$UserSettingsTable, UserSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _deletedMeta =
      const VerificationMeta('deleted');
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
      'deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
      'key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
      'value', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [createdAt, updatedAt, deleted, key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_settings';
  @override
  VerificationContext validateIntegrity(Insertable<UserSetting> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('deleted')) {
      context.handle(_deletedMeta,
          deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta));
    }
    if (data.containsKey('key')) {
      context.handle(
          _keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  UserSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserSetting(
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      deleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}deleted'])!,
      key: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}value'])!,
    );
  }

  @override
  $UserSettingsTable createAlias(String alias) {
    return $UserSettingsTable(attachedDatabase, alias);
  }
}

class UserSetting extends DataClass implements Insertable<UserSetting> {
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool deleted;
  final String key;
  final String value;
  const UserSetting(
      {required this.createdAt,
      required this.updatedAt,
      required this.deleted,
      required this.key,
      required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['deleted'] = Variable<bool>(deleted);
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  UserSettingsCompanion toCompanion(bool nullToAbsent) {
    return UserSettingsCompanion(
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deleted: Value(deleted),
      key: Value(key),
      value: Value(value),
    );
  }

  factory UserSetting.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserSetting(
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deleted': serializer.toJson<bool>(deleted),
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  UserSetting copyWith(
          {DateTime? createdAt,
          DateTime? updatedAt,
          bool? deleted,
          String? key,
          String? value}) =>
      UserSetting(
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deleted: deleted ?? this.deleted,
        key: key ?? this.key,
        value: value ?? this.value,
      );
  UserSetting copyWithCompanion(UserSettingsCompanion data) {
    return UserSetting(
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserSetting(')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(createdAt, updatedAt, deleted, key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserSetting &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deleted == this.deleted &&
          other.key == this.key &&
          other.value == this.value);
}

class UserSettingsCompanion extends UpdateCompanion<UserSetting> {
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> deleted;
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const UserSettingsCompanion({
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserSettingsCompanion.insert({
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  })  : key = Value(key),
        value = Value(value);
  static Insertable<UserSetting> custom({
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? deleted,
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deleted != null) 'deleted': deleted,
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserSettingsCompanion copyWith(
      {Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<bool>? deleted,
      Value<String>? key,
      Value<String>? value,
      Value<int>? rowid}) {
    return UserSettingsCompanion(
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserSettingsCompanion(')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$UserDb extends GeneratedDatabase {
  _$UserDb(QueryExecutor e) : super(e);
  $UserDbManager get managers => $UserDbManager(this);
  late final $SavedLocationsTable savedLocations = $SavedLocationsTable(this);
  late final $WeatherLogTable weatherLog = $WeatherLogTable(this);
  late final $FarmLogTable farmLog = $FarmLogTable(this);
  late final $DeviceProfilesTable deviceProfiles = $DeviceProfilesTable(this);
  late final $PhotoObservationsTable photoObservations =
      $PhotoObservationsTable(this);
  late final $PhotoResultsTable photoResults = $PhotoResultsTable(this);
  late final $FeedbackTable feedback = $FeedbackTable(this);
  late final $UserSettingsTable userSettings = $UserSettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        savedLocations,
        weatherLog,
        farmLog,
        deviceProfiles,
        photoObservations,
        photoResults,
        feedback,
        userSettings
      ];
}

typedef $$SavedLocationsTableCreateCompanionBuilder = SavedLocationsCompanion
    Function({
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<bool> deleted,
  required String locationId,
  required String label,
  required double lat,
  required double lon,
  Value<int?> placeId,
  Value<String?> timezoneId,
  Value<bool> isActive,
  Value<int> rowid,
});
typedef $$SavedLocationsTableUpdateCompanionBuilder = SavedLocationsCompanion
    Function({
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<bool> deleted,
  Value<String> locationId,
  Value<String> label,
  Value<double> lat,
  Value<double> lon,
  Value<int?> placeId,
  Value<String?> timezoneId,
  Value<bool> isActive,
  Value<int> rowid,
});

class $$SavedLocationsTableFilterComposer
    extends Composer<_$UserDb, $SavedLocationsTable> {
  $$SavedLocationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get locationId => $composableBuilder(
      column: $table.locationId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get label => $composableBuilder(
      column: $table.label, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get lat => $composableBuilder(
      column: $table.lat, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get lon => $composableBuilder(
      column: $table.lon, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get placeId => $composableBuilder(
      column: $table.placeId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get timezoneId => $composableBuilder(
      column: $table.timezoneId, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));
}

class $$SavedLocationsTableOrderingComposer
    extends Composer<_$UserDb, $SavedLocationsTable> {
  $$SavedLocationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get locationId => $composableBuilder(
      column: $table.locationId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get label => $composableBuilder(
      column: $table.label, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get lat => $composableBuilder(
      column: $table.lat, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get lon => $composableBuilder(
      column: $table.lon, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get placeId => $composableBuilder(
      column: $table.placeId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get timezoneId => $composableBuilder(
      column: $table.timezoneId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));
}

class $$SavedLocationsTableAnnotationComposer
    extends Composer<_$UserDb, $SavedLocationsTable> {
  $$SavedLocationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<String> get locationId => $composableBuilder(
      column: $table.locationId, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<double> get lat =>
      $composableBuilder(column: $table.lat, builder: (column) => column);

  GeneratedColumn<double> get lon =>
      $composableBuilder(column: $table.lon, builder: (column) => column);

  GeneratedColumn<int> get placeId =>
      $composableBuilder(column: $table.placeId, builder: (column) => column);

  GeneratedColumn<String> get timezoneId => $composableBuilder(
      column: $table.timezoneId, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);
}

class $$SavedLocationsTableTableManager extends RootTableManager<
    _$UserDb,
    $SavedLocationsTable,
    SavedLocation,
    $$SavedLocationsTableFilterComposer,
    $$SavedLocationsTableOrderingComposer,
    $$SavedLocationsTableAnnotationComposer,
    $$SavedLocationsTableCreateCompanionBuilder,
    $$SavedLocationsTableUpdateCompanionBuilder,
    (
      SavedLocation,
      BaseReferences<_$UserDb, $SavedLocationsTable, SavedLocation>
    ),
    SavedLocation,
    PrefetchHooks Function()> {
  $$SavedLocationsTableTableManager(_$UserDb db, $SavedLocationsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SavedLocationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SavedLocationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SavedLocationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
            Value<String> locationId = const Value.absent(),
            Value<String> label = const Value.absent(),
            Value<double> lat = const Value.absent(),
            Value<double> lon = const Value.absent(),
            Value<int?> placeId = const Value.absent(),
            Value<String?> timezoneId = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SavedLocationsCompanion(
            createdAt: createdAt,
            updatedAt: updatedAt,
            deleted: deleted,
            locationId: locationId,
            label: label,
            lat: lat,
            lon: lon,
            placeId: placeId,
            timezoneId: timezoneId,
            isActive: isActive,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
            required String locationId,
            required String label,
            required double lat,
            required double lon,
            Value<int?> placeId = const Value.absent(),
            Value<String?> timezoneId = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SavedLocationsCompanion.insert(
            createdAt: createdAt,
            updatedAt: updatedAt,
            deleted: deleted,
            locationId: locationId,
            label: label,
            lat: lat,
            lon: lon,
            placeId: placeId,
            timezoneId: timezoneId,
            isActive: isActive,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SavedLocationsTableProcessedTableManager = ProcessedTableManager<
    _$UserDb,
    $SavedLocationsTable,
    SavedLocation,
    $$SavedLocationsTableFilterComposer,
    $$SavedLocationsTableOrderingComposer,
    $$SavedLocationsTableAnnotationComposer,
    $$SavedLocationsTableCreateCompanionBuilder,
    $$SavedLocationsTableUpdateCompanionBuilder,
    (
      SavedLocation,
      BaseReferences<_$UserDb, $SavedLocationsTable, SavedLocation>
    ),
    SavedLocation,
    PrefetchHooks Function()>;
typedef $$WeatherLogTableCreateCompanionBuilder = WeatherLogCompanion Function({
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<bool> deleted,
  required String logId,
  required String locationId,
  required DateTime obsDate,
  Value<double?> rainMm,
  Value<double?> tempC,
  Value<String?> notes,
  Value<int> rowid,
});
typedef $$WeatherLogTableUpdateCompanionBuilder = WeatherLogCompanion Function({
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<bool> deleted,
  Value<String> logId,
  Value<String> locationId,
  Value<DateTime> obsDate,
  Value<double?> rainMm,
  Value<double?> tempC,
  Value<String?> notes,
  Value<int> rowid,
});

class $$WeatherLogTableFilterComposer
    extends Composer<_$UserDb, $WeatherLogTable> {
  $$WeatherLogTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get logId => $composableBuilder(
      column: $table.logId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get locationId => $composableBuilder(
      column: $table.locationId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get obsDate => $composableBuilder(
      column: $table.obsDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get rainMm => $composableBuilder(
      column: $table.rainMm, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get tempC => $composableBuilder(
      column: $table.tempC, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));
}

class $$WeatherLogTableOrderingComposer
    extends Composer<_$UserDb, $WeatherLogTable> {
  $$WeatherLogTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get logId => $composableBuilder(
      column: $table.logId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get locationId => $composableBuilder(
      column: $table.locationId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get obsDate => $composableBuilder(
      column: $table.obsDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get rainMm => $composableBuilder(
      column: $table.rainMm, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get tempC => $composableBuilder(
      column: $table.tempC, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));
}

class $$WeatherLogTableAnnotationComposer
    extends Composer<_$UserDb, $WeatherLogTable> {
  $$WeatherLogTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<String> get logId =>
      $composableBuilder(column: $table.logId, builder: (column) => column);

  GeneratedColumn<String> get locationId => $composableBuilder(
      column: $table.locationId, builder: (column) => column);

  GeneratedColumn<DateTime> get obsDate =>
      $composableBuilder(column: $table.obsDate, builder: (column) => column);

  GeneratedColumn<double> get rainMm =>
      $composableBuilder(column: $table.rainMm, builder: (column) => column);

  GeneratedColumn<double> get tempC =>
      $composableBuilder(column: $table.tempC, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);
}

class $$WeatherLogTableTableManager extends RootTableManager<
    _$UserDb,
    $WeatherLogTable,
    WeatherLogData,
    $$WeatherLogTableFilterComposer,
    $$WeatherLogTableOrderingComposer,
    $$WeatherLogTableAnnotationComposer,
    $$WeatherLogTableCreateCompanionBuilder,
    $$WeatherLogTableUpdateCompanionBuilder,
    (
      WeatherLogData,
      BaseReferences<_$UserDb, $WeatherLogTable, WeatherLogData>
    ),
    WeatherLogData,
    PrefetchHooks Function()> {
  $$WeatherLogTableTableManager(_$UserDb db, $WeatherLogTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WeatherLogTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WeatherLogTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WeatherLogTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
            Value<String> logId = const Value.absent(),
            Value<String> locationId = const Value.absent(),
            Value<DateTime> obsDate = const Value.absent(),
            Value<double?> rainMm = const Value.absent(),
            Value<double?> tempC = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              WeatherLogCompanion(
            createdAt: createdAt,
            updatedAt: updatedAt,
            deleted: deleted,
            logId: logId,
            locationId: locationId,
            obsDate: obsDate,
            rainMm: rainMm,
            tempC: tempC,
            notes: notes,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
            required String logId,
            required String locationId,
            required DateTime obsDate,
            Value<double?> rainMm = const Value.absent(),
            Value<double?> tempC = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              WeatherLogCompanion.insert(
            createdAt: createdAt,
            updatedAt: updatedAt,
            deleted: deleted,
            logId: logId,
            locationId: locationId,
            obsDate: obsDate,
            rainMm: rainMm,
            tempC: tempC,
            notes: notes,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$WeatherLogTableProcessedTableManager = ProcessedTableManager<
    _$UserDb,
    $WeatherLogTable,
    WeatherLogData,
    $$WeatherLogTableFilterComposer,
    $$WeatherLogTableOrderingComposer,
    $$WeatherLogTableAnnotationComposer,
    $$WeatherLogTableCreateCompanionBuilder,
    $$WeatherLogTableUpdateCompanionBuilder,
    (
      WeatherLogData,
      BaseReferences<_$UserDb, $WeatherLogTable, WeatherLogData>
    ),
    WeatherLogData,
    PrefetchHooks Function()>;
typedef $$FarmLogTableCreateCompanionBuilder = FarmLogCompanion Function({
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<bool> deleted,
  required String logId,
  required String locationId,
  required DateTime logDate,
  Value<int?> cropId,
  Value<int?> activityId,
  Value<String?> notes,
  Value<int> rowid,
});
typedef $$FarmLogTableUpdateCompanionBuilder = FarmLogCompanion Function({
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<bool> deleted,
  Value<String> logId,
  Value<String> locationId,
  Value<DateTime> logDate,
  Value<int?> cropId,
  Value<int?> activityId,
  Value<String?> notes,
  Value<int> rowid,
});

class $$FarmLogTableFilterComposer extends Composer<_$UserDb, $FarmLogTable> {
  $$FarmLogTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get logId => $composableBuilder(
      column: $table.logId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get locationId => $composableBuilder(
      column: $table.locationId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get logDate => $composableBuilder(
      column: $table.logDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get cropId => $composableBuilder(
      column: $table.cropId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get activityId => $composableBuilder(
      column: $table.activityId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));
}

class $$FarmLogTableOrderingComposer extends Composer<_$UserDb, $FarmLogTable> {
  $$FarmLogTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get logId => $composableBuilder(
      column: $table.logId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get locationId => $composableBuilder(
      column: $table.locationId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get logDate => $composableBuilder(
      column: $table.logDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get cropId => $composableBuilder(
      column: $table.cropId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get activityId => $composableBuilder(
      column: $table.activityId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));
}

class $$FarmLogTableAnnotationComposer
    extends Composer<_$UserDb, $FarmLogTable> {
  $$FarmLogTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<String> get logId =>
      $composableBuilder(column: $table.logId, builder: (column) => column);

  GeneratedColumn<String> get locationId => $composableBuilder(
      column: $table.locationId, builder: (column) => column);

  GeneratedColumn<DateTime> get logDate =>
      $composableBuilder(column: $table.logDate, builder: (column) => column);

  GeneratedColumn<int> get cropId =>
      $composableBuilder(column: $table.cropId, builder: (column) => column);

  GeneratedColumn<int> get activityId => $composableBuilder(
      column: $table.activityId, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);
}

class $$FarmLogTableTableManager extends RootTableManager<
    _$UserDb,
    $FarmLogTable,
    FarmLogData,
    $$FarmLogTableFilterComposer,
    $$FarmLogTableOrderingComposer,
    $$FarmLogTableAnnotationComposer,
    $$FarmLogTableCreateCompanionBuilder,
    $$FarmLogTableUpdateCompanionBuilder,
    (FarmLogData, BaseReferences<_$UserDb, $FarmLogTable, FarmLogData>),
    FarmLogData,
    PrefetchHooks Function()> {
  $$FarmLogTableTableManager(_$UserDb db, $FarmLogTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FarmLogTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FarmLogTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FarmLogTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
            Value<String> logId = const Value.absent(),
            Value<String> locationId = const Value.absent(),
            Value<DateTime> logDate = const Value.absent(),
            Value<int?> cropId = const Value.absent(),
            Value<int?> activityId = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              FarmLogCompanion(
            createdAt: createdAt,
            updatedAt: updatedAt,
            deleted: deleted,
            logId: logId,
            locationId: locationId,
            logDate: logDate,
            cropId: cropId,
            activityId: activityId,
            notes: notes,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
            required String logId,
            required String locationId,
            required DateTime logDate,
            Value<int?> cropId = const Value.absent(),
            Value<int?> activityId = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              FarmLogCompanion.insert(
            createdAt: createdAt,
            updatedAt: updatedAt,
            deleted: deleted,
            logId: logId,
            locationId: locationId,
            logDate: logDate,
            cropId: cropId,
            activityId: activityId,
            notes: notes,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$FarmLogTableProcessedTableManager = ProcessedTableManager<
    _$UserDb,
    $FarmLogTable,
    FarmLogData,
    $$FarmLogTableFilterComposer,
    $$FarmLogTableOrderingComposer,
    $$FarmLogTableAnnotationComposer,
    $$FarmLogTableCreateCompanionBuilder,
    $$FarmLogTableUpdateCompanionBuilder,
    (FarmLogData, BaseReferences<_$UserDb, $FarmLogTable, FarmLogData>),
    FarmLogData,
    PrefetchHooks Function()>;
typedef $$DeviceProfilesTableCreateCompanionBuilder = DeviceProfilesCompanion
    Function({
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<bool> deleted,
  required String deviceId,
  Value<String?> model,
  Value<double?> fieldOfViewDeg,
  Value<String?> distortionJson,
  Value<double?> compassErrorDeg,
  Value<bool?> arSupported,
  Value<int> rowid,
});
typedef $$DeviceProfilesTableUpdateCompanionBuilder = DeviceProfilesCompanion
    Function({
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<bool> deleted,
  Value<String> deviceId,
  Value<String?> model,
  Value<double?> fieldOfViewDeg,
  Value<String?> distortionJson,
  Value<double?> compassErrorDeg,
  Value<bool?> arSupported,
  Value<int> rowid,
});

class $$DeviceProfilesTableFilterComposer
    extends Composer<_$UserDb, $DeviceProfilesTable> {
  $$DeviceProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get model => $composableBuilder(
      column: $table.model, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get fieldOfViewDeg => $composableBuilder(
      column: $table.fieldOfViewDeg,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get distortionJson => $composableBuilder(
      column: $table.distortionJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get compassErrorDeg => $composableBuilder(
      column: $table.compassErrorDeg,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get arSupported => $composableBuilder(
      column: $table.arSupported, builder: (column) => ColumnFilters(column));
}

class $$DeviceProfilesTableOrderingComposer
    extends Composer<_$UserDb, $DeviceProfilesTable> {
  $$DeviceProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get model => $composableBuilder(
      column: $table.model, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get fieldOfViewDeg => $composableBuilder(
      column: $table.fieldOfViewDeg,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get distortionJson => $composableBuilder(
      column: $table.distortionJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get compassErrorDeg => $composableBuilder(
      column: $table.compassErrorDeg,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get arSupported => $composableBuilder(
      column: $table.arSupported, builder: (column) => ColumnOrderings(column));
}

class $$DeviceProfilesTableAnnotationComposer
    extends Composer<_$UserDb, $DeviceProfilesTable> {
  $$DeviceProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get model =>
      $composableBuilder(column: $table.model, builder: (column) => column);

  GeneratedColumn<double> get fieldOfViewDeg => $composableBuilder(
      column: $table.fieldOfViewDeg, builder: (column) => column);

  GeneratedColumn<String> get distortionJson => $composableBuilder(
      column: $table.distortionJson, builder: (column) => column);

  GeneratedColumn<double> get compassErrorDeg => $composableBuilder(
      column: $table.compassErrorDeg, builder: (column) => column);

  GeneratedColumn<bool> get arSupported => $composableBuilder(
      column: $table.arSupported, builder: (column) => column);
}

class $$DeviceProfilesTableTableManager extends RootTableManager<
    _$UserDb,
    $DeviceProfilesTable,
    DeviceProfile,
    $$DeviceProfilesTableFilterComposer,
    $$DeviceProfilesTableOrderingComposer,
    $$DeviceProfilesTableAnnotationComposer,
    $$DeviceProfilesTableCreateCompanionBuilder,
    $$DeviceProfilesTableUpdateCompanionBuilder,
    (
      DeviceProfile,
      BaseReferences<_$UserDb, $DeviceProfilesTable, DeviceProfile>
    ),
    DeviceProfile,
    PrefetchHooks Function()> {
  $$DeviceProfilesTableTableManager(_$UserDb db, $DeviceProfilesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DeviceProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DeviceProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DeviceProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
            Value<String> deviceId = const Value.absent(),
            Value<String?> model = const Value.absent(),
            Value<double?> fieldOfViewDeg = const Value.absent(),
            Value<String?> distortionJson = const Value.absent(),
            Value<double?> compassErrorDeg = const Value.absent(),
            Value<bool?> arSupported = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DeviceProfilesCompanion(
            createdAt: createdAt,
            updatedAt: updatedAt,
            deleted: deleted,
            deviceId: deviceId,
            model: model,
            fieldOfViewDeg: fieldOfViewDeg,
            distortionJson: distortionJson,
            compassErrorDeg: compassErrorDeg,
            arSupported: arSupported,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
            required String deviceId,
            Value<String?> model = const Value.absent(),
            Value<double?> fieldOfViewDeg = const Value.absent(),
            Value<String?> distortionJson = const Value.absent(),
            Value<double?> compassErrorDeg = const Value.absent(),
            Value<bool?> arSupported = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DeviceProfilesCompanion.insert(
            createdAt: createdAt,
            updatedAt: updatedAt,
            deleted: deleted,
            deviceId: deviceId,
            model: model,
            fieldOfViewDeg: fieldOfViewDeg,
            distortionJson: distortionJson,
            compassErrorDeg: compassErrorDeg,
            arSupported: arSupported,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DeviceProfilesTableProcessedTableManager = ProcessedTableManager<
    _$UserDb,
    $DeviceProfilesTable,
    DeviceProfile,
    $$DeviceProfilesTableFilterComposer,
    $$DeviceProfilesTableOrderingComposer,
    $$DeviceProfilesTableAnnotationComposer,
    $$DeviceProfilesTableCreateCompanionBuilder,
    $$DeviceProfilesTableUpdateCompanionBuilder,
    (
      DeviceProfile,
      BaseReferences<_$UserDb, $DeviceProfilesTable, DeviceProfile>
    ),
    DeviceProfile,
    PrefetchHooks Function()>;
typedef $$PhotoObservationsTableCreateCompanionBuilder
    = PhotoObservationsCompanion Function({
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<bool> deleted,
  required String obsId,
  required String locationId,
  required String deviceId,
  required String filePath,
  required DateTime takenAt,
  Value<int?> exposureMs,
  Value<int?> iso,
  Value<int> rowid,
});
typedef $$PhotoObservationsTableUpdateCompanionBuilder
    = PhotoObservationsCompanion Function({
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<bool> deleted,
  Value<String> obsId,
  Value<String> locationId,
  Value<String> deviceId,
  Value<String> filePath,
  Value<DateTime> takenAt,
  Value<int?> exposureMs,
  Value<int?> iso,
  Value<int> rowid,
});

class $$PhotoObservationsTableFilterComposer
    extends Composer<_$UserDb, $PhotoObservationsTable> {
  $$PhotoObservationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get obsId => $composableBuilder(
      column: $table.obsId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get locationId => $composableBuilder(
      column: $table.locationId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get filePath => $composableBuilder(
      column: $table.filePath, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get takenAt => $composableBuilder(
      column: $table.takenAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get exposureMs => $composableBuilder(
      column: $table.exposureMs, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get iso => $composableBuilder(
      column: $table.iso, builder: (column) => ColumnFilters(column));
}

class $$PhotoObservationsTableOrderingComposer
    extends Composer<_$UserDb, $PhotoObservationsTable> {
  $$PhotoObservationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get obsId => $composableBuilder(
      column: $table.obsId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get locationId => $composableBuilder(
      column: $table.locationId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get filePath => $composableBuilder(
      column: $table.filePath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get takenAt => $composableBuilder(
      column: $table.takenAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get exposureMs => $composableBuilder(
      column: $table.exposureMs, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get iso => $composableBuilder(
      column: $table.iso, builder: (column) => ColumnOrderings(column));
}

class $$PhotoObservationsTableAnnotationComposer
    extends Composer<_$UserDb, $PhotoObservationsTable> {
  $$PhotoObservationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<String> get obsId =>
      $composableBuilder(column: $table.obsId, builder: (column) => column);

  GeneratedColumn<String> get locationId => $composableBuilder(
      column: $table.locationId, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<DateTime> get takenAt =>
      $composableBuilder(column: $table.takenAt, builder: (column) => column);

  GeneratedColumn<int> get exposureMs => $composableBuilder(
      column: $table.exposureMs, builder: (column) => column);

  GeneratedColumn<int> get iso =>
      $composableBuilder(column: $table.iso, builder: (column) => column);
}

class $$PhotoObservationsTableTableManager extends RootTableManager<
    _$UserDb,
    $PhotoObservationsTable,
    PhotoObservation,
    $$PhotoObservationsTableFilterComposer,
    $$PhotoObservationsTableOrderingComposer,
    $$PhotoObservationsTableAnnotationComposer,
    $$PhotoObservationsTableCreateCompanionBuilder,
    $$PhotoObservationsTableUpdateCompanionBuilder,
    (
      PhotoObservation,
      BaseReferences<_$UserDb, $PhotoObservationsTable, PhotoObservation>
    ),
    PhotoObservation,
    PrefetchHooks Function()> {
  $$PhotoObservationsTableTableManager(
      _$UserDb db, $PhotoObservationsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PhotoObservationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PhotoObservationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PhotoObservationsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
            Value<String> obsId = const Value.absent(),
            Value<String> locationId = const Value.absent(),
            Value<String> deviceId = const Value.absent(),
            Value<String> filePath = const Value.absent(),
            Value<DateTime> takenAt = const Value.absent(),
            Value<int?> exposureMs = const Value.absent(),
            Value<int?> iso = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PhotoObservationsCompanion(
            createdAt: createdAt,
            updatedAt: updatedAt,
            deleted: deleted,
            obsId: obsId,
            locationId: locationId,
            deviceId: deviceId,
            filePath: filePath,
            takenAt: takenAt,
            exposureMs: exposureMs,
            iso: iso,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
            required String obsId,
            required String locationId,
            required String deviceId,
            required String filePath,
            required DateTime takenAt,
            Value<int?> exposureMs = const Value.absent(),
            Value<int?> iso = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PhotoObservationsCompanion.insert(
            createdAt: createdAt,
            updatedAt: updatedAt,
            deleted: deleted,
            obsId: obsId,
            locationId: locationId,
            deviceId: deviceId,
            filePath: filePath,
            takenAt: takenAt,
            exposureMs: exposureMs,
            iso: iso,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PhotoObservationsTableProcessedTableManager = ProcessedTableManager<
    _$UserDb,
    $PhotoObservationsTable,
    PhotoObservation,
    $$PhotoObservationsTableFilterComposer,
    $$PhotoObservationsTableOrderingComposer,
    $$PhotoObservationsTableAnnotationComposer,
    $$PhotoObservationsTableCreateCompanionBuilder,
    $$PhotoObservationsTableUpdateCompanionBuilder,
    (
      PhotoObservation,
      BaseReferences<_$UserDb, $PhotoObservationsTable, PhotoObservation>
    ),
    PhotoObservation,
    PrefetchHooks Function()>;
typedef $$PhotoResultsTableCreateCompanionBuilder = PhotoResultsCompanion
    Function({
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<bool> deleted,
  required String obsId,
  Value<int?> starsDetected,
  Value<int?> starsMatched,
  Value<double?> confidence,
  Value<double?> rotationDeg,
  Value<double?> shiftXPx,
  Value<double?> shiftYPx,
  Value<String?> result,
  Value<double?> recoveredHeadingDeg,
  Value<double?> recoveredPitchDeg,
  Value<String?> matchedConstCode,
  Value<int> rowid,
});
typedef $$PhotoResultsTableUpdateCompanionBuilder = PhotoResultsCompanion
    Function({
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<bool> deleted,
  Value<String> obsId,
  Value<int?> starsDetected,
  Value<int?> starsMatched,
  Value<double?> confidence,
  Value<double?> rotationDeg,
  Value<double?> shiftXPx,
  Value<double?> shiftYPx,
  Value<String?> result,
  Value<double?> recoveredHeadingDeg,
  Value<double?> recoveredPitchDeg,
  Value<String?> matchedConstCode,
  Value<int> rowid,
});

class $$PhotoResultsTableFilterComposer
    extends Composer<_$UserDb, $PhotoResultsTable> {
  $$PhotoResultsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get obsId => $composableBuilder(
      column: $table.obsId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get starsDetected => $composableBuilder(
      column: $table.starsDetected, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get starsMatched => $composableBuilder(
      column: $table.starsMatched, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get confidence => $composableBuilder(
      column: $table.confidence, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get rotationDeg => $composableBuilder(
      column: $table.rotationDeg, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get shiftXPx => $composableBuilder(
      column: $table.shiftXPx, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get shiftYPx => $composableBuilder(
      column: $table.shiftYPx, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get result => $composableBuilder(
      column: $table.result, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get recoveredHeadingDeg => $composableBuilder(
      column: $table.recoveredHeadingDeg,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get recoveredPitchDeg => $composableBuilder(
      column: $table.recoveredPitchDeg,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get matchedConstCode => $composableBuilder(
      column: $table.matchedConstCode,
      builder: (column) => ColumnFilters(column));
}

class $$PhotoResultsTableOrderingComposer
    extends Composer<_$UserDb, $PhotoResultsTable> {
  $$PhotoResultsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get obsId => $composableBuilder(
      column: $table.obsId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get starsDetected => $composableBuilder(
      column: $table.starsDetected,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get starsMatched => $composableBuilder(
      column: $table.starsMatched,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get confidence => $composableBuilder(
      column: $table.confidence, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get rotationDeg => $composableBuilder(
      column: $table.rotationDeg, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get shiftXPx => $composableBuilder(
      column: $table.shiftXPx, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get shiftYPx => $composableBuilder(
      column: $table.shiftYPx, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get result => $composableBuilder(
      column: $table.result, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get recoveredHeadingDeg => $composableBuilder(
      column: $table.recoveredHeadingDeg,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get recoveredPitchDeg => $composableBuilder(
      column: $table.recoveredPitchDeg,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get matchedConstCode => $composableBuilder(
      column: $table.matchedConstCode,
      builder: (column) => ColumnOrderings(column));
}

class $$PhotoResultsTableAnnotationComposer
    extends Composer<_$UserDb, $PhotoResultsTable> {
  $$PhotoResultsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<String> get obsId =>
      $composableBuilder(column: $table.obsId, builder: (column) => column);

  GeneratedColumn<int> get starsDetected => $composableBuilder(
      column: $table.starsDetected, builder: (column) => column);

  GeneratedColumn<int> get starsMatched => $composableBuilder(
      column: $table.starsMatched, builder: (column) => column);

  GeneratedColumn<double> get confidence => $composableBuilder(
      column: $table.confidence, builder: (column) => column);

  GeneratedColumn<double> get rotationDeg => $composableBuilder(
      column: $table.rotationDeg, builder: (column) => column);

  GeneratedColumn<double> get shiftXPx =>
      $composableBuilder(column: $table.shiftXPx, builder: (column) => column);

  GeneratedColumn<double> get shiftYPx =>
      $composableBuilder(column: $table.shiftYPx, builder: (column) => column);

  GeneratedColumn<String> get result =>
      $composableBuilder(column: $table.result, builder: (column) => column);

  GeneratedColumn<double> get recoveredHeadingDeg => $composableBuilder(
      column: $table.recoveredHeadingDeg, builder: (column) => column);

  GeneratedColumn<double> get recoveredPitchDeg => $composableBuilder(
      column: $table.recoveredPitchDeg, builder: (column) => column);

  GeneratedColumn<String> get matchedConstCode => $composableBuilder(
      column: $table.matchedConstCode, builder: (column) => column);
}

class $$PhotoResultsTableTableManager extends RootTableManager<
    _$UserDb,
    $PhotoResultsTable,
    PhotoResult,
    $$PhotoResultsTableFilterComposer,
    $$PhotoResultsTableOrderingComposer,
    $$PhotoResultsTableAnnotationComposer,
    $$PhotoResultsTableCreateCompanionBuilder,
    $$PhotoResultsTableUpdateCompanionBuilder,
    (PhotoResult, BaseReferences<_$UserDb, $PhotoResultsTable, PhotoResult>),
    PhotoResult,
    PrefetchHooks Function()> {
  $$PhotoResultsTableTableManager(_$UserDb db, $PhotoResultsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PhotoResultsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PhotoResultsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PhotoResultsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
            Value<String> obsId = const Value.absent(),
            Value<int?> starsDetected = const Value.absent(),
            Value<int?> starsMatched = const Value.absent(),
            Value<double?> confidence = const Value.absent(),
            Value<double?> rotationDeg = const Value.absent(),
            Value<double?> shiftXPx = const Value.absent(),
            Value<double?> shiftYPx = const Value.absent(),
            Value<String?> result = const Value.absent(),
            Value<double?> recoveredHeadingDeg = const Value.absent(),
            Value<double?> recoveredPitchDeg = const Value.absent(),
            Value<String?> matchedConstCode = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PhotoResultsCompanion(
            createdAt: createdAt,
            updatedAt: updatedAt,
            deleted: deleted,
            obsId: obsId,
            starsDetected: starsDetected,
            starsMatched: starsMatched,
            confidence: confidence,
            rotationDeg: rotationDeg,
            shiftXPx: shiftXPx,
            shiftYPx: shiftYPx,
            result: result,
            recoveredHeadingDeg: recoveredHeadingDeg,
            recoveredPitchDeg: recoveredPitchDeg,
            matchedConstCode: matchedConstCode,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
            required String obsId,
            Value<int?> starsDetected = const Value.absent(),
            Value<int?> starsMatched = const Value.absent(),
            Value<double?> confidence = const Value.absent(),
            Value<double?> rotationDeg = const Value.absent(),
            Value<double?> shiftXPx = const Value.absent(),
            Value<double?> shiftYPx = const Value.absent(),
            Value<String?> result = const Value.absent(),
            Value<double?> recoveredHeadingDeg = const Value.absent(),
            Value<double?> recoveredPitchDeg = const Value.absent(),
            Value<String?> matchedConstCode = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PhotoResultsCompanion.insert(
            createdAt: createdAt,
            updatedAt: updatedAt,
            deleted: deleted,
            obsId: obsId,
            starsDetected: starsDetected,
            starsMatched: starsMatched,
            confidence: confidence,
            rotationDeg: rotationDeg,
            shiftXPx: shiftXPx,
            shiftYPx: shiftYPx,
            result: result,
            recoveredHeadingDeg: recoveredHeadingDeg,
            recoveredPitchDeg: recoveredPitchDeg,
            matchedConstCode: matchedConstCode,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PhotoResultsTableProcessedTableManager = ProcessedTableManager<
    _$UserDb,
    $PhotoResultsTable,
    PhotoResult,
    $$PhotoResultsTableFilterComposer,
    $$PhotoResultsTableOrderingComposer,
    $$PhotoResultsTableAnnotationComposer,
    $$PhotoResultsTableCreateCompanionBuilder,
    $$PhotoResultsTableUpdateCompanionBuilder,
    (PhotoResult, BaseReferences<_$UserDb, $PhotoResultsTable, PhotoResult>),
    PhotoResult,
    PrefetchHooks Function()>;
typedef $$FeedbackTableCreateCompanionBuilder = FeedbackCompanion Function({
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<bool> deleted,
  required String feedbackId,
  Value<int?> ruleId,
  Value<String?> note,
  Value<int> rowid,
});
typedef $$FeedbackTableUpdateCompanionBuilder = FeedbackCompanion Function({
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<bool> deleted,
  Value<String> feedbackId,
  Value<int?> ruleId,
  Value<String?> note,
  Value<int> rowid,
});

class $$FeedbackTableFilterComposer extends Composer<_$UserDb, $FeedbackTable> {
  $$FeedbackTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get feedbackId => $composableBuilder(
      column: $table.feedbackId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get ruleId => $composableBuilder(
      column: $table.ruleId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));
}

class $$FeedbackTableOrderingComposer
    extends Composer<_$UserDb, $FeedbackTable> {
  $$FeedbackTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get feedbackId => $composableBuilder(
      column: $table.feedbackId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get ruleId => $composableBuilder(
      column: $table.ruleId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));
}

class $$FeedbackTableAnnotationComposer
    extends Composer<_$UserDb, $FeedbackTable> {
  $$FeedbackTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<String> get feedbackId => $composableBuilder(
      column: $table.feedbackId, builder: (column) => column);

  GeneratedColumn<int> get ruleId =>
      $composableBuilder(column: $table.ruleId, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);
}

class $$FeedbackTableTableManager extends RootTableManager<
    _$UserDb,
    $FeedbackTable,
    FeedbackData,
    $$FeedbackTableFilterComposer,
    $$FeedbackTableOrderingComposer,
    $$FeedbackTableAnnotationComposer,
    $$FeedbackTableCreateCompanionBuilder,
    $$FeedbackTableUpdateCompanionBuilder,
    (FeedbackData, BaseReferences<_$UserDb, $FeedbackTable, FeedbackData>),
    FeedbackData,
    PrefetchHooks Function()> {
  $$FeedbackTableTableManager(_$UserDb db, $FeedbackTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FeedbackTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FeedbackTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FeedbackTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
            Value<String> feedbackId = const Value.absent(),
            Value<int?> ruleId = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              FeedbackCompanion(
            createdAt: createdAt,
            updatedAt: updatedAt,
            deleted: deleted,
            feedbackId: feedbackId,
            ruleId: ruleId,
            note: note,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
            required String feedbackId,
            Value<int?> ruleId = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              FeedbackCompanion.insert(
            createdAt: createdAt,
            updatedAt: updatedAt,
            deleted: deleted,
            feedbackId: feedbackId,
            ruleId: ruleId,
            note: note,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$FeedbackTableProcessedTableManager = ProcessedTableManager<
    _$UserDb,
    $FeedbackTable,
    FeedbackData,
    $$FeedbackTableFilterComposer,
    $$FeedbackTableOrderingComposer,
    $$FeedbackTableAnnotationComposer,
    $$FeedbackTableCreateCompanionBuilder,
    $$FeedbackTableUpdateCompanionBuilder,
    (FeedbackData, BaseReferences<_$UserDb, $FeedbackTable, FeedbackData>),
    FeedbackData,
    PrefetchHooks Function()>;
typedef $$UserSettingsTableCreateCompanionBuilder = UserSettingsCompanion
    Function({
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<bool> deleted,
  required String key,
  required String value,
  Value<int> rowid,
});
typedef $$UserSettingsTableUpdateCompanionBuilder = UserSettingsCompanion
    Function({
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<bool> deleted,
  Value<String> key,
  Value<String> value,
  Value<int> rowid,
});

class $$UserSettingsTableFilterComposer
    extends Composer<_$UserDb, $UserSettingsTable> {
  $$UserSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnFilters(column));
}

class $$UserSettingsTableOrderingComposer
    extends Composer<_$UserDb, $UserSettingsTable> {
  $$UserSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnOrderings(column));
}

class $$UserSettingsTableAnnotationComposer
    extends Composer<_$UserDb, $UserSettingsTable> {
  $$UserSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$UserSettingsTableTableManager extends RootTableManager<
    _$UserDb,
    $UserSettingsTable,
    UserSetting,
    $$UserSettingsTableFilterComposer,
    $$UserSettingsTableOrderingComposer,
    $$UserSettingsTableAnnotationComposer,
    $$UserSettingsTableCreateCompanionBuilder,
    $$UserSettingsTableUpdateCompanionBuilder,
    (UserSetting, BaseReferences<_$UserDb, $UserSettingsTable, UserSetting>),
    UserSetting,
    PrefetchHooks Function()> {
  $$UserSettingsTableTableManager(_$UserDb db, $UserSettingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UserSettingsCompanion(
            createdAt: createdAt,
            updatedAt: updatedAt,
            deleted: deleted,
            key: key,
            value: value,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
            required String key,
            required String value,
            Value<int> rowid = const Value.absent(),
          }) =>
              UserSettingsCompanion.insert(
            createdAt: createdAt,
            updatedAt: updatedAt,
            deleted: deleted,
            key: key,
            value: value,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UserSettingsTableProcessedTableManager = ProcessedTableManager<
    _$UserDb,
    $UserSettingsTable,
    UserSetting,
    $$UserSettingsTableFilterComposer,
    $$UserSettingsTableOrderingComposer,
    $$UserSettingsTableAnnotationComposer,
    $$UserSettingsTableCreateCompanionBuilder,
    $$UserSettingsTableUpdateCompanionBuilder,
    (UserSetting, BaseReferences<_$UserDb, $UserSettingsTable, UserSetting>),
    UserSetting,
    PrefetchHooks Function()>;

class $UserDbManager {
  final _$UserDb _db;
  $UserDbManager(this._db);
  $$SavedLocationsTableTableManager get savedLocations =>
      $$SavedLocationsTableTableManager(_db, _db.savedLocations);
  $$WeatherLogTableTableManager get weatherLog =>
      $$WeatherLogTableTableManager(_db, _db.weatherLog);
  $$FarmLogTableTableManager get farmLog =>
      $$FarmLogTableTableManager(_db, _db.farmLog);
  $$DeviceProfilesTableTableManager get deviceProfiles =>
      $$DeviceProfilesTableTableManager(_db, _db.deviceProfiles);
  $$PhotoObservationsTableTableManager get photoObservations =>
      $$PhotoObservationsTableTableManager(_db, _db.photoObservations);
  $$PhotoResultsTableTableManager get photoResults =>
      $$PhotoResultsTableTableManager(_db, _db.photoResults);
  $$FeedbackTableTableManager get feedback =>
      $$FeedbackTableTableManager(_db, _db.feedback);
  $$UserSettingsTableTableManager get userSettings =>
      $$UserSettingsTableTableManager(_db, _db.userSettings);
}
