import 'package:flutter/services.dart';
import '../models/thermal_zone.dart';

/// Dart-side wrapper for the native thermal MethodChannel.
class ThermalChannel {
  static const _channel = MethodChannel('com.thermacore.android/thermal');

  /// Discover all thermal zones available on this device.
  Future<List<ThermalZoneInfo>> discoverZones() async {
    final raw = await _channel.invokeListMethod<Map>('discoverZones') ?? [];
    return raw.map((m) => ThermalZoneInfo(
      id: m['id'] as int,
      name: m['name'] as String,
      path: m['path'] as String,
    )).toList();
  }

  /// Read all zone temperatures in one native call.
  /// Values are in millidegrees Celsius (raw sysfs values).
  Future<Map<String, dynamic>> readAllTemperatures() async {
    final raw = await _channel.invokeMapMethod<String, dynamic>(
      'readAllTemperatures',
    ) ?? {};
    return raw;
  }

  /// Read a single zone temperature by sysfs path.
  Future<int?> readZoneTemperature(String path) async {
    return await _channel.invokeMethod<int>(
      'readZoneTemperature',
      {'path': path},
    );
  }

  /// Get battery temperature from BatteryManager API.
  /// Returns in tenths of degrees Celsius (divide by 10 for °C).
  Future<int> getBatteryTemperature() async {
    return await _channel.invokeMethod<int>('getBatteryTemperature') ?? -1;
  }
}

class ThermalZoneInfo {
  final int id;
  final String name;
  final String path;
  const ThermalZoneInfo({required this.id, required this.name, required this.path});
}
