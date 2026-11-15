// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cache_db.dart';

// ignore_for_file: type=lint
class $WeatherForecastCacheTable extends WeatherForecastCache
    with TableInfo<$WeatherForecastCacheTable, WeatherForecastCacheData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeatherForecastCacheTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _locationIdMeta =
      const VerificationMeta('locationId');
  @override
  late final GeneratedColumn<String> locationId = GeneratedColumn<String>(
      'location_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fetchedAtMeta =
      const VerificationMeta('fetchedAt');
  @override
  late final GeneratedColumn<DateTime> fetchedAt = GeneratedColumn<DateTime>(
      'fetched_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _validUntilMeta =
      const VerificationMeta('validUntil');
  @override
  late final GeneratedColumn<DateTime> validUntil = GeneratedColumn<DateTime>(
      'valid_until', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _payloadJsonMeta =
      const VerificationMeta('payloadJson');
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
      'payload_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [locationId, fetchedAt, validUntil, payloadJson];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'weather_forecast_cache';
  @override
  VerificationContext validateIntegrity(
      Insertable<WeatherForecastCacheData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('location_id')) {
      context.handle(
          _locationIdMeta,
          locationId.isAcceptableOrUnknown(
              data['location_id']!, _locationIdMeta));
    } else if (isInserting) {
      context.missing(_locationIdMeta);
    }
    if (data.containsKey('fetched_at')) {
      context.handle(_fetchedAtMeta,
          fetchedAt.isAcceptableOrUnknown(data['fetched_at']!, _fetchedAtMeta));
    } else if (isInserting) {
      context.missing(_fetchedAtMeta);
    }
    if (data.containsKey('valid_until')) {
      context.handle(
          _validUntilMeta,
          validUntil.isAcceptableOrUnknown(
              data['valid_until']!, _validUntilMeta));
    } else if (isInserting) {
      context.missing(_validUntilMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
          _payloadJsonMeta,
          payloadJson.isAcceptableOrUnknown(
              data['payload_json']!, _payloadJsonMeta));
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {locationId};
  @override
  WeatherForecastCacheData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeatherForecastCacheData(
      locationId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}location_id'])!,
      fetchedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}fetched_at'])!,
      validUntil: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}valid_until'])!,
      payloadJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payload_json'])!,
    );
  }

  @override
  $WeatherForecastCacheTable createAlias(String alias) {
    return $WeatherForecastCacheTable(attachedDatabase, alias);
  }
}

