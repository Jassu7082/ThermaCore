import '../../core/constants/thermal_constants.dart';

class ThermalReading {
  final String zoneId;
  final double temperatureCelsius;
  final double smoothedTemperatureCelsius;
  final DateTime timestamp;
  final ThermalStatus status;
  final bool isThrottling;

  const ThermalReading({
    required this.zoneId,
    required this.temperatureCelsius,
    required this.smoothedTemperatureCelsius,
    required this.timestamp,
    required this.status,
    this.isThrottling = false,
  });

  double get fahrenheit => (smoothedTemperatureCelsius * 9 / 5) + 32;
  double get kelvin => smoothedTemperatureCelsius + 273.15;

  ZoneCategory get category => ThermalConstants.getCategory(zoneId);

  ThermalReading copyWith({double? temperatureCelsius, double? smoothedTemperatureCelsius, ThermalStatus? status}) {
    return ThermalReading(
      zoneId: zoneId,
      temperatureCelsius: temperatureCelsius ?? this.temperatureCelsius,
      smoothedTemperatureCelsius: smoothedTemperatureCelsius ?? this.smoothedTemperatureCelsius,
      timestamp: timestamp,
      status: status ?? this.status,
      isThrottling: isThrottling,
    );
  }
}

enum ThermalStatus {
  safe('SAFE'),
  warm('WARM'),
  hot('HOT'),
  critical('CRITICAL');

  final String label;
  const ThermalStatus(this.label);
}

extension ThermalStatusX on double {
  ThermalStatus toStatus({
    double warm = 45.0,
    double hot = 60.0,
    double critical = 75.0,
  }) {
    if (this >= critical) return ThermalStatus.critical;
    if (this >= hot) return ThermalStatus.hot;
    if (this >= warm) return ThermalStatus.warm;
    return ThermalStatus.safe;
  }
}
