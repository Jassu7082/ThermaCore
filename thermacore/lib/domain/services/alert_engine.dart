import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:typed_data';
import '../../data/models/thermal_reading.dart';

class AlertEngine {
  final FlutterLocalNotificationsPlugin _notifications;
  final Map<String, ThermalStatus> _lastStatus = {};
  DateTime? _lastAlertTime;

  Duration alertCooldown;

  AlertEngine({
    required FlutterLocalNotificationsPlugin notifications,
    this.alertCooldown = const Duration(minutes: 2),
  }) : _notifications = notifications;

  Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    await _notifications.initialize(
      const InitializationSettings(android: androidSettings),
    );

    final androidPlugin = _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.createNotificationChannel(
      const AndroidNotificationChannel(
        'thermacore_warning',
        'Temperature Warnings',
        description: 'Elevated temperature alerts',
        importance: Importance.defaultImportance,
        playSound: false,
      ),
    );

    await androidPlugin?.createNotificationChannel(
      AndroidNotificationChannel(
        'thermacore_critical',
        'Critical Temperature Alerts',
        description: 'Dangerous temperature level alerts',
        importance: Importance.high,
        playSound: true,
        enableVibration: true,
        vibrationPattern: Int64List.fromList([0, 200, 100, 200, 100, 400]),
      ),
    );
  }

  Future<void> evaluate(List<ThermalReading> readings) async {
    for (final reading in readings) {
      final previous = _lastStatus[reading.zoneId];
      final current = reading.status;

      if (_hasWorsened(previous, current)) {
        final now = DateTime.now();
        final withinCooldown = _lastAlertTime != null &&
            now.difference(_lastAlertTime!) < alertCooldown;

        if (!withinCooldown || current == ThermalStatus.critical) {
          await _sendAlert(reading);
          _lastAlertTime = now;
        }
      }

      if (current == ThermalStatus.safe && previous != ThermalStatus.safe) {
        await _notifications.cancel(_notificationId(reading.zoneId));
      }

      _lastStatus[reading.zoneId] = current;
    }
  }

  Future<void> _sendAlert(ThermalReading reading) async {
    final isCritical = reading.status == ThermalStatus.critical;
    final channelId = isCritical ? 'thermacore_critical' : 'thermacore_warning';
    final title = isCritical ? '🔴 Critical Temperature' : '🟡 High Temperature';
    final temp = reading.temperatureCelsius.toStringAsFixed(1);
    final zone = reading.zoneId.toUpperCase();

    await _notifications.show(
      _notificationId(reading.zoneId),
      title,
      '$zone reached ${temp}°C',
      NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          isCritical ? 'Critical Temperature Alerts' : 'Temperature Warnings',
          importance: isCritical ? Importance.high : Importance.defaultImportance,
          priority: isCritical ? Priority.high : Priority.defaultPriority,
          ongoing: isCritical,
          autoCancel: !isCritical,
        ),
      ),
    );
  }

  bool _hasWorsened(ThermalStatus? previous, ThermalStatus current) {
    if (previous == null) return current != ThermalStatus.safe;
    return current.index > previous.index;
  }

  int _notificationId(String zoneId) => zoneId.hashCode.abs() % 10000;
}
