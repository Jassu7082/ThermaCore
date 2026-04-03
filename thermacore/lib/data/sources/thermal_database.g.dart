// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'thermal_database.dart';

// ignore_for_file: type=lint
class $ThermalReadingsTable extends ThermalReadings
    with TableInfo<$ThermalReadingsTable, ThermalReadingRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ThermalReadingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _zoneIdMeta = const VerificationMeta('zoneId');
  @override
  late final GeneratedColumn<String> zoneId = GeneratedColumn<String>(
      'zone_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _temperatureCelsiusMeta =
      const VerificationMeta('temperatureCelsius');
  @override
  late final GeneratedColumn<double> temperatureCelsius =
      GeneratedColumn<double>('temperature_celsius', aliasedName, false,
          type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _timestampMeta =
      const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _statusIndexMeta =
      const VerificationMeta('statusIndex');
  @override
  late final GeneratedColumn<int> statusIndex = GeneratedColumn<int>(
      'status_index', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _isThrottlingMeta =
      const VerificationMeta('isThrottling');
  @override
  late final GeneratedColumn<bool> isThrottling = GeneratedColumn<bool>(
      'is_throttling', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_throttling" IN (0, 1))'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, zoneId, temperatureCelsius, timestamp, statusIndex, isThrottling];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'thermal_readings';
  @override
  VerificationContext validateIntegrity(
      Insertable<ThermalReadingRecord> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('zone_id')) {
      context.handle(_zoneIdMeta,
          zoneId.isAcceptableOrUnknown(data['zone_id']!, _zoneIdMeta));
    } else if (isInserting) {
      context.missing(_zoneIdMeta);
    }
    if (data.containsKey('temperature_celsius')) {
      context.handle(
          _temperatureCelsiusMeta,
          temperatureCelsius.isAcceptableOrUnknown(
              data['temperature_celsius']!, _temperatureCelsiusMeta));
    } else if (isInserting) {
      context.missing(_temperatureCelsiusMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('status_index')) {
      context.handle(
          _statusIndexMeta,
          statusIndex.isAcceptableOrUnknown(
              data['status_index']!, _statusIndexMeta));
    } else if (isInserting) {
      context.missing(_statusIndexMeta);
    }
    if (data.containsKey('is_throttling')) {
      context.handle(
          _isThrottlingMeta,
          isThrottling.isAcceptableOrUnknown(
              data['is_throttling']!, _isThrottlingMeta));
    } else if (isInserting) {
      context.missing(_isThrottlingMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ThermalReadingRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ThermalReadingRecord(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      zoneId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}zone_id'])!,
      temperatureCelsius: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}temperature_celsius'])!,
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}timestamp'])!,
      statusIndex: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}status_index'])!,
      isThrottling: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_throttling'])!,
    );
  }

  @override
  $ThermalReadingsTable createAlias(String alias) {
    return $ThermalReadingsTable(attachedDatabase, alias);
  }
}

class ThermalReadingRecord extends DataClass
    implements Insertable<ThermalReadingRecord> {
  final int id;
  final String zoneId;
  final double temperatureCelsius;
  final DateTime timestamp;
  final int statusIndex;
  final bool isThrottling;
  const ThermalReadingRecord(
      {required this.id,
      required this.zoneId,
      required this.temperatureCelsius,
      required this.timestamp,
      required this.statusIndex,
      required this.isThrottling});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['zone_id'] = Variable<String>(zoneId);
    map['temperature_celsius'] = Variable<double>(temperatureCelsius);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['status_index'] = Variable<int>(statusIndex);
    map['is_throttling'] = Variable<bool>(isThrottling);
    return map;
  }

  ThermalReadingsCompanion toCompanion(bool nullToAbsent) {
    return ThermalReadingsCompanion(
      id: Value(id),
      zoneId: Value(zoneId),
      temperatureCelsius: Value(temperatureCelsius),
      timestamp: Value(timestamp),
      statusIndex: Value(statusIndex),
      isThrottling: Value(isThrottling),
    );
  }

  factory ThermalReadingRecord.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ThermalReadingRecord(
      id: serializer.fromJson<int>(json['id']),
      zoneId: serializer.fromJson<String>(json['zoneId']),
      temperatureCelsius:
          serializer.fromJson<double>(json['temperatureCelsius']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      statusIndex: serializer.fromJson<int>(json['statusIndex']),
      isThrottling: serializer.fromJson<bool>(json['isThrottling']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'zoneId': serializer.toJson<String>(zoneId),
      'temperatureCelsius': serializer.toJson<double>(temperatureCelsius),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'statusIndex': serializer.toJson<int>(statusIndex),
      'isThrottling': serializer.toJson<bool>(isThrottling),
    };
  }

  ThermalReadingRecord copyWith(
          {int? id,
          String? zoneId,
          double? temperatureCelsius,
          DateTime? timestamp,
          int? statusIndex,
          bool? isThrottling}) =>
      ThermalReadingRecord(
        id: id ?? this.id,
        zoneId: zoneId ?? this.zoneId,
        temperatureCelsius: temperatureCelsius ?? this.temperatureCelsius,
        timestamp: timestamp ?? this.timestamp,
        statusIndex: statusIndex ?? this.statusIndex,
        isThrottling: isThrottling ?? this.isThrottling,
      );
  @override
  String toString() {
    return (StringBuffer('ThermalReadingRecord(')
          ..write('id: $id, ')
          ..write('zoneId: $zoneId, ')
          ..write('temperatureCelsius: $temperatureCelsius, ')
          ..write('timestamp: $timestamp, ')
          ..write('statusIndex: $statusIndex, ')
          ..write('isThrottling: $isThrottling')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, zoneId, temperatureCelsius, timestamp, statusIndex, isThrottling);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ThermalReadingRecord &&
          other.id == this.id &&
          other.zoneId == this.zoneId &&
          other.temperatureCelsius == this.temperatureCelsius &&
          other.timestamp == this.timestamp &&
          other.statusIndex == this.statusIndex &&
          other.isThrottling == this.isThrottling);
}

class ThermalReadingsCompanion extends UpdateCompanion<ThermalReadingRecord> {
  final Value<int> id;
  final Value<String> zoneId;
  final Value<double> temperatureCelsius;
  final Value<DateTime> timestamp;
  final Value<int> statusIndex;
  final Value<bool> isThrottling;
  const ThermalReadingsCompanion({
    this.id = const Value.absent(),
    this.zoneId = const Value.absent(),
    this.temperatureCelsius = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.statusIndex = const Value.absent(),
    this.isThrottling = const Value.absent(),
  });
  ThermalReadingsCompanion.insert({
    this.id = const Value.absent(),
    required String zoneId,
    required double temperatureCelsius,
    required DateTime timestamp,
    required int statusIndex,
    required bool isThrottling,
  })  : zoneId = Value(zoneId),
        temperatureCelsius = Value(temperatureCelsius),
        timestamp = Value(timestamp),
        statusIndex = Value(statusIndex),
        isThrottling = Value(isThrottling);
  static Insertable<ThermalReadingRecord> custom({
    Expression<int>? id,
    Expression<String>? zoneId,
    Expression<double>? temperatureCelsius,
    Expression<DateTime>? timestamp,
    Expression<int>? statusIndex,
    Expression<bool>? isThrottling,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (zoneId != null) 'zone_id': zoneId,
      if (temperatureCelsius != null) 'temperature_celsius': temperatureCelsius,
      if (timestamp != null) 'timestamp': timestamp,
      if (statusIndex != null) 'status_index': statusIndex,
      if (isThrottling != null) 'is_throttling': isThrottling,
    });
  }

  ThermalReadingsCompanion copyWith(
      {Value<int>? id,
      Value<String>? zoneId,
      Value<double>? temperatureCelsius,
      Value<DateTime>? timestamp,
      Value<int>? statusIndex,
      Value<bool>? isThrottling}) {
    return ThermalReadingsCompanion(
      id: id ?? this.id,
      zoneId: zoneId ?? this.zoneId,
      temperatureCelsius: temperatureCelsius ?? this.temperatureCelsius,
      timestamp: timestamp ?? this.timestamp,
      statusIndex: statusIndex ?? this.statusIndex,
      isThrottling: isThrottling ?? this.isThrottling,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (zoneId.present) {
      map['zone_id'] = Variable<String>(zoneId.value);
    }
    if (temperatureCelsius.present) {
      map['temperature_celsius'] = Variable<double>(temperatureCelsius.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (statusIndex.present) {
      map['status_index'] = Variable<int>(statusIndex.value);
    }
    if (isThrottling.present) {
      map['is_throttling'] = Variable<bool>(isThrottling.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ThermalReadingsCompanion(')
          ..write('id: $id, ')
          ..write('zoneId: $zoneId, ')
          ..write('temperatureCelsius: $temperatureCelsius, ')
          ..write('timestamp: $timestamp, ')
          ..write('statusIndex: $statusIndex, ')
          ..write('isThrottling: $isThrottling')
          ..write(')'))
        .toString();
  }
}

abstract class _$ThermalDatabase extends GeneratedDatabase {
  _$ThermalDatabase(QueryExecutor e) : super(e);
  _$ThermalDatabaseManager get managers => _$ThermalDatabaseManager(this);
  late final $ThermalReadingsTable thermalReadings =
      $ThermalReadingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [thermalReadings];
}

typedef $$ThermalReadingsTableInsertCompanionBuilder = ThermalReadingsCompanion
    Function({
  Value<int> id,
  required String zoneId,
  required double temperatureCelsius,
  required DateTime timestamp,
  required int statusIndex,
  required bool isThrottling,
});
typedef $$ThermalReadingsTableUpdateCompanionBuilder = ThermalReadingsCompanion
    Function({
  Value<int> id,
  Value<String> zoneId,
  Value<double> temperatureCelsius,
  Value<DateTime> timestamp,
  Value<int> statusIndex,
  Value<bool> isThrottling,
});

class $$ThermalReadingsTableTableManager extends RootTableManager<
    _$ThermalDatabase,
    $ThermalReadingsTable,
    ThermalReadingRecord,
    $$ThermalReadingsTableFilterComposer,
    $$ThermalReadingsTableOrderingComposer,
    $$ThermalReadingsTableProcessedTableManager,
    $$ThermalReadingsTableInsertCompanionBuilder,
    $$ThermalReadingsTableUpdateCompanionBuilder> {
  $$ThermalReadingsTableTableManager(
      _$ThermalDatabase db, $ThermalReadingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$ThermalReadingsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$ThermalReadingsTableOrderingComposer(ComposerState(db, table)),
          getChildManagerBuilder: (p) =>
              $$ThermalReadingsTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            Value<String> zoneId = const Value.absent(),
            Value<double> temperatureCelsius = const Value.absent(),
            Value<DateTime> timestamp = const Value.absent(),
            Value<int> statusIndex = const Value.absent(),
            Value<bool> isThrottling = const Value.absent(),
          }) =>
              ThermalReadingsCompanion(
            id: id,
            zoneId: zoneId,
            temperatureCelsius: temperatureCelsius,
            timestamp: timestamp,
            statusIndex: statusIndex,
            isThrottling: isThrottling,
          ),
          getInsertCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            required String zoneId,
            required double temperatureCelsius,
            required DateTime timestamp,
            required int statusIndex,
            required bool isThrottling,
          }) =>
              ThermalReadingsCompanion.insert(
            id: id,
            zoneId: zoneId,
            temperatureCelsius: temperatureCelsius,
            timestamp: timestamp,
            statusIndex: statusIndex,
            isThrottling: isThrottling,
          ),
        ));
}

