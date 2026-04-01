/// Friendly display names for well-known thermal zone type strings.
/// Different devices use different zone names for the same hardware.
class ThermalConstants {
  static const double defaultWarmThreshold = 45.0;
  static const double defaultHotThreshold = 60.0;
  static const double defaultCriticalThreshold = 75.0;

  static const Duration defaultPollingInterval = Duration(seconds: 2);

  /// Maps sysfs zone type keywords to human-friendly names.
  static const Map<String, String> _friendlyNames = {
    'cpu': 'CPU',
    'cpu0': 'CPU Core 0',
    'cpu1': 'CPU Core 1',
    'cpu2': 'CPU Core 2',
    'cpu3': 'CPU Core 3',
    'gpu': 'GPU',
    'battery': 'Battery',
    'battery_bm': 'Battery',
    'skin': 'Device Skin',
    'back': 'Back Panel',
    'soc': 'SoC',
    'soc_max': 'SoC (Max)',
    'npu': 'NPU',
    'dsp': 'DSP',
    'camera': 'Camera',
    'wlan': 'Wi-Fi',
    'charger': 'Charger',
    'pa': 'Power Amp',
    'modem': 'Modem',
    'memory': 'Memory',
    'ufs': 'Storage (UFS)',
    'ambient': 'Ambient',
  };

  /// Returns a human-readable name for a raw sysfs zone type string.
  static String getFriendlyName(String rawName) {
    final lower = rawName.toLowerCase();
    for (final entry in _friendlyNames.entries) {
      if (lower.contains(entry.key)) return entry.value;
    }
    // Format unknown names nicely: "tsens_tz_sensor2" → "Tsens Tz Sensor2"
    return rawName
        .replaceAll('_', ' ')
        .split(' ')
        .map((w) => w.isEmpty ? '' : '${w[0].toUpperCase()}${w.substring(1)}')
        .join(' ');
  }

  /// Returns a category for zone colouring purposes.
  static ZoneCategory getCategory(String zoneId) {
    final lower = zoneId.toLowerCase();
    if (lower.contains('gpu')) return ZoneCategory.gpu;
    if (lower.contains('cpu')) return ZoneCategory.cpu;
    if (lower.contains('battery') || lower.contains('battery_bm')) {
      return ZoneCategory.battery;
    }
    return ZoneCategory.system;
  }
}

enum ZoneCategory { cpu, gpu, battery, system }
