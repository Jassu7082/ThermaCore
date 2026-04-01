import 'dart:async';
import '../sources/thermal_channel.dart';
import '../models/thermal_reading.dart';
import '../models/thermal_zone.dart';
import '../../core/constants/thermal_constants.dart';

class ThermalRepository {
  final ThermalChannel _channel;

  ThermalRepository(this._channel);

  /// Stream of temperature snapshots at the given polling interval.
  Stream<List<ThermalReading>> watchTemperatures({
    Duration interval = ThermalConstants.defaultPollingInterval,
    List<ThermalZone> zones = const [],
  }) async* {
    while (true) {
      try {
        final readings = await _readOnceInternal(zones);
        yield readings;
      } catch (e) {
        yield [];
      }
      await Future.delayed(interval);
    }
  }

  /// One-shot read for widget updates or manual refresh.
  Future<List<ThermalReading>> readOnce({List<ThermalZone> zones = const []}) {
    return _readOnceInternal(zones);
  }

  Future<List<ThermalReading>> _readOnceInternal(List<ThermalZone> zones) async {
    final rawMap = await _channel.readAllTemperatures();
    final now = DateTime.now();
    final readings = <ThermalReading>[];
    final isThrottling = (rawMap['_throttling'] as int? ?? 0) == 1;

    for (final entry in rawMap.entries) {
      if (entry.key.startsWith('_')) continue;
      final rawValue = entry.value;
      if (rawValue is! int) continue;

      double tempC;
      if (entry.key == 'battery_bm') {
        tempC = ThermalZone.tenthsToC(rawValue);
      } else {
        tempC = ThermalZone.milliToC(rawValue);
      }

      // Find matching zone config for custom thresholds
      final zone = zones.firstWhere(
        (z) => z.id == entry.key,
        orElse: () => ThermalZone(
          id: entry.key,
          displayName: ThermalConstants.getFriendlyName(entry.key),
          sysfsPath: '',
        ),
      );

      readings.add(ThermalReading(
        zoneId: entry.key,
        temperatureCelsius: tempC,
        timestamp: now,
        status: tempC.toStatus(
          warm: zone.warningThreshold ?? ThermalConstants.defaultWarmThreshold,
          hot: (zone.warningThreshold ?? ThermalConstants.defaultWarmThreshold) + 10,
          critical: zone.criticalThreshold ?? ThermalConstants.defaultCriticalThreshold,
        ),
        isThrottling: isThrottling,
      ));
    }

    // Sort: CPU first, then battery, then rest
    readings.sort((a, b) {
      int priority(ThermalReading r) {
        if (r.zoneId.toLowerCase().contains('cpu')) return 0;
        if (r.zoneId == 'battery_bm') return 1;
        return 2;
      }
      return priority(a).compareTo(priority(b));
    });

    return readings;
  }

  /// Discover all thermal zones on the device.
  Future<List<ThermalZoneInfo>> discoverZones() => _channel.discoverZones();
}