class WeatherForecastCacheData extends DataClass
    implements Insertable<WeatherForecastCacheData> {
  final String locationId;
  final DateTime fetchedAt;
  final DateTime validUntil;
  final String payloadJson;
  const WeatherForecastCacheData(
      {required this.locationId,
      required this.fetchedAt,
      required this.validUntil,
      required this.payloadJson});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['location_id'] = Variable<String>(locationId);
    map['fetched_at'] = Variable<DateTime>(fetchedAt);
    map['valid_until'] = Variable<DateTime>(validUntil);
    map['payload_json'] = Variable<String>(payloadJson);
    return map;
  }

  WeatherForecastCacheCompanion toCompanion(bool nullToAbsent) {
    return WeatherForecastCacheCompanion(
      locationId: Value(locationId),
      fetchedAt: Value(fetchedAt),
      validUntil: Value(validUntil),
      payloadJson: Value(payloadJson),
    );
  }

  factory WeatherForecastCacheData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeatherForecastCacheData(
      locationId: serializer.fromJson<String>(json['locationId']),
      fetchedAt: serializer.fromJson<DateTime>(json['fetchedAt']),
      validUntil: serializer.fromJson<DateTime>(json['validUntil']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'locationId': serializer.toJson<String>(locationId),
      'fetchedAt': serializer.toJson<DateTime>(fetchedAt),
      'validUntil': serializer.toJson<DateTime>(validUntil),
      'payloadJson': serializer.toJson<String>(payloadJson),
    };
  }

  WeatherForecastCacheData copyWith(
          {String? locationId,
          DateTime? fetchedAt,
          DateTime? validUntil,
          String? payloadJson}) =>
      WeatherForecastCacheData(
        locationId: locationId ?? this.locationId,
        fetchedAt: fetchedAt ?? this.fetchedAt,
        validUntil: validUntil ?? this.validUntil,
        payloadJson: payloadJson ?? this.payloadJson,
      );
  WeatherForecastCacheData copyWithCompanion(
      WeatherForecastCacheCompanion data) {
    return WeatherForecastCacheData(
      locationId:
          data.locationId.present ? data.locationId.value : this.locationId,
      fetchedAt: data.fetchedAt.present ? data.fetchedAt.value : this.fetchedAt,
      validUntil:
          data.validUntil.present ? data.validUntil.value : this.validUntil,
      payloadJson:
          data.payloadJson.present ? data.payloadJson.value : this.payloadJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WeatherForecastCacheData(')
          ..write('locationId: $locationId, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('validUntil: $validUntil, ')
          ..write('payloadJson: $payloadJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(locationId, fetchedAt, validUntil, payloadJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeatherForecastCacheData &&
          other.locationId == this.locationId &&
          other.fetchedAt == this.fetchedAt &&
          other.validUntil == this.validUntil &&
          other.payloadJson == this.payloadJson);
}

class WeatherForecastCacheCompanion
    extends UpdateCompanion<WeatherForecastCacheData> {
  final Value<String> locationId;
  final Value<DateTime> fetchedAt;
  final Value<DateTime> validUntil;
  final Value<String> payloadJson;
  final Value<int> rowid;
  const WeatherForecastCacheCompanion({
    this.locationId = const Value.absent(),
    this.fetchedAt = const Value.absent(),
    this.validUntil = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WeatherForecastCacheCompanion.insert({
    required String locationId,
    required DateTime fetchedAt,
    required DateTime validUntil,
    required String payloadJson,
    this.rowid = const Value.absent(),
  })  : locationId = Value(locationId),
        fetchedAt = Value(fetchedAt),
        validUntil = Value(validUntil),
        payloadJson = Value(payloadJson);
  static Insertable<WeatherForecastCacheData> custom({
    Expression<String>? locationId,
    Expression<DateTime>? fetchedAt,
    Expression<DateTime>? validUntil,
    Expression<String>? payloadJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (locationId != null) 'location_id': locationId,
      if (fetchedAt != null) 'fetched_at': fetchedAt,
      if (validUntil != null) 'valid_until': validUntil,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WeatherForecastCacheCompanion copyWith(
      {Value<String>? locationId,
      Value<DateTime>? fetchedAt,
      Value<DateTime>? validUntil,
      Value<String>? payloadJson,
      Value<int>? rowid}) {
    return WeatherForecastCacheCompanion(
      locationId: locationId ?? this.locationId,
      fetchedAt: fetchedAt ?? this.fetchedAt,
      validUntil: validUntil ?? this.validUntil,
      payloadJson: payloadJson ?? this.payloadJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (locationId.present) {
      map['location_id'] = Variable<String>(locationId.value);
    }
    if (fetchedAt.present) {
      map['fetched_at'] = Variable<DateTime>(fetchedAt.value);
    }
    if (validUntil.present) {
      map['valid_until'] = Variable<DateTime>(validUntil.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeatherForecastCacheCompanion(')
          ..write('locationId: $locationId, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('validUntil: $validUntil, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $VisibilityCacheTable extends VisibilityCache
    with TableInfo<$VisibilityCacheTable, VisibilityCacheData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VisibilityCacheTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _locationIdMeta =
      const VerificationMeta('locationId');
  @override
  late final GeneratedColumn<String> locationId = GeneratedColumn<String>(
      'location_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _calcDateMeta =
      const VerificationMeta('calcDate');
  @override
  late final GeneratedColumn<DateTime> calcDate = GeneratedColumn<DateTime>(
      'calc_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _visibilityJsonMeta =
      const VerificationMeta('visibilityJson');
  @override
  late final GeneratedColumn<String> visibilityJson = GeneratedColumn<String>(
      'visibility_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _refDataVersionMeta =
      const VerificationMeta('refDataVersion');
  @override
  late final GeneratedColumn<int> refDataVersion = GeneratedColumn<int>(
      'ref_data_version', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [locationId, calcDate, visibilityJson, refDataVersion];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'visibility_cache';
  @override
  VerificationContext validateIntegrity(
      Insertable<VisibilityCacheData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('location_id')) {
      context.handle(
          _locationIdMeta,
          locationId.isAcceptableOrUnknown(
              data['location_id']!, _locationIdMeta));
    } else if (isInserting) {
      context.missing(_locationIdMeta);
    }
    if (data.containsKey('calc_date')) {
      context.handle(_calcDateMeta,
          calcDate.isAcceptableOrUnknown(data['calc_date']!, _calcDateMeta));
    } else if (isInserting) {
      context.missing(_calcDateMeta);
    }
    if (data.containsKey('visibility_json')) {
      context.handle(
          _visibilityJsonMeta,
          visibilityJson.isAcceptableOrUnknown(
              data['visibility_json']!, _visibilityJsonMeta));
    } else if (isInserting) {
      context.missing(_visibilityJsonMeta);
    }
    if (data.containsKey('ref_data_version')) {
      context.handle(
          _refDataVersionMeta,
          refDataVersion.isAcceptableOrUnknown(
              data['ref_data_version']!, _refDataVersionMeta));
    } else if (isInserting) {
      context.missing(_refDataVersionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {locationId, calcDate};
  @override
  VisibilityCacheData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VisibilityCacheData(
      locationId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}location_id'])!,
      calcDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}calc_date'])!,
      visibilityJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}visibility_json'])!,
      refDataVersion: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}ref_data_version'])!,
    );
  }

  @override
  $VisibilityCacheTable createAlias(String alias) {
    return $VisibilityCacheTable(attachedDatabase, alias);
  }
}

class VisibilityCacheData extends DataClass
    implements Insertable<VisibilityCacheData> {
  final String locationId;
  final DateTime calcDate;
  final String visibilityJson;
  final int refDataVersion;
  const VisibilityCacheData(
      {required this.locationId,
      required this.calcDate,
      required this.visibilityJson,
      required this.refDataVersion});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['location_id'] = Variable<String>(locationId);
    map['calc_date'] = Variable<DateTime>(calcDate);
    map['visibility_json'] = Variable<String>(visibilityJson);
    map['ref_data_version'] = Variable<int>(refDataVersion);
    return map;
  }

  VisibilityCacheCompanion toCompanion(bool nullToAbsent) {
    return VisibilityCacheCompanion(
      locationId: Value(locationId),
      calcDate: Value(calcDate),
      visibilityJson: Value(visibilityJson),
      refDataVersion: Value(refDataVersion),
    );
  }

  factory VisibilityCacheData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VisibilityCacheData(
      locationId: serializer.fromJson<String>(json['locationId']),
      calcDate: serializer.fromJson<DateTime>(json['calcDate']),
      visibilityJson: serializer.fromJson<String>(json['visibilityJson']),
      refDataVersion: serializer.fromJson<int>(json['refDataVersion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'locationId': serializer.toJson<String>(locationId),
      'calcDate': serializer.toJson<DateTime>(calcDate),
      'visibilityJson': serializer.toJson<String>(visibilityJson),
      'refDataVersion': serializer.toJson<int>(refDataVersion),
    };
  }

  VisibilityCacheData copyWith(
          {String? locationId,
          DateTime? calcDate,
          String? visibilityJson,
          int? refDataVersion}) =>
      VisibilityCacheData(
        locationId: locationId ?? this.locationId,
        calcDate: calcDate ?? this.calcDate,
        visibilityJson: visibilityJson ?? this.visibilityJson,
        refDataVersion: refDataVersion ?? this.refDataVersion,
      );
  VisibilityCacheData copyWithCompanion(VisibilityCacheCompanion data) {
    return VisibilityCacheData(
      locationId:
          data.locationId.present ? data.locationId.value : this.locationId,
      calcDate: data.calcDate.present ? data.calcDate.value : this.calcDate,
      visibilityJson: data.visibilityJson.present
          ? data.visibilityJson.value
          : this.visibilityJson,
      refDataVersion: data.refDataVersion.present
          ? data.refDataVersion.value
          : this.refDataVersion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VisibilityCacheData(')
          ..write('locationId: $locationId, ')
          ..write('calcDate: $calcDate, ')
          ..write('visibilityJson: $visibilityJson, ')
          ..write('refDataVersion: $refDataVersion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(locationId, calcDate, visibilityJson, refDataVersion);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VisibilityCacheData &&
          other.locationId == this.locationId &&
          other.calcDate == this.calcDate &&
          other.visibilityJson == this.visibilityJson &&
          other.refDataVersion == this.refDataVersion);
}

class VisibilityCacheCompanion extends UpdateCompanion<VisibilityCacheData> {
  final Value<String> locationId;
  final Value<DateTime> calcDate;
  final Value<String> visibilityJson;
  final Value<int> refDataVersion;
  final Value<int> rowid;
  const VisibilityCacheCompanion({
    this.locationId = const Value.absent(),
    this.calcDate = const Value.absent(),
    this.visibilityJson = const Value.absent(),
    this.refDataVersion = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VisibilityCacheCompanion.insert({
    required String locationId,
    required DateTime calcDate,
    required String visibilityJson,
    required int refDataVersion,
    this.rowid = const Value.absent(),
  })  : locationId = Value(locationId),
        calcDate = Value(calcDate),
        visibilityJson = Value(visibilityJson),
        refDataVersion = Value(refDataVersion);
  static Insertable<VisibilityCacheData> custom({
    Expression<String>? locationId,
    Expression<DateTime>? calcDate,
    Expression<String>? visibilityJson,
    Expression<int>? refDataVersion,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (locationId != null) 'location_id': locationId,
      if (calcDate != null) 'calc_date': calcDate,
      if (visibilityJson != null) 'visibility_json': visibilityJson,
      if (refDataVersion != null) 'ref_data_version': refDataVersion,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VisibilityCacheCompanion copyWith(
      {Value<String>? locationId,
      Value<DateTime>? calcDate,
      Value<String>? visibilityJson,
      Value<int>? refDataVersion,
      Value<int>? rowid}) {
    return VisibilityCacheCompanion(
      locationId: locationId ?? this.locationId,
      calcDate: calcDate ?? this.calcDate,
      visibilityJson: visibilityJson ?? this.visibilityJson,
      refDataVersion: refDataVersion ?? this.refDataVersion,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (locationId.present) {
      map['location_id'] = Variable<String>(locationId.value);
    }
    if (calcDate.present) {
      map['calc_date'] = Variable<DateTime>(calcDate.value);
    }
    if (visibilityJson.present) {
      map['visibility_json'] = Variable<String>(visibilityJson.value);
    }
    if (refDataVersion.present) {
      map['ref_data_version'] = Variable<int>(refDataVersion.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VisibilityCacheCompanion(')
          ..write('locationId: $locationId, ')
          ..write('calcDate: $calcDate, ')
          ..write('visibilityJson: $visibilityJson, ')
          ..write('refDataVersion: $refDataVersion, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SkySnapshotTable extends SkySnapshot
    with TableInfo<$SkySnapshotTable, SkySnapshotData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SkySnapshotTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _computedAtMeta =
      const VerificationMeta('computedAt');
  @override
  late final GeneratedColumn<DateTime> computedAt = GeneratedColumn<DateTime>(
      'computed_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _snapshotJsonMeta =
      const VerificationMeta('snapshotJson');
  @override
  late final GeneratedColumn<String> snapshotJson = GeneratedColumn<String>(
      'snapshot_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [computedAt, snapshotJson];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sky_snapshot';
  @override
  VerificationContext validateIntegrity(Insertable<SkySnapshotData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('computed_at')) {
      context.handle(
          _computedAtMeta,
          computedAt.isAcceptableOrUnknown(
              data['computed_at']!, _computedAtMeta));
    } else if (isInserting) {
      context.missing(_computedAtMeta);
    }
    if (data.containsKey('snapshot_json')) {
      context.handle(
          _snapshotJsonMeta,
          snapshotJson.isAcceptableOrUnknown(
              data['snapshot_json']!, _snapshotJsonMeta));
    } else if (isInserting) {
      context.missing(_snapshotJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {computedAt};
  @override
  SkySnapshotData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SkySnapshotData(
      computedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}computed_at'])!,
      snapshotJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}snapshot_json'])!,
    );
  }

  @override
  $SkySnapshotTable createAlias(String alias) {
    return $SkySnapshotTable(attachedDatabase, alias);
  }
}

class SkySnapshotData extends DataClass implements Insertable<SkySnapshotData> {
  final DateTime computedAt;
  final String snapshotJson;
  const SkySnapshotData({required this.computedAt, required this.snapshotJson});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['computed_at'] = Variable<DateTime>(computedAt);
    map['snapshot_json'] = Variable<String>(snapshotJson);
    return map;
  }

  SkySnapshotCompanion toCompanion(bool nullToAbsent) {
    return SkySnapshotCompanion(
      computedAt: Value(computedAt),
      snapshotJson: Value(snapshotJson),
    );
  }

  factory SkySnapshotData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SkySnapshotData(
      computedAt: serializer.fromJson<DateTime>(json['computedAt']),
      snapshotJson: serializer.fromJson<String>(json['snapshotJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'computedAt': serializer.toJson<DateTime>(computedAt),
      'snapshotJson': serializer.toJson<String>(snapshotJson),
    };
  }

  SkySnapshotData copyWith({DateTime? computedAt, String? snapshotJson}) =>
      SkySnapshotData(
        computedAt: computedAt ?? this.computedAt,
        snapshotJson: snapshotJson ?? this.snapshotJson,
      );
  SkySnapshotData copyWithCompanion(SkySnapshotCompanion data) {
    return SkySnapshotData(
      computedAt:
          data.computedAt.present ? data.computedAt.value : this.computedAt,
      snapshotJson: data.snapshotJson.present
          ? data.snapshotJson.value
          : this.snapshotJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SkySnapshotData(')
          ..write('computedAt: $computedAt, ')
          ..write('snapshotJson: $snapshotJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(computedAt, snapshotJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SkySnapshotData &&
          other.computedAt == this.computedAt &&
          other.snapshotJson == this.snapshotJson);
}

class SkySnapshotCompanion extends UpdateCompanion<SkySnapshotData> {
  final Value<DateTime> computedAt;
  final Value<String> snapshotJson;
  final Value<int> rowid;
  const SkySnapshotCompanion({
    this.computedAt = const Value.absent(),
    this.snapshotJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SkySnapshotCompanion.insert({
    required DateTime computedAt,
    required String snapshotJson,
    this.rowid = const Value.absent(),
  })  : computedAt = Value(computedAt),
        snapshotJson = Value(snapshotJson);
  static Insertable<SkySnapshotData> custom({
    Expression<DateTime>? computedAt,
    Expression<String>? snapshotJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (computedAt != null) 'computed_at': computedAt,
      if (snapshotJson != null) 'snapshot_json': snapshotJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SkySnapshotCompanion copyWith(
      {Value<DateTime>? computedAt,
      Value<String>? snapshotJson,
      Value<int>? rowid}) {
    return SkySnapshotCompanion(
      computedAt: computedAt ?? this.computedAt,
      snapshotJson: snapshotJson ?? this.snapshotJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (computedAt.present) {
      map['computed_at'] = Variable<DateTime>(computedAt.value);
    }
    if (snapshotJson.present) {
      map['snapshot_json'] = Variable<String>(snapshotJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SkySnapshotCompanion(')
          ..write('computedAt: $computedAt, ')
          ..write('snapshotJson: $snapshotJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$CacheDb extends GeneratedDatabase {
  _$CacheDb(QueryExecutor e) : super(e);
  $CacheDbManager get managers => $CacheDbManager(this);
  late final $WeatherForecastCacheTable weatherForecastCache =
      $WeatherForecastCacheTable(this);
  late final $VisibilityCacheTable visibilityCache =
      $VisibilityCacheTable(this);
  late final $SkySnapshotTable skySnapshot = $SkySnapshotTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [weatherForecastCache, visibilityCache, skySnapshot];
}

typedef $$WeatherForecastCacheTableCreateCompanionBuilder
    = WeatherForecastCacheCompanion Function({
  required String locationId,
  required DateTime fetchedAt,
  required DateTime validUntil,
  required String payloadJson,
  Value<int> rowid,
});
typedef $$WeatherForecastCacheTableUpdateCompanionBuilder
    = WeatherForecastCacheCompanion Function({
  Value<String> locationId,
  Value<DateTime> fetchedAt,
  Value<DateTime> validUntil,
  Value<String> payloadJson,
  Value<int> rowid,
});

class $$WeatherForecastCacheTableFilterComposer
    extends Composer<_$CacheDb, $WeatherForecastCacheTable> {
  $$WeatherForecastCacheTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get locationId => $composableBuilder(
      column: $table.locationId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get fetchedAt => $composableBuilder(
      column: $table.fetchedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get validUntil => $composableBuilder(
      column: $table.validUntil, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get payloadJson => $composableBuilder(
      column: $table.payloadJson, builder: (column) => ColumnFilters(column));
}

class $$WeatherForecastCacheTableOrderingComposer
    extends Composer<_$CacheDb, $WeatherForecastCacheTable> {
  $$WeatherForecastCacheTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get locationId => $composableBuilder(
      column: $table.locationId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get fetchedAt => $composableBuilder(
      column: $table.fetchedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get validUntil => $composableBuilder(
      column: $table.validUntil, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get payloadJson => $composableBuilder(
      column: $table.payloadJson, builder: (column) => ColumnOrderings(column));
}

class $$WeatherForecastCacheTableAnnotationComposer
    extends Composer<_$CacheDb, $WeatherForecastCacheTable> {
  $$WeatherForecastCacheTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get locationId => $composableBuilder(
      column: $table.locationId, builder: (column) => column);

  GeneratedColumn<DateTime> get fetchedAt =>
      $composableBuilder(column: $table.fetchedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get validUntil => $composableBuilder(
      column: $table.validUntil, builder: (column) => column);

  GeneratedColumn<String> get payloadJson => $composableBuilder(
      column: $table.payloadJson, builder: (column) => column);
}

class $$WeatherForecastCacheTableTableManager extends RootTableManager<
    _$CacheDb,
    $WeatherForecastCacheTable,
    WeatherForecastCacheData,
    $$WeatherForecastCacheTableFilterComposer,
    $$WeatherForecastCacheTableOrderingComposer,
    $$WeatherForecastCacheTableAnnotationComposer,
    $$WeatherForecastCacheTableCreateCompanionBuilder,
    $$WeatherForecastCacheTableUpdateCompanionBuilder,
    (
      WeatherForecastCacheData,
      BaseReferences<_$CacheDb, $WeatherForecastCacheTable,
          WeatherForecastCacheData>
    ),
    WeatherForecastCacheData,
    PrefetchHooks Function()> {
  $$WeatherForecastCacheTableTableManager(
      _$CacheDb db, $WeatherForecastCacheTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WeatherForecastCacheTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WeatherForecastCacheTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WeatherForecastCacheTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> locationId = const Value.absent(),
            Value<DateTime> fetchedAt = const Value.absent(),
            Value<DateTime> validUntil = const Value.absent(),
            Value<String> payloadJson = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              WeatherForecastCacheCompanion(
            locationId: locationId,
            fetchedAt: fetchedAt,
            validUntil: validUntil,
            payloadJson: payloadJson,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String locationId,
            required DateTime fetchedAt,
            required DateTime validUntil,
            required String payloadJson,
            Value<int> rowid = const Value.absent(),
          }) =>
              WeatherForecastCacheCompanion.insert(
            locationId: locationId,
            fetchedAt: fetchedAt,
            validUntil: validUntil,
            payloadJson: payloadJson,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$WeatherForecastCacheTableProcessedTableManager
    = ProcessedTableManager<
        _$CacheDb,
        $WeatherForecastCacheTable,
        WeatherForecastCacheData,
        $$WeatherForecastCacheTableFilterComposer,
        $$WeatherForecastCacheTableOrderingComposer,
        $$WeatherForecastCacheTableAnnotationComposer,
        $$WeatherForecastCacheTableCreateCompanionBuilder,
        $$WeatherForecastCacheTableUpdateCompanionBuilder,
        (
          WeatherForecastCacheData,
          BaseReferences<_$CacheDb, $WeatherForecastCacheTable,
              WeatherForecastCacheData>
        ),
        WeatherForecastCacheData,
        PrefetchHooks Function()>;
typedef $$VisibilityCacheTableCreateCompanionBuilder = VisibilityCacheCompanion
    Function({
  required String locationId,
  required DateTime calcDate,
  required String visibilityJson,
  required int refDataVersion,
  Value<int> rowid,
});
typedef $$VisibilityCacheTableUpdateCompanionBuilder = VisibilityCacheCompanion
    Function({
  Value<String> locationId,
  Value<DateTime> calcDate,
  Value<String> visibilityJson,
  Value<int> refDataVersion,
  Value<int> rowid,
});

class $$VisibilityCacheTableFilterComposer
    extends Composer<_$CacheDb, $VisibilityCacheTable> {
  $$VisibilityCacheTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get locationId => $composableBuilder(
      column: $table.locationId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get calcDate => $composableBuilder(
      column: $table.calcDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get visibilityJson => $composableBuilder(
      column: $table.visibilityJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get refDataVersion => $composableBuilder(
      column: $table.refDataVersion,
      builder: (column) => ColumnFilters(column));
}

class $$VisibilityCacheTableOrderingComposer
    extends Composer<_$CacheDb, $VisibilityCacheTable> {
  $$VisibilityCacheTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get locationId => $composableBuilder(
      column: $table.locationId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get calcDate => $composableBuilder(
      column: $table.calcDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get visibilityJson => $composableBuilder(
      column: $table.visibilityJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get refDataVersion => $composableBuilder(
      column: $table.refDataVersion,
      builder: (column) => ColumnOrderings(column));
}

class $$VisibilityCacheTableAnnotationComposer
    extends Composer<_$CacheDb, $VisibilityCacheTable> {
  $$VisibilityCacheTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get locationId => $composableBuilder(
      column: $table.locationId, builder: (column) => column);

  GeneratedColumn<DateTime> get calcDate =>
      $composableBuilder(column: $table.calcDate, builder: (column) => column);

  GeneratedColumn<String> get visibilityJson => $composableBuilder(
      column: $table.visibilityJson, builder: (column) => column);

  GeneratedColumn<int> get refDataVersion => $composableBuilder(
      column: $table.refDataVersion, builder: (column) => column);
}

class $$VisibilityCacheTableTableManager extends RootTableManager<
    _$CacheDb,
    $VisibilityCacheTable,
    VisibilityCacheData,
    $$VisibilityCacheTableFilterComposer,
    $$VisibilityCacheTableOrderingComposer,
    $$VisibilityCacheTableAnnotationComposer,
    $$VisibilityCacheTableCreateCompanionBuilder,
    $$VisibilityCacheTableUpdateCompanionBuilder,
    (
      VisibilityCacheData,
      BaseReferences<_$CacheDb, $VisibilityCacheTable, VisibilityCacheData>
    ),
    VisibilityCacheData,
    PrefetchHooks Function()> {
  $$VisibilityCacheTableTableManager(_$CacheDb db, $VisibilityCacheTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VisibilityCacheTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VisibilityCacheTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VisibilityCacheTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> locationId = const Value.absent(),
            Value<DateTime> calcDate = const Value.absent(),
            Value<String> visibilityJson = const Value.absent(),
            Value<int> refDataVersion = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              VisibilityCacheCompanion(
            locationId: locationId,
            calcDate: calcDate,
            visibilityJson: visibilityJson,
            refDataVersion: refDataVersion,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String locationId,
            required DateTime calcDate,
            required String visibilityJson,
            required int refDataVersion,
            Value<int> rowid = const Value.absent(),
          }) =>
              VisibilityCacheCompanion.insert(
            locationId: locationId,
            calcDate: calcDate,
            visibilityJson: visibilityJson,
            refDataVersion: refDataVersion,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$VisibilityCacheTableProcessedTableManager = ProcessedTableManager<
    _$CacheDb,
    $VisibilityCacheTable,
    VisibilityCacheData,
    $$VisibilityCacheTableFilterComposer,
    $$VisibilityCacheTableOrderingComposer,
    $$VisibilityCacheTableAnnotationComposer,
    $$VisibilityCacheTableCreateCompanionBuilder,
    $$VisibilityCacheTableUpdateCompanionBuilder,
    (
      VisibilityCacheData,
      BaseReferences<_$CacheDb, $VisibilityCacheTable, VisibilityCacheData>
    ),
    VisibilityCacheData,
    PrefetchHooks Function()>;
typedef $$SkySnapshotTableCreateCompanionBuilder = SkySnapshotCompanion
    Function({
  required DateTime computedAt,
  required String snapshotJson,
  Value<int> rowid,
});
typedef $$SkySnapshotTableUpdateCompanionBuilder = SkySnapshotCompanion
    Function({
  Value<DateTime> computedAt,
  Value<String> snapshotJson,
  Value<int> rowid,
});

class $$SkySnapshotTableFilterComposer
    extends Composer<_$CacheDb, $SkySnapshotTable> {
  $$SkySnapshotTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get computedAt => $composableBuilder(
      column: $table.computedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get snapshotJson => $composableBuilder(
      column: $table.snapshotJson, builder: (column) => ColumnFilters(column));
}

class $$SkySnapshotTableOrderingComposer
    extends Composer<_$CacheDb, $SkySnapshotTable> {
  $$SkySnapshotTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get computedAt => $composableBuilder(
      column: $table.computedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get snapshotJson => $composableBuilder(
      column: $table.snapshotJson,
      builder: (column) => ColumnOrderings(column));
}

class $$SkySnapshotTableAnnotationComposer
    extends Composer<_$CacheDb, $SkySnapshotTable> {
  $$SkySnapshotTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get computedAt => $composableBuilder(
      column: $table.computedAt, builder: (column) => column);

  GeneratedColumn<String> get snapshotJson => $composableBuilder(
      column: $table.snapshotJson, builder: (column) => column);
}

class $$SkySnapshotTableTableManager extends RootTableManager<
    _$CacheDb,
    $SkySnapshotTable,
    SkySnapshotData,
    $$SkySnapshotTableFilterComposer,
    $$SkySnapshotTableOrderingComposer,
    $$SkySnapshotTableAnnotationComposer,
    $$SkySnapshotTableCreateCompanionBuilder,
    $$SkySnapshotTableUpdateCompanionBuilder,
    (
      SkySnapshotData,
      BaseReferences<_$CacheDb, $SkySnapshotTable, SkySnapshotData>
    ),
    SkySnapshotData,
    PrefetchHooks Function()> {
  $$SkySnapshotTableTableManager(_$CacheDb db, $SkySnapshotTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SkySnapshotTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SkySnapshotTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SkySnapshotTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<DateTime> computedAt = const Value.absent(),
            Value<String> snapshotJson = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SkySnapshotCompanion(
            computedAt: computedAt,
            snapshotJson: snapshotJson,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required DateTime computedAt,
            required String snapshotJson,
            Value<int> rowid = const Value.absent(),
          }) =>
              SkySnapshotCompanion.insert(
            computedAt: computedAt,
            snapshotJson: snapshotJson,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SkySnapshotTableProcessedTableManager = ProcessedTableManager<
    _$CacheDb,
    $SkySnapshotTable,
    SkySnapshotData,
    $$SkySnapshotTableFilterComposer,
    $$SkySnapshotTableOrderingComposer,
    $$SkySnapshotTableAnnotationComposer,
    $$SkySnapshotTableCreateCompanionBuilder,
    $$SkySnapshotTableUpdateCompanionBuilder,
    (
      SkySnapshotData,
      BaseReferences<_$CacheDb, $SkySnapshotTable, SkySnapshotData>
    ),
    SkySnapshotData,
    PrefetchHooks Function()>;

class $CacheDbManager {
  final _$CacheDb _db;
  $CacheDbManager(this._db);
  $$WeatherForecastCacheTableTableManager get weatherForecastCache =>
      $$WeatherForecastCacheTableTableManager(_db, _db.weatherForecastCache);
  $$VisibilityCacheTableTableManager get visibilityCache =>
      $$VisibilityCacheTableTableManager(_db, _db.visibilityCache);
  $$SkySnapshotTableTableManager get skySnapshot =>
      $$SkySnapshotTableTableManager(_db, _db.skySnapshot);
}
