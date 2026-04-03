import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'thermal_database.g.dart';

@DataClassName('ThermalReadingRecord')
class ThermalReadings extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get zoneId => text()();
  RealColumn get temperatureCelsius => real()();
  DateTimeColumn get timestamp => dateTime()();
  IntColumn get statusIndex => integer()();
  BoolColumn get isThrottling => boolean()();
}

@DriftDatabase(tables: [ThermalReadings])
class ThermalDatabase extends _$ThermalDatabase {
  ThermalDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<int> insertReading(ThermalReadingsCompanion reading) {
    return into(thermalReadings).insert(reading);
  }

  Future<void> insertReadings(List<ThermalReadingsCompanion> readings) async {
    await batch((batch) {
      batch.insertAll(thermalReadings, readings);
    });
  }

  Future<List<ThermalReadingRecord>> getLatestReadings(String zoneId, {int limit = 60}) {
    return (select(thermalReadings)
          ..where((t) => t.zoneId.equals(zoneId))
          ..orderBy([(t) => OrderingTerm(expression: t.timestamp, mode: OrderingMode.desc)])
          ..limit(limit))
        .get();
  }

  Future<int> deleteOldReadings(DateTime before) {
    return (delete(thermalReadings)..where((t) => t.timestamp.isSmallerThanValue(before))).go();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'thermacore.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
