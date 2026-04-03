import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/thermal_constants.dart';
import '../../data/models/thermal_reading.dart';
import '../../providers.dart';

class ZoneDetailScreen extends ConsumerWidget {
  const ZoneDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final zoneId = ref.watch(selectedZoneProvider);
    if (zoneId == null) return const Scaffold(body: Center(child: Text('No zone selected')));

    final thermalAsync = ref.watch(thermalStreamProvider);
    final unit = ref.watch(tempUnitProvider);
    final friendlyName = ThermalConstants.getFriendlyName(zoneId);

    return Scaffold(
      appBar: AppBar(title: Text(friendlyName)),
      body: thermalAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (readings) {
          final reading = readings.firstWhere(
            (r) => r.zoneId == zoneId,
            orElse: () => readings.first,
          );
          
          final color = AppColors.forStatus(reading.status);

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: color, width: 4),
                      boxShadow: [BoxShadow(color: color.withOpacity(0.2), blurRadius: 40)],
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            unit.label(reading.smoothedTemperatureCelsius),
                            style: TextStyle(
                              fontFamily: 'Orbitron',
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            reading.status.label,
                            style: TextStyle(
                              fontFamily: 'SpaceMono',
                              letterSpacing: 3,
                              color: color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                _InfoRow('System ID', reading.zoneId),
                _InfoRow('Category', reading.category.name.toUpperCase()),
                _InfoRow('Throttling', reading.isThrottling ? 'YES' : 'NO', 
                  color: reading.isThrottling ? AppColors.critical : AppColors.safe),
                _InfoRow('Last Updated', reading.timestamp.toString().split('.').first),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;

  const _InfoRow(this.label, this.value, {this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'SpaceMono',
              color: AppColors.muted,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'SpaceMono',
              fontWeight: FontWeight.bold,
              color: color ?? Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
