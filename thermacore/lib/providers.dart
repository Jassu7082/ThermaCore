import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../data/sources/thermal_channel.dart';
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

final coolingScoreProvider = Provider<int>((ref) {
  final readings = ref.watch(thermalStreamProvider).valueOrNull ?? [];
  return CoolingScoreCalculator.compute(readings);
});

final selectedZoneProvider = StateProvider<String?>((ref) => null);

// ── History buffer (in-memory ring buffer of last 60 readings) ─

final historyProvider =
    StateNotifierProvider<HistoryNotifier, Map<String, List<ThermalReading>>>(
  (ref) {
    final notifier = HistoryNotifier();
    ref.listen<AsyncValue<List<ThermalReading>>>(
      thermalStreamProvider,
      (_, next) => next.whenData(notifier.addReadings),
    );
    return notifier;
  },
);

class HistoryNotifier extends StateNotifier<Map<String, List<ThermalReading>>> {
  static const _maxPoints = 60;

  HistoryNotifier() : super({});

  void addReadings(List<ThermalReading> readings) {
    final next = Map<String, List<ThermalReading>>.from(state);
    for (final r in readings) {
      final list = List<ThermalReading>.from(next[r.zoneId] ?? [])..add(r);
      if (list.length > _maxPoints) list.removeAt(0);
      next[r.zoneId] = list;
    }
    state = next;
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
