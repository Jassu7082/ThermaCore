import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/thermal_constants.dart';
import '../../../data/models/thermal_reading.dart';
import '../../../providers.dart';

class ZoneChip extends ConsumerWidget {
  final ThermalReading reading;
  final VoidCallback? onTap;

  const ZoneChip({super.key, required this.reading, this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = AppColors.forStatus(reading.status);
    final unit = ref.watch(tempUnitProvider);
    final friendlyName = ThermalConstants.getFriendlyName(reading.zoneId);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.6), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.15),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                    boxShadow: [BoxShadow(color: color, blurRadius: 4)],
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  friendlyName,
                  style: const TextStyle(
                    fontFamily: 'SpaceMono',
                    fontSize: 9,
                    letterSpacing: 1,
                    color: AppColors.muted,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              unit.label(reading.smoothedTemperatureCelsius),
              style: TextStyle(
                fontFamily: 'Orbitron',
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