class $$ThermalReadingsTableProcessedTableManager extends ProcessedTableManager<
    _$ThermalDatabase,
    $ThermalReadingsTable,
    ThermalReadingRecord,
    $$ThermalReadingsTableFilterComposer,
    $$ThermalReadingsTableOrderingComposer,
    $$ThermalReadingsTableProcessedTableManager,
    $$ThermalReadingsTableInsertCompanionBuilder,
    $$ThermalReadingsTableUpdateCompanionBuilder> {
  $$ThermalReadingsTableProcessedTableManager(super.$state);
}

class $$ThermalReadingsTableFilterComposer
    extends FilterComposer<_$ThermalDatabase, $ThermalReadingsTable> {
  $$ThermalReadingsTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get zoneId => $state.composableBuilder(
      column: $state.table.zoneId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get temperatureCelsius => $state.composableBuilder(
      column: $state.table.temperatureCelsius,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get timestamp => $state.composableBuilder(
      column: $state.table.timestamp,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get statusIndex => $state.composableBuilder(
      column: $state.table.statusIndex,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isThrottling => $state.composableBuilder(
      column: $state.table.isThrottling,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$ThermalReadingsTableOrderingComposer
    extends OrderingComposer<_$ThermalDatabase, $ThermalReadingsTable> {
  $$ThermalReadingsTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get zoneId => $state.composableBuilder(
      column: $state.table.zoneId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get temperatureCelsius => $state.composableBuilder(
      column: $state.table.temperatureCelsius,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get timestamp => $state.composableBuilder(
      column: $state.table.timestamp,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get statusIndex => $state.composableBuilder(
      column: $state.table.statusIndex,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isThrottling => $state.composableBuilder(
      column: $state.table.isThrottling,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class _$ThermalDatabaseManager {
  final _$ThermalDatabase _db;
  _$ThermalDatabaseManager(this._db);
  $$ThermalReadingsTableTableManager get thermalReadings =>
      $$ThermalReadingsTableTableManager(_db, _db.thermalReadings);
}
