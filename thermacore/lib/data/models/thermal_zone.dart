import '../../core/constants/thermal_constants.dart';

class ThermalZone {
  final String id;
  final String displayName;
  final String sysfsPath;
  final bool isEnabled;
  final double? warningThreshold;
  final double? criticalThreshold;

  const ThermalZone({
    required this.id,
    required this.displayName,
    required this.sysfsPath,
    this.isEnabled = true,
    this.warningThreshold,
    this.criticalThreshold,
  });

  /// Convert raw millidegrees from sysfs to Celsius.
  static double milliToC(int millidegrees) => millidegrees / 1000.0;

  /// Battery temp from BatteryManager is in tenths of degree Celsius.
  static double tenthsToC(int tenths) => tenths / 10.0;

  ThermalZone copyWith({
    String? displayName,
    bool? isEnabled,
    double? warningThreshold,
    double? criticalThreshold,
  }) {
    return ThermalZone(
      id: id,
      displayName: displayName ?? this.displayName,
      sysfsPath: sysfsPath,
      isEnabled: isEnabled ?? this.isEnabled,
      warningThreshold: warningThreshold ?? this.warningThreshold,
      criticalThreshold: criticalThreshold ?? this.criticalThreshold,
    );
  }

  ZoneCategory get category => ThermalConstants.getCategory(id);

  Map<String, dynamic> toJson() => {
    'id': id,
    'displayName': displayName,
    'sysfsPath': sysfsPath,
    'isEnabled': isEnabled,
    'warningThreshold': warningThreshold,
    'criticalThreshold': criticalThreshold,
  };

  factory ThermalZone.fromJson(Map<String, dynamic> json) => ThermalZone(
    id: json['id'] as String,
    displayName: json['displayName'] as String,
    sysfsPath: json['sysfsPath'] as String,
    isEnabled: json['isEnabled'] as bool? ?? true,
    warningThreshold: json['warningThreshold'] as double?,
    criticalThreshold: json['criticalThreshold'] as double?,
  );
}
