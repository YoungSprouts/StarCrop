// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reference_db.dart';

// ignore_for_file: type=lint
class $StarsTable extends Stars with TableInfo<$StarsTable, Star> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StarsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _hipIdMeta = const VerificationMeta('hipId');
  @override
  late final GeneratedColumn<int> hipId = GeneratedColumn<int>(
      'hip_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _raDegMeta = const VerificationMeta('raDeg');
  @override
  late final GeneratedColumn<double> raDeg = GeneratedColumn<double>(
      'ra_deg', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _decDegMeta = const VerificationMeta('decDeg');
  @override
  late final GeneratedColumn<double> decDeg = GeneratedColumn<double>(
      'dec_deg', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _magnitudeMeta =
      const VerificationMeta('magnitude');
  @override
  late final GeneratedColumn<double> magnitude = GeneratedColumn<double>(
      'magnitude', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _colorIndexMeta =
      const VerificationMeta('colorIndex');
  @override
  late final GeneratedColumn<double> colorIndex = GeneratedColumn<double>(
      'color_index', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _properNameMeta =
      const VerificationMeta('properName');
  @override
  late final GeneratedColumn<String> properName = GeneratedColumn<String>(
      'proper_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [hipId, raDeg, decDeg, magnitude, colorIndex, properName];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stars';
  @override
  VerificationContext validateIntegrity(Insertable<Star> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('hip_id')) {
      context.handle(
          _hipIdMeta, hipId.isAcceptableOrUnknown(data['hip_id']!, _hipIdMeta));
    }
    if (data.containsKey('ra_deg')) {
      context.handle(
          _raDegMeta, raDeg.isAcceptableOrUnknown(data['ra_deg']!, _raDegMeta));
    } else if (isInserting) {
      context.missing(_raDegMeta);
    }
    if (data.containsKey('dec_deg')) {
      context.handle(_decDegMeta,
          decDeg.isAcceptableOrUnknown(data['dec_deg']!, _decDegMeta));
    } else if (isInserting) {
      context.missing(_decDegMeta);
    }
    if (data.containsKey('magnitude')) {
      context.handle(_magnitudeMeta,
          magnitude.isAcceptableOrUnknown(data['magnitude']!, _magnitudeMeta));
    } else if (isInserting) {
      context.missing(_magnitudeMeta);
    }
    if (data.containsKey('color_index')) {
      context.handle(
          _colorIndexMeta,
          colorIndex.isAcceptableOrUnknown(
              data['color_index']!, _colorIndexMeta));
    }
    if (data.containsKey('proper_name')) {
      context.handle(
          _properNameMeta,
          properName.isAcceptableOrUnknown(
              data['proper_name']!, _properNameMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {hipId};
  @override
  Star map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Star(
      hipId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}hip_id'])!,
      raDeg: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}ra_deg'])!,
      decDeg: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}dec_deg'])!,
      magnitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}magnitude'])!,
      colorIndex: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}color_index']),
      properName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}proper_name']),
    );
  }

  @override
  $StarsTable createAlias(String alias) {
    return $StarsTable(attachedDatabase, alias);
  }
}

class Star extends DataClass implements Insertable<Star> {
  final int hipId;
  final double raDeg;
  final double decDeg;
  final double magnitude;
  final double? colorIndex;
  final String? properName;
  const Star(
      {required this.hipId,
      required this.raDeg,
      required this.decDeg,
      required this.magnitude,
      this.colorIndex,
      this.properName});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['hip_id'] = Variable<int>(hipId);
    map['ra_deg'] = Variable<double>(raDeg);
    map['dec_deg'] = Variable<double>(decDeg);
    map['magnitude'] = Variable<double>(magnitude);
    if (!nullToAbsent || colorIndex != null) {
      map['color_index'] = Variable<double>(colorIndex);
    }
    if (!nullToAbsent || properName != null) {
      map['proper_name'] = Variable<String>(properName);
    }
    return map;
  }

  StarsCompanion toCompanion(bool nullToAbsent) {
    return StarsCompanion(
      hipId: Value(hipId),
      raDeg: Value(raDeg),
      decDeg: Value(decDeg),
      magnitude: Value(magnitude),
      colorIndex: colorIndex == null && nullToAbsent
          ? const Value.absent()
          : Value(colorIndex),
      properName: properName == null && nullToAbsent
          ? const Value.absent()
          : Value(properName),
    );
  }

  factory Star.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Star(
      hipId: serializer.fromJson<int>(json['hipId']),
      raDeg: serializer.fromJson<double>(json['raDeg']),
      decDeg: serializer.fromJson<double>(json['decDeg']),
      magnitude: serializer.fromJson<double>(json['magnitude']),
      colorIndex: serializer.fromJson<double?>(json['colorIndex']),
      properName: serializer.fromJson<String?>(json['properName']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'hipId': serializer.toJson<int>(hipId),
      'raDeg': serializer.toJson<double>(raDeg),
      'decDeg': serializer.toJson<double>(decDeg),
      'magnitude': serializer.toJson<double>(magnitude),
      'colorIndex': serializer.toJson<double?>(colorIndex),
      'properName': serializer.toJson<String?>(properName),
    };
  }

  Star copyWith(
          {int? hipId,
          double? raDeg,
          double? decDeg,
          double? magnitude,
          Value<double?> colorIndex = const Value.absent(),
          Value<String?> properName = const Value.absent()}) =>
      Star(
        hipId: hipId ?? this.hipId,
        raDeg: raDeg ?? this.raDeg,
        decDeg: decDeg ?? this.decDeg,
        magnitude: magnitude ?? this.magnitude,
        colorIndex: colorIndex.present ? colorIndex.value : this.colorIndex,
        properName: properName.present ? properName.value : this.properName,
      );
  Star copyWithCompanion(StarsCompanion data) {
    return Star(
      hipId: data.hipId.present ? data.hipId.value : this.hipId,
      raDeg: data.raDeg.present ? data.raDeg.value : this.raDeg,
      decDeg: data.decDeg.present ? data.decDeg.value : this.decDeg,
      magnitude: data.magnitude.present ? data.magnitude.value : this.magnitude,
      colorIndex:
          data.colorIndex.present ? data.colorIndex.value : this.colorIndex,
      properName:
          data.properName.present ? data.properName.value : this.properName,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Star(')
          ..write('hipId: $hipId, ')
          ..write('raDeg: $raDeg, ')
          ..write('decDeg: $decDeg, ')
          ..write('magnitude: $magnitude, ')
          ..write('colorIndex: $colorIndex, ')
          ..write('properName: $properName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(hipId, raDeg, decDeg, magnitude, colorIndex, properName);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Star &&
          other.hipId == this.hipId &&
          other.raDeg == this.raDeg &&
          other.decDeg == this.decDeg &&
          other.magnitude == this.magnitude &&
          other.colorIndex == this.colorIndex &&
          other.properName == this.properName);
}

class StarsCompanion extends UpdateCompanion<Star> {
  final Value<int> hipId;
  final Value<double> raDeg;
  final Value<double> decDeg;
  final Value<double> magnitude;
  final Value<double?> colorIndex;
  final Value<String?> properName;
  const StarsCompanion({
    this.hipId = const Value.absent(),
    this.raDeg = const Value.absent(),
    this.decDeg = const Value.absent(),
    this.magnitude = const Value.absent(),
    this.colorIndex = const Value.absent(),
    this.properName = const Value.absent(),
  });
  StarsCompanion.insert({
    this.hipId = const Value.absent(),
    required double raDeg,
    required double decDeg,
    required double magnitude,
    this.colorIndex = const Value.absent(),
    this.properName = const Value.absent(),
  })  : raDeg = Value(raDeg),
        decDeg = Value(decDeg),
        magnitude = Value(magnitude);
  static Insertable<Star> custom({
    Expression<int>? hipId,
    Expression<double>? raDeg,
    Expression<double>? decDeg,
    Expression<double>? magnitude,
    Expression<double>? colorIndex,
    Expression<String>? properName,
  }) {
    return RawValuesInsertable({
      if (hipId != null) 'hip_id': hipId,
      if (raDeg != null) 'ra_deg': raDeg,
      if (decDeg != null) 'dec_deg': decDeg,
      if (magnitude != null) 'magnitude': magnitude,
      if (colorIndex != null) 'color_index': colorIndex,
      if (properName != null) 'proper_name': properName,
    });
  }

  StarsCompanion copyWith(
      {Value<int>? hipId,
      Value<double>? raDeg,
      Value<double>? decDeg,
      Value<double>? magnitude,
      Value<double?>? colorIndex,
      Value<String?>? properName}) {
    return StarsCompanion(
      hipId: hipId ?? this.hipId,
      raDeg: raDeg ?? this.raDeg,
      decDeg: decDeg ?? this.decDeg,
      magnitude: magnitude ?? this.magnitude,
      colorIndex: colorIndex ?? this.colorIndex,
      properName: properName ?? this.properName,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (hipId.present) {
      map['hip_id'] = Variable<int>(hipId.value);
    }
    if (raDeg.present) {
      map['ra_deg'] = Variable<double>(raDeg.value);
    }
    if (decDeg.present) {
      map['dec_deg'] = Variable<double>(decDeg.value);
    }
    if (magnitude.present) {
      map['magnitude'] = Variable<double>(magnitude.value);
    }
    if (colorIndex.present) {
      map['color_index'] = Variable<double>(colorIndex.value);
    }
    if (properName.present) {
      map['proper_name'] = Variable<String>(properName.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StarsCompanion(')
          ..write('hipId: $hipId, ')
          ..write('raDeg: $raDeg, ')
          ..write('decDeg: $decDeg, ')
          ..write('magnitude: $magnitude, ')
          ..write('colorIndex: $colorIndex, ')
          ..write('properName: $properName')
          ..write(')'))
        .toString();
  }
}

class $ConstellationsTable extends Constellations
    with TableInfo<$ConstellationsTable, Constellation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConstellationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
      'code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _latinNameMeta =
      const VerificationMeta('latinName');
  @override
  late final GeneratedColumn<String> latinName = GeneratedColumn<String>(
      'latin_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _areaSqDegMeta =
      const VerificationMeta('areaSqDeg');
  @override
  late final GeneratedColumn<double> areaSqDeg = GeneratedColumn<double>(
      'area_sq_deg', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _centerRaMeta =
      const VerificationMeta('centerRa');
  @override
  late final GeneratedColumn<double> centerRa = GeneratedColumn<double>(
      'center_ra', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _centerDecMeta =
      const VerificationMeta('centerDec');
  @override
  late final GeneratedColumn<double> centerDec = GeneratedColumn<double>(
      'center_dec', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [code, latinName, areaSqDeg, centerRa, centerDec];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'constellations';
  @override
  VerificationContext validateIntegrity(Insertable<Constellation> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('code')) {
      context.handle(
          _codeMeta, code.isAcceptableOrUnknown(data['code']!, _codeMeta));
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('latin_name')) {
      context.handle(_latinNameMeta,
          latinName.isAcceptableOrUnknown(data['latin_name']!, _latinNameMeta));
    } else if (isInserting) {
      context.missing(_latinNameMeta);
    }
    if (data.containsKey('area_sq_deg')) {
      context.handle(
          _areaSqDegMeta,
          areaSqDeg.isAcceptableOrUnknown(
              data['area_sq_deg']!, _areaSqDegMeta));
    }
    if (data.containsKey('center_ra')) {
      context.handle(_centerRaMeta,
          centerRa.isAcceptableOrUnknown(data['center_ra']!, _centerRaMeta));
    }
    if (data.containsKey('center_dec')) {
      context.handle(_centerDecMeta,
          centerDec.isAcceptableOrUnknown(data['center_dec']!, _centerDecMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {code};
  @override
  Constellation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Constellation(
      code: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}code'])!,
      latinName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}latin_name'])!,
      areaSqDeg: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}area_sq_deg']),
      centerRa: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}center_ra']),
      centerDec: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}center_dec']),
    );
  }

  @override
  $ConstellationsTable createAlias(String alias) {
    return $ConstellationsTable(attachedDatabase, alias);
  }
}

class Constellation extends DataClass implements Insertable<Constellation> {
  final String code;
  final String latinName;
  final double? areaSqDeg;
  final double? centerRa;
  final double? centerDec;
  const Constellation(
      {required this.code,
      required this.latinName,
      this.areaSqDeg,
      this.centerRa,
      this.centerDec});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['code'] = Variable<String>(code);
    map['latin_name'] = Variable<String>(latinName);
    if (!nullToAbsent || areaSqDeg != null) {
      map['area_sq_deg'] = Variable<double>(areaSqDeg);
    }
    if (!nullToAbsent || centerRa != null) {
      map['center_ra'] = Variable<double>(centerRa);
    }
    if (!nullToAbsent || centerDec != null) {
      map['center_dec'] = Variable<double>(centerDec);
    }
    return map;
  }

  ConstellationsCompanion toCompanion(bool nullToAbsent) {
    return ConstellationsCompanion(
      code: Value(code),
      latinName: Value(latinName),
      areaSqDeg: areaSqDeg == null && nullToAbsent
          ? const Value.absent()
          : Value(areaSqDeg),
      centerRa: centerRa == null && nullToAbsent
          ? const Value.absent()
          : Value(centerRa),
      centerDec: centerDec == null && nullToAbsent
          ? const Value.absent()
          : Value(centerDec),
    );
  }

  factory Constellation.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Constellation(
      code: serializer.fromJson<String>(json['code']),
      latinName: serializer.fromJson<String>(json['latinName']),
      areaSqDeg: serializer.fromJson<double?>(json['areaSqDeg']),
      centerRa: serializer.fromJson<double?>(json['centerRa']),
      centerDec: serializer.fromJson<double?>(json['centerDec']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'code': serializer.toJson<String>(code),
      'latinName': serializer.toJson<String>(latinName),
      'areaSqDeg': serializer.toJson<double?>(areaSqDeg),
      'centerRa': serializer.toJson<double?>(centerRa),
      'centerDec': serializer.toJson<double?>(centerDec),
    };
  }

  Constellation copyWith(
          {String? code,
          String? latinName,
          Value<double?> areaSqDeg = const Value.absent(),
          Value<double?> centerRa = const Value.absent(),
          Value<double?> centerDec = const Value.absent()}) =>
      Constellation(
        code: code ?? this.code,
        latinName: latinName ?? this.latinName,
        areaSqDeg: areaSqDeg.present ? areaSqDeg.value : this.areaSqDeg,
        centerRa: centerRa.present ? centerRa.value : this.centerRa,
        centerDec: centerDec.present ? centerDec.value : this.centerDec,
      );
  Constellation copyWithCompanion(ConstellationsCompanion data) {
    return Constellation(
      code: data.code.present ? data.code.value : this.code,
      latinName: data.latinName.present ? data.latinName.value : this.latinName,
      areaSqDeg: data.areaSqDeg.present ? data.areaSqDeg.value : this.areaSqDeg,
      centerRa: data.centerRa.present ? data.centerRa.value : this.centerRa,
      centerDec: data.centerDec.present ? data.centerDec.value : this.centerDec,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Constellation(')
          ..write('code: $code, ')
          ..write('latinName: $latinName, ')
          ..write('areaSqDeg: $areaSqDeg, ')
          ..write('centerRa: $centerRa, ')
          ..write('centerDec: $centerDec')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(code, latinName, areaSqDeg, centerRa, centerDec);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Constellation &&
          other.code == this.code &&
          other.latinName == this.latinName &&
          other.areaSqDeg == this.areaSqDeg &&
          other.centerRa == this.centerRa &&
          other.centerDec == this.centerDec);
}

class ConstellationsCompanion extends UpdateCompanion<Constellation> {
  final Value<String> code;
  final Value<String> latinName;
  final Value<double?> areaSqDeg;
  final Value<double?> centerRa;
  final Value<double?> centerDec;
  final Value<int> rowid;
  const ConstellationsCompanion({
    this.code = const Value.absent(),
    this.latinName = const Value.absent(),
    this.areaSqDeg = const Value.absent(),
    this.centerRa = const Value.absent(),
    this.centerDec = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ConstellationsCompanion.insert({
    required String code,
    required String latinName,
    this.areaSqDeg = const Value.absent(),
    this.centerRa = const Value.absent(),
    this.centerDec = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : code = Value(code),
        latinName = Value(latinName);
  static Insertable<Constellation> custom({
    Expression<String>? code,
    Expression<String>? latinName,
    Expression<double>? areaSqDeg,
    Expression<double>? centerRa,
    Expression<double>? centerDec,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (code != null) 'code': code,
      if (latinName != null) 'latin_name': latinName,
      if (areaSqDeg != null) 'area_sq_deg': areaSqDeg,
      if (centerRa != null) 'center_ra': centerRa,
      if (centerDec != null) 'center_dec': centerDec,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ConstellationsCompanion copyWith(
      {Value<String>? code,
      Value<String>? latinName,
      Value<double?>? areaSqDeg,
      Value<double?>? centerRa,
      Value<double?>? centerDec,
      Value<int>? rowid}) {
    return ConstellationsCompanion(
      code: code ?? this.code,
      latinName: latinName ?? this.latinName,
      areaSqDeg: areaSqDeg ?? this.areaSqDeg,
      centerRa: centerRa ?? this.centerRa,
      centerDec: centerDec ?? this.centerDec,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (latinName.present) {
      map['latin_name'] = Variable<String>(latinName.value);
    }
    if (areaSqDeg.present) {
      map['area_sq_deg'] = Variable<double>(areaSqDeg.value);
    }
    if (centerRa.present) {
      map['center_ra'] = Variable<double>(centerRa.value);
    }
    if (centerDec.present) {
      map['center_dec'] = Variable<double>(centerDec.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ConstellationsCompanion(')
          ..write('code: $code, ')
          ..write('latinName: $latinName, ')
          ..write('areaSqDeg: $areaSqDeg, ')
          ..write('centerRa: $centerRa, ')
          ..write('centerDec: $centerDec, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SkyCulturesTable extends SkyCultures
    with TableInfo<$SkyCulturesTable, SkyCulture> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SkyCulturesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _cultureIdMeta =
      const VerificationMeta('cultureId');
  @override
  late final GeneratedColumn<int> cultureId = GeneratedColumn<int>(
      'culture_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _regionMeta = const VerificationMeta('region');
  @override
  late final GeneratedColumn<String> region = GeneratedColumn<String>(
      'region', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _licenseMeta =
      const VerificationMeta('license');
  @override
  late final GeneratedColumn<String> license = GeneratedColumn<String>(
      'license', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
      'source', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [cultureId, name, region, license, source];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sky_cultures';
  @override
  VerificationContext validateIntegrity(Insertable<SkyCulture> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('culture_id')) {
      context.handle(_cultureIdMeta,
          cultureId.isAcceptableOrUnknown(data['culture_id']!, _cultureIdMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('region')) {
      context.handle(_regionMeta,
          region.isAcceptableOrUnknown(data['region']!, _regionMeta));
    }
    if (data.containsKey('license')) {
      context.handle(_licenseMeta,
          license.isAcceptableOrUnknown(data['license']!, _licenseMeta));
    }
    if (data.containsKey('source')) {
      context.handle(_sourceMeta,
          source.isAcceptableOrUnknown(data['source']!, _sourceMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {cultureId};
  @override
  SkyCulture map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SkyCulture(
      cultureId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}culture_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      region: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}region']),
      license: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}license']),
      source: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source']),
    );
  }

  @override
  $SkyCulturesTable createAlias(String alias) {
    return $SkyCulturesTable(attachedDatabase, alias);
  }
}

class SkyCulture extends DataClass implements Insertable<SkyCulture> {
  final int cultureId;
  final String name;
  final String? region;
  final String? license;
  final String? source;
  const SkyCulture(
      {required this.cultureId,
      required this.name,
      this.region,
      this.license,
      this.source});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['culture_id'] = Variable<int>(cultureId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || region != null) {
      map['region'] = Variable<String>(region);
    }
    if (!nullToAbsent || license != null) {
      map['license'] = Variable<String>(license);
    }
    if (!nullToAbsent || source != null) {
      map['source'] = Variable<String>(source);
    }
    return map;
  }

  SkyCulturesCompanion toCompanion(bool nullToAbsent) {
    return SkyCulturesCompanion(
      cultureId: Value(cultureId),
      name: Value(name),
      region:
          region == null && nullToAbsent ? const Value.absent() : Value(region),
      license: license == null && nullToAbsent
          ? const Value.absent()
          : Value(license),
      source:
          source == null && nullToAbsent ? const Value.absent() : Value(source),
    );
  }

  factory SkyCulture.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SkyCulture(
      cultureId: serializer.fromJson<int>(json['cultureId']),
      name: serializer.fromJson<String>(json['name']),
      region: serializer.fromJson<String?>(json['region']),
      license: serializer.fromJson<String?>(json['license']),
      source: serializer.fromJson<String?>(json['source']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'cultureId': serializer.toJson<int>(cultureId),
      'name': serializer.toJson<String>(name),
      'region': serializer.toJson<String?>(region),
      'license': serializer.toJson<String?>(license),
      'source': serializer.toJson<String?>(source),
    };
  }

  SkyCulture copyWith(
          {int? cultureId,
          String? name,
          Value<String?> region = const Value.absent(),
          Value<String?> license = const Value.absent(),
          Value<String?> source = const Value.absent()}) =>
      SkyCulture(
        cultureId: cultureId ?? this.cultureId,
        name: name ?? this.name,
        region: region.present ? region.value : this.region,
        license: license.present ? license.value : this.license,
        source: source.present ? source.value : this.source,
      );
  SkyCulture copyWithCompanion(SkyCulturesCompanion data) {
    return SkyCulture(
      cultureId: data.cultureId.present ? data.cultureId.value : this.cultureId,
      name: data.name.present ? data.name.value : this.name,
      region: data.region.present ? data.region.value : this.region,
      license: data.license.present ? data.license.value : this.license,
      source: data.source.present ? data.source.value : this.source,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SkyCulture(')
          ..write('cultureId: $cultureId, ')
          ..write('name: $name, ')
          ..write('region: $region, ')
          ..write('license: $license, ')
          ..write('source: $source')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(cultureId, name, region, license, source);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SkyCulture &&
          other.cultureId == this.cultureId &&
          other.name == this.name &&
          other.region == this.region &&
          other.license == this.license &&
          other.source == this.source);
}

class SkyCulturesCompanion extends UpdateCompanion<SkyCulture> {
  final Value<int> cultureId;
  final Value<String> name;
  final Value<String?> region;
  final Value<String?> license;
  final Value<String?> source;
  const SkyCulturesCompanion({
    this.cultureId = const Value.absent(),
    this.name = const Value.absent(),
    this.region = const Value.absent(),
    this.license = const Value.absent(),
    this.source = const Value.absent(),
  });
  SkyCulturesCompanion.insert({
    this.cultureId = const Value.absent(),
    required String name,
    this.region = const Value.absent(),
    this.license = const Value.absent(),
    this.source = const Value.absent(),
  }) : name = Value(name);
  static Insertable<SkyCulture> custom({
    Expression<int>? cultureId,
    Expression<String>? name,
    Expression<String>? region,
    Expression<String>? license,
    Expression<String>? source,
  }) {
    return RawValuesInsertable({
      if (cultureId != null) 'culture_id': cultureId,
      if (name != null) 'name': name,
      if (region != null) 'region': region,
      if (license != null) 'license': license,
      if (source != null) 'source': source,
    });
  }

  SkyCulturesCompanion copyWith(
      {Value<int>? cultureId,
      Value<String>? name,
      Value<String?>? region,
      Value<String?>? license,
      Value<String?>? source}) {
    return SkyCulturesCompanion(
      cultureId: cultureId ?? this.cultureId,
      name: name ?? this.name,
      region: region ?? this.region,
      license: license ?? this.license,
      source: source ?? this.source,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (cultureId.present) {
      map['culture_id'] = Variable<int>(cultureId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (region.present) {
      map['region'] = Variable<String>(region.value);
    }
    if (license.present) {
      map['license'] = Variable<String>(license.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SkyCulturesCompanion(')
          ..write('cultureId: $cultureId, ')
          ..write('name: $name, ')
          ..write('region: $region, ')
          ..write('license: $license, ')
          ..write('source: $source')
          ..write(')'))
        .toString();
  }
}

class $ConstellationLinesTable extends ConstellationLines
    with TableInfo<$ConstellationLinesTable, ConstellationLine> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConstellationLinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _lineIdMeta = const VerificationMeta('lineId');
  @override
  late final GeneratedColumn<int> lineId = GeneratedColumn<int>(
      'line_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _constCodeMeta =
      const VerificationMeta('constCode');
  @override
  late final GeneratedColumn<String> constCode = GeneratedColumn<String>(
      'const_code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _cultureIdMeta =
      const VerificationMeta('cultureId');
  @override
  late final GeneratedColumn<int> cultureId = GeneratedColumn<int>(
      'culture_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _starAMeta = const VerificationMeta('starA');
  @override
  late final GeneratedColumn<int> starA = GeneratedColumn<int>(
      'star_a', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _starBMeta = const VerificationMeta('starB');
  @override
  late final GeneratedColumn<int> starB = GeneratedColumn<int>(
      'star_b', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [lineId, constCode, cultureId, starA, starB];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'constellation_lines';
  @override
  VerificationContext validateIntegrity(Insertable<ConstellationLine> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('line_id')) {
      context.handle(_lineIdMeta,
          lineId.isAcceptableOrUnknown(data['line_id']!, _lineIdMeta));
    }
    if (data.containsKey('const_code')) {
      context.handle(_constCodeMeta,
          constCode.isAcceptableOrUnknown(data['const_code']!, _constCodeMeta));
    } else if (isInserting) {
      context.missing(_constCodeMeta);
    }
    if (data.containsKey('culture_id')) {
      context.handle(_cultureIdMeta,
          cultureId.isAcceptableOrUnknown(data['culture_id']!, _cultureIdMeta));
    } else if (isInserting) {
      context.missing(_cultureIdMeta);
    }
    if (data.containsKey('star_a')) {
      context.handle(
          _starAMeta, starA.isAcceptableOrUnknown(data['star_a']!, _starAMeta));
    } else if (isInserting) {
      context.missing(_starAMeta);
    }
    if (data.containsKey('star_b')) {
      context.handle(
          _starBMeta, starB.isAcceptableOrUnknown(data['star_b']!, _starBMeta));
    } else if (isInserting) {
      context.missing(_starBMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {lineId};
  @override
  ConstellationLine map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ConstellationLine(
      lineId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}line_id'])!,
      constCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}const_code'])!,
      cultureId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}culture_id'])!,
      starA: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}star_a'])!,
      starB: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}star_b'])!,
    );
  }

  @override
  $ConstellationLinesTable createAlias(String alias) {
    return $ConstellationLinesTable(attachedDatabase, alias);
  }
}

class ConstellationLine extends DataClass
    implements Insertable<ConstellationLine> {
  final int lineId;
  final String constCode;
  final int cultureId;
  final int starA;
  final int starB;
  const ConstellationLine(
      {required this.lineId,
      required this.constCode,
      required this.cultureId,
      required this.starA,
      required this.starB});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['line_id'] = Variable<int>(lineId);
    map['const_code'] = Variable<String>(constCode);
    map['culture_id'] = Variable<int>(cultureId);
    map['star_a'] = Variable<int>(starA);
    map['star_b'] = Variable<int>(starB);
    return map;
  }

  ConstellationLinesCompanion toCompanion(bool nullToAbsent) {
    return ConstellationLinesCompanion(
      lineId: Value(lineId),
      constCode: Value(constCode),
      cultureId: Value(cultureId),
      starA: Value(starA),
      starB: Value(starB),
    );
  }

  factory ConstellationLine.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ConstellationLine(
      lineId: serializer.fromJson<int>(json['lineId']),
      constCode: serializer.fromJson<String>(json['constCode']),
      cultureId: serializer.fromJson<int>(json['cultureId']),
      starA: serializer.fromJson<int>(json['starA']),
      starB: serializer.fromJson<int>(json['starB']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'lineId': serializer.toJson<int>(lineId),
      'constCode': serializer.toJson<String>(constCode),
      'cultureId': serializer.toJson<int>(cultureId),
      'starA': serializer.toJson<int>(starA),
      'starB': serializer.toJson<int>(starB),
    };
  }

  ConstellationLine copyWith(
          {int? lineId,
          String? constCode,
          int? cultureId,
          int? starA,
          int? starB}) =>
      ConstellationLine(
        lineId: lineId ?? this.lineId,
        constCode: constCode ?? this.constCode,
        cultureId: cultureId ?? this.cultureId,
        starA: starA ?? this.starA,
        starB: starB ?? this.starB,
      );
  ConstellationLine copyWithCompanion(ConstellationLinesCompanion data) {
    return ConstellationLine(
      lineId: data.lineId.present ? data.lineId.value : this.lineId,
      constCode: data.constCode.present ? data.constCode.value : this.constCode,
      cultureId: data.cultureId.present ? data.cultureId.value : this.cultureId,
      starA: data.starA.present ? data.starA.value : this.starA,
      starB: data.starB.present ? data.starB.value : this.starB,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ConstellationLine(')
          ..write('lineId: $lineId, ')
          ..write('constCode: $constCode, ')
          ..write('cultureId: $cultureId, ')
          ..write('starA: $starA, ')
          ..write('starB: $starB')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(lineId, constCode, cultureId, starA, starB);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ConstellationLine &&
          other.lineId == this.lineId &&
          other.constCode == this.constCode &&
          other.cultureId == this.cultureId &&
          other.starA == this.starA &&
          other.starB == this.starB);
}

class ConstellationLinesCompanion extends UpdateCompanion<ConstellationLine> {
  final Value<int> lineId;
  final Value<String> constCode;
  final Value<int> cultureId;
  final Value<int> starA;
  final Value<int> starB;
  const ConstellationLinesCompanion({
    this.lineId = const Value.absent(),
    this.constCode = const Value.absent(),
    this.cultureId = const Value.absent(),
    this.starA = const Value.absent(),
    this.starB = const Value.absent(),
  });
  ConstellationLinesCompanion.insert({
    this.lineId = const Value.absent(),
    required String constCode,
    required int cultureId,
    required int starA,
    required int starB,
  })  : constCode = Value(constCode),
        cultureId = Value(cultureId),
        starA = Value(starA),
        starB = Value(starB);
  static Insertable<ConstellationLine> custom({
    Expression<int>? lineId,
    Expression<String>? constCode,
    Expression<int>? cultureId,
    Expression<int>? starA,
    Expression<int>? starB,
  }) {
    return RawValuesInsertable({
      if (lineId != null) 'line_id': lineId,
      if (constCode != null) 'const_code': constCode,
      if (cultureId != null) 'culture_id': cultureId,
      if (starA != null) 'star_a': starA,
      if (starB != null) 'star_b': starB,
    });
  }

  ConstellationLinesCompanion copyWith(
      {Value<int>? lineId,
      Value<String>? constCode,
      Value<int>? cultureId,
      Value<int>? starA,
      Value<int>? starB}) {
    return ConstellationLinesCompanion(
      lineId: lineId ?? this.lineId,
      constCode: constCode ?? this.constCode,
      cultureId: cultureId ?? this.cultureId,
      starA: starA ?? this.starA,
      starB: starB ?? this.starB,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (lineId.present) {
      map['line_id'] = Variable<int>(lineId.value);
    }
    if (constCode.present) {
      map['const_code'] = Variable<String>(constCode.value);
    }
    if (cultureId.present) {
      map['culture_id'] = Variable<int>(cultureId.value);
    }
    if (starA.present) {
      map['star_a'] = Variable<int>(starA.value);
    }
    if (starB.present) {
      map['star_b'] = Variable<int>(starB.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ConstellationLinesCompanion(')
          ..write('lineId: $lineId, ')
          ..write('constCode: $constCode, ')
          ..write('cultureId: $cultureId, ')
          ..write('starA: $starA, ')
          ..write('starB: $starB')
          ..write(')'))
        .toString();
  }
}

class $ConstellationNamesTable extends ConstellationNames
    with TableInfo<$ConstellationNamesTable, ConstellationName> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConstellationNamesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _nameIdMeta = const VerificationMeta('nameId');
  @override
  late final GeneratedColumn<int> nameId = GeneratedColumn<int>(
      'name_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _constCodeMeta =
      const VerificationMeta('constCode');
  @override
  late final GeneratedColumn<String> constCode = GeneratedColumn<String>(
      'const_code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _cultureIdMeta =
      const VerificationMeta('cultureId');
  @override
  late final GeneratedColumn<int> cultureId = GeneratedColumn<int>(
      'culture_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _languageMeta =
      const VerificationMeta('language');
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
      'language', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _localNameMeta =
      const VerificationMeta('localName');
  @override
  late final GeneratedColumn<String> localName = GeneratedColumn<String>(
      'local_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _pronunciationNoteMeta =
      const VerificationMeta('pronunciationNote');
  @override
  late final GeneratedColumn<String> pronunciationNote =
      GeneratedColumn<String>('pronunciation_note', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [nameId, constCode, cultureId, language, localName, pronunciationNote];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'constellation_names';
  @override
  VerificationContext validateIntegrity(Insertable<ConstellationName> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('name_id')) {
      context.handle(_nameIdMeta,
          nameId.isAcceptableOrUnknown(data['name_id']!, _nameIdMeta));
    }
    if (data.containsKey('const_code')) {
      context.handle(_constCodeMeta,
          constCode.isAcceptableOrUnknown(data['const_code']!, _constCodeMeta));
    } else if (isInserting) {
      context.missing(_constCodeMeta);
    }
    if (data.containsKey('culture_id')) {
      context.handle(_cultureIdMeta,
          cultureId.isAcceptableOrUnknown(data['culture_id']!, _cultureIdMeta));
    } else if (isInserting) {
      context.missing(_cultureIdMeta);
    }
    if (data.containsKey('language')) {
      context.handle(_languageMeta,
          language.isAcceptableOrUnknown(data['language']!, _languageMeta));
    } else if (isInserting) {
      context.missing(_languageMeta);
    }
    if (data.containsKey('local_name')) {
      context.handle(_localNameMeta,
          localName.isAcceptableOrUnknown(data['local_name']!, _localNameMeta));
    } else if (isInserting) {
      context.missing(_localNameMeta);
    }
    if (data.containsKey('pronunciation_note')) {
      context.handle(
          _pronunciationNoteMeta,
          pronunciationNote.isAcceptableOrUnknown(
              data['pronunciation_note']!, _pronunciationNoteMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {nameId};
  @override
  ConstellationName map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ConstellationName(
      nameId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}name_id'])!,
      constCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}const_code'])!,
      cultureId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}culture_id'])!,
      language: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}language'])!,
      localName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}local_name'])!,
      pronunciationNote: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}pronunciation_note']),
    );
  }

  @override
  $ConstellationNamesTable createAlias(String alias) {
    return $ConstellationNamesTable(attachedDatabase, alias);
  }
}

class ConstellationName extends DataClass
    implements Insertable<ConstellationName> {
  final int nameId;
  final String constCode;
  final int cultureId;
  final String language;
  final String localName;
  final String? pronunciationNote;
  const ConstellationName(
      {required this.nameId,
      required this.constCode,
      required this.cultureId,
      required this.language,
      required this.localName,
      this.pronunciationNote});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['name_id'] = Variable<int>(nameId);
    map['const_code'] = Variable<String>(constCode);
    map['culture_id'] = Variable<int>(cultureId);
    map['language'] = Variable<String>(language);
    map['local_name'] = Variable<String>(localName);
    if (!nullToAbsent || pronunciationNote != null) {
      map['pronunciation_note'] = Variable<String>(pronunciationNote);
    }
    return map;
  }

  ConstellationNamesCompanion toCompanion(bool nullToAbsent) {
    return ConstellationNamesCompanion(
      nameId: Value(nameId),
      constCode: Value(constCode),
      cultureId: Value(cultureId),
      language: Value(language),
      localName: Value(localName),
      pronunciationNote: pronunciationNote == null && nullToAbsent
          ? const Value.absent()
          : Value(pronunciationNote),
    );
  }

  factory ConstellationName.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ConstellationName(
      nameId: serializer.fromJson<int>(json['nameId']),
      constCode: serializer.fromJson<String>(json['constCode']),
      cultureId: serializer.fromJson<int>(json['cultureId']),
      language: serializer.fromJson<String>(json['language']),
      localName: serializer.fromJson<String>(json['localName']),
      pronunciationNote:
          serializer.fromJson<String?>(json['pronunciationNote']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'nameId': serializer.toJson<int>(nameId),
      'constCode': serializer.toJson<String>(constCode),
      'cultureId': serializer.toJson<int>(cultureId),
      'language': serializer.toJson<String>(language),
      'localName': serializer.toJson<String>(localName),
      'pronunciationNote': serializer.toJson<String?>(pronunciationNote),
    };
  }

  ConstellationName copyWith(
          {int? nameId,
          String? constCode,
          int? cultureId,
          String? language,
          String? localName,
          Value<String?> pronunciationNote = const Value.absent()}) =>
      ConstellationName(
        nameId: nameId ?? this.nameId,
        constCode: constCode ?? this.constCode,
        cultureId: cultureId ?? this.cultureId,
        language: language ?? this.language,
        localName: localName ?? this.localName,
        pronunciationNote: pronunciationNote.present
            ? pronunciationNote.value
            : this.pronunciationNote,
      );
  ConstellationName copyWithCompanion(ConstellationNamesCompanion data) {
    return ConstellationName(
      nameId: data.nameId.present ? data.nameId.value : this.nameId,
      constCode: data.constCode.present ? data.constCode.value : this.constCode,
      cultureId: data.cultureId.present ? data.cultureId.value : this.cultureId,
      language: data.language.present ? data.language.value : this.language,
      localName: data.localName.present ? data.localName.value : this.localName,
      pronunciationNote: data.pronunciationNote.present
          ? data.pronunciationNote.value
          : this.pronunciationNote,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ConstellationName(')
          ..write('nameId: $nameId, ')
          ..write('constCode: $constCode, ')
          ..write('cultureId: $cultureId, ')
          ..write('language: $language, ')
          ..write('localName: $localName, ')
          ..write('pronunciationNote: $pronunciationNote')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      nameId, constCode, cultureId, language, localName, pronunciationNote);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ConstellationName &&
          other.nameId == this.nameId &&
          other.constCode == this.constCode &&
          other.cultureId == this.cultureId &&
          other.language == this.language &&
          other.localName == this.localName &&
          other.pronunciationNote == this.pronunciationNote);
}

class ConstellationNamesCompanion extends UpdateCompanion<ConstellationName> {
  final Value<int> nameId;
  final Value<String> constCode;
  final Value<int> cultureId;
  final Value<String> language;
  final Value<String> localName;
  final Value<String?> pronunciationNote;
  const ConstellationNamesCompanion({
    this.nameId = const Value.absent(),
    this.constCode = const Value.absent(),
    this.cultureId = const Value.absent(),
    this.language = const Value.absent(),
    this.localName = const Value.absent(),
    this.pronunciationNote = const Value.absent(),
  });
  ConstellationNamesCompanion.insert({
    this.nameId = const Value.absent(),
    required String constCode,
    required int cultureId,
    required String language,
    required String localName,
    this.pronunciationNote = const Value.absent(),
  })  : constCode = Value(constCode),
        cultureId = Value(cultureId),
        language = Value(language),
        localName = Value(localName);
  static Insertable<ConstellationName> custom({
    Expression<int>? nameId,
    Expression<String>? constCode,
    Expression<int>? cultureId,
    Expression<String>? language,
    Expression<String>? localName,
    Expression<String>? pronunciationNote,
  }) {
    return RawValuesInsertable({
      if (nameId != null) 'name_id': nameId,
      if (constCode != null) 'const_code': constCode,
      if (cultureId != null) 'culture_id': cultureId,
      if (language != null) 'language': language,
      if (localName != null) 'local_name': localName,
      if (pronunciationNote != null) 'pronunciation_note': pronunciationNote,
    });
  }

  ConstellationNamesCompanion copyWith(
      {Value<int>? nameId,
      Value<String>? constCode,
      Value<int>? cultureId,
      Value<String>? language,
      Value<String>? localName,
      Value<String?>? pronunciationNote}) {
    return ConstellationNamesCompanion(
      nameId: nameId ?? this.nameId,
      constCode: constCode ?? this.constCode,
      cultureId: cultureId ?? this.cultureId,
      language: language ?? this.language,
      localName: localName ?? this.localName,
      pronunciationNote: pronunciationNote ?? this.pronunciationNote,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (nameId.present) {
      map['name_id'] = Variable<int>(nameId.value);
    }
    if (constCode.present) {
      map['const_code'] = Variable<String>(constCode.value);
    }
    if (cultureId.present) {
      map['culture_id'] = Variable<int>(cultureId.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (localName.present) {
      map['local_name'] = Variable<String>(localName.value);
    }
    if (pronunciationNote.present) {
      map['pronunciation_note'] = Variable<String>(pronunciationNote.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ConstellationNamesCompanion(')
          ..write('nameId: $nameId, ')
          ..write('constCode: $constCode, ')
          ..write('cultureId: $cultureId, ')
          ..write('language: $language, ')
          ..write('localName: $localName, ')
          ..write('pronunciationNote: $pronunciationNote')
          ..write(')'))
        .toString();
  }
}

class $TimezonesTable extends Timezones
    with TableInfo<$TimezonesTable, Timezone> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TimezonesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _zoneIdMeta = const VerificationMeta('zoneId');
  @override
  late final GeneratedColumn<String> zoneId = GeneratedColumn<String>(
      'zone_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _rulesJsonMeta =
      const VerificationMeta('rulesJson');
  @override
  late final GeneratedColumn<String> rulesJson = GeneratedColumn<String>(
      'rules_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [zoneId, rulesJson];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'timezones';
  @override
  VerificationContext validateIntegrity(Insertable<Timezone> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('zone_id')) {
      context.handle(_zoneIdMeta,
          zoneId.isAcceptableOrUnknown(data['zone_id']!, _zoneIdMeta));
    } else if (isInserting) {
      context.missing(_zoneIdMeta);
    }
    if (data.containsKey('rules_json')) {
      context.handle(_rulesJsonMeta,
          rulesJson.isAcceptableOrUnknown(data['rules_json']!, _rulesJsonMeta));
    } else if (isInserting) {
      context.missing(_rulesJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {zoneId};
  @override
  Timezone map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Timezone(
      zoneId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}zone_id'])!,
      rulesJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}rules_json'])!,
    );
  }

  @override
  $TimezonesTable createAlias(String alias) {
    return $TimezonesTable(attachedDatabase, alias);
  }
}

class Timezone extends DataClass implements Insertable<Timezone> {
  final String zoneId;
  final String rulesJson;
  const Timezone({required this.zoneId, required this.rulesJson});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['zone_id'] = Variable<String>(zoneId);
    map['rules_json'] = Variable<String>(rulesJson);
    return map;
  }

  TimezonesCompanion toCompanion(bool nullToAbsent) {
    return TimezonesCompanion(
      zoneId: Value(zoneId),
      rulesJson: Value(rulesJson),
    );
  }

  factory Timezone.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Timezone(
      zoneId: serializer.fromJson<String>(json['zoneId']),
      rulesJson: serializer.fromJson<String>(json['rulesJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'zoneId': serializer.toJson<String>(zoneId),
      'rulesJson': serializer.toJson<String>(rulesJson),
    };
  }

  Timezone copyWith({String? zoneId, String? rulesJson}) => Timezone(
        zoneId: zoneId ?? this.zoneId,
        rulesJson: rulesJson ?? this.rulesJson,
      );
  Timezone copyWithCompanion(TimezonesCompanion data) {
    return Timezone(
      zoneId: data.zoneId.present ? data.zoneId.value : this.zoneId,
      rulesJson: data.rulesJson.present ? data.rulesJson.value : this.rulesJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Timezone(')
          ..write('zoneId: $zoneId, ')
          ..write('rulesJson: $rulesJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(zoneId, rulesJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Timezone &&
          other.zoneId == this.zoneId &&
          other.rulesJson == this.rulesJson);
}

class TimezonesCompanion extends UpdateCompanion<Timezone> {
  final Value<String> zoneId;
  final Value<String> rulesJson;
  final Value<int> rowid;
  const TimezonesCompanion({
    this.zoneId = const Value.absent(),
    this.rulesJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TimezonesCompanion.insert({
    required String zoneId,
    required String rulesJson,
    this.rowid = const Value.absent(),
  })  : zoneId = Value(zoneId),
        rulesJson = Value(rulesJson);
  static Insertable<Timezone> custom({
    Expression<String>? zoneId,
    Expression<String>? rulesJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (zoneId != null) 'zone_id': zoneId,
      if (rulesJson != null) 'rules_json': rulesJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TimezonesCompanion copyWith(
      {Value<String>? zoneId, Value<String>? rulesJson, Value<int>? rowid}) {
    return TimezonesCompanion(
      zoneId: zoneId ?? this.zoneId,
      rulesJson: rulesJson ?? this.rulesJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (zoneId.present) {
      map['zone_id'] = Variable<String>(zoneId.value);
    }
    if (rulesJson.present) {
      map['rules_json'] = Variable<String>(rulesJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TimezonesCompanion(')
          ..write('zoneId: $zoneId, ')
          ..write('rulesJson: $rulesJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PlacesTable extends Places with TableInfo<$PlacesTable, Place> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlacesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _geonameIdMeta =
      const VerificationMeta('geonameId');
  @override
  late final GeneratedColumn<int> geonameId = GeneratedColumn<int>(
      'geoname_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _altNamesMeta =
      const VerificationMeta('altNames');
  @override
  late final GeneratedColumn<String> altNames = GeneratedColumn<String>(
      'alt_names', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _provinceMeta =
      const VerificationMeta('province');
  @override
  late final GeneratedColumn<String> province = GeneratedColumn<String>(
      'province', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _countryMeta =
      const VerificationMeta('country');
  @override
  late final GeneratedColumn<String> country = GeneratedColumn<String>(
      'country', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
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
  static const VerificationMeta _timezoneIdMeta =
      const VerificationMeta('timezoneId');
  @override
  late final GeneratedColumn<String> timezoneId = GeneratedColumn<String>(
      'timezone_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _populationMeta =
      const VerificationMeta('population');
  @override
  late final GeneratedColumn<int> population = GeneratedColumn<int>(
      'population', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        geonameId,
        name,
        altNames,
        province,
        country,
        lat,
        lon,
        timezoneId,
        population
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'places';
  @override
  VerificationContext validateIntegrity(Insertable<Place> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('geoname_id')) {
      context.handle(_geonameIdMeta,
          geonameId.isAcceptableOrUnknown(data['geoname_id']!, _geonameIdMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('alt_names')) {
      context.handle(_altNamesMeta,
          altNames.isAcceptableOrUnknown(data['alt_names']!, _altNamesMeta));
    }
    if (data.containsKey('province')) {
      context.handle(_provinceMeta,
          province.isAcceptableOrUnknown(data['province']!, _provinceMeta));
    }
    if (data.containsKey('country')) {
      context.handle(_countryMeta,
          country.isAcceptableOrUnknown(data['country']!, _countryMeta));
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
    if (data.containsKey('timezone_id')) {
      context.handle(
          _timezoneIdMeta,
          timezoneId.isAcceptableOrUnknown(
              data['timezone_id']!, _timezoneIdMeta));
    } else if (isInserting) {
      context.missing(_timezoneIdMeta);
    }
    if (data.containsKey('population')) {
      context.handle(
          _populationMeta,
          population.isAcceptableOrUnknown(
              data['population']!, _populationMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {geonameId};
  @override
  Place map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Place(
      geonameId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}geoname_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      altNames: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}alt_names']),
      province: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}province']),
      country: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}country']),
      lat: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}lat'])!,
      lon: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}lon'])!,
      timezoneId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}timezone_id'])!,
      population: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}population']),
    );
  }

  @override
  $PlacesTable createAlias(String alias) {
    return $PlacesTable(attachedDatabase, alias);
  }
}

class Place extends DataClass implements Insertable<Place> {
  final int geonameId;
  final String name;
  final String? altNames;
  final String? province;
  final String? country;
  final double lat;
  final double lon;
  final String timezoneId;
  final int? population;
  const Place(
      {required this.geonameId,
      required this.name,
      this.altNames,
      this.province,
      this.country,
      required this.lat,
      required this.lon,
      required this.timezoneId,
      this.population});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['geoname_id'] = Variable<int>(geonameId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || altNames != null) {
      map['alt_names'] = Variable<String>(altNames);
    }
    if (!nullToAbsent || province != null) {
      map['province'] = Variable<String>(province);
    }
    if (!nullToAbsent || country != null) {
      map['country'] = Variable<String>(country);
    }
    map['lat'] = Variable<double>(lat);
    map['lon'] = Variable<double>(lon);
    map['timezone_id'] = Variable<String>(timezoneId);
    if (!nullToAbsent || population != null) {
      map['population'] = Variable<int>(population);
    }
    return map;
  }

  PlacesCompanion toCompanion(bool nullToAbsent) {
    return PlacesCompanion(
      geonameId: Value(geonameId),
      name: Value(name),
      altNames: altNames == null && nullToAbsent
          ? const Value.absent()
          : Value(altNames),
      province: province == null && nullToAbsent
          ? const Value.absent()
          : Value(province),
      country: country == null && nullToAbsent
          ? const Value.absent()
          : Value(country),
      lat: Value(lat),
      lon: Value(lon),
      timezoneId: Value(timezoneId),
      population: population == null && nullToAbsent
          ? const Value.absent()
          : Value(population),
    );
  }

  factory Place.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Place(
      geonameId: serializer.fromJson<int>(json['geonameId']),
      name: serializer.fromJson<String>(json['name']),
      altNames: serializer.fromJson<String?>(json['altNames']),
      province: serializer.fromJson<String?>(json['province']),
      country: serializer.fromJson<String?>(json['country']),
      lat: serializer.fromJson<double>(json['lat']),
      lon: serializer.fromJson<double>(json['lon']),
      timezoneId: serializer.fromJson<String>(json['timezoneId']),
      population: serializer.fromJson<int?>(json['population']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'geonameId': serializer.toJson<int>(geonameId),
      'name': serializer.toJson<String>(name),
      'altNames': serializer.toJson<String?>(altNames),
      'province': serializer.toJson<String?>(province),
      'country': serializer.toJson<String?>(country),
      'lat': serializer.toJson<double>(lat),
      'lon': serializer.toJson<double>(lon),
      'timezoneId': serializer.toJson<String>(timezoneId),
      'population': serializer.toJson<int?>(population),
    };
  }

  Place copyWith(
          {int? geonameId,
          String? name,
          Value<String?> altNames = const Value.absent(),
          Value<String?> province = const Value.absent(),
          Value<String?> country = const Value.absent(),
          double? lat,
          double? lon,
          String? timezoneId,
          Value<int?> population = const Value.absent()}) =>
      Place(
        geonameId: geonameId ?? this.geonameId,
        name: name ?? this.name,
        altNames: altNames.present ? altNames.value : this.altNames,
        province: province.present ? province.value : this.province,
        country: country.present ? country.value : this.country,
        lat: lat ?? this.lat,
        lon: lon ?? this.lon,
        timezoneId: timezoneId ?? this.timezoneId,
        population: population.present ? population.value : this.population,
      );
  Place copyWithCompanion(PlacesCompanion data) {
    return Place(
      geonameId: data.geonameId.present ? data.geonameId.value : this.geonameId,
      name: data.name.present ? data.name.value : this.name,
      altNames: data.altNames.present ? data.altNames.value : this.altNames,
      province: data.province.present ? data.province.value : this.province,
      country: data.country.present ? data.country.value : this.country,
      lat: data.lat.present ? data.lat.value : this.lat,
      lon: data.lon.present ? data.lon.value : this.lon,
      timezoneId:
          data.timezoneId.present ? data.timezoneId.value : this.timezoneId,
      population:
          data.population.present ? data.population.value : this.population,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Place(')
          ..write('geonameId: $geonameId, ')
          ..write('name: $name, ')
          ..write('altNames: $altNames, ')
          ..write('province: $province, ')
          ..write('country: $country, ')
          ..write('lat: $lat, ')
          ..write('lon: $lon, ')
          ..write('timezoneId: $timezoneId, ')
          ..write('population: $population')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(geonameId, name, altNames, province, country,
      lat, lon, timezoneId, population);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Place &&
          other.geonameId == this.geonameId &&
          other.name == this.name &&
          other.altNames == this.altNames &&
          other.province == this.province &&
          other.country == this.country &&
          other.lat == this.lat &&
          other.lon == this.lon &&
          other.timezoneId == this.timezoneId &&
          other.population == this.population);
}

class PlacesCompanion extends UpdateCompanion<Place> {
  final Value<int> geonameId;
  final Value<String> name;
  final Value<String?> altNames;
  final Value<String?> province;
  final Value<String?> country;
  final Value<double> lat;
  final Value<double> lon;
  final Value<String> timezoneId;
  final Value<int?> population;
  const PlacesCompanion({
    this.geonameId = const Value.absent(),
    this.name = const Value.absent(),
    this.altNames = const Value.absent(),
    this.province = const Value.absent(),
    this.country = const Value.absent(),
    this.lat = const Value.absent(),
    this.lon = const Value.absent(),
    this.timezoneId = const Value.absent(),
    this.population = const Value.absent(),
  });
  PlacesCompanion.insert({
    this.geonameId = const Value.absent(),
    required String name,
    this.altNames = const Value.absent(),
    this.province = const Value.absent(),
    this.country = const Value.absent(),
    required double lat,
    required double lon,
    required String timezoneId,
    this.population = const Value.absent(),
  })  : name = Value(name),
        lat = Value(lat),
        lon = Value(lon),
        timezoneId = Value(timezoneId);
  static Insertable<Place> custom({
    Expression<int>? geonameId,
    Expression<String>? name,
    Expression<String>? altNames,
    Expression<String>? province,
    Expression<String>? country,
    Expression<double>? lat,
    Expression<double>? lon,
    Expression<String>? timezoneId,
    Expression<int>? population,
  }) {
    return RawValuesInsertable({
      if (geonameId != null) 'geoname_id': geonameId,
      if (name != null) 'name': name,
      if (altNames != null) 'alt_names': altNames,
      if (province != null) 'province': province,
      if (country != null) 'country': country,
      if (lat != null) 'lat': lat,
      if (lon != null) 'lon': lon,
      if (timezoneId != null) 'timezone_id': timezoneId,
      if (population != null) 'population': population,
    });
  }

  PlacesCompanion copyWith(
      {Value<int>? geonameId,
      Value<String>? name,
      Value<String?>? altNames,
      Value<String?>? province,
      Value<String?>? country,
      Value<double>? lat,
      Value<double>? lon,
      Value<String>? timezoneId,
      Value<int?>? population}) {
    return PlacesCompanion(
      geonameId: geonameId ?? this.geonameId,
      name: name ?? this.name,
      altNames: altNames ?? this.altNames,
      province: province ?? this.province,
      country: country ?? this.country,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      timezoneId: timezoneId ?? this.timezoneId,
      population: population ?? this.population,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (geonameId.present) {
      map['geoname_id'] = Variable<int>(geonameId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (altNames.present) {
      map['alt_names'] = Variable<String>(altNames.value);
    }
    if (province.present) {
      map['province'] = Variable<String>(province.value);
    }
    if (country.present) {
      map['country'] = Variable<String>(country.value);
    }
    if (lat.present) {
      map['lat'] = Variable<double>(lat.value);
    }
    if (lon.present) {
      map['lon'] = Variable<double>(lon.value);
    }
    if (timezoneId.present) {
      map['timezone_id'] = Variable<String>(timezoneId.value);
    }
    if (population.present) {
      map['population'] = Variable<int>(population.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlacesCompanion(')
          ..write('geonameId: $geonameId, ')
          ..write('name: $name, ')
          ..write('altNames: $altNames, ')
          ..write('province: $province, ')
          ..write('country: $country, ')
          ..write('lat: $lat, ')
          ..write('lon: $lon, ')
          ..write('timezoneId: $timezoneId, ')
          ..write('population: $population')
          ..write(')'))
        .toString();
  }
}

abstract class _$ReferenceDb extends GeneratedDatabase {
  _$ReferenceDb(QueryExecutor e) : super(e);
  $ReferenceDbManager get managers => $ReferenceDbManager(this);
  late final $StarsTable stars = $StarsTable(this);
  late final $ConstellationsTable constellations = $ConstellationsTable(this);
  late final $SkyCulturesTable skyCultures = $SkyCulturesTable(this);
  late final $ConstellationLinesTable constellationLines =
      $ConstellationLinesTable(this);
  late final $ConstellationNamesTable constellationNames =
      $ConstellationNamesTable(this);
  late final $TimezonesTable timezones = $TimezonesTable(this);
  late final $PlacesTable places = $PlacesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        stars,
        constellations,
        skyCultures,
        constellationLines,
        constellationNames,
        timezones,
        places
      ];
}

typedef $$StarsTableCreateCompanionBuilder = StarsCompanion Function({
  Value<int> hipId,
  required double raDeg,
  required double decDeg,
  required double magnitude,
  Value<double?> colorIndex,
  Value<String?> properName,
});
typedef $$StarsTableUpdateCompanionBuilder = StarsCompanion Function({
  Value<int> hipId,
  Value<double> raDeg,
  Value<double> decDeg,
  Value<double> magnitude,
  Value<double?> colorIndex,
  Value<String?> properName,
});

class $$StarsTableFilterComposer extends Composer<_$ReferenceDb, $StarsTable> {
  $$StarsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get hipId => $composableBuilder(
      column: $table.hipId, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get raDeg => $composableBuilder(
      column: $table.raDeg, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get decDeg => $composableBuilder(
      column: $table.decDeg, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get magnitude => $composableBuilder(
      column: $table.magnitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get colorIndex => $composableBuilder(
      column: $table.colorIndex, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get properName => $composableBuilder(
      column: $table.properName, builder: (column) => ColumnFilters(column));
}

class $$StarsTableOrderingComposer
    extends Composer<_$ReferenceDb, $StarsTable> {
  $$StarsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get hipId => $composableBuilder(
      column: $table.hipId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get raDeg => $composableBuilder(
      column: $table.raDeg, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get decDeg => $composableBuilder(
      column: $table.decDeg, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get magnitude => $composableBuilder(
      column: $table.magnitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get colorIndex => $composableBuilder(
      column: $table.colorIndex, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get properName => $composableBuilder(
      column: $table.properName, builder: (column) => ColumnOrderings(column));
}

class $$StarsTableAnnotationComposer
    extends Composer<_$ReferenceDb, $StarsTable> {
  $$StarsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get hipId =>
      $composableBuilder(column: $table.hipId, builder: (column) => column);

  GeneratedColumn<double> get raDeg =>
      $composableBuilder(column: $table.raDeg, builder: (column) => column);

  GeneratedColumn<double> get decDeg =>
      $composableBuilder(column: $table.decDeg, builder: (column) => column);

  GeneratedColumn<double> get magnitude =>
      $composableBuilder(column: $table.magnitude, builder: (column) => column);

  GeneratedColumn<double> get colorIndex => $composableBuilder(
      column: $table.colorIndex, builder: (column) => column);

  GeneratedColumn<String> get properName => $composableBuilder(
      column: $table.properName, builder: (column) => column);
}

class $$StarsTableTableManager extends RootTableManager<
    _$ReferenceDb,
    $StarsTable,
    Star,
    $$StarsTableFilterComposer,
    $$StarsTableOrderingComposer,
    $$StarsTableAnnotationComposer,
    $$StarsTableCreateCompanionBuilder,
    $$StarsTableUpdateCompanionBuilder,
    (Star, BaseReferences<_$ReferenceDb, $StarsTable, Star>),
    Star,
    PrefetchHooks Function()> {
  $$StarsTableTableManager(_$ReferenceDb db, $StarsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StarsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StarsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StarsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> hipId = const Value.absent(),
            Value<double> raDeg = const Value.absent(),
            Value<double> decDeg = const Value.absent(),
            Value<double> magnitude = const Value.absent(),
            Value<double?> colorIndex = const Value.absent(),
            Value<String?> properName = const Value.absent(),
          }) =>
              StarsCompanion(
            hipId: hipId,
            raDeg: raDeg,
            decDeg: decDeg,
            magnitude: magnitude,
            colorIndex: colorIndex,
            properName: properName,
          ),
          createCompanionCallback: ({
            Value<int> hipId = const Value.absent(),
            required double raDeg,
            required double decDeg,
            required double magnitude,
            Value<double?> colorIndex = const Value.absent(),
            Value<String?> properName = const Value.absent(),
          }) =>
              StarsCompanion.insert(
            hipId: hipId,
            raDeg: raDeg,
            decDeg: decDeg,
            magnitude: magnitude,
            colorIndex: colorIndex,
            properName: properName,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$StarsTableProcessedTableManager = ProcessedTableManager<
    _$ReferenceDb,
    $StarsTable,
    Star,
    $$StarsTableFilterComposer,
    $$StarsTableOrderingComposer,
    $$StarsTableAnnotationComposer,
    $$StarsTableCreateCompanionBuilder,
    $$StarsTableUpdateCompanionBuilder,
    (Star, BaseReferences<_$ReferenceDb, $StarsTable, Star>),
    Star,
    PrefetchHooks Function()>;
typedef $$ConstellationsTableCreateCompanionBuilder = ConstellationsCompanion
    Function({
  required String code,
  required String latinName,
  Value<double?> areaSqDeg,
  Value<double?> centerRa,
  Value<double?> centerDec,
  Value<int> rowid,
});
typedef $$ConstellationsTableUpdateCompanionBuilder = ConstellationsCompanion
    Function({
  Value<String> code,
  Value<String> latinName,
  Value<double?> areaSqDeg,
  Value<double?> centerRa,
  Value<double?> centerDec,
  Value<int> rowid,
});

class $$ConstellationsTableFilterComposer
    extends Composer<_$ReferenceDb, $ConstellationsTable> {
  $$ConstellationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get latinName => $composableBuilder(
      column: $table.latinName, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get areaSqDeg => $composableBuilder(
      column: $table.areaSqDeg, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get centerRa => $composableBuilder(
      column: $table.centerRa, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get centerDec => $composableBuilder(
      column: $table.centerDec, builder: (column) => ColumnFilters(column));
}

class $$ConstellationsTableOrderingComposer
    extends Composer<_$ReferenceDb, $ConstellationsTable> {
  $$ConstellationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get latinName => $composableBuilder(
      column: $table.latinName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get areaSqDeg => $composableBuilder(
      column: $table.areaSqDeg, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get centerRa => $composableBuilder(
      column: $table.centerRa, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get centerDec => $composableBuilder(
      column: $table.centerDec, builder: (column) => ColumnOrderings(column));
}

class $$ConstellationsTableAnnotationComposer
    extends Composer<_$ReferenceDb, $ConstellationsTable> {
  $$ConstellationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get latinName =>
      $composableBuilder(column: $table.latinName, builder: (column) => column);

  GeneratedColumn<double> get areaSqDeg =>
      $composableBuilder(column: $table.areaSqDeg, builder: (column) => column);

  GeneratedColumn<double> get centerRa =>
      $composableBuilder(column: $table.centerRa, builder: (column) => column);

  GeneratedColumn<double> get centerDec =>
      $composableBuilder(column: $table.centerDec, builder: (column) => column);
}

class $$ConstellationsTableTableManager extends RootTableManager<
    _$ReferenceDb,
    $ConstellationsTable,
    Constellation,
    $$ConstellationsTableFilterComposer,
    $$ConstellationsTableOrderingComposer,
    $$ConstellationsTableAnnotationComposer,
    $$ConstellationsTableCreateCompanionBuilder,
    $$ConstellationsTableUpdateCompanionBuilder,
    (
      Constellation,
      BaseReferences<_$ReferenceDb, $ConstellationsTable, Constellation>
    ),
    Constellation,
    PrefetchHooks Function()> {
  $$ConstellationsTableTableManager(
      _$ReferenceDb db, $ConstellationsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ConstellationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ConstellationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ConstellationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> code = const Value.absent(),
            Value<String> latinName = const Value.absent(),
            Value<double?> areaSqDeg = const Value.absent(),
            Value<double?> centerRa = const Value.absent(),
            Value<double?> centerDec = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ConstellationsCompanion(
            code: code,
            latinName: latinName,
            areaSqDeg: areaSqDeg,
            centerRa: centerRa,
            centerDec: centerDec,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String code,
            required String latinName,
            Value<double?> areaSqDeg = const Value.absent(),
            Value<double?> centerRa = const Value.absent(),
            Value<double?> centerDec = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ConstellationsCompanion.insert(
            code: code,
            latinName: latinName,
            areaSqDeg: areaSqDeg,
            centerRa: centerRa,
            centerDec: centerDec,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ConstellationsTableProcessedTableManager = ProcessedTableManager<
    _$ReferenceDb,
    $ConstellationsTable,
    Constellation,
    $$ConstellationsTableFilterComposer,
    $$ConstellationsTableOrderingComposer,
    $$ConstellationsTableAnnotationComposer,
    $$ConstellationsTableCreateCompanionBuilder,
    $$ConstellationsTableUpdateCompanionBuilder,
    (
      Constellation,
      BaseReferences<_$ReferenceDb, $ConstellationsTable, Constellation>
    ),
    Constellation,
    PrefetchHooks Function()>;
typedef $$SkyCulturesTableCreateCompanionBuilder = SkyCulturesCompanion
    Function({
  Value<int> cultureId,
  required String name,
  Value<String?> region,
  Value<String?> license,
  Value<String?> source,
});
typedef $$SkyCulturesTableUpdateCompanionBuilder = SkyCulturesCompanion
    Function({
  Value<int> cultureId,
  Value<String> name,
  Value<String?> region,
  Value<String?> license,
  Value<String?> source,
});

class $$SkyCulturesTableFilterComposer
    extends Composer<_$ReferenceDb, $SkyCulturesTable> {
  $$SkyCulturesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get cultureId => $composableBuilder(
      column: $table.cultureId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get region => $composableBuilder(
      column: $table.region, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get license => $composableBuilder(
      column: $table.license, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnFilters(column));
}

class $$SkyCulturesTableOrderingComposer
    extends Composer<_$ReferenceDb, $SkyCulturesTable> {
  $$SkyCulturesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get cultureId => $composableBuilder(
      column: $table.cultureId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get region => $composableBuilder(
      column: $table.region, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get license => $composableBuilder(
      column: $table.license, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnOrderings(column));
}

class $$SkyCulturesTableAnnotationComposer
    extends Composer<_$ReferenceDb, $SkyCulturesTable> {
  $$SkyCulturesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get cultureId =>
      $composableBuilder(column: $table.cultureId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get region =>
      $composableBuilder(column: $table.region, builder: (column) => column);

  GeneratedColumn<String> get license =>
      $composableBuilder(column: $table.license, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);
}

class $$SkyCulturesTableTableManager extends RootTableManager<
    _$ReferenceDb,
    $SkyCulturesTable,
    SkyCulture,
    $$SkyCulturesTableFilterComposer,
    $$SkyCulturesTableOrderingComposer,
    $$SkyCulturesTableAnnotationComposer,
    $$SkyCulturesTableCreateCompanionBuilder,
    $$SkyCulturesTableUpdateCompanionBuilder,
    (SkyCulture, BaseReferences<_$ReferenceDb, $SkyCulturesTable, SkyCulture>),
    SkyCulture,
    PrefetchHooks Function()> {
  $$SkyCulturesTableTableManager(_$ReferenceDb db, $SkyCulturesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SkyCulturesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SkyCulturesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SkyCulturesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> cultureId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> region = const Value.absent(),
            Value<String?> license = const Value.absent(),
            Value<String?> source = const Value.absent(),
          }) =>
              SkyCulturesCompanion(
            cultureId: cultureId,
            name: name,
            region: region,
            license: license,
            source: source,
          ),
          createCompanionCallback: ({
            Value<int> cultureId = const Value.absent(),
            required String name,
            Value<String?> region = const Value.absent(),
            Value<String?> license = const Value.absent(),
            Value<String?> source = const Value.absent(),
          }) =>
              SkyCulturesCompanion.insert(
            cultureId: cultureId,
            name: name,
            region: region,
            license: license,
            source: source,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SkyCulturesTableProcessedTableManager = ProcessedTableManager<
    _$ReferenceDb,
    $SkyCulturesTable,
    SkyCulture,
    $$SkyCulturesTableFilterComposer,
    $$SkyCulturesTableOrderingComposer,
    $$SkyCulturesTableAnnotationComposer,
    $$SkyCulturesTableCreateCompanionBuilder,
    $$SkyCulturesTableUpdateCompanionBuilder,
    (SkyCulture, BaseReferences<_$ReferenceDb, $SkyCulturesTable, SkyCulture>),
    SkyCulture,
    PrefetchHooks Function()>;
typedef $$ConstellationLinesTableCreateCompanionBuilder
    = ConstellationLinesCompanion Function({
  Value<int> lineId,
  required String constCode,
  required int cultureId,
  required int starA,
  required int starB,
});
typedef $$ConstellationLinesTableUpdateCompanionBuilder
    = ConstellationLinesCompanion Function({
  Value<int> lineId,
  Value<String> constCode,
  Value<int> cultureId,
  Value<int> starA,
  Value<int> starB,
});

class $$ConstellationLinesTableFilterComposer
    extends Composer<_$ReferenceDb, $ConstellationLinesTable> {
  $$ConstellationLinesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get lineId => $composableBuilder(
      column: $table.lineId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get constCode => $composableBuilder(
      column: $table.constCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get cultureId => $composableBuilder(
      column: $table.cultureId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get starA => $composableBuilder(
      column: $table.starA, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get starB => $composableBuilder(
      column: $table.starB, builder: (column) => ColumnFilters(column));
}

class $$ConstellationLinesTableOrderingComposer
    extends Composer<_$ReferenceDb, $ConstellationLinesTable> {
  $$ConstellationLinesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get lineId => $composableBuilder(
      column: $table.lineId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get constCode => $composableBuilder(
      column: $table.constCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get cultureId => $composableBuilder(
      column: $table.cultureId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get starA => $composableBuilder(
      column: $table.starA, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get starB => $composableBuilder(
      column: $table.starB, builder: (column) => ColumnOrderings(column));
}

class $$ConstellationLinesTableAnnotationComposer
    extends Composer<_$ReferenceDb, $ConstellationLinesTable> {
  $$ConstellationLinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get lineId =>
      $composableBuilder(column: $table.lineId, builder: (column) => column);

  GeneratedColumn<String> get constCode =>
      $composableBuilder(column: $table.constCode, builder: (column) => column);

  GeneratedColumn<int> get cultureId =>
      $composableBuilder(column: $table.cultureId, builder: (column) => column);

  GeneratedColumn<int> get starA =>
      $composableBuilder(column: $table.starA, builder: (column) => column);

  GeneratedColumn<int> get starB =>
      $composableBuilder(column: $table.starB, builder: (column) => column);
}

class $$ConstellationLinesTableTableManager extends RootTableManager<
    _$ReferenceDb,
    $ConstellationLinesTable,
    ConstellationLine,
    $$ConstellationLinesTableFilterComposer,
    $$ConstellationLinesTableOrderingComposer,
    $$ConstellationLinesTableAnnotationComposer,
    $$ConstellationLinesTableCreateCompanionBuilder,
    $$ConstellationLinesTableUpdateCompanionBuilder,
    (
      ConstellationLine,
      BaseReferences<_$ReferenceDb, $ConstellationLinesTable, ConstellationLine>
    ),
    ConstellationLine,
    PrefetchHooks Function()> {
  $$ConstellationLinesTableTableManager(
      _$ReferenceDb db, $ConstellationLinesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ConstellationLinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ConstellationLinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ConstellationLinesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> lineId = const Value.absent(),
            Value<String> constCode = const Value.absent(),
            Value<int> cultureId = const Value.absent(),
            Value<int> starA = const Value.absent(),
            Value<int> starB = const Value.absent(),
          }) =>
              ConstellationLinesCompanion(
            lineId: lineId,
            constCode: constCode,
            cultureId: cultureId,
            starA: starA,
            starB: starB,
          ),
          createCompanionCallback: ({
            Value<int> lineId = const Value.absent(),
            required String constCode,
            required int cultureId,
            required int starA,
            required int starB,
          }) =>
              ConstellationLinesCompanion.insert(
            lineId: lineId,
            constCode: constCode,
            cultureId: cultureId,
            starA: starA,
            starB: starB,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ConstellationLinesTableProcessedTableManager = ProcessedTableManager<
    _$ReferenceDb,
    $ConstellationLinesTable,
    ConstellationLine,
    $$ConstellationLinesTableFilterComposer,
    $$ConstellationLinesTableOrderingComposer,
    $$ConstellationLinesTableAnnotationComposer,
    $$ConstellationLinesTableCreateCompanionBuilder,
    $$ConstellationLinesTableUpdateCompanionBuilder,
    (
      ConstellationLine,
      BaseReferences<_$ReferenceDb, $ConstellationLinesTable, ConstellationLine>
    ),
    ConstellationLine,
    PrefetchHooks Function()>;
typedef $$ConstellationNamesTableCreateCompanionBuilder
    = ConstellationNamesCompanion Function({
  Value<int> nameId,
  required String constCode,
  required int cultureId,
  required String language,
  required String localName,
  Value<String?> pronunciationNote,
});
typedef $$ConstellationNamesTableUpdateCompanionBuilder
    = ConstellationNamesCompanion Function({
  Value<int> nameId,
  Value<String> constCode,
  Value<int> cultureId,
  Value<String> language,
  Value<String> localName,
  Value<String?> pronunciationNote,
});

class $$ConstellationNamesTableFilterComposer
    extends Composer<_$ReferenceDb, $ConstellationNamesTable> {
  $$ConstellationNamesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get nameId => $composableBuilder(
      column: $table.nameId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get constCode => $composableBuilder(
      column: $table.constCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get cultureId => $composableBuilder(
      column: $table.cultureId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get language => $composableBuilder(
      column: $table.language, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get localName => $composableBuilder(
      column: $table.localName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pronunciationNote => $composableBuilder(
      column: $table.pronunciationNote,
      builder: (column) => ColumnFilters(column));
}

class $$ConstellationNamesTableOrderingComposer
    extends Composer<_$ReferenceDb, $ConstellationNamesTable> {
  $$ConstellationNamesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get nameId => $composableBuilder(
      column: $table.nameId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get constCode => $composableBuilder(
      column: $table.constCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get cultureId => $composableBuilder(
      column: $table.cultureId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get language => $composableBuilder(
      column: $table.language, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get localName => $composableBuilder(
      column: $table.localName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pronunciationNote => $composableBuilder(
      column: $table.pronunciationNote,
      builder: (column) => ColumnOrderings(column));
}

class $$ConstellationNamesTableAnnotationComposer
    extends Composer<_$ReferenceDb, $ConstellationNamesTable> {
  $$ConstellationNamesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get nameId =>
      $composableBuilder(column: $table.nameId, builder: (column) => column);

  GeneratedColumn<String> get constCode =>
      $composableBuilder(column: $table.constCode, builder: (column) => column);

  GeneratedColumn<int> get cultureId =>
      $composableBuilder(column: $table.cultureId, builder: (column) => column);

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<String> get localName =>
      $composableBuilder(column: $table.localName, builder: (column) => column);

  GeneratedColumn<String> get pronunciationNote => $composableBuilder(
      column: $table.pronunciationNote, builder: (column) => column);
}

class $$ConstellationNamesTableTableManager extends RootTableManager<
    _$ReferenceDb,
    $ConstellationNamesTable,
    ConstellationName,
    $$ConstellationNamesTableFilterComposer,
    $$ConstellationNamesTableOrderingComposer,
    $$ConstellationNamesTableAnnotationComposer,
    $$ConstellationNamesTableCreateCompanionBuilder,
    $$ConstellationNamesTableUpdateCompanionBuilder,
    (
      ConstellationName,
      BaseReferences<_$ReferenceDb, $ConstellationNamesTable, ConstellationName>
    ),
    ConstellationName,
    PrefetchHooks Function()> {
  $$ConstellationNamesTableTableManager(
      _$ReferenceDb db, $ConstellationNamesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ConstellationNamesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ConstellationNamesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ConstellationNamesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> nameId = const Value.absent(),
            Value<String> constCode = const Value.absent(),
            Value<int> cultureId = const Value.absent(),
            Value<String> language = const Value.absent(),
            Value<String> localName = const Value.absent(),
            Value<String?> pronunciationNote = const Value.absent(),
          }) =>
              ConstellationNamesCompanion(
            nameId: nameId,
            constCode: constCode,
            cultureId: cultureId,
            language: language,
            localName: localName,
            pronunciationNote: pronunciationNote,
          ),
          createCompanionCallback: ({
            Value<int> nameId = const Value.absent(),
            required String constCode,
            required int cultureId,
            required String language,
            required String localName,
            Value<String?> pronunciationNote = const Value.absent(),
          }) =>
              ConstellationNamesCompanion.insert(
            nameId: nameId,
            constCode: constCode,
            cultureId: cultureId,
            language: language,
            localName: localName,
            pronunciationNote: pronunciationNote,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ConstellationNamesTableProcessedTableManager = ProcessedTableManager<
    _$ReferenceDb,
    $ConstellationNamesTable,
    ConstellationName,
    $$ConstellationNamesTableFilterComposer,
    $$ConstellationNamesTableOrderingComposer,
    $$ConstellationNamesTableAnnotationComposer,
    $$ConstellationNamesTableCreateCompanionBuilder,
    $$ConstellationNamesTableUpdateCompanionBuilder,
    (
      ConstellationName,
      BaseReferences<_$ReferenceDb, $ConstellationNamesTable, ConstellationName>
    ),
    ConstellationName,
    PrefetchHooks Function()>;
typedef $$TimezonesTableCreateCompanionBuilder = TimezonesCompanion Function({
  required String zoneId,
  required String rulesJson,
  Value<int> rowid,
});
typedef $$TimezonesTableUpdateCompanionBuilder = TimezonesCompanion Function({
  Value<String> zoneId,
  Value<String> rulesJson,
  Value<int> rowid,
});

class $$TimezonesTableFilterComposer
    extends Composer<_$ReferenceDb, $TimezonesTable> {
  $$TimezonesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get zoneId => $composableBuilder(
      column: $table.zoneId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get rulesJson => $composableBuilder(
      column: $table.rulesJson, builder: (column) => ColumnFilters(column));
}

class $$TimezonesTableOrderingComposer
    extends Composer<_$ReferenceDb, $TimezonesTable> {
  $$TimezonesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get zoneId => $composableBuilder(
      column: $table.zoneId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get rulesJson => $composableBuilder(
      column: $table.rulesJson, builder: (column) => ColumnOrderings(column));
}

class $$TimezonesTableAnnotationComposer
    extends Composer<_$ReferenceDb, $TimezonesTable> {
  $$TimezonesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get zoneId =>
      $composableBuilder(column: $table.zoneId, builder: (column) => column);

  GeneratedColumn<String> get rulesJson =>
      $composableBuilder(column: $table.rulesJson, builder: (column) => column);
}

class $$TimezonesTableTableManager extends RootTableManager<
    _$ReferenceDb,
    $TimezonesTable,
    Timezone,
    $$TimezonesTableFilterComposer,
    $$TimezonesTableOrderingComposer,
    $$TimezonesTableAnnotationComposer,
    $$TimezonesTableCreateCompanionBuilder,
    $$TimezonesTableUpdateCompanionBuilder,
    (Timezone, BaseReferences<_$ReferenceDb, $TimezonesTable, Timezone>),
    Timezone,
    PrefetchHooks Function()> {
  $$TimezonesTableTableManager(_$ReferenceDb db, $TimezonesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TimezonesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TimezonesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TimezonesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> zoneId = const Value.absent(),
            Value<String> rulesJson = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TimezonesCompanion(
            zoneId: zoneId,
            rulesJson: rulesJson,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String zoneId,
            required String rulesJson,
            Value<int> rowid = const Value.absent(),
          }) =>
              TimezonesCompanion.insert(
            zoneId: zoneId,
            rulesJson: rulesJson,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TimezonesTableProcessedTableManager = ProcessedTableManager<
    _$ReferenceDb,
    $TimezonesTable,
    Timezone,
    $$TimezonesTableFilterComposer,
    $$TimezonesTableOrderingComposer,
    $$TimezonesTableAnnotationComposer,
    $$TimezonesTableCreateCompanionBuilder,
    $$TimezonesTableUpdateCompanionBuilder,
    (Timezone, BaseReferences<_$ReferenceDb, $TimezonesTable, Timezone>),
    Timezone,
    PrefetchHooks Function()>;
typedef $$PlacesTableCreateCompanionBuilder = PlacesCompanion Function({
  Value<int> geonameId,
  required String name,
  Value<String?> altNames,
  Value<String?> province,
  Value<String?> country,
  required double lat,
  required double lon,
  required String timezoneId,
  Value<int?> population,
});
typedef $$PlacesTableUpdateCompanionBuilder = PlacesCompanion Function({
  Value<int> geonameId,
  Value<String> name,
  Value<String?> altNames,
  Value<String?> province,
  Value<String?> country,
  Value<double> lat,
  Value<double> lon,
  Value<String> timezoneId,
  Value<int?> population,
});

class $$PlacesTableFilterComposer
    extends Composer<_$ReferenceDb, $PlacesTable> {
  $$PlacesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get geonameId => $composableBuilder(
      column: $table.geonameId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get altNames => $composableBuilder(
      column: $table.altNames, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get province => $composableBuilder(
      column: $table.province, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get country => $composableBuilder(
      column: $table.country, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get lat => $composableBuilder(
      column: $table.lat, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get lon => $composableBuilder(
      column: $table.lon, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get timezoneId => $composableBuilder(
      column: $table.timezoneId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get population => $composableBuilder(
      column: $table.population, builder: (column) => ColumnFilters(column));
}

class $$PlacesTableOrderingComposer
    extends Composer<_$ReferenceDb, $PlacesTable> {
  $$PlacesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get geonameId => $composableBuilder(
      column: $table.geonameId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get altNames => $composableBuilder(
      column: $table.altNames, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get province => $composableBuilder(
      column: $table.province, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get country => $composableBuilder(
      column: $table.country, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get lat => $composableBuilder(
      column: $table.lat, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get lon => $composableBuilder(
      column: $table.lon, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get timezoneId => $composableBuilder(
      column: $table.timezoneId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get population => $composableBuilder(
      column: $table.population, builder: (column) => ColumnOrderings(column));
}

class $$PlacesTableAnnotationComposer
    extends Composer<_$ReferenceDb, $PlacesTable> {
  $$PlacesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get geonameId =>
      $composableBuilder(column: $table.geonameId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get altNames =>
      $composableBuilder(column: $table.altNames, builder: (column) => column);

  GeneratedColumn<String> get province =>
      $composableBuilder(column: $table.province, builder: (column) => column);

  GeneratedColumn<String> get country =>
      $composableBuilder(column: $table.country, builder: (column) => column);

  GeneratedColumn<double> get lat =>
      $composableBuilder(column: $table.lat, builder: (column) => column);

  GeneratedColumn<double> get lon =>
      $composableBuilder(column: $table.lon, builder: (column) => column);

  GeneratedColumn<String> get timezoneId => $composableBuilder(
      column: $table.timezoneId, builder: (column) => column);

  GeneratedColumn<int> get population => $composableBuilder(
      column: $table.population, builder: (column) => column);
}

class $$PlacesTableTableManager extends RootTableManager<
    _$ReferenceDb,
    $PlacesTable,
    Place,
    $$PlacesTableFilterComposer,
    $$PlacesTableOrderingComposer,
    $$PlacesTableAnnotationComposer,
    $$PlacesTableCreateCompanionBuilder,
    $$PlacesTableUpdateCompanionBuilder,
    (Place, BaseReferences<_$ReferenceDb, $PlacesTable, Place>),
    Place,
    PrefetchHooks Function()> {
  $$PlacesTableTableManager(_$ReferenceDb db, $PlacesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlacesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlacesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlacesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> geonameId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> altNames = const Value.absent(),
            Value<String?> province = const Value.absent(),
            Value<String?> country = const Value.absent(),
            Value<double> lat = const Value.absent(),
            Value<double> lon = const Value.absent(),
            Value<String> timezoneId = const Value.absent(),
            Value<int?> population = const Value.absent(),
          }) =>
              PlacesCompanion(
            geonameId: geonameId,
            name: name,
            altNames: altNames,
            province: province,
            country: country,
            lat: lat,
            lon: lon,
            timezoneId: timezoneId,
            population: population,
          ),
          createCompanionCallback: ({
            Value<int> geonameId = const Value.absent(),
            required String name,
            Value<String?> altNames = const Value.absent(),
            Value<String?> province = const Value.absent(),
            Value<String?> country = const Value.absent(),
            required double lat,
            required double lon,
            required String timezoneId,
            Value<int?> population = const Value.absent(),
          }) =>
              PlacesCompanion.insert(
            geonameId: geonameId,
            name: name,
            altNames: altNames,
            province: province,
            country: country,
            lat: lat,
            lon: lon,
            timezoneId: timezoneId,
            population: population,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PlacesTableProcessedTableManager = ProcessedTableManager<
    _$ReferenceDb,
    $PlacesTable,
    Place,
    $$PlacesTableFilterComposer,
    $$PlacesTableOrderingComposer,
    $$PlacesTableAnnotationComposer,
    $$PlacesTableCreateCompanionBuilder,
    $$PlacesTableUpdateCompanionBuilder,
    (Place, BaseReferences<_$ReferenceDb, $PlacesTable, Place>),
    Place,
    PrefetchHooks Function()>;

class $ReferenceDbManager {
  final _$ReferenceDb _db;
  $ReferenceDbManager(this._db);
  $$StarsTableTableManager get stars =>
      $$StarsTableTableManager(_db, _db.stars);
  $$ConstellationsTableTableManager get constellations =>
      $$ConstellationsTableTableManager(_db, _db.constellations);
  $$SkyCulturesTableTableManager get skyCultures =>
      $$SkyCulturesTableTableManager(_db, _db.skyCultures);
  $$ConstellationLinesTableTableManager get constellationLines =>
      $$ConstellationLinesTableTableManager(_db, _db.constellationLines);
  $$ConstellationNamesTableTableManager get constellationNames =>
      $$ConstellationNamesTableTableManager(_db, _db.constellationNames);
  $$TimezonesTableTableManager get timezones =>
      $$TimezonesTableTableManager(_db, _db.timezones);
  $$PlacesTableTableManager get places =>
      $$PlacesTableTableManager(_db, _db.places);
}
