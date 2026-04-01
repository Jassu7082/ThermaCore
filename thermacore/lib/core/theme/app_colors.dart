import 'package:flutter/material.dart';
import '../../data/models/thermal_reading.dart';
import '../../core/constants/thermal_constants.dart';

class AppColors {
  // Background layers
  static const background = Color(0xFF050810);
  static const surface    = Color(0xFF0B1120);
  static const border     = Color(0xFF1A2640);

  // Brand / state colours
  static const primary    = Color(0xFF00E5FF);  // Cyan — active
  static const safe       = Color(0xFF7FFF6E);  // Green
  static const warning    = Color(0xFFFFA500);  // Orange
  static const hot        = Color(0xFFFF6B35);  // Deep orange
  static const critical   = Color(0xFFFF4D6A);  // Red
  static const gpu        = Color(0xFFC77DFF);  // Violet
  static const muted      = Color(0xFF4A6080);  // Dim text

  static Color forStatus(ThermalStatus status) => switch (status) {
    ThermalStatus.safe     => safe,
    ThermalStatus.warm     => warning,
    ThermalStatus.hot      => hot,
    ThermalStatus.critical => critical,
  };

  static Color forCategory(ZoneCategory cat) => switch (cat) {
    ZoneCategory.cpu     => primary,
    ZoneCategory.gpu     => gpu,
    ZoneCategory.battery => safe,
    ZoneCategory.system  => muted,
  };
}
