// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'farming_db.dart';

// ignore_for_file: type=lint
class $SkyTriggersTable extends SkyTriggers
    with TableInfo<$SkyTriggersTable, SkyTrigger> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SkyTriggersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _triggerIdMeta =
      const VerificationMeta('triggerId');
  @override
  late final GeneratedColumn<int> triggerId = GeneratedColumn<int>(
      'trigger_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _triggerTypeMeta =
      const VerificationMeta('triggerType');
  @override
  late final GeneratedColumn<String> triggerType = GeneratedColumn<String>(
      'trigger_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _constCodeMeta =
      const VerificationMeta('constCode');
  @override
  late final GeneratedColumn<String> constCode = GeneratedColumn<String>(
      'const_code', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _paramsJsonMeta =
      const VerificationMeta('paramsJson');
  @override
  late final GeneratedColumn<String> paramsJson = GeneratedColumn<String>(
      'params_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [triggerId, triggerType, constCode, paramsJson];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sky_triggers';
  @override
  VerificationContext validateIntegrity(Insertable<SkyTrigger> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('trigger_id')) {
      context.handle(_triggerIdMeta,
          triggerId.isAcceptableOrUnknown(data['trigger_id']!, _triggerIdMeta));
    }
    if (data.containsKey('trigger_type')) {
      context.handle(
          _triggerTypeMeta,
          triggerType.isAcceptableOrUnknown(
              data['trigger_type']!, _triggerTypeMeta));
    } else if (isInserting) {
      context.missing(_triggerTypeMeta);
    }
    if (data.containsKey('const_code')) {
      context.handle(_constCodeMeta,
          constCode.isAcceptableOrUnknown(data['const_code']!, _constCodeMeta));
    }
    if (data.containsKey('params_json')) {
      context.handle(
          _paramsJsonMeta,
          paramsJson.isAcceptableOrUnknown(
              data['params_json']!, _paramsJsonMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {triggerId};
  @override
  SkyTrigger map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SkyTrigger(
      triggerId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}trigger_id'])!,
      triggerType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}trigger_type'])!,
      constCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}const_code']),
      paramsJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}params_json']),
    );
  }

  @override
  $SkyTriggersTable createAlias(String alias) {
    return $SkyTriggersTable(attachedDatabase, alias);
  }
}

class SkyTrigger extends DataClass implements Insertable<SkyTrigger> {
  final int triggerId;
  final String triggerType;
  final String? constCode;
  final String? paramsJson;
  const SkyTrigger(
      {required this.triggerId,
      required this.triggerType,
      this.constCode,
      this.paramsJson});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['trigger_id'] = Variable<int>(triggerId);
    map['trigger_type'] = Variable<String>(triggerType);
    if (!nullToAbsent || constCode != null) {
      map['const_code'] = Variable<String>(constCode);
    }
    if (!nullToAbsent || paramsJson != null) {
      map['params_json'] = Variable<String>(paramsJson);
    }
    return map;
  }

  SkyTriggersCompanion toCompanion(bool nullToAbsent) {
    return SkyTriggersCompanion(
      triggerId: Value(triggerId),
      triggerType: Value(triggerType),
      constCode: constCode == null && nullToAbsent
          ? const Value.absent()
          : Value(constCode),
      paramsJson: paramsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(paramsJson),
    );
  }

  factory SkyTrigger.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SkyTrigger(
      triggerId: serializer.fromJson<int>(json['triggerId']),
      triggerType: serializer.fromJson<String>(json['triggerType']),
      constCode: serializer.fromJson<String?>(json['constCode']),
      paramsJson: serializer.fromJson<String?>(json['paramsJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'triggerId': serializer.toJson<int>(triggerId),
      'triggerType': serializer.toJson<String>(triggerType),
      'constCode': serializer.toJson<String?>(constCode),
      'paramsJson': serializer.toJson<String?>(paramsJson),
    };
  }

  SkyTrigger copyWith(
          {int? triggerId,
          String? triggerType,
          Value<String?> constCode = const Value.absent(),
          Value<String?> paramsJson = const Value.absent()}) =>
      SkyTrigger(
        triggerId: triggerId ?? this.triggerId,
        triggerType: triggerType ?? this.triggerType,
        constCode: constCode.present ? constCode.value : this.constCode,
        paramsJson: paramsJson.present ? paramsJson.value : this.paramsJson,
      );
  SkyTrigger copyWithCompanion(SkyTriggersCompanion data) {
    return SkyTrigger(
      triggerId: data.triggerId.present ? data.triggerId.value : this.triggerId,
      triggerType:
          data.triggerType.present ? data.triggerType.value : this.triggerType,
      constCode: data.constCode.present ? data.constCode.value : this.constCode,
      paramsJson:
          data.paramsJson.present ? data.paramsJson.value : this.paramsJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SkyTrigger(')
          ..write('triggerId: $triggerId, ')
          ..write('triggerType: $triggerType, ')
          ..write('constCode: $constCode, ')
          ..write('paramsJson: $paramsJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(triggerId, triggerType, constCode, paramsJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SkyTrigger &&
          other.triggerId == this.triggerId &&
          other.triggerType == this.triggerType &&
          other.constCode == this.constCode &&
          other.paramsJson == this.paramsJson);
}

class SkyTriggersCompanion extends UpdateCompanion<SkyTrigger> {
  final Value<int> triggerId;
  final Value<String> triggerType;
  final Value<String?> constCode;
  final Value<String?> paramsJson;
  const SkyTriggersCompanion({
    this.triggerId = const Value.absent(),
    this.triggerType = const Value.absent(),
    this.constCode = const Value.absent(),
    this.paramsJson = const Value.absent(),
  });
  SkyTriggersCompanion.insert({
    this.triggerId = const Value.absent(),
    required String triggerType,
    this.constCode = const Value.absent(),
    this.paramsJson = const Value.absent(),
  }) : triggerType = Value(triggerType);
  static Insertable<SkyTrigger> custom({
    Expression<int>? triggerId,
    Expression<String>? triggerType,
    Expression<String>? constCode,
    Expression<String>? paramsJson,
  }) {
    return RawValuesInsertable({
      if (triggerId != null) 'trigger_id': triggerId,
      if (triggerType != null) 'trigger_type': triggerType,
      if (constCode != null) 'const_code': constCode,
      if (paramsJson != null) 'params_json': paramsJson,
    });
  }

  SkyTriggersCompanion copyWith(
      {Value<int>? triggerId,
      Value<String>? triggerType,
      Value<String?>? constCode,
      Value<String?>? paramsJson}) {
    return SkyTriggersCompanion(
      triggerId: triggerId ?? this.triggerId,
      triggerType: triggerType ?? this.triggerType,
      constCode: constCode ?? this.constCode,
      paramsJson: paramsJson ?? this.paramsJson,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (triggerId.present) {
      map['trigger_id'] = Variable<int>(triggerId.value);
    }
    if (triggerType.present) {
      map['trigger_type'] = Variable<String>(triggerType.value);
    }
    if (constCode.present) {
      map['const_code'] = Variable<String>(constCode.value);
    }
    if (paramsJson.present) {
      map['params_json'] = Variable<String>(paramsJson.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SkyTriggersCompanion(')
          ..write('triggerId: $triggerId, ')
          ..write('triggerType: $triggerType, ')
          ..write('constCode: $constCode, ')
          ..write('paramsJson: $paramsJson')
          ..write(')'))
        .toString();
  }
}

class $WeatherTriggersTable extends WeatherTriggers
    with TableInfo<$WeatherTriggersTable, WeatherTrigger> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeatherTriggersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _triggerIdMeta =
      const VerificationMeta('triggerId');
  @override
  late final GeneratedColumn<int> triggerId = GeneratedColumn<int>(
      'trigger_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _variableMeta =
      const VerificationMeta('variable');
  @override
  late final GeneratedColumn<String> variable = GeneratedColumn<String>(
      'variable', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _operatorMeta =
      const VerificationMeta('operator');
  @override
  late final GeneratedColumn<String> operator = GeneratedColumn<String>(
      'operator', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _thresholdMeta =
      const VerificationMeta('threshold');
  @override
  late final GeneratedColumn<double> threshold = GeneratedColumn<double>(
      'threshold', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _daysAheadMeta =
      const VerificationMeta('daysAhead');
  @override
  late final GeneratedColumn<int> daysAhead = GeneratedColumn<int>(
      'days_ahead', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _durationDaysMeta =
      const VerificationMeta('durationDays');
  @override
  late final GeneratedColumn<int> durationDays = GeneratedColumn<int>(
      'duration_days', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [triggerId, variable, operator, threshold, daysAhead, durationDays];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'weather_triggers';
  @override
  VerificationContext validateIntegrity(Insertable<WeatherTrigger> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('trigger_id')) {
      context.handle(_triggerIdMeta,
          triggerId.isAcceptableOrUnknown(data['trigger_id']!, _triggerIdMeta));
    }
    if (data.containsKey('variable')) {
      context.handle(_variableMeta,
          variable.isAcceptableOrUnknown(data['variable']!, _variableMeta));
    } else if (isInserting) {
      context.missing(_variableMeta);
    }
    if (data.containsKey('operator')) {
      context.handle(_operatorMeta,
          operator.isAcceptableOrUnknown(data['operator']!, _operatorMeta));
    } else if (isInserting) {
      context.missing(_operatorMeta);
    }
    if (data.containsKey('threshold')) {
      context.handle(_thresholdMeta,
          threshold.isAcceptableOrUnknown(data['threshold']!, _thresholdMeta));
    } else if (isInserting) {
      context.missing(_thresholdMeta);
    }
    if (data.containsKey('days_ahead')) {
      context.handle(_daysAheadMeta,
          daysAhead.isAcceptableOrUnknown(data['days_ahead']!, _daysAheadMeta));
    }
    if (data.containsKey('duration_days')) {
      context.handle(
          _durationDaysMeta,
          durationDays.isAcceptableOrUnknown(
              data['duration_days']!, _durationDaysMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {triggerId};
  @override
  WeatherTrigger map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeatherTrigger(
      triggerId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}trigger_id'])!,
      variable: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}variable'])!,
      operator: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}operator'])!,
      threshold: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}threshold'])!,
      daysAhead: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}days_ahead']),
      durationDays: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}duration_days']),
    );
  }

  @override
  $WeatherTriggersTable createAlias(String alias) {
    return $WeatherTriggersTable(attachedDatabase, alias);
  }
}

class WeatherTrigger extends DataClass implements Insertable<WeatherTrigger> {
  final int triggerId;
  final String variable;
  final String operator;
  final double threshold;
  final int? daysAhead;
  final int? durationDays;
  const WeatherTrigger(
      {required this.triggerId,
      required this.variable,
      required this.operator,
      required this.threshold,
      this.daysAhead,
      this.durationDays});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['trigger_id'] = Variable<int>(triggerId);
    map['variable'] = Variable<String>(variable);
    map['operator'] = Variable<String>(operator);
    map['threshold'] = Variable<double>(threshold);
    if (!nullToAbsent || daysAhead != null) {
      map['days_ahead'] = Variable<int>(daysAhead);
    }
    if (!nullToAbsent || durationDays != null) {
      map['duration_days'] = Variable<int>(durationDays);
    }
    return map;
  }

  WeatherTriggersCompanion toCompanion(bool nullToAbsent) {
    return WeatherTriggersCompanion(
      triggerId: Value(triggerId),
      variable: Value(variable),
      operator: Value(operator),
      threshold: Value(threshold),
      daysAhead: daysAhead == null && nullToAbsent
          ? const Value.absent()
          : Value(daysAhead),
      durationDays: durationDays == null && nullToAbsent
          ? const Value.absent()
          : Value(durationDays),
    );
  }

  factory WeatherTrigger.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeatherTrigger(
      triggerId: serializer.fromJson<int>(json['triggerId']),
      variable: serializer.fromJson<String>(json['variable']),
      operator: serializer.fromJson<String>(json['operator']),
      threshold: serializer.fromJson<double>(json['threshold']),
      daysAhead: serializer.fromJson<int?>(json['daysAhead']),
      durationDays: serializer.fromJson<int?>(json['durationDays']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'triggerId': serializer.toJson<int>(triggerId),
      'variable': serializer.toJson<String>(variable),
      'operator': serializer.toJson<String>(operator),
      'threshold': serializer.toJson<double>(threshold),
      'daysAhead': serializer.toJson<int?>(daysAhead),
      'durationDays': serializer.toJson<int?>(durationDays),
    };
  }

  WeatherTrigger copyWith(
          {int? triggerId,
          String? variable,
          String? operator,
          double? threshold,
          Value<int?> daysAhead = const Value.absent(),
          Value<int?> durationDays = const Value.absent()}) =>
      WeatherTrigger(
        triggerId: triggerId ?? this.triggerId,
        variable: variable ?? this.variable,
        operator: operator ?? this.operator,
        threshold: threshold ?? this.threshold,
        daysAhead: daysAhead.present ? daysAhead.value : this.daysAhead,
        durationDays:
            durationDays.present ? durationDays.value : this.durationDays,
      );
  WeatherTrigger copyWithCompanion(WeatherTriggersCompanion data) {
    return WeatherTrigger(
      triggerId: data.triggerId.present ? data.triggerId.value : this.triggerId,
      variable: data.variable.present ? data.variable.value : this.variable,
      operator: data.operator.present ? data.operator.value : this.operator,
      threshold: data.threshold.present ? data.threshold.value : this.threshold,
      daysAhead: data.daysAhead.present ? data.daysAhead.value : this.daysAhead,
      durationDays: data.durationDays.present
          ? data.durationDays.value
          : this.durationDays,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WeatherTrigger(')
          ..write('triggerId: $triggerId, ')
          ..write('variable: $variable, ')
          ..write('operator: $operator, ')
          ..write('threshold: $threshold, ')
          ..write('daysAhead: $daysAhead, ')
          ..write('durationDays: $durationDays')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      triggerId, variable, operator, threshold, daysAhead, durationDays);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeatherTrigger &&
          other.triggerId == this.triggerId &&
          other.variable == this.variable &&
          other.operator == this.operator &&
          other.threshold == this.threshold &&
          other.daysAhead == this.daysAhead &&
          other.durationDays == this.durationDays);
}

class WeatherTriggersCompanion extends UpdateCompanion<WeatherTrigger> {
  final Value<int> triggerId;
  final Value<String> variable;
  final Value<String> operator;
  final Value<double> threshold;
  final Value<int?> daysAhead;
  final Value<int?> durationDays;
  const WeatherTriggersCompanion({
    this.triggerId = const Value.absent(),
    this.variable = const Value.absent(),
    this.operator = const Value.absent(),
    this.threshold = const Value.absent(),
    this.daysAhead = const Value.absent(),
    this.durationDays = const Value.absent(),
  });
  WeatherTriggersCompanion.insert({
    this.triggerId = const Value.absent(),
    required String variable,
    required String operator,
    required double threshold,
    this.daysAhead = const Value.absent(),
    this.durationDays = const Value.absent(),
  })  : variable = Value(variable),
        operator = Value(operator),
        threshold = Value(threshold);
  static Insertable<WeatherTrigger> custom({
    Expression<int>? triggerId,
    Expression<String>? variable,
    Expression<String>? operator,
    Expression<double>? threshold,
    Expression<int>? daysAhead,
    Expression<int>? durationDays,
  }) {
    return RawValuesInsertable({
      if (triggerId != null) 'trigger_id': triggerId,
      if (variable != null) 'variable': variable,
      if (operator != null) 'operator': operator,
      if (threshold != null) 'threshold': threshold,
      if (daysAhead != null) 'days_ahead': daysAhead,
      if (durationDays != null) 'duration_days': durationDays,
    });
  }

  WeatherTriggersCompanion copyWith(
      {Value<int>? triggerId,
      Value<String>? variable,
      Value<String>? operator,
      Value<double>? threshold,
      Value<int?>? daysAhead,
      Value<int?>? durationDays}) {
    return WeatherTriggersCompanion(
      triggerId: triggerId ?? this.triggerId,
      variable: variable ?? this.variable,
      operator: operator ?? this.operator,
      threshold: threshold ?? this.threshold,
      daysAhead: daysAhead ?? this.daysAhead,
      durationDays: durationDays ?? this.durationDays,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (triggerId.present) {
      map['trigger_id'] = Variable<int>(triggerId.value);
    }
    if (variable.present) {
      map['variable'] = Variable<String>(variable.value);
    }
    if (operator.present) {
      map['operator'] = Variable<String>(operator.value);
    }
    if (threshold.present) {
      map['threshold'] = Variable<double>(threshold.value);
    }
    if (daysAhead.present) {
      map['days_ahead'] = Variable<int>(daysAhead.value);
    }
    if (durationDays.present) {
      map['duration_days'] = Variable<int>(durationDays.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeatherTriggersCompanion(')
          ..write('triggerId: $triggerId, ')
          ..write('variable: $variable, ')
          ..write('operator: $operator, ')
          ..write('threshold: $threshold, ')
          ..write('daysAhead: $daysAhead, ')
          ..write('durationDays: $durationDays')
          ..write(')'))
        .toString();
  }
}

class $ActivitiesTable extends Activities
    with TableInfo<$ActivitiesTable, Activity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActivitiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _activityIdMeta =
      const VerificationMeta('activityId');
  @override
  late final GeneratedColumn<int> activityId = GeneratedColumn<int>(
      'activity_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _activityTypeMeta =
      const VerificationMeta('activityType');
  @override
  late final GeneratedColumn<String> activityType = GeneratedColumn<String>(
      'activity_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionI18nMeta =
      const VerificationMeta('descriptionI18n');
  @override
  late final GeneratedColumn<String> descriptionI18n = GeneratedColumn<String>(
      'description_i18n', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [activityId, activityType, descriptionI18n];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'activities';
  @override
  VerificationContext validateIntegrity(Insertable<Activity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('activity_id')) {
      context.handle(
          _activityIdMeta,
          activityId.isAcceptableOrUnknown(
              data['activity_id']!, _activityIdMeta));
    }
    if (data.containsKey('activity_type')) {
      context.handle(
          _activityTypeMeta,
          activityType.isAcceptableOrUnknown(
              data['activity_type']!, _activityTypeMeta));
    } else if (isInserting) {
      context.missing(_activityTypeMeta);
    }
    if (data.containsKey('description_i18n')) {
      context.handle(
          _descriptionI18nMeta,
          descriptionI18n.isAcceptableOrUnknown(
              data['description_i18n']!, _descriptionI18nMeta));
    } else if (isInserting) {
      context.missing(_descriptionI18nMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {activityId};
  @override
  Activity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Activity(
      activityId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}activity_id'])!,
      activityType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}activity_type'])!,
      descriptionI18n: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}description_i18n'])!,
    );
  }

  @override
  $ActivitiesTable createAlias(String alias) {
    return $ActivitiesTable(attachedDatabase, alias);
  }
}

class Activity extends DataClass implements Insertable<Activity> {
  final int activityId;
  final String activityType;
  final String descriptionI18n;
  const Activity(
      {required this.activityId,
      required this.activityType,
      required this.descriptionI18n});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['activity_id'] = Variable<int>(activityId);
    map['activity_type'] = Variable<String>(activityType);
    map['description_i18n'] = Variable<String>(descriptionI18n);
    return map;
  }

  ActivitiesCompanion toCompanion(bool nullToAbsent) {
    return ActivitiesCompanion(
      activityId: Value(activityId),
      activityType: Value(activityType),
      descriptionI18n: Value(descriptionI18n),
    );
  }

  factory Activity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Activity(
      activityId: serializer.fromJson<int>(json['activityId']),
      activityType: serializer.fromJson<String>(json['activityType']),
      descriptionI18n: serializer.fromJson<String>(json['descriptionI18n']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'activityId': serializer.toJson<int>(activityId),
      'activityType': serializer.toJson<String>(activityType),
      'descriptionI18n': serializer.toJson<String>(descriptionI18n),
    };
  }

  Activity copyWith(
          {int? activityId, String? activityType, String? descriptionI18n}) =>
      Activity(
        activityId: activityId ?? this.activityId,
        activityType: activityType ?? this.activityType,
        descriptionI18n: descriptionI18n ?? this.descriptionI18n,
      );
  Activity copyWithCompanion(ActivitiesCompanion data) {
    return Activity(
      activityId:
          data.activityId.present ? data.activityId.value : this.activityId,
      activityType: data.activityType.present
          ? data.activityType.value
          : this.activityType,
      descriptionI18n: data.descriptionI18n.present
          ? data.descriptionI18n.value
          : this.descriptionI18n,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Activity(')
          ..write('activityId: $activityId, ')
          ..write('activityType: $activityType, ')
          ..write('descriptionI18n: $descriptionI18n')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(activityId, activityType, descriptionI18n);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Activity &&
          other.activityId == this.activityId &&
          other.activityType == this.activityType &&
          other.descriptionI18n == this.descriptionI18n);
}

class ActivitiesCompanion extends UpdateCompanion<Activity> {
  final Value<int> activityId;
  final Value<String> activityType;
  final Value<String> descriptionI18n;
  const ActivitiesCompanion({
    this.activityId = const Value.absent(),
    this.activityType = const Value.absent(),
    this.descriptionI18n = const Value.absent(),
  });
  ActivitiesCompanion.insert({
    this.activityId = const Value.absent(),
    required String activityType,
    required String descriptionI18n,
  })  : activityType = Value(activityType),
        descriptionI18n = Value(descriptionI18n);
  static Insertable<Activity> custom({
    Expression<int>? activityId,
    Expression<String>? activityType,
    Expression<String>? descriptionI18n,
  }) {
    return RawValuesInsertable({
      if (activityId != null) 'activity_id': activityId,
      if (activityType != null) 'activity_type': activityType,
      if (descriptionI18n != null) 'description_i18n': descriptionI18n,
    });
  }

  ActivitiesCompanion copyWith(
      {Value<int>? activityId,
      Value<String>? activityType,
      Value<String>? descriptionI18n}) {
    return ActivitiesCompanion(
      activityId: activityId ?? this.activityId,
      activityType: activityType ?? this.activityType,
      descriptionI18n: descriptionI18n ?? this.descriptionI18n,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (activityId.present) {
      map['activity_id'] = Variable<int>(activityId.value);
    }
    if (activityType.present) {
      map['activity_type'] = Variable<String>(activityType.value);
    }
    if (descriptionI18n.present) {
      map['description_i18n'] = Variable<String>(descriptionI18n.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActivitiesCompanion(')
          ..write('activityId: $activityId, ')
          ..write('activityType: $activityType, ')
          ..write('descriptionI18n: $descriptionI18n')
          ..write(')'))
        .toString();
  }
}

class $CropsTable extends Crops with TableInfo<$CropsTable, Crop> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CropsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _cropIdMeta = const VerificationMeta('cropId');
  @override
  late final GeneratedColumn<int> cropId = GeneratedColumn<int>(
      'crop_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _localNamesMeta =
      const VerificationMeta('localNames');
  @override
  late final GeneratedColumn<String> localNames = GeneratedColumn<String>(
      'local_names', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [cropId, name, localNames, category];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'crops';
  @override
  VerificationContext validateIntegrity(Insertable<Crop> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('crop_id')) {
      context.handle(_cropIdMeta,
          cropId.isAcceptableOrUnknown(data['crop_id']!, _cropIdMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('local_names')) {
      context.handle(
          _localNamesMeta,
          localNames.isAcceptableOrUnknown(
              data['local_names']!, _localNamesMeta));
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {cropId};
  @override
  Crop map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Crop(
      cropId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}crop_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      localNames: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}local_names']),
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category']),
    );
  }

  @override
  $CropsTable createAlias(String alias) {
    return $CropsTable(attachedDatabase, alias);
  }
}

class Crop extends DataClass implements Insertable<Crop> {
  final int cropId;
  final String name;
  final String? localNames;
  final String? category;
  const Crop(
      {required this.cropId,
      required this.name,
      this.localNames,
      this.category});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['crop_id'] = Variable<int>(cropId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || localNames != null) {
      map['local_names'] = Variable<String>(localNames);
    }
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    return map;
  }

  CropsCompanion toCompanion(bool nullToAbsent) {
    return CropsCompanion(
      cropId: Value(cropId),
      name: Value(name),
      localNames: localNames == null && nullToAbsent
          ? const Value.absent()
          : Value(localNames),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
    );
  }

  factory Crop.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Crop(
      cropId: serializer.fromJson<int>(json['cropId']),
      name: serializer.fromJson<String>(json['name']),
      localNames: serializer.fromJson<String?>(json['localNames']),
      category: serializer.fromJson<String?>(json['category']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'cropId': serializer.toJson<int>(cropId),
      'name': serializer.toJson<String>(name),
      'localNames': serializer.toJson<String?>(localNames),
      'category': serializer.toJson<String?>(category),
    };
  }

  Crop copyWith(
          {int? cropId,
          String? name,
          Value<String?> localNames = const Value.absent(),
          Value<String?> category = const Value.absent()}) =>
      Crop(
        cropId: cropId ?? this.cropId,
        name: name ?? this.name,
        localNames: localNames.present ? localNames.value : this.localNames,
        category: category.present ? category.value : this.category,
      );
  Crop copyWithCompanion(CropsCompanion data) {
    return Crop(
      cropId: data.cropId.present ? data.cropId.value : this.cropId,
      name: data.name.present ? data.name.value : this.name,
      localNames:
          data.localNames.present ? data.localNames.value : this.localNames,
      category: data.category.present ? data.category.value : this.category,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Crop(')
          ..write('cropId: $cropId, ')
          ..write('name: $name, ')
          ..write('localNames: $localNames, ')
          ..write('category: $category')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(cropId, name, localNames, category);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Crop &&
          other.cropId == this.cropId &&
          other.name == this.name &&
          other.localNames == this.localNames &&
          other.category == this.category);
}

class CropsCompanion extends UpdateCompanion<Crop> {
  final Value<int> cropId;
  final Value<String> name;
  final Value<String?> localNames;
  final Value<String?> category;
  const CropsCompanion({
    this.cropId = const Value.absent(),
    this.name = const Value.absent(),
    this.localNames = const Value.absent(),
    this.category = const Value.absent(),
  });
  CropsCompanion.insert({
    this.cropId = const Value.absent(),
    required String name,
    this.localNames = const Value.absent(),
    this.category = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Crop> custom({
    Expression<int>? cropId,
    Expression<String>? name,
    Expression<String>? localNames,
    Expression<String>? category,
  }) {
    return RawValuesInsertable({
      if (cropId != null) 'crop_id': cropId,
      if (name != null) 'name': name,
      if (localNames != null) 'local_names': localNames,
      if (category != null) 'category': category,
    });
  }

  CropsCompanion copyWith(
      {Value<int>? cropId,
      Value<String>? name,
      Value<String?>? localNames,
      Value<String?>? category}) {
    return CropsCompanion(
      cropId: cropId ?? this.cropId,
      name: name ?? this.name,
      localNames: localNames ?? this.localNames,
      category: category ?? this.category,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (cropId.present) {
      map['crop_id'] = Variable<int>(cropId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (localNames.present) {
      map['local_names'] = Variable<String>(localNames.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CropsCompanion(')
          ..write('cropId: $cropId, ')
          ..write('name: $name, ')
          ..write('localNames: $localNames, ')
          ..write('category: $category')
          ..write(')'))
        .toString();
  }
}

class $RegionsTable extends Regions with TableInfo<$RegionsTable, Region> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RegionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _regionIdMeta =
      const VerificationMeta('regionId');
  @override
  late final GeneratedColumn<int> regionId = GeneratedColumn<int>(
      'region_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _latMinMeta = const VerificationMeta('latMin');
  @override
  late final GeneratedColumn<double> latMin = GeneratedColumn<double>(
      'lat_min', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _latMaxMeta = const VerificationMeta('latMax');
  @override
  late final GeneratedColumn<double> latMax = GeneratedColumn<double>(
      'lat_max', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _lonMinMeta = const VerificationMeta('lonMin');
  @override
  late final GeneratedColumn<double> lonMin = GeneratedColumn<double>(
      'lon_min', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _lonMaxMeta = const VerificationMeta('lonMax');
  @override
  late final GeneratedColumn<double> lonMax = GeneratedColumn<double>(
      'lon_max', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _climateZoneMeta =
      const VerificationMeta('climateZone');
  @override
  late final GeneratedColumn<String> climateZone = GeneratedColumn<String>(
      'climate_zone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [regionId, name, latMin, latMax, lonMin, lonMax, climateZone];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'regions';
  @override
  VerificationContext validateIntegrity(Insertable<Region> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('region_id')) {
      context.handle(_regionIdMeta,
          regionId.isAcceptableOrUnknown(data['region_id']!, _regionIdMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('lat_min')) {
      context.handle(_latMinMeta,
          latMin.isAcceptableOrUnknown(data['lat_min']!, _latMinMeta));
    } else if (isInserting) {
      context.missing(_latMinMeta);
    }
    if (data.containsKey('lat_max')) {
      context.handle(_latMaxMeta,
          latMax.isAcceptableOrUnknown(data['lat_max']!, _latMaxMeta));
    } else if (isInserting) {
      context.missing(_latMaxMeta);
    }
    if (data.containsKey('lon_min')) {
      context.handle(_lonMinMeta,
          lonMin.isAcceptableOrUnknown(data['lon_min']!, _lonMinMeta));
    } else if (isInserting) {
      context.missing(_lonMinMeta);
    }
    if (data.containsKey('lon_max')) {
      context.handle(_lonMaxMeta,
          lonMax.isAcceptableOrUnknown(data['lon_max']!, _lonMaxMeta));
    } else if (isInserting) {
      context.missing(_lonMaxMeta);
    }
    if (data.containsKey('climate_zone')) {
      context.handle(
          _climateZoneMeta,
          climateZone.isAcceptableOrUnknown(
              data['climate_zone']!, _climateZoneMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {regionId};
  @override
  Region map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Region(
      regionId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}region_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      latMin: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}lat_min'])!,
      latMax: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}lat_max'])!,
      lonMin: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}lon_min'])!,
      lonMax: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}lon_max'])!,
      climateZone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}climate_zone']),
    );
  }

  @override
  $RegionsTable createAlias(String alias) {
    return $RegionsTable(attachedDatabase, alias);
  }
}

class Region extends DataClass implements Insertable<Region> {
  final int regionId;
  final String name;
  final double latMin;
  final double latMax;
  final double lonMin;
  final double lonMax;
  final String? climateZone;
  const Region(
      {required this.regionId,
      required this.name,
      required this.latMin,
      required this.latMax,
      required this.lonMin,
      required this.lonMax,
      this.climateZone});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['region_id'] = Variable<int>(regionId);
    map['name'] = Variable<String>(name);
    map['lat_min'] = Variable<double>(latMin);
    map['lat_max'] = Variable<double>(latMax);
    map['lon_min'] = Variable<double>(lonMin);
    map['lon_max'] = Variable<double>(lonMax);
    if (!nullToAbsent || climateZone != null) {
      map['climate_zone'] = Variable<String>(climateZone);
    }
    return map;
  }

  RegionsCompanion toCompanion(bool nullToAbsent) {
    return RegionsCompanion(
      regionId: Value(regionId),
      name: Value(name),
      latMin: Value(latMin),
      latMax: Value(latMax),
      lonMin: Value(lonMin),
      lonMax: Value(lonMax),
      climateZone: climateZone == null && nullToAbsent
          ? const Value.absent()
          : Value(climateZone),
    );
  }

  factory Region.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Region(
      regionId: serializer.fromJson<int>(json['regionId']),
      name: serializer.fromJson<String>(json['name']),
      latMin: serializer.fromJson<double>(json['latMin']),
      latMax: serializer.fromJson<double>(json['latMax']),
      lonMin: serializer.fromJson<double>(json['lonMin']),
      lonMax: serializer.fromJson<double>(json['lonMax']),
      climateZone: serializer.fromJson<String?>(json['climateZone']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'regionId': serializer.toJson<int>(regionId),
      'name': serializer.toJson<String>(name),
      'latMin': serializer.toJson<double>(latMin),
      'latMax': serializer.toJson<double>(latMax),
      'lonMin': serializer.toJson<double>(lonMin),
      'lonMax': serializer.toJson<double>(lonMax),
      'climateZone': serializer.toJson<String?>(climateZone),
    };
  }

  Region copyWith(
          {int? regionId,
          String? name,
          double? latMin,
          double? latMax,
          double? lonMin,
          double? lonMax,
          Value<String?> climateZone = const Value.absent()}) =>
      Region(
        regionId: regionId ?? this.regionId,
        name: name ?? this.name,
        latMin: latMin ?? this.latMin,
        latMax: latMax ?? this.latMax,
        lonMin: lonMin ?? this.lonMin,
        lonMax: lonMax ?? this.lonMax,
        climateZone: climateZone.present ? climateZone.value : this.climateZone,
      );
  Region copyWithCompanion(RegionsCompanion data) {
    return Region(
      regionId: data.regionId.present ? data.regionId.value : this.regionId,
      name: data.name.present ? data.name.value : this.name,
      latMin: data.latMin.present ? data.latMin.value : this.latMin,
      latMax: data.latMax.present ? data.latMax.value : this.latMax,
      lonMin: data.lonMin.present ? data.lonMin.value : this.lonMin,
      lonMax: data.lonMax.present ? data.lonMax.value : this.lonMax,
      climateZone:
          data.climateZone.present ? data.climateZone.value : this.climateZone,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Region(')
          ..write('regionId: $regionId, ')
          ..write('name: $name, ')
          ..write('latMin: $latMin, ')
          ..write('latMax: $latMax, ')
          ..write('lonMin: $lonMin, ')
          ..write('lonMax: $lonMax, ')
          ..write('climateZone: $climateZone')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(regionId, name, latMin, latMax, lonMin, lonMax, climateZone);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Region &&
          other.regionId == this.regionId &&
          other.name == this.name &&
          other.latMin == this.latMin &&
          other.latMax == this.latMax &&
          other.lonMin == this.lonMin &&
          other.lonMax == this.lonMax &&
          other.climateZone == this.climateZone);
}

class RegionsCompanion extends UpdateCompanion<Region> {
  final Value<int> regionId;
  final Value<String> name;
  final Value<double> latMin;
  final Value<double> latMax;
  final Value<double> lonMin;
  final Value<double> lonMax;
  final Value<String?> climateZone;
  const RegionsCompanion({
    this.regionId = const Value.absent(),
    this.name = const Value.absent(),
    this.latMin = const Value.absent(),
    this.latMax = const Value.absent(),
    this.lonMin = const Value.absent(),
    this.lonMax = const Value.absent(),
    this.climateZone = const Value.absent(),
  });
  RegionsCompanion.insert({
    this.regionId = const Value.absent(),
    required String name,
    required double latMin,
    required double latMax,
    required double lonMin,
    required double lonMax,
    this.climateZone = const Value.absent(),
  })  : name = Value(name),
        latMin = Value(latMin),
        latMax = Value(latMax),
        lonMin = Value(lonMin),
        lonMax = Value(lonMax);
  static Insertable<Region> custom({
    Expression<int>? regionId,
    Expression<String>? name,
    Expression<double>? latMin,
    Expression<double>? latMax,
    Expression<double>? lonMin,
    Expression<double>? lonMax,
    Expression<String>? climateZone,
  }) {
    return RawValuesInsertable({
      if (regionId != null) 'region_id': regionId,
      if (name != null) 'name': name,
      if (latMin != null) 'lat_min': latMin,
      if (latMax != null) 'lat_max': latMax,
      if (lonMin != null) 'lon_min': lonMin,
      if (lonMax != null) 'lon_max': lonMax,
      if (climateZone != null) 'climate_zone': climateZone,
    });
  }

  RegionsCompanion copyWith(
      {Value<int>? regionId,
      Value<String>? name,
      Value<double>? latMin,
      Value<double>? latMax,
      Value<double>? lonMin,
      Value<double>? lonMax,
      Value<String?>? climateZone}) {
    return RegionsCompanion(
      regionId: regionId ?? this.regionId,
      name: name ?? this.name,
      latMin: latMin ?? this.latMin,
      latMax: latMax ?? this.latMax,
      lonMin: lonMin ?? this.lonMin,
      lonMax: lonMax ?? this.lonMax,
      climateZone: climateZone ?? this.climateZone,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (regionId.present) {
      map['region_id'] = Variable<int>(regionId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (latMin.present) {
      map['lat_min'] = Variable<double>(latMin.value);
    }
    if (latMax.present) {
      map['lat_max'] = Variable<double>(latMax.value);
    }
    if (lonMin.present) {
      map['lon_min'] = Variable<double>(lonMin.value);
    }
    if (lonMax.present) {
      map['lon_max'] = Variable<double>(lonMax.value);
    }
    if (climateZone.present) {
      map['climate_zone'] = Variable<String>(climateZone.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RegionsCompanion(')
          ..write('regionId: $regionId, ')
          ..write('name: $name, ')
          ..write('latMin: $latMin, ')
          ..write('latMax: $latMax, ')
          ..write('lonMin: $lonMin, ')
          ..write('lonMax: $lonMax, ')
          ..write('climateZone: $climateZone')
          ..write(')'))
        .toString();
  }
}

class $SourcesTable extends Sources with TableInfo<$SourcesTable, Source> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SourcesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _sourceIdMeta =
      const VerificationMeta('sourceId');
  @override
  late final GeneratedColumn<int> sourceId = GeneratedColumn<int>(
      'source_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _sourceTypeMeta =
      const VerificationMeta('sourceType');
  @override
  late final GeneratedColumn<String> sourceType = GeneratedColumn<String>(
      'source_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _citationMeta =
      const VerificationMeta('citation');
  @override
  late final GeneratedColumn<String> citation = GeneratedColumn<String>(
      'citation', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sourceDateMeta =
      const VerificationMeta('sourceDate');
  @override
  late final GeneratedColumn<DateTime> sourceDate = GeneratedColumn<DateTime>(
      'source_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [sourceId, sourceType, name, citation, sourceDate];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sources';
  @override
  VerificationContext validateIntegrity(Insertable<Source> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('source_id')) {
      context.handle(_sourceIdMeta,
          sourceId.isAcceptableOrUnknown(data['source_id']!, _sourceIdMeta));
    }
    if (data.containsKey('source_type')) {
      context.handle(
          _sourceTypeMeta,
          sourceType.isAcceptableOrUnknown(
              data['source_type']!, _sourceTypeMeta));
    } else if (isInserting) {
      context.missing(_sourceTypeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('citation')) {
      context.handle(_citationMeta,
          citation.isAcceptableOrUnknown(data['citation']!, _citationMeta));
    }
    if (data.containsKey('source_date')) {
      context.handle(
          _sourceDateMeta,
          sourceDate.isAcceptableOrUnknown(
              data['source_date']!, _sourceDateMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {sourceId};
  @override
  Source map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Source(
      sourceId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}source_id'])!,
      sourceType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source_type'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      citation: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}citation']),
      sourceDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}source_date']),
    );
  }

  @override
  $SourcesTable createAlias(String alias) {
    return $SourcesTable(attachedDatabase, alias);
  }
}

class Source extends DataClass implements Insertable<Source> {
  final int sourceId;
  final String sourceType;
  final String name;
  final String? citation;
  final DateTime? sourceDate;
  const Source(
      {required this.sourceId,
      required this.sourceType,
      required this.name,
      this.citation,
      this.sourceDate});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['source_id'] = Variable<int>(sourceId);
    map['source_type'] = Variable<String>(sourceType);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || citation != null) {
      map['citation'] = Variable<String>(citation);
    }
    if (!nullToAbsent || sourceDate != null) {
      map['source_date'] = Variable<DateTime>(sourceDate);
    }
    return map;
  }

  SourcesCompanion toCompanion(bool nullToAbsent) {
    return SourcesCompanion(
      sourceId: Value(sourceId),
      sourceType: Value(sourceType),
      name: Value(name),
      citation: citation == null && nullToAbsent
          ? const Value.absent()
          : Value(citation),
      sourceDate: sourceDate == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceDate),
    );
  }

  factory Source.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Source(
      sourceId: serializer.fromJson<int>(json['sourceId']),
      sourceType: serializer.fromJson<String>(json['sourceType']),
      name: serializer.fromJson<String>(json['name']),
      citation: serializer.fromJson<String?>(json['citation']),
      sourceDate: serializer.fromJson<DateTime?>(json['sourceDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'sourceId': serializer.toJson<int>(sourceId),
      'sourceType': serializer.toJson<String>(sourceType),
      'name': serializer.toJson<String>(name),
      'citation': serializer.toJson<String?>(citation),
      'sourceDate': serializer.toJson<DateTime?>(sourceDate),
    };
  }

  Source copyWith(
          {int? sourceId,
          String? sourceType,
          String? name,
          Value<String?> citation = const Value.absent(),
          Value<DateTime?> sourceDate = const Value.absent()}) =>
      Source(
        sourceId: sourceId ?? this.sourceId,
        sourceType: sourceType ?? this.sourceType,
        name: name ?? this.name,
        citation: citation.present ? citation.value : this.citation,
        sourceDate: sourceDate.present ? sourceDate.value : this.sourceDate,
      );
  Source copyWithCompanion(SourcesCompanion data) {
    return Source(
      sourceId: data.sourceId.present ? data.sourceId.value : this.sourceId,
      sourceType:
          data.sourceType.present ? data.sourceType.value : this.sourceType,
      name: data.name.present ? data.name.value : this.name,
      citation: data.citation.present ? data.citation.value : this.citation,
      sourceDate:
          data.sourceDate.present ? data.sourceDate.value : this.sourceDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Source(')
          ..write('sourceId: $sourceId, ')
          ..write('sourceType: $sourceType, ')
          ..write('name: $name, ')
          ..write('citation: $citation, ')
          ..write('sourceDate: $sourceDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(sourceId, sourceType, name, citation, sourceDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Source &&
          other.sourceId == this.sourceId &&
          other.sourceType == this.sourceType &&
          other.name == this.name &&
          other.citation == this.citation &&
          other.sourceDate == this.sourceDate);
}

class SourcesCompanion extends UpdateCompanion<Source> {
  final Value<int> sourceId;
  final Value<String> sourceType;
  final Value<String> name;
  final Value<String?> citation;
  final Value<DateTime?> sourceDate;
  const SourcesCompanion({
    this.sourceId = const Value.absent(),
    this.sourceType = const Value.absent(),
    this.name = const Value.absent(),
    this.citation = const Value.absent(),
    this.sourceDate = const Value.absent(),
  });
  SourcesCompanion.insert({
    this.sourceId = const Value.absent(),
    required String sourceType,
    required String name,
    this.citation = const Value.absent(),
    this.sourceDate = const Value.absent(),
  })  : sourceType = Value(sourceType),
        name = Value(name);
  static Insertable<Source> custom({
    Expression<int>? sourceId,
    Expression<String>? sourceType,
    Expression<String>? name,
    Expression<String>? citation,
    Expression<DateTime>? sourceDate,
  }) {
    return RawValuesInsertable({
      if (sourceId != null) 'source_id': sourceId,
      if (sourceType != null) 'source_type': sourceType,
      if (name != null) 'name': name,
      if (citation != null) 'citation': citation,
      if (sourceDate != null) 'source_date': sourceDate,
    });
  }

  SourcesCompanion copyWith(
      {Value<int>? sourceId,
      Value<String>? sourceType,
      Value<String>? name,
      Value<String?>? citation,
      Value<DateTime?>? sourceDate}) {
    return SourcesCompanion(
      sourceId: sourceId ?? this.sourceId,
      sourceType: sourceType ?? this.sourceType,
      name: name ?? this.name,
      citation: citation ?? this.citation,
      sourceDate: sourceDate ?? this.sourceDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (sourceId.present) {
      map['source_id'] = Variable<int>(sourceId.value);
    }
    if (sourceType.present) {
      map['source_type'] = Variable<String>(sourceType.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (citation.present) {
      map['citation'] = Variable<String>(citation.value);
    }
    if (sourceDate.present) {
      map['source_date'] = Variable<DateTime>(sourceDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SourcesCompanion(')
          ..write('sourceId: $sourceId, ')
          ..write('sourceType: $sourceType, ')
          ..write('name: $name, ')
          ..write('citation: $citation, ')
          ..write('sourceDate: $sourceDate')
          ..write(')'))
        .toString();
  }
}

class $FarmingRulesTable extends FarmingRules
    with TableInfo<$FarmingRulesTable, FarmingRule> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FarmingRulesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _ruleIdMeta = const VerificationMeta('ruleId');
  @override
  late final GeneratedColumn<int> ruleId = GeneratedColumn<int>(
      'rule_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _skyTriggerIdMeta =
      const VerificationMeta('skyTriggerId');
  @override
  late final GeneratedColumn<int> skyTriggerId = GeneratedColumn<int>(
      'sky_trigger_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _weatherTriggerIdMeta =
      const VerificationMeta('weatherTriggerId');
  @override
  late final GeneratedColumn<int> weatherTriggerId = GeneratedColumn<int>(
      'weather_trigger_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _activityIdMeta =
      const VerificationMeta('activityId');
  @override
  late final GeneratedColumn<int> activityId = GeneratedColumn<int>(
      'activity_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _cropIdMeta = const VerificationMeta('cropId');
  @override
  late final GeneratedColumn<int> cropId = GeneratedColumn<int>(
      'crop_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _regionIdMeta =
      const VerificationMeta('regionId');
  @override
  late final GeneratedColumn<int> regionId = GeneratedColumn<int>(
      'region_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _sourceIdMeta =
      const VerificationMeta('sourceId');
  @override
  late final GeneratedColumn<int> sourceId = GeneratedColumn<int>(
      'source_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _guidanceI18nMeta =
      const VerificationMeta('guidanceI18n');
  @override
  late final GeneratedColumn<String> guidanceI18n = GeneratedColumn<String>(
      'guidance_i18n', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _severityMeta =
      const VerificationMeta('severity');
  @override
  late final GeneratedColumn<String> severity = GeneratedColumn<String>(
      'severity', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _verificationStatusMeta =
      const VerificationMeta('verificationStatus');
  @override
  late final GeneratedColumn<String> verificationStatus =
      GeneratedColumn<String>('verification_status', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultValue: const Constant('draft'));
  @override
  List<GeneratedColumn> get $columns => [
        ruleId,
        skyTriggerId,
        weatherTriggerId,
        activityId,
        cropId,
        regionId,
        sourceId,
        guidanceI18n,
        severity,
        verificationStatus
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'farming_rules';
  @override
  VerificationContext validateIntegrity(Insertable<FarmingRule> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('rule_id')) {
      context.handle(_ruleIdMeta,
          ruleId.isAcceptableOrUnknown(data['rule_id']!, _ruleIdMeta));
    }
    if (data.containsKey('sky_trigger_id')) {
      context.handle(
          _skyTriggerIdMeta,
          skyTriggerId.isAcceptableOrUnknown(
              data['sky_trigger_id']!, _skyTriggerIdMeta));
    }
    if (data.containsKey('weather_trigger_id')) {
      context.handle(
          _weatherTriggerIdMeta,
          weatherTriggerId.isAcceptableOrUnknown(
              data['weather_trigger_id']!, _weatherTriggerIdMeta));
    }
    if (data.containsKey('activity_id')) {
      context.handle(
          _activityIdMeta,
          activityId.isAcceptableOrUnknown(
              data['activity_id']!, _activityIdMeta));
    } else if (isInserting) {
      context.missing(_activityIdMeta);
    }
    if (data.containsKey('crop_id')) {
      context.handle(_cropIdMeta,
          cropId.isAcceptableOrUnknown(data['crop_id']!, _cropIdMeta));
    }
    if (data.containsKey('region_id')) {
      context.handle(_regionIdMeta,
          regionId.isAcceptableOrUnknown(data['region_id']!, _regionIdMeta));
    }
    if (data.containsKey('source_id')) {
      context.handle(_sourceIdMeta,
          sourceId.isAcceptableOrUnknown(data['source_id']!, _sourceIdMeta));
    } else if (isInserting) {
      context.missing(_sourceIdMeta);
    }
    if (data.containsKey('guidance_i18n')) {
      context.handle(
          _guidanceI18nMeta,
          guidanceI18n.isAcceptableOrUnknown(
              data['guidance_i18n']!, _guidanceI18nMeta));
    } else if (isInserting) {
      context.missing(_guidanceI18nMeta);
    }
    if (data.containsKey('severity')) {
      context.handle(_severityMeta,
          severity.isAcceptableOrUnknown(data['severity']!, _severityMeta));
    }
    if (data.containsKey('verification_status')) {
      context.handle(
          _verificationStatusMeta,
          verificationStatus.isAcceptableOrUnknown(
              data['verification_status']!, _verificationStatusMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {ruleId};
  @override
  FarmingRule map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FarmingRule(
      ruleId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}rule_id'])!,
      skyTriggerId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sky_trigger_id']),
      weatherTriggerId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}weather_trigger_id']),
      activityId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}activity_id'])!,
      cropId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}crop_id']),
      regionId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}region_id']),
      sourceId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}source_id'])!,
      guidanceI18n: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}guidance_i18n'])!,
      severity: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}severity']),
      verificationStatus: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}verification_status'])!,
    );
  }

  @override
  $FarmingRulesTable createAlias(String alias) {
    return $FarmingRulesTable(attachedDatabase, alias);
  }
}

class FarmingRule extends DataClass implements Insertable<FarmingRule> {
  final int ruleId;
  final int? skyTriggerId;
  final int? weatherTriggerId;
  final int activityId;
  final int? cropId;
  final int? regionId;
  final int sourceId;
  final String guidanceI18n;
  final String? severity;
  final String verificationStatus;
  const FarmingRule(
      {required this.ruleId,
      this.skyTriggerId,
      this.weatherTriggerId,
      required this.activityId,
      this.cropId,
      this.regionId,
      required this.sourceId,
      required this.guidanceI18n,
      this.severity,
      required this.verificationStatus});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['rule_id'] = Variable<int>(ruleId);
    if (!nullToAbsent || skyTriggerId != null) {
      map['sky_trigger_id'] = Variable<int>(skyTriggerId);
    }
    if (!nullToAbsent || weatherTriggerId != null) {
      map['weather_trigger_id'] = Variable<int>(weatherTriggerId);
    }
    map['activity_id'] = Variable<int>(activityId);
    if (!nullToAbsent || cropId != null) {
      map['crop_id'] = Variable<int>(cropId);
    }
    if (!nullToAbsent || regionId != null) {
      map['region_id'] = Variable<int>(regionId);
    }
    map['source_id'] = Variable<int>(sourceId);
    map['guidance_i18n'] = Variable<String>(guidanceI18n);
    if (!nullToAbsent || severity != null) {
      map['severity'] = Variable<String>(severity);
    }
    map['verification_status'] = Variable<String>(verificationStatus);
    return map;
  }

  FarmingRulesCompanion toCompanion(bool nullToAbsent) {
    return FarmingRulesCompanion(
      ruleId: Value(ruleId),
      skyTriggerId: skyTriggerId == null && nullToAbsent
          ? const Value.absent()
          : Value(skyTriggerId),
      weatherTriggerId: weatherTriggerId == null && nullToAbsent
          ? const Value.absent()
          : Value(weatherTriggerId),
      activityId: Value(activityId),
      cropId:
          cropId == null && nullToAbsent ? const Value.absent() : Value(cropId),
      regionId: regionId == null && nullToAbsent
          ? const Value.absent()
          : Value(regionId),
      sourceId: Value(sourceId),
      guidanceI18n: Value(guidanceI18n),
      severity: severity == null && nullToAbsent
          ? const Value.absent()
          : Value(severity),
      verificationStatus: Value(verificationStatus),
    );
  }

  factory FarmingRule.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FarmingRule(
      ruleId: serializer.fromJson<int>(json['ruleId']),
      skyTriggerId: serializer.fromJson<int?>(json['skyTriggerId']),
      weatherTriggerId: serializer.fromJson<int?>(json['weatherTriggerId']),
      activityId: serializer.fromJson<int>(json['activityId']),
      cropId: serializer.fromJson<int?>(json['cropId']),
      regionId: serializer.fromJson<int?>(json['regionId']),
      sourceId: serializer.fromJson<int>(json['sourceId']),
      guidanceI18n: serializer.fromJson<String>(json['guidanceI18n']),
      severity: serializer.fromJson<String?>(json['severity']),
      verificationStatus:
          serializer.fromJson<String>(json['verificationStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'ruleId': serializer.toJson<int>(ruleId),
      'skyTriggerId': serializer.toJson<int?>(skyTriggerId),
      'weatherTriggerId': serializer.toJson<int?>(weatherTriggerId),
      'activityId': serializer.toJson<int>(activityId),
      'cropId': serializer.toJson<int?>(cropId),
      'regionId': serializer.toJson<int?>(regionId),
      'sourceId': serializer.toJson<int>(sourceId),
      'guidanceI18n': serializer.toJson<String>(guidanceI18n),
      'severity': serializer.toJson<String?>(severity),
      'verificationStatus': serializer.toJson<String>(verificationStatus),
    };
  }

  FarmingRule copyWith(
          {int? ruleId,
          Value<int?> skyTriggerId = const Value.absent(),
          Value<int?> weatherTriggerId = const Value.absent(),
          int? activityId,
          Value<int?> cropId = const Value.absent(),
          Value<int?> regionId = const Value.absent(),
          int? sourceId,
          String? guidanceI18n,
          Value<String?> severity = const Value.absent(),
          String? verificationStatus}) =>
      FarmingRule(
        ruleId: ruleId ?? this.ruleId,
        skyTriggerId:
            skyTriggerId.present ? skyTriggerId.value : this.skyTriggerId,
        weatherTriggerId: weatherTriggerId.present
            ? weatherTriggerId.value
            : this.weatherTriggerId,
        activityId: activityId ?? this.activityId,
        cropId: cropId.present ? cropId.value : this.cropId,
        regionId: regionId.present ? regionId.value : this.regionId,
        sourceId: sourceId ?? this.sourceId,
        guidanceI18n: guidanceI18n ?? this.guidanceI18n,
        severity: severity.present ? severity.value : this.severity,
        verificationStatus: verificationStatus ?? this.verificationStatus,
      );
  FarmingRule copyWithCompanion(FarmingRulesCompanion data) {
    return FarmingRule(
      ruleId: data.ruleId.present ? data.ruleId.value : this.ruleId,
      skyTriggerId: data.skyTriggerId.present
          ? data.skyTriggerId.value
          : this.skyTriggerId,
      weatherTriggerId: data.weatherTriggerId.present
          ? data.weatherTriggerId.value
          : this.weatherTriggerId,
      activityId:
          data.activityId.present ? data.activityId.value : this.activityId,
      cropId: data.cropId.present ? data.cropId.value : this.cropId,
      regionId: data.regionId.present ? data.regionId.value : this.regionId,
      sourceId: data.sourceId.present ? data.sourceId.value : this.sourceId,
      guidanceI18n: data.guidanceI18n.present
          ? data.guidanceI18n.value
          : this.guidanceI18n,
      severity: data.severity.present ? data.severity.value : this.severity,
      verificationStatus: data.verificationStatus.present
          ? data.verificationStatus.value
          : this.verificationStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FarmingRule(')
          ..write('ruleId: $ruleId, ')
          ..write('skyTriggerId: $skyTriggerId, ')
          ..write('weatherTriggerId: $weatherTriggerId, ')
          ..write('activityId: $activityId, ')
          ..write('cropId: $cropId, ')
          ..write('regionId: $regionId, ')
          ..write('sourceId: $sourceId, ')
          ..write('guidanceI18n: $guidanceI18n, ')
          ..write('severity: $severity, ')
          ..write('verificationStatus: $verificationStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      ruleId,
      skyTriggerId,
      weatherTriggerId,
      activityId,
      cropId,
      regionId,
      sourceId,
      guidanceI18n,
      severity,
      verificationStatus);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FarmingRule &&
          other.ruleId == this.ruleId &&
          other.skyTriggerId == this.skyTriggerId &&
          other.weatherTriggerId == this.weatherTriggerId &&
          other.activityId == this.activityId &&
          other.cropId == this.cropId &&
          other.regionId == this.regionId &&
          other.sourceId == this.sourceId &&
          other.guidanceI18n == this.guidanceI18n &&
          other.severity == this.severity &&
          other.verificationStatus == this.verificationStatus);
}

class FarmingRulesCompanion extends UpdateCompanion<FarmingRule> {
  final Value<int> ruleId;
  final Value<int?> skyTriggerId;
  final Value<int?> weatherTriggerId;
  final Value<int> activityId;
  final Value<int?> cropId;
  final Value<int?> regionId;
  final Value<int> sourceId;
  final Value<String> guidanceI18n;
  final Value<String?> severity;
  final Value<String> verificationStatus;
  const FarmingRulesCompanion({
    this.ruleId = const Value.absent(),
    this.skyTriggerId = const Value.absent(),
    this.weatherTriggerId = const Value.absent(),
    this.activityId = const Value.absent(),
    this.cropId = const Value.absent(),
    this.regionId = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.guidanceI18n = const Value.absent(),
    this.severity = const Value.absent(),
    this.verificationStatus = const Value.absent(),
  });
  FarmingRulesCompanion.insert({
    this.ruleId = const Value.absent(),
    this.skyTriggerId = const Value.absent(),
    this.weatherTriggerId = const Value.absent(),
    required int activityId,
    this.cropId = const Value.absent(),
    this.regionId = const Value.absent(),
    required int sourceId,
    required String guidanceI18n,
    this.severity = const Value.absent(),
    this.verificationStatus = const Value.absent(),
  })  : activityId = Value(activityId),
        sourceId = Value(sourceId),
        guidanceI18n = Value(guidanceI18n);
  static Insertable<FarmingRule> custom({
    Expression<int>? ruleId,
    Expression<int>? skyTriggerId,
    Expression<int>? weatherTriggerId,
    Expression<int>? activityId,
    Expression<int>? cropId,
    Expression<int>? regionId,
    Expression<int>? sourceId,
    Expression<String>? guidanceI18n,
    Expression<String>? severity,
    Expression<String>? verificationStatus,
  }) {
    return RawValuesInsertable({
      if (ruleId != null) 'rule_id': ruleId,
      if (skyTriggerId != null) 'sky_trigger_id': skyTriggerId,
      if (weatherTriggerId != null) 'weather_trigger_id': weatherTriggerId,
      if (activityId != null) 'activity_id': activityId,
      if (cropId != null) 'crop_id': cropId,
      if (regionId != null) 'region_id': regionId,
      if (sourceId != null) 'source_id': sourceId,
      if (guidanceI18n != null) 'guidance_i18n': guidanceI18n,
      if (severity != null) 'severity': severity,
      if (verificationStatus != null) 'verification_status': verificationStatus,
    });
  }

  FarmingRulesCompanion copyWith(
      {Value<int>? ruleId,
      Value<int?>? skyTriggerId,
      Value<int?>? weatherTriggerId,
      Value<int>? activityId,
      Value<int?>? cropId,
      Value<int?>? regionId,
      Value<int>? sourceId,
      Value<String>? guidanceI18n,
      Value<String?>? severity,
      Value<String>? verificationStatus}) {
    return FarmingRulesCompanion(
      ruleId: ruleId ?? this.ruleId,
      skyTriggerId: skyTriggerId ?? this.skyTriggerId,
      weatherTriggerId: weatherTriggerId ?? this.weatherTriggerId,
      activityId: activityId ?? this.activityId,
      cropId: cropId ?? this.cropId,
      regionId: regionId ?? this.regionId,
      sourceId: sourceId ?? this.sourceId,
      guidanceI18n: guidanceI18n ?? this.guidanceI18n,
      severity: severity ?? this.severity,
      verificationStatus: verificationStatus ?? this.verificationStatus,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (ruleId.present) {
      map['rule_id'] = Variable<int>(ruleId.value);
    }
    if (skyTriggerId.present) {
      map['sky_trigger_id'] = Variable<int>(skyTriggerId.value);
    }
    if (weatherTriggerId.present) {
      map['weather_trigger_id'] = Variable<int>(weatherTriggerId.value);
    }
    if (activityId.present) {
      map['activity_id'] = Variable<int>(activityId.value);
    }
    if (cropId.present) {
      map['crop_id'] = Variable<int>(cropId.value);
    }
    if (regionId.present) {
      map['region_id'] = Variable<int>(regionId.value);
    }
    if (sourceId.present) {
      map['source_id'] = Variable<int>(sourceId.value);
    }
    if (guidanceI18n.present) {
      map['guidance_i18n'] = Variable<String>(guidanceI18n.value);
    }
    if (severity.present) {
      map['severity'] = Variable<String>(severity.value);
    }
    if (verificationStatus.present) {
      map['verification_status'] = Variable<String>(verificationStatus.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FarmingRulesCompanion(')
          ..write('ruleId: $ruleId, ')
          ..write('skyTriggerId: $skyTriggerId, ')
          ..write('weatherTriggerId: $weatherTriggerId, ')
          ..write('activityId: $activityId, ')
          ..write('cropId: $cropId, ')
          ..write('regionId: $regionId, ')
          ..write('sourceId: $sourceId, ')
          ..write('guidanceI18n: $guidanceI18n, ')
          ..write('severity: $severity, ')
          ..write('verificationStatus: $verificationStatus')
          ..write(')'))
        .toString();
  }
}

class $SeasonalClimateNormalsTable extends SeasonalClimateNormals
    with TableInfo<$SeasonalClimateNormalsTable, SeasonalClimateNormal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SeasonalClimateNormalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _regionIdMeta =
      const VerificationMeta('regionId');
  @override
  late final GeneratedColumn<int> regionId = GeneratedColumn<int>(
      'region_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _monthMeta = const VerificationMeta('month');
  @override
  late final GeneratedColumn<int> month = GeneratedColumn<int>(
      'month', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _skyTriggerIdMeta =
      const VerificationMeta('skyTriggerId');
  @override
  late final GeneratedColumn<int> skyTriggerId = GeneratedColumn<int>(
      'sky_trigger_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _avgRainMmMeta =
      const VerificationMeta('avgRainMm');
  @override
  late final GeneratedColumn<double> avgRainMm = GeneratedColumn<double>(
      'avg_rain_mm', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _tempMinCMeta =
      const VerificationMeta('tempMinC');
  @override
  late final GeneratedColumn<double> tempMinC = GeneratedColumn<double>(
      'temp_min_c', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _tempMaxCMeta =
      const VerificationMeta('tempMaxC');
  @override
  late final GeneratedColumn<double> tempMaxC = GeneratedColumn<double>(
      'temp_max_c', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _classificationMeta =
      const VerificationMeta('classification');
  @override
  late final GeneratedColumn<String> classification = GeneratedColumn<String>(
      'classification', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sourceIdMeta =
      const VerificationMeta('sourceId');
  @override
  late final GeneratedColumn<int> sourceId = GeneratedColumn<int>(
      'source_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _verificationStatusMeta =
      const VerificationMeta('verificationStatus');
  @override
  late final GeneratedColumn<String> verificationStatus =
      GeneratedColumn<String>('verification_status', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultValue: const Constant('draft'));
  @override
  List<GeneratedColumn> get $columns => [
        regionId,
        month,
        skyTriggerId,
        avgRainMm,
        tempMinC,
        tempMaxC,
        classification,
        sourceId,
        verificationStatus
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'seasonal_climate_normals';
  @override
  VerificationContext validateIntegrity(
      Insertable<SeasonalClimateNormal> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('region_id')) {
      context.handle(_regionIdMeta,
          regionId.isAcceptableOrUnknown(data['region_id']!, _regionIdMeta));
    } else if (isInserting) {
      context.missing(_regionIdMeta);
    }
    if (data.containsKey('month')) {
      context.handle(
          _monthMeta, month.isAcceptableOrUnknown(data['month']!, _monthMeta));
    } else if (isInserting) {
      context.missing(_monthMeta);
    }
    if (data.containsKey('sky_trigger_id')) {
      context.handle(
          _skyTriggerIdMeta,
          skyTriggerId.isAcceptableOrUnknown(
              data['sky_trigger_id']!, _skyTriggerIdMeta));
    }
    if (data.containsKey('avg_rain_mm')) {
      context.handle(
          _avgRainMmMeta,
          avgRainMm.isAcceptableOrUnknown(
              data['avg_rain_mm']!, _avgRainMmMeta));
    } else if (isInserting) {
      context.missing(_avgRainMmMeta);
    }
    if (data.containsKey('temp_min_c')) {
      context.handle(_tempMinCMeta,
          tempMinC.isAcceptableOrUnknown(data['temp_min_c']!, _tempMinCMeta));
    } else if (isInserting) {
      context.missing(_tempMinCMeta);
    }
    if (data.containsKey('temp_max_c')) {
      context.handle(_tempMaxCMeta,
          tempMaxC.isAcceptableOrUnknown(data['temp_max_c']!, _tempMaxCMeta));
    } else if (isInserting) {
      context.missing(_tempMaxCMeta);
    }
    if (data.containsKey('classification')) {
      context.handle(
          _classificationMeta,
          classification.isAcceptableOrUnknown(
              data['classification']!, _classificationMeta));
    } else if (isInserting) {
      context.missing(_classificationMeta);
    }
    if (data.containsKey('source_id')) {
      context.handle(_sourceIdMeta,
          sourceId.isAcceptableOrUnknown(data['source_id']!, _sourceIdMeta));
    } else if (isInserting) {
      context.missing(_sourceIdMeta);
    }
    if (data.containsKey('verification_status')) {
      context.handle(
          _verificationStatusMeta,
          verificationStatus.isAcceptableOrUnknown(
              data['verification_status']!, _verificationStatusMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {regionId, month};
  @override
  SeasonalClimateNormal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SeasonalClimateNormal(
      regionId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}region_id'])!,
      month: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}month'])!,
      skyTriggerId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sky_trigger_id']),
      avgRainMm: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}avg_rain_mm'])!,
      tempMinC: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}temp_min_c'])!,
      tempMaxC: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}temp_max_c'])!,
      classification: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}classification'])!,
      sourceId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}source_id'])!,
      verificationStatus: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}verification_status'])!,
    );
  }

  @override
  $SeasonalClimateNormalsTable createAlias(String alias) {
    return $SeasonalClimateNormalsTable(attachedDatabase, alias);
  }
}

class SeasonalClimateNormal extends DataClass
    implements Insertable<SeasonalClimateNormal> {
  final int regionId;
  final int month;
  final int? skyTriggerId;
  final double avgRainMm;
  final double tempMinC;
  final double tempMaxC;
  final String classification;
  final int sourceId;
  final String verificationStatus;
  const SeasonalClimateNormal(
      {required this.regionId,
      required this.month,
      this.skyTriggerId,
      required this.avgRainMm,
      required this.tempMinC,
      required this.tempMaxC,
      required this.classification,
      required this.sourceId,
      required this.verificationStatus});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['region_id'] = Variable<int>(regionId);
    map['month'] = Variable<int>(month);
    if (!nullToAbsent || skyTriggerId != null) {
      map['sky_trigger_id'] = Variable<int>(skyTriggerId);
    }
    map['avg_rain_mm'] = Variable<double>(avgRainMm);
    map['temp_min_c'] = Variable<double>(tempMinC);
    map['temp_max_c'] = Variable<double>(tempMaxC);
    map['classification'] = Variable<String>(classification);
    map['source_id'] = Variable<int>(sourceId);
    map['verification_status'] = Variable<String>(verificationStatus);
    return map;
  }

  SeasonalClimateNormalsCompanion toCompanion(bool nullToAbsent) {
    return SeasonalClimateNormalsCompanion(
      regionId: Value(regionId),
      month: Value(month),
      skyTriggerId: skyTriggerId == null && nullToAbsent
          ? const Value.absent()
          : Value(skyTriggerId),
      avgRainMm: Value(avgRainMm),
      tempMinC: Value(tempMinC),
      tempMaxC: Value(tempMaxC),
      classification: Value(classification),
      sourceId: Value(sourceId),
      verificationStatus: Value(verificationStatus),
    );
  }

  factory SeasonalClimateNormal.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SeasonalClimateNormal(
      regionId: serializer.fromJson<int>(json['regionId']),
      month: serializer.fromJson<int>(json['month']),
      skyTriggerId: serializer.fromJson<int?>(json['skyTriggerId']),
      avgRainMm: serializer.fromJson<double>(json['avgRainMm']),
      tempMinC: serializer.fromJson<double>(json['tempMinC']),
      tempMaxC: serializer.fromJson<double>(json['tempMaxC']),
      classification: serializer.fromJson<String>(json['classification']),
      sourceId: serializer.fromJson<int>(json['sourceId']),
      verificationStatus:
          serializer.fromJson<String>(json['verificationStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'regionId': serializer.toJson<int>(regionId),
      'month': serializer.toJson<int>(month),
      'skyTriggerId': serializer.toJson<int?>(skyTriggerId),
      'avgRainMm': serializer.toJson<double>(avgRainMm),
      'tempMinC': serializer.toJson<double>(tempMinC),
      'tempMaxC': serializer.toJson<double>(tempMaxC),
      'classification': serializer.toJson<String>(classification),
      'sourceId': serializer.toJson<int>(sourceId),
      'verificationStatus': serializer.toJson<String>(verificationStatus),
    };
  }

  SeasonalClimateNormal copyWith(
          {int? regionId,
          int? month,
          Value<int?> skyTriggerId = const Value.absent(),
          double? avgRainMm,
          double? tempMinC,
          double? tempMaxC,
          String? classification,
          int? sourceId,
          String? verificationStatus}) =>
      SeasonalClimateNormal(
        regionId: regionId ?? this.regionId,
        month: month ?? this.month,
        skyTriggerId:
            skyTriggerId.present ? skyTriggerId.value : this.skyTriggerId,
        avgRainMm: avgRainMm ?? this.avgRainMm,
        tempMinC: tempMinC ?? this.tempMinC,
        tempMaxC: tempMaxC ?? this.tempMaxC,
        classification: classification ?? this.classification,
        sourceId: sourceId ?? this.sourceId,
        verificationStatus: verificationStatus ?? this.verificationStatus,
      );
  SeasonalClimateNormal copyWithCompanion(
      SeasonalClimateNormalsCompanion data) {
    return SeasonalClimateNormal(
      regionId: data.regionId.present ? data.regionId.value : this.regionId,
      month: data.month.present ? data.month.value : this.month,
      skyTriggerId: data.skyTriggerId.present
          ? data.skyTriggerId.value
          : this.skyTriggerId,
      avgRainMm: data.avgRainMm.present ? data.avgRainMm.value : this.avgRainMm,
      tempMinC: data.tempMinC.present ? data.tempMinC.value : this.tempMinC,
      tempMaxC: data.tempMaxC.present ? data.tempMaxC.value : this.tempMaxC,
      classification: data.classification.present
          ? data.classification.value
          : this.classification,
      sourceId: data.sourceId.present ? data.sourceId.value : this.sourceId,
      verificationStatus: data.verificationStatus.present
          ? data.verificationStatus.value
          : this.verificationStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SeasonalClimateNormal(')
          ..write('regionId: $regionId, ')
          ..write('month: $month, ')
          ..write('skyTriggerId: $skyTriggerId, ')
          ..write('avgRainMm: $avgRainMm, ')
          ..write('tempMinC: $tempMinC, ')
          ..write('tempMaxC: $tempMaxC, ')
          ..write('classification: $classification, ')
          ..write('sourceId: $sourceId, ')
          ..write('verificationStatus: $verificationStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(regionId, month, skyTriggerId, avgRainMm,
      tempMinC, tempMaxC, classification, sourceId, verificationStatus);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SeasonalClimateNormal &&
          other.regionId == this.regionId &&
          other.month == this.month &&
          other.skyTriggerId == this.skyTriggerId &&
          other.avgRainMm == this.avgRainMm &&
          other.tempMinC == this.tempMinC &&
          other.tempMaxC == this.tempMaxC &&
          other.classification == this.classification &&
          other.sourceId == this.sourceId &&
          other.verificationStatus == this.verificationStatus);
}

class SeasonalClimateNormalsCompanion
    extends UpdateCompanion<SeasonalClimateNormal> {
  final Value<int> regionId;
  final Value<int> month;
  final Value<int?> skyTriggerId;
  final Value<double> avgRainMm;
  final Value<double> tempMinC;
  final Value<double> tempMaxC;
  final Value<String> classification;
  final Value<int> sourceId;
  final Value<String> verificationStatus;
  final Value<int> rowid;
  const SeasonalClimateNormalsCompanion({
    this.regionId = const Value.absent(),
    this.month = const Value.absent(),
    this.skyTriggerId = const Value.absent(),
    this.avgRainMm = const Value.absent(),
    this.tempMinC = const Value.absent(),
    this.tempMaxC = const Value.absent(),
    this.classification = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.verificationStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SeasonalClimateNormalsCompanion.insert({
    required int regionId,
    required int month,
    this.skyTriggerId = const Value.absent(),
    required double avgRainMm,
    required double tempMinC,
    required double tempMaxC,
    required String classification,
    required int sourceId,
    this.verificationStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : regionId = Value(regionId),
        month = Value(month),
        avgRainMm = Value(avgRainMm),
        tempMinC = Value(tempMinC),
        tempMaxC = Value(tempMaxC),
        classification = Value(classification),
        sourceId = Value(sourceId);
  static Insertable<SeasonalClimateNormal> custom({
    Expression<int>? regionId,
    Expression<int>? month,
    Expression<int>? skyTriggerId,
    Expression<double>? avgRainMm,
    Expression<double>? tempMinC,
    Expression<double>? tempMaxC,
    Expression<String>? classification,
    Expression<int>? sourceId,
    Expression<String>? verificationStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (regionId != null) 'region_id': regionId,
      if (month != null) 'month': month,
      if (skyTriggerId != null) 'sky_trigger_id': skyTriggerId,
      if (avgRainMm != null) 'avg_rain_mm': avgRainMm,
      if (tempMinC != null) 'temp_min_c': tempMinC,
      if (tempMaxC != null) 'temp_max_c': tempMaxC,
      if (classification != null) 'classification': classification,
      if (sourceId != null) 'source_id': sourceId,
      if (verificationStatus != null) 'verification_status': verificationStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SeasonalClimateNormalsCompanion copyWith(
      {Value<int>? regionId,
      Value<int>? month,
      Value<int?>? skyTriggerId,
      Value<double>? avgRainMm,
      Value<double>? tempMinC,
      Value<double>? tempMaxC,
      Value<String>? classification,
      Value<int>? sourceId,
      Value<String>? verificationStatus,
      Value<int>? rowid}) {
    return SeasonalClimateNormalsCompanion(
      regionId: regionId ?? this.regionId,
      month: month ?? this.month,
      skyTriggerId: skyTriggerId ?? this.skyTriggerId,
      avgRainMm: avgRainMm ?? this.avgRainMm,
      tempMinC: tempMinC ?? this.tempMinC,
      tempMaxC: tempMaxC ?? this.tempMaxC,
      classification: classification ?? this.classification,
      sourceId: sourceId ?? this.sourceId,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (regionId.present) {
      map['region_id'] = Variable<int>(regionId.value);
    }
    if (month.present) {
      map['month'] = Variable<int>(month.value);
    }
    if (skyTriggerId.present) {
      map['sky_trigger_id'] = Variable<int>(skyTriggerId.value);
    }
    if (avgRainMm.present) {
      map['avg_rain_mm'] = Variable<double>(avgRainMm.value);
    }
    if (tempMinC.present) {
      map['temp_min_c'] = Variable<double>(tempMinC.value);
    }
    if (tempMaxC.present) {
      map['temp_max_c'] = Variable<double>(tempMaxC.value);
    }
    if (classification.present) {
      map['classification'] = Variable<String>(classification.value);
    }
    if (sourceId.present) {
      map['source_id'] = Variable<int>(sourceId.value);
    }
    if (verificationStatus.present) {
      map['verification_status'] = Variable<String>(verificationStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SeasonalClimateNormalsCompanion(')
          ..write('regionId: $regionId, ')
          ..write('month: $month, ')
          ..write('skyTriggerId: $skyTriggerId, ')
          ..write('avgRainMm: $avgRainMm, ')
          ..write('tempMinC: $tempMinC, ')
          ..write('tempMaxC: $tempMaxC, ')
          ..write('classification: $classification, ')
          ..write('sourceId: $sourceId, ')
          ..write('verificationStatus: $verificationStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$FarmingDb extends GeneratedDatabase {
  _$FarmingDb(QueryExecutor e) : super(e);
  $FarmingDbManager get managers => $FarmingDbManager(this);
  late final $SkyTriggersTable skyTriggers = $SkyTriggersTable(this);
  late final $WeatherTriggersTable weatherTriggers =
      $WeatherTriggersTable(this);
  late final $ActivitiesTable activities = $ActivitiesTable(this);
  late final $CropsTable crops = $CropsTable(this);
  late final $RegionsTable regions = $RegionsTable(this);
  late final $SourcesTable sources = $SourcesTable(this);
  late final $FarmingRulesTable farmingRules = $FarmingRulesTable(this);
  late final $SeasonalClimateNormalsTable seasonalClimateNormals =
      $SeasonalClimateNormalsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        skyTriggers,
        weatherTriggers,
        activities,
        crops,
        regions,
        sources,
        farmingRules,
        seasonalClimateNormals
      ];
}

typedef $$SkyTriggersTableCreateCompanionBuilder = SkyTriggersCompanion
    Function({
  Value<int> triggerId,
  required String triggerType,
  Value<String?> constCode,
  Value<String?> paramsJson,
});
typedef $$SkyTriggersTableUpdateCompanionBuilder = SkyTriggersCompanion
    Function({
  Value<int> triggerId,
  Value<String> triggerType,
  Value<String?> constCode,
  Value<String?> paramsJson,
});

class $$SkyTriggersTableFilterComposer
    extends Composer<_$FarmingDb, $SkyTriggersTable> {
  $$SkyTriggersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get triggerId => $composableBuilder(
      column: $table.triggerId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get triggerType => $composableBuilder(
      column: $table.triggerType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get constCode => $composableBuilder(
      column: $table.constCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get paramsJson => $composableBuilder(
      column: $table.paramsJson, builder: (column) => ColumnFilters(column));
}

class $$SkyTriggersTableOrderingComposer
    extends Composer<_$FarmingDb, $SkyTriggersTable> {
  $$SkyTriggersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get triggerId => $composableBuilder(
      column: $table.triggerId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get triggerType => $composableBuilder(
      column: $table.triggerType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get constCode => $composableBuilder(
      column: $table.constCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get paramsJson => $composableBuilder(
      column: $table.paramsJson, builder: (column) => ColumnOrderings(column));
}

class $$SkyTriggersTableAnnotationComposer
    extends Composer<_$FarmingDb, $SkyTriggersTable> {
  $$SkyTriggersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get triggerId =>
      $composableBuilder(column: $table.triggerId, builder: (column) => column);

  GeneratedColumn<String> get triggerType => $composableBuilder(
      column: $table.triggerType, builder: (column) => column);

  GeneratedColumn<String> get constCode =>
      $composableBuilder(column: $table.constCode, builder: (column) => column);

  GeneratedColumn<String> get paramsJson => $composableBuilder(
      column: $table.paramsJson, builder: (column) => column);
}

class $$SkyTriggersTableTableManager extends RootTableManager<
    _$FarmingDb,
    $SkyTriggersTable,
    SkyTrigger,
    $$SkyTriggersTableFilterComposer,
    $$SkyTriggersTableOrderingComposer,
    $$SkyTriggersTableAnnotationComposer,
    $$SkyTriggersTableCreateCompanionBuilder,
    $$SkyTriggersTableUpdateCompanionBuilder,
    (SkyTrigger, BaseReferences<_$FarmingDb, $SkyTriggersTable, SkyTrigger>),
    SkyTrigger,
    PrefetchHooks Function()> {
  $$SkyTriggersTableTableManager(_$FarmingDb db, $SkyTriggersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SkyTriggersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SkyTriggersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SkyTriggersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> triggerId = const Value.absent(),
            Value<String> triggerType = const Value.absent(),
            Value<String?> constCode = const Value.absent(),
            Value<String?> paramsJson = const Value.absent(),
          }) =>
              SkyTriggersCompanion(
            triggerId: triggerId,
            triggerType: triggerType,
            constCode: constCode,
            paramsJson: paramsJson,
          ),
          createCompanionCallback: ({
            Value<int> triggerId = const Value.absent(),
            required String triggerType,
            Value<String?> constCode = const Value.absent(),
            Value<String?> paramsJson = const Value.absent(),
          }) =>
              SkyTriggersCompanion.insert(
            triggerId: triggerId,
            triggerType: triggerType,
            constCode: constCode,
            paramsJson: paramsJson,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SkyTriggersTableProcessedTableManager = ProcessedTableManager<
    _$FarmingDb,
    $SkyTriggersTable,
    SkyTrigger,
    $$SkyTriggersTableFilterComposer,
    $$SkyTriggersTableOrderingComposer,
    $$SkyTriggersTableAnnotationComposer,
    $$SkyTriggersTableCreateCompanionBuilder,
    $$SkyTriggersTableUpdateCompanionBuilder,
    (SkyTrigger, BaseReferences<_$FarmingDb, $SkyTriggersTable, SkyTrigger>),
    SkyTrigger,
    PrefetchHooks Function()>;
typedef $$WeatherTriggersTableCreateCompanionBuilder = WeatherTriggersCompanion
    Function({
  Value<int> triggerId,
  required String variable,
  required String operator,
  required double threshold,
  Value<int?> daysAhead,
  Value<int?> durationDays,
});
typedef $$WeatherTriggersTableUpdateCompanionBuilder = WeatherTriggersCompanion
    Function({
  Value<int> triggerId,
  Value<String> variable,
  Value<String> operator,
  Value<double> threshold,
  Value<int?> daysAhead,
  Value<int?> durationDays,
});

class $$WeatherTriggersTableFilterComposer
    extends Composer<_$FarmingDb, $WeatherTriggersTable> {
  $$WeatherTriggersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get triggerId => $composableBuilder(
      column: $table.triggerId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get variable => $composableBuilder(
      column: $table.variable, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get operator => $composableBuilder(
      column: $table.operator, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get threshold => $composableBuilder(
      column: $table.threshold, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get daysAhead => $composableBuilder(
      column: $table.daysAhead, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get durationDays => $composableBuilder(
      column: $table.durationDays, builder: (column) => ColumnFilters(column));
}

class $$WeatherTriggersTableOrderingComposer
    extends Composer<_$FarmingDb, $WeatherTriggersTable> {
  $$WeatherTriggersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get triggerId => $composableBuilder(
      column: $table.triggerId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get variable => $composableBuilder(
      column: $table.variable, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get operator => $composableBuilder(
      column: $table.operator, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get threshold => $composableBuilder(
      column: $table.threshold, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get daysAhead => $composableBuilder(
      column: $table.daysAhead, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get durationDays => $composableBuilder(
      column: $table.durationDays,
      builder: (column) => ColumnOrderings(column));
}

class $$WeatherTriggersTableAnnotationComposer
    extends Composer<_$FarmingDb, $WeatherTriggersTable> {
  $$WeatherTriggersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get triggerId =>
      $composableBuilder(column: $table.triggerId, builder: (column) => column);

  GeneratedColumn<String> get variable =>
      $composableBuilder(column: $table.variable, builder: (column) => column);

  GeneratedColumn<String> get operator =>
      $composableBuilder(column: $table.operator, builder: (column) => column);

  GeneratedColumn<double> get threshold =>
      $composableBuilder(column: $table.threshold, builder: (column) => column);

  GeneratedColumn<int> get daysAhead =>
      $composableBuilder(column: $table.daysAhead, builder: (column) => column);

  GeneratedColumn<int> get durationDays => $composableBuilder(
      column: $table.durationDays, builder: (column) => column);
}

class $$WeatherTriggersTableTableManager extends RootTableManager<
    _$FarmingDb,
    $WeatherTriggersTable,
    WeatherTrigger,
    $$WeatherTriggersTableFilterComposer,
    $$WeatherTriggersTableOrderingComposer,
    $$WeatherTriggersTableAnnotationComposer,
    $$WeatherTriggersTableCreateCompanionBuilder,
    $$WeatherTriggersTableUpdateCompanionBuilder,
    (
      WeatherTrigger,
      BaseReferences<_$FarmingDb, $WeatherTriggersTable, WeatherTrigger>
    ),
    WeatherTrigger,
    PrefetchHooks Function()> {
  $$WeatherTriggersTableTableManager(
      _$FarmingDb db, $WeatherTriggersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WeatherTriggersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WeatherTriggersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WeatherTriggersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> triggerId = const Value.absent(),
            Value<String> variable = const Value.absent(),
            Value<String> operator = const Value.absent(),
            Value<double> threshold = const Value.absent(),
            Value<int?> daysAhead = const Value.absent(),
            Value<int?> durationDays = const Value.absent(),
          }) =>
              WeatherTriggersCompanion(
            triggerId: triggerId,
            variable: variable,
            operator: operator,
            threshold: threshold,
            daysAhead: daysAhead,
            durationDays: durationDays,
          ),
          createCompanionCallback: ({
            Value<int> triggerId = const Value.absent(),
            required String variable,
            required String operator,
            required double threshold,
            Value<int?> daysAhead = const Value.absent(),
            Value<int?> durationDays = const Value.absent(),
          }) =>
              WeatherTriggersCompanion.insert(
            triggerId: triggerId,
            variable: variable,
            operator: operator,
            threshold: threshold,
            daysAhead: daysAhead,
            durationDays: durationDays,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$WeatherTriggersTableProcessedTableManager = ProcessedTableManager<
    _$FarmingDb,
    $WeatherTriggersTable,
    WeatherTrigger,
    $$WeatherTriggersTableFilterComposer,
    $$WeatherTriggersTableOrderingComposer,
    $$WeatherTriggersTableAnnotationComposer,
    $$WeatherTriggersTableCreateCompanionBuilder,
    $$WeatherTriggersTableUpdateCompanionBuilder,
    (
      WeatherTrigger,
      BaseReferences<_$FarmingDb, $WeatherTriggersTable, WeatherTrigger>
    ),
    WeatherTrigger,
    PrefetchHooks Function()>;
typedef $$ActivitiesTableCreateCompanionBuilder = ActivitiesCompanion Function({
  Value<int> activityId,
  required String activityType,
  required String descriptionI18n,
});
typedef $$ActivitiesTableUpdateCompanionBuilder = ActivitiesCompanion Function({
  Value<int> activityId,
  Value<String> activityType,
  Value<String> descriptionI18n,
});

class $$ActivitiesTableFilterComposer
    extends Composer<_$FarmingDb, $ActivitiesTable> {
  $$ActivitiesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get activityId => $composableBuilder(
      column: $table.activityId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get activityType => $composableBuilder(
      column: $table.activityType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get descriptionI18n => $composableBuilder(
      column: $table.descriptionI18n,
      builder: (column) => ColumnFilters(column));
}

class $$ActivitiesTableOrderingComposer
    extends Composer<_$FarmingDb, $ActivitiesTable> {
  $$ActivitiesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get activityId => $composableBuilder(
      column: $table.activityId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get activityType => $composableBuilder(
      column: $table.activityType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get descriptionI18n => $composableBuilder(
      column: $table.descriptionI18n,
      builder: (column) => ColumnOrderings(column));
}

class $$ActivitiesTableAnnotationComposer
    extends Composer<_$FarmingDb, $ActivitiesTable> {
  $$ActivitiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get activityId => $composableBuilder(
      column: $table.activityId, builder: (column) => column);

  GeneratedColumn<String> get activityType => $composableBuilder(
      column: $table.activityType, builder: (column) => column);

  GeneratedColumn<String> get descriptionI18n => $composableBuilder(
      column: $table.descriptionI18n, builder: (column) => column);
}

class $$ActivitiesTableTableManager extends RootTableManager<
    _$FarmingDb,
    $ActivitiesTable,
    Activity,
    $$ActivitiesTableFilterComposer,
    $$ActivitiesTableOrderingComposer,
    $$ActivitiesTableAnnotationComposer,
    $$ActivitiesTableCreateCompanionBuilder,
    $$ActivitiesTableUpdateCompanionBuilder,
    (Activity, BaseReferences<_$FarmingDb, $ActivitiesTable, Activity>),
    Activity,
    PrefetchHooks Function()> {
  $$ActivitiesTableTableManager(_$FarmingDb db, $ActivitiesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActivitiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ActivitiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ActivitiesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> activityId = const Value.absent(),
            Value<String> activityType = const Value.absent(),
            Value<String> descriptionI18n = const Value.absent(),
          }) =>
              ActivitiesCompanion(
            activityId: activityId,
            activityType: activityType,
            descriptionI18n: descriptionI18n,
          ),
          createCompanionCallback: ({
            Value<int> activityId = const Value.absent(),
            required String activityType,
            required String descriptionI18n,
          }) =>
              ActivitiesCompanion.insert(
            activityId: activityId,
            activityType: activityType,
            descriptionI18n: descriptionI18n,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ActivitiesTableProcessedTableManager = ProcessedTableManager<
    _$FarmingDb,
    $ActivitiesTable,
    Activity,
    $$ActivitiesTableFilterComposer,
    $$ActivitiesTableOrderingComposer,
    $$ActivitiesTableAnnotationComposer,
    $$ActivitiesTableCreateCompanionBuilder,
    $$ActivitiesTableUpdateCompanionBuilder,
    (Activity, BaseReferences<_$FarmingDb, $ActivitiesTable, Activity>),
    Activity,
    PrefetchHooks Function()>;
typedef $$CropsTableCreateCompanionBuilder = CropsCompanion Function({
  Value<int> cropId,
  required String name,
  Value<String?> localNames,
  Value<String?> category,
});
typedef $$CropsTableUpdateCompanionBuilder = CropsCompanion Function({
  Value<int> cropId,
  Value<String> name,
  Value<String?> localNames,
  Value<String?> category,
});

class $$CropsTableFilterComposer extends Composer<_$FarmingDb, $CropsTable> {
  $$CropsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get cropId => $composableBuilder(
      column: $table.cropId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get localNames => $composableBuilder(
      column: $table.localNames, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));
}

class $$CropsTableOrderingComposer extends Composer<_$FarmingDb, $CropsTable> {
  $$CropsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get cropId => $composableBuilder(
      column: $table.cropId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get localNames => $composableBuilder(
      column: $table.localNames, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));
}

class $$CropsTableAnnotationComposer
    extends Composer<_$FarmingDb, $CropsTable> {
  $$CropsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get cropId =>
      $composableBuilder(column: $table.cropId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get localNames => $composableBuilder(
      column: $table.localNames, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);
}

class $$CropsTableTableManager extends RootTableManager<
    _$FarmingDb,
    $CropsTable,
    Crop,
    $$CropsTableFilterComposer,
    $$CropsTableOrderingComposer,
    $$CropsTableAnnotationComposer,
    $$CropsTableCreateCompanionBuilder,
    $$CropsTableUpdateCompanionBuilder,
    (Crop, BaseReferences<_$FarmingDb, $CropsTable, Crop>),
    Crop,
    PrefetchHooks Function()> {
  $$CropsTableTableManager(_$FarmingDb db, $CropsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CropsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CropsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CropsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> cropId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> localNames = const Value.absent(),
            Value<String?> category = const Value.absent(),
          }) =>
              CropsCompanion(
            cropId: cropId,
            name: name,
            localNames: localNames,
            category: category,
          ),
          createCompanionCallback: ({
            Value<int> cropId = const Value.absent(),
            required String name,
            Value<String?> localNames = const Value.absent(),
            Value<String?> category = const Value.absent(),
          }) =>
              CropsCompanion.insert(
            cropId: cropId,
            name: name,
            localNames: localNames,
            category: category,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CropsTableProcessedTableManager = ProcessedTableManager<
    _$FarmingDb,
    $CropsTable,
    Crop,
    $$CropsTableFilterComposer,
    $$CropsTableOrderingComposer,
    $$CropsTableAnnotationComposer,
    $$CropsTableCreateCompanionBuilder,
    $$CropsTableUpdateCompanionBuilder,
    (Crop, BaseReferences<_$FarmingDb, $CropsTable, Crop>),
    Crop,
    PrefetchHooks Function()>;
typedef $$RegionsTableCreateCompanionBuilder = RegionsCompanion Function({
  Value<int> regionId,
  required String name,
  required double latMin,
  required double latMax,
  required double lonMin,
  required double lonMax,
  Value<String?> climateZone,
});
typedef $$RegionsTableUpdateCompanionBuilder = RegionsCompanion Function({
  Value<int> regionId,
  Value<String> name,
  Value<double> latMin,
  Value<double> latMax,
  Value<double> lonMin,
  Value<double> lonMax,
  Value<String?> climateZone,
});

class $$RegionsTableFilterComposer
    extends Composer<_$FarmingDb, $RegionsTable> {
  $$RegionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get regionId => $composableBuilder(
      column: $table.regionId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get latMin => $composableBuilder(
      column: $table.latMin, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get latMax => $composableBuilder(
      column: $table.latMax, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get lonMin => $composableBuilder(
      column: $table.lonMin, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get lonMax => $composableBuilder(
      column: $table.lonMax, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get climateZone => $composableBuilder(
      column: $table.climateZone, builder: (column) => ColumnFilters(column));
}

class $$RegionsTableOrderingComposer
    extends Composer<_$FarmingDb, $RegionsTable> {
  $$RegionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get regionId => $composableBuilder(
      column: $table.regionId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get latMin => $composableBuilder(
      column: $table.latMin, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get latMax => $composableBuilder(
      column: $table.latMax, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get lonMin => $composableBuilder(
      column: $table.lonMin, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get lonMax => $composableBuilder(
      column: $table.lonMax, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get climateZone => $composableBuilder(
      column: $table.climateZone, builder: (column) => ColumnOrderings(column));
}

class $$RegionsTableAnnotationComposer
    extends Composer<_$FarmingDb, $RegionsTable> {
  $$RegionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get regionId =>
      $composableBuilder(column: $table.regionId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get latMin =>
      $composableBuilder(column: $table.latMin, builder: (column) => column);

  GeneratedColumn<double> get latMax =>
      $composableBuilder(column: $table.latMax, builder: (column) => column);

  GeneratedColumn<double> get lonMin =>
      $composableBuilder(column: $table.lonMin, builder: (column) => column);

  GeneratedColumn<double> get lonMax =>
      $composableBuilder(column: $table.lonMax, builder: (column) => column);

  GeneratedColumn<String> get climateZone => $composableBuilder(
      column: $table.climateZone, builder: (column) => column);
}

class $$RegionsTableTableManager extends RootTableManager<
    _$FarmingDb,
    $RegionsTable,
    Region,
    $$RegionsTableFilterComposer,
    $$RegionsTableOrderingComposer,
    $$RegionsTableAnnotationComposer,
    $$RegionsTableCreateCompanionBuilder,
    $$RegionsTableUpdateCompanionBuilder,
    (Region, BaseReferences<_$FarmingDb, $RegionsTable, Region>),
    Region,
    PrefetchHooks Function()> {
  $$RegionsTableTableManager(_$FarmingDb db, $RegionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RegionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RegionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RegionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> regionId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<double> latMin = const Value.absent(),
            Value<double> latMax = const Value.absent(),
            Value<double> lonMin = const Value.absent(),
            Value<double> lonMax = const Value.absent(),
            Value<String?> climateZone = const Value.absent(),
          }) =>
              RegionsCompanion(
            regionId: regionId,
            name: name,
            latMin: latMin,
            latMax: latMax,
            lonMin: lonMin,
            lonMax: lonMax,
            climateZone: climateZone,
          ),
          createCompanionCallback: ({
            Value<int> regionId = const Value.absent(),
            required String name,
            required double latMin,
            required double latMax,
            required double lonMin,
            required double lonMax,
            Value<String?> climateZone = const Value.absent(),
          }) =>
              RegionsCompanion.insert(
            regionId: regionId,
            name: name,
            latMin: latMin,
            latMax: latMax,
            lonMin: lonMin,
            lonMax: lonMax,
            climateZone: climateZone,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$RegionsTableProcessedTableManager = ProcessedTableManager<
    _$FarmingDb,
    $RegionsTable,
    Region,
    $$RegionsTableFilterComposer,
    $$RegionsTableOrderingComposer,
    $$RegionsTableAnnotationComposer,
    $$RegionsTableCreateCompanionBuilder,
    $$RegionsTableUpdateCompanionBuilder,
    (Region, BaseReferences<_$FarmingDb, $RegionsTable, Region>),
    Region,
    PrefetchHooks Function()>;
typedef $$SourcesTableCreateCompanionBuilder = SourcesCompanion Function({
  Value<int> sourceId,
  required String sourceType,
  required String name,
  Value<String?> citation,
  Value<DateTime?> sourceDate,
});
typedef $$SourcesTableUpdateCompanionBuilder = SourcesCompanion Function({
  Value<int> sourceId,
  Value<String> sourceType,
  Value<String> name,
  Value<String?> citation,
  Value<DateTime?> sourceDate,
});

class $$SourcesTableFilterComposer
    extends Composer<_$FarmingDb, $SourcesTable> {
  $$SourcesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get sourceId => $composableBuilder(
      column: $table.sourceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sourceType => $composableBuilder(
      column: $table.sourceType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get citation => $composableBuilder(
      column: $table.citation, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get sourceDate => $composableBuilder(
      column: $table.sourceDate, builder: (column) => ColumnFilters(column));
}

class $$SourcesTableOrderingComposer
    extends Composer<_$FarmingDb, $SourcesTable> {
  $$SourcesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get sourceId => $composableBuilder(
      column: $table.sourceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sourceType => $composableBuilder(
      column: $table.sourceType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get citation => $composableBuilder(
      column: $table.citation, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get sourceDate => $composableBuilder(
      column: $table.sourceDate, builder: (column) => ColumnOrderings(column));
}

class $$SourcesTableAnnotationComposer
    extends Composer<_$FarmingDb, $SourcesTable> {
  $$SourcesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get sourceId =>
      $composableBuilder(column: $table.sourceId, builder: (column) => column);

  GeneratedColumn<String> get sourceType => $composableBuilder(
      column: $table.sourceType, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get citation =>
      $composableBuilder(column: $table.citation, builder: (column) => column);

  GeneratedColumn<DateTime> get sourceDate => $composableBuilder(
      column: $table.sourceDate, builder: (column) => column);
}

class $$SourcesTableTableManager extends RootTableManager<
    _$FarmingDb,
    $SourcesTable,
    Source,
    $$SourcesTableFilterComposer,
    $$SourcesTableOrderingComposer,
    $$SourcesTableAnnotationComposer,
    $$SourcesTableCreateCompanionBuilder,
    $$SourcesTableUpdateCompanionBuilder,
    (Source, BaseReferences<_$FarmingDb, $SourcesTable, Source>),
    Source,
    PrefetchHooks Function()> {
  $$SourcesTableTableManager(_$FarmingDb db, $SourcesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SourcesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SourcesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SourcesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> sourceId = const Value.absent(),
            Value<String> sourceType = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> citation = const Value.absent(),
            Value<DateTime?> sourceDate = const Value.absent(),
          }) =>
              SourcesCompanion(
            sourceId: sourceId,
            sourceType: sourceType,
            name: name,
            citation: citation,
            sourceDate: sourceDate,
          ),
          createCompanionCallback: ({
            Value<int> sourceId = const Value.absent(),
            required String sourceType,
            required String name,
            Value<String?> citation = const Value.absent(),
            Value<DateTime?> sourceDate = const Value.absent(),
          }) =>
              SourcesCompanion.insert(
            sourceId: sourceId,
            sourceType: sourceType,
            name: name,
            citation: citation,
            sourceDate: sourceDate,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SourcesTableProcessedTableManager = ProcessedTableManager<
    _$FarmingDb,
    $SourcesTable,
    Source,
    $$SourcesTableFilterComposer,
    $$SourcesTableOrderingComposer,
    $$SourcesTableAnnotationComposer,
    $$SourcesTableCreateCompanionBuilder,
    $$SourcesTableUpdateCompanionBuilder,
    (Source, BaseReferences<_$FarmingDb, $SourcesTable, Source>),
    Source,
    PrefetchHooks Function()>;
typedef $$FarmingRulesTableCreateCompanionBuilder = FarmingRulesCompanion
    Function({
  Value<int> ruleId,
  Value<int?> skyTriggerId,
  Value<int?> weatherTriggerId,
  required int activityId,
  Value<int?> cropId,
  Value<int?> regionId,
  required int sourceId,
  required String guidanceI18n,
  Value<String?> severity,
  Value<String> verificationStatus,
});
typedef $$FarmingRulesTableUpdateCompanionBuilder = FarmingRulesCompanion
    Function({
  Value<int> ruleId,
  Value<int?> skyTriggerId,
  Value<int?> weatherTriggerId,
  Value<int> activityId,
  Value<int?> cropId,
  Value<int?> regionId,
  Value<int> sourceId,
  Value<String> guidanceI18n,
  Value<String?> severity,
  Value<String> verificationStatus,
});

class $$FarmingRulesTableFilterComposer
    extends Composer<_$FarmingDb, $FarmingRulesTable> {
  $$FarmingRulesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get ruleId => $composableBuilder(
      column: $table.ruleId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get skyTriggerId => $composableBuilder(
      column: $table.skyTriggerId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get weatherTriggerId => $composableBuilder(
      column: $table.weatherTriggerId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get activityId => $composableBuilder(
      column: $table.activityId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get cropId => $composableBuilder(
      column: $table.cropId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get regionId => $composableBuilder(
      column: $table.regionId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sourceId => $composableBuilder(
      column: $table.sourceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get guidanceI18n => $composableBuilder(
      column: $table.guidanceI18n, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get severity => $composableBuilder(
      column: $table.severity, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get verificationStatus => $composableBuilder(
      column: $table.verificationStatus,
      builder: (column) => ColumnFilters(column));
}

class $$FarmingRulesTableOrderingComposer
    extends Composer<_$FarmingDb, $FarmingRulesTable> {
  $$FarmingRulesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get ruleId => $composableBuilder(
      column: $table.ruleId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get skyTriggerId => $composableBuilder(
      column: $table.skyTriggerId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get weatherTriggerId => $composableBuilder(
      column: $table.weatherTriggerId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get activityId => $composableBuilder(
      column: $table.activityId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get cropId => $composableBuilder(
      column: $table.cropId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get regionId => $composableBuilder(
      column: $table.regionId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sourceId => $composableBuilder(
      column: $table.sourceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get guidanceI18n => $composableBuilder(
      column: $table.guidanceI18n,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get severity => $composableBuilder(
      column: $table.severity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get verificationStatus => $composableBuilder(
      column: $table.verificationStatus,
      builder: (column) => ColumnOrderings(column));
}

class $$FarmingRulesTableAnnotationComposer
    extends Composer<_$FarmingDb, $FarmingRulesTable> {
  $$FarmingRulesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get ruleId =>
      $composableBuilder(column: $table.ruleId, builder: (column) => column);

  GeneratedColumn<int> get skyTriggerId => $composableBuilder(
      column: $table.skyTriggerId, builder: (column) => column);

  GeneratedColumn<int> get weatherTriggerId => $composableBuilder(
      column: $table.weatherTriggerId, builder: (column) => column);

  GeneratedColumn<int> get activityId => $composableBuilder(
      column: $table.activityId, builder: (column) => column);

  GeneratedColumn<int> get cropId =>
      $composableBuilder(column: $table.cropId, builder: (column) => column);

  GeneratedColumn<int> get regionId =>
      $composableBuilder(column: $table.regionId, builder: (column) => column);

  GeneratedColumn<int> get sourceId =>
      $composableBuilder(column: $table.sourceId, builder: (column) => column);

  GeneratedColumn<String> get guidanceI18n => $composableBuilder(
      column: $table.guidanceI18n, builder: (column) => column);

  GeneratedColumn<String> get severity =>
      $composableBuilder(column: $table.severity, builder: (column) => column);

  GeneratedColumn<String> get verificationStatus => $composableBuilder(
      column: $table.verificationStatus, builder: (column) => column);
}

class $$FarmingRulesTableTableManager extends RootTableManager<
    _$FarmingDb,
    $FarmingRulesTable,
    FarmingRule,
    $$FarmingRulesTableFilterComposer,
    $$FarmingRulesTableOrderingComposer,
    $$FarmingRulesTableAnnotationComposer,
    $$FarmingRulesTableCreateCompanionBuilder,
    $$FarmingRulesTableUpdateCompanionBuilder,
    (FarmingRule, BaseReferences<_$FarmingDb, $FarmingRulesTable, FarmingRule>),
    FarmingRule,
    PrefetchHooks Function()> {
  $$FarmingRulesTableTableManager(_$FarmingDb db, $FarmingRulesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FarmingRulesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FarmingRulesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FarmingRulesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> ruleId = const Value.absent(),
            Value<int?> skyTriggerId = const Value.absent(),
            Value<int?> weatherTriggerId = const Value.absent(),
            Value<int> activityId = const Value.absent(),
            Value<int?> cropId = const Value.absent(),
            Value<int?> regionId = const Value.absent(),
            Value<int> sourceId = const Value.absent(),
            Value<String> guidanceI18n = const Value.absent(),
            Value<String?> severity = const Value.absent(),
            Value<String> verificationStatus = const Value.absent(),
          }) =>
              FarmingRulesCompanion(
            ruleId: ruleId,
            skyTriggerId: skyTriggerId,
            weatherTriggerId: weatherTriggerId,
            activityId: activityId,
            cropId: cropId,
            regionId: regionId,
            sourceId: sourceId,
            guidanceI18n: guidanceI18n,
            severity: severity,
            verificationStatus: verificationStatus,
          ),
          createCompanionCallback: ({
            Value<int> ruleId = const Value.absent(),
            Value<int?> skyTriggerId = const Value.absent(),
            Value<int?> weatherTriggerId = const Value.absent(),
            required int activityId,
            Value<int?> cropId = const Value.absent(),
            Value<int?> regionId = const Value.absent(),
            required int sourceId,
            required String guidanceI18n,
            Value<String?> severity = const Value.absent(),
            Value<String> verificationStatus = const Value.absent(),
          }) =>
              FarmingRulesCompanion.insert(
            ruleId: ruleId,
            skyTriggerId: skyTriggerId,
            weatherTriggerId: weatherTriggerId,
            activityId: activityId,
            cropId: cropId,
            regionId: regionId,
            sourceId: sourceId,
            guidanceI18n: guidanceI18n,
            severity: severity,
            verificationStatus: verificationStatus,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$FarmingRulesTableProcessedTableManager = ProcessedTableManager<
    _$FarmingDb,
    $FarmingRulesTable,
    FarmingRule,
    $$FarmingRulesTableFilterComposer,
    $$FarmingRulesTableOrderingComposer,
    $$FarmingRulesTableAnnotationComposer,
    $$FarmingRulesTableCreateCompanionBuilder,
    $$FarmingRulesTableUpdateCompanionBuilder,
    (FarmingRule, BaseReferences<_$FarmingDb, $FarmingRulesTable, FarmingRule>),
    FarmingRule,
    PrefetchHooks Function()>;
typedef $$SeasonalClimateNormalsTableCreateCompanionBuilder
    = SeasonalClimateNormalsCompanion Function({
  required int regionId,
  required int month,
  Value<int?> skyTriggerId,
  required double avgRainMm,
  required double tempMinC,
  required double tempMaxC,
  required String classification,
  required int sourceId,
  Value<String> verificationStatus,
  Value<int> rowid,
});
typedef $$SeasonalClimateNormalsTableUpdateCompanionBuilder
    = SeasonalClimateNormalsCompanion Function({
  Value<int> regionId,
  Value<int> month,
  Value<int?> skyTriggerId,
  Value<double> avgRainMm,
  Value<double> tempMinC,
  Value<double> tempMaxC,
  Value<String> classification,
  Value<int> sourceId,
  Value<String> verificationStatus,
  Value<int> rowid,
});

class $$SeasonalClimateNormalsTableFilterComposer
    extends Composer<_$FarmingDb, $SeasonalClimateNormalsTable> {
  $$SeasonalClimateNormalsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get regionId => $composableBuilder(
      column: $table.regionId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get month => $composableBuilder(
      column: $table.month, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get skyTriggerId => $composableBuilder(
      column: $table.skyTriggerId, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get avgRainMm => $composableBuilder(
      column: $table.avgRainMm, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get tempMinC => $composableBuilder(
      column: $table.tempMinC, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get tempMaxC => $composableBuilder(
      column: $table.tempMaxC, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get classification => $composableBuilder(
      column: $table.classification,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sourceId => $composableBuilder(
      column: $table.sourceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get verificationStatus => $composableBuilder(
      column: $table.verificationStatus,
      builder: (column) => ColumnFilters(column));
}

class $$SeasonalClimateNormalsTableOrderingComposer
    extends Composer<_$FarmingDb, $SeasonalClimateNormalsTable> {
  $$SeasonalClimateNormalsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get regionId => $composableBuilder(
      column: $table.regionId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get month => $composableBuilder(
      column: $table.month, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get skyTriggerId => $composableBuilder(
      column: $table.skyTriggerId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get avgRainMm => $composableBuilder(
      column: $table.avgRainMm, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get tempMinC => $composableBuilder(
      column: $table.tempMinC, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get tempMaxC => $composableBuilder(
      column: $table.tempMaxC, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get classification => $composableBuilder(
      column: $table.classification,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sourceId => $composableBuilder(
      column: $table.sourceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get verificationStatus => $composableBuilder(
      column: $table.verificationStatus,
      builder: (column) => ColumnOrderings(column));
}

class $$SeasonalClimateNormalsTableAnnotationComposer
    extends Composer<_$FarmingDb, $SeasonalClimateNormalsTable> {
  $$SeasonalClimateNormalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get regionId =>
      $composableBuilder(column: $table.regionId, builder: (column) => column);

  GeneratedColumn<int> get month =>
      $composableBuilder(column: $table.month, builder: (column) => column);

  GeneratedColumn<int> get skyTriggerId => $composableBuilder(
      column: $table.skyTriggerId, builder: (column) => column);

  GeneratedColumn<double> get avgRainMm =>
      $composableBuilder(column: $table.avgRainMm, builder: (column) => column);

  GeneratedColumn<double> get tempMinC =>
      $composableBuilder(column: $table.tempMinC, builder: (column) => column);

  GeneratedColumn<double> get tempMaxC =>
      $composableBuilder(column: $table.tempMaxC, builder: (column) => column);

  GeneratedColumn<String> get classification => $composableBuilder(
      column: $table.classification, builder: (column) => column);

  GeneratedColumn<int> get sourceId =>
      $composableBuilder(column: $table.sourceId, builder: (column) => column);

  GeneratedColumn<String> get verificationStatus => $composableBuilder(
      column: $table.verificationStatus, builder: (column) => column);
}

class $$SeasonalClimateNormalsTableTableManager extends RootTableManager<
    _$FarmingDb,
    $SeasonalClimateNormalsTable,
    SeasonalClimateNormal,
    $$SeasonalClimateNormalsTableFilterComposer,
    $$SeasonalClimateNormalsTableOrderingComposer,
    $$SeasonalClimateNormalsTableAnnotationComposer,
    $$SeasonalClimateNormalsTableCreateCompanionBuilder,
    $$SeasonalClimateNormalsTableUpdateCompanionBuilder,
    (
      SeasonalClimateNormal,
      BaseReferences<_$FarmingDb, $SeasonalClimateNormalsTable,
          SeasonalClimateNormal>
    ),
    SeasonalClimateNormal,
    PrefetchHooks Function()> {
  $$SeasonalClimateNormalsTableTableManager(
      _$FarmingDb db, $SeasonalClimateNormalsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SeasonalClimateNormalsTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$SeasonalClimateNormalsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SeasonalClimateNormalsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> regionId = const Value.absent(),
            Value<int> month = const Value.absent(),
            Value<int?> skyTriggerId = const Value.absent(),
            Value<double> avgRainMm = const Value.absent(),
            Value<double> tempMinC = const Value.absent(),
            Value<double> tempMaxC = const Value.absent(),
            Value<String> classification = const Value.absent(),
            Value<int> sourceId = const Value.absent(),
            Value<String> verificationStatus = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SeasonalClimateNormalsCompanion(
            regionId: regionId,
            month: month,
            skyTriggerId: skyTriggerId,
            avgRainMm: avgRainMm,
            tempMinC: tempMinC,
            tempMaxC: tempMaxC,
            classification: classification,
            sourceId: sourceId,
            verificationStatus: verificationStatus,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required int regionId,
            required int month,
            Value<int?> skyTriggerId = const Value.absent(),
            required double avgRainMm,
            required double tempMinC,
            required double tempMaxC,
            required String classification,
            required int sourceId,
            Value<String> verificationStatus = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SeasonalClimateNormalsCompanion.insert(
            regionId: regionId,
            month: month,
            skyTriggerId: skyTriggerId,
            avgRainMm: avgRainMm,
            tempMinC: tempMinC,
            tempMaxC: tempMaxC,
            classification: classification,
            sourceId: sourceId,
            verificationStatus: verificationStatus,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SeasonalClimateNormalsTableProcessedTableManager
    = ProcessedTableManager<
        _$FarmingDb,
        $SeasonalClimateNormalsTable,
        SeasonalClimateNormal,
        $$SeasonalClimateNormalsTableFilterComposer,
        $$SeasonalClimateNormalsTableOrderingComposer,
        $$SeasonalClimateNormalsTableAnnotationComposer,
        $$SeasonalClimateNormalsTableCreateCompanionBuilder,
        $$SeasonalClimateNormalsTableUpdateCompanionBuilder,
        (
          SeasonalClimateNormal,
          BaseReferences<_$FarmingDb, $SeasonalClimateNormalsTable,
              SeasonalClimateNormal>
        ),
        SeasonalClimateNormal,
        PrefetchHooks Function()>;

class $FarmingDbManager {
  final _$FarmingDb _db;
  $FarmingDbManager(this._db);
  $$SkyTriggersTableTableManager get skyTriggers =>
      $$SkyTriggersTableTableManager(_db, _db.skyTriggers);
  $$WeatherTriggersTableTableManager get weatherTriggers =>
      $$WeatherTriggersTableTableManager(_db, _db.weatherTriggers);
  $$ActivitiesTableTableManager get activities =>
      $$ActivitiesTableTableManager(_db, _db.activities);
  $$CropsTableTableManager get crops =>
      $$CropsTableTableManager(_db, _db.crops);
  $$RegionsTableTableManager get regions =>
      $$RegionsTableTableManager(_db, _db.regions);
  $$SourcesTableTableManager get sources =>
      $$SourcesTableTableManager(_db, _db.sources);
  $$FarmingRulesTableTableManager get farmingRules =>
      $$FarmingRulesTableTableManager(_db, _db.farmingRules);
  $$SeasonalClimateNormalsTableTableManager get seasonalClimateNormals =>
      $$SeasonalClimateNormalsTableTableManager(
          _db, _db.seasonalClimateNormals);
}
