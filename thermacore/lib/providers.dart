import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../data/sources/thermal_channel.dart';
import '../data/sources/thermal_database.dart';
import '../data/repositories/thermal_repository.dart';
import '../data/models/thermal_reading.dart';
import '../domain/services/cooling_score_calculator.dart';
import '../domain/services/alert_engine.dart';
import '../core/constants/thermal_constants.dart';

// ── Low-level providers ────────────────────────────────────────

final thermalChannelProvider = Provider<ThermalChannel>((ref) {
  return ThermalChannel();
});

final thermalRepositoryProvider = Provider<ThermalRepository>((ref) {
  return ThermalRepository(ref.watch(thermalChannelProvider));
});

final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) {
  return SharedPreferences.getInstance();
});

final thermalDatabaseProvider = Provider<ThermalDatabase>((ref) {
  return ThermalDatabase();
});

final notificationsProvider = Provider<FlutterLocalNotificationsPlugin>((ref) {
  return FlutterLocalNotificationsPlugin();
});

final alertEngineProvider = Provider<AlertEngine>((ref) {
  return AlertEngine(notifications: ref.watch(notificationsProvider));
});

// ── Settings providers ────────────────────────────────────────

final pollingIntervalProvider = StateProvider<Duration>((ref) {
  return ThermalConstants.defaultPollingInterval;
});

final tempUnitProvider = StateProvider<TempUnit>((ref) => TempUnit.celsius);

final amoledModeProvider = StateProvider<bool>((ref) => false);

enum TempUnit { celsius, fahrenheit, kelvin }

extension TempUnitX on TempUnit {
  String label(double celsius) => switch (this) {
    TempUnit.celsius    => '${celsius.toStringAsFixed(1)}°C',
    TempUnit.fahrenheit => '${((celsius * 9 / 5) + 32).toStringAsFixed(1)}°F',
    TempUnit.kelvin     => '${(celsius + 273.15).toStringAsFixed(1)} K',
  };
  String get name => switch (this) {
    TempUnit.celsius    => '°C',
    TempUnit.fahrenheit => '°F',
    TempUnit.kelvin     => 'K',
  };
}

// ── Live temperature stream ───────────────────────────────────

final thermalStreamProvider = StreamProvider<List<ThermalReading>>((ref) {
  final repo = ref.watch(thermalRepositoryProvider);
  final interval = ref.watch(pollingIntervalProvider);
  return repo.watchTemperatures(interval: interval);
});

// ── Derived providers ─────────────────────────────────────────

/// Cooling score based on the LAST HOUR of historical data.
final coolingScoreProvider = Provider<int>((ref) {
  final historyMap = ref.watch(historyProvider);
  if (historyMap.isEmpty) return 100;

  // Flatten all historical points into a single list for the calculator
  final List<ThermalReading> allPoints = historyMap.values.expand((list) => list).cast<ThermalReading>().toList();
  return CoolingScoreCalculator.computeHistorical(allPoints);
});

final selectedZoneProvider = StateProvider<String?>((ref) => null);

// ── History buffer (Syncs with Drift SQLite) ───────────────────

final historyProvider =
    StateNotifierProvider<HistoryNotifier, Map<String, List<ThermalReading>>>(
  (ref) {
    final db = ref.watch(thermalDatabaseProvider);
    final notifier = HistoryNotifier(db);
    
    // In a real app, we'd trigger an initial load here.
    // For this implementation, we'll start fresh in-memory and persist going forward.

    ref.listen<AsyncValue<List<ThermalReading>>>(
      thermalStreamProvider,
      (_, next) => next.whenData(notifier.addReadings),
    );
    return notifier;
  },
);

class HistoryNotifier extends StateNotifier<Map<String, List<ThermalReading>>> {
  static const _maxPointsInMemory = 60;
  final ThermalDatabase _db;

  HistoryNotifier(this._db) : super({});

  void addReadings(List<ThermalReading> readings) {
    final next = Map<String, List<ThermalReading>>.from(state);
    final List<ThermalReadingsCompanion> companions = [];

    for (final r in readings) {
      // Update Memory State (Ring Buffer for Sparkline)
      final list = List<ThermalReading>.from(next[r.zoneId] ?? [])..add(r);
      if (list.length > _maxPointsInMemory) list.removeAt(0);
      next[r.zoneId] = list;

      // Prepare for Database (Persistence)
      companions.add(ThermalReadingsCompanion.insert(
        zoneId: r.zoneId,
        temperatureCelsius: r.temperatureCelsius,
        timestamp: r.timestamp,
        statusIndex: r.status.index,
        isThrottling: r.isThrottling,
      ));
    }
    
    state = next;
    
    // Batch Insert into SQLite
    _db.insertReadings(companions);
    
    // Cleanup old data periodically (e.g. older than 24h)
    _db.deleteOldReadings(DateTime.now().subtract(const Duration(hours: 24)));
  }
}

// ── Alert listener ─────────────────────────────────────────────

final alertListenerProvider = Provider<void>((ref) {
  final engine = ref.watch(alertEngineProvider);
  ref.listen<AsyncValue<List<ThermalReading>>>(
    thermalStreamProvider,
    (_, next) => next.whenData(engine.evaluate),
  );
});
