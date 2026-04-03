import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../data/models/thermal_reading.dart';

class FileExporter {

  /// Export readings as CSV and open system share sheet.
  Future<void> exportCsv(List<ThermalReading> readings, String sessionName) async {
    final buffer = StringBuffer();
    // Header row
    buffer.writeln('timestamp,zone_id,temperature_c,status,throttling');

    for (final r in readings) {
      buffer.writeln(
        '${r.timestamp.toIso8601String()},'
        '${r.zoneId},'
        '${r.temperatureCelsius.toStringAsFixed(3)},'
        '${r.status.name},'
        '${r.isThrottling ? 1 : 0}',
      );
    }

    final file = await _writeTemp('thermacore_$sessionName.csv', buffer.toString());
    await Share.shareXFiles(
      [XFile(file.path, mimeType: 'text/csv')],
      subject: 'ThermaCore Export — $sessionName',
    );
  }

  /// Export readings as structured JSON.
  Future<void> exportJson(List<ThermalReading> readings, String sessionName) async {
    final data = {
      'app': 'ThermaCore',
      'exported_at': DateTime.now().toIso8601String(),
      'session': sessionName,
      'total_readings': readings.length,
      'readings': readings.map((r) => {
        'timestamp': r.timestamp.toIso8601String(),
        'zone_id': r.zoneId,
        'temperature_c': r.temperatureCelsius,
        'status': r.status.name,
        'throttling': r.isThrottling,
      }).toList(),
    };

    final json = const JsonEncoder.withIndent('  ').convert(data);
    final file = await _writeTemp('thermacore_$sessionName.json', json);
    await Share.shareXFiles(
      [XFile(file.path, mimeType: 'application/json')],
      subject: 'ThermaCore Export — $sessionName',
    );
  }

  Future<File> _writeTemp(String filename, String content) async {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$filename');
    await file.writeAsString(content);
    return file;
  }
}
