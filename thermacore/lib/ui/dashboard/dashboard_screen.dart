import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/thermal_reading.dart';
import '../../providers.dart';
import 'widgets/radial_gauge.dart';
import 'widgets/zone_chip.dart';
import 'widgets/sparkline_chart.dart';
import 'widgets/cooling_score_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final thermalAsync = ref.watch(thermalStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ThermaCore'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: AppColors.muted),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: thermalAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (e, _) => Center(child: Text('Error: $e', style: const TextStyle(color: AppColors.critical))),
        data: (readings) => _DashboardContent(readings: readings),
      ),
    );
  }
}

class _DashboardContent extends ConsumerWidget {
  final List<ThermalReading> readings;
  const _DashboardContent({required this.readings});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coolingScore = ref.watch(coolingScoreProvider);
    
    // Find primary CPU temperature
    final cpuReading = readings.firstWhere(
      (r) => r.zoneId.toLowerCase().contains('cpu'),
      orElse: () => readings.isNotEmpty ? readings.first : _emptyReading(),
    );

    return RefreshIndicator(
      color: AppColors.primary,
      backgroundColor: AppColors.surface,
      onRefresh: () async {
        ref.read(thermalRepositoryProvider).readOnce(); // trigger manual refresh
      },
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Radial Gauge ──────────────────────────────
                  Center(
                    child: RadialGauge(
                      temperature: cpuReading.temperatureCelsius,
                      status: cpuReading.status,
                      label: 'CPU TEMP',
                      minTemp: 20,
                      maxTemp: 90,
                    ),
                  ),
                  const SizedBox(height: 30),
                  
                  // ── Zone Chips Row ────────────────────────────
                  if (readings.length > 1) ...[
                    const Text(
                      'ZONES',
                      style: TextStyle(
                        fontFamily: 'SpaceMono',
                        fontSize: 10,
                        letterSpacing: 2,
                        color: AppColors.muted,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        children: readings
                          .where((r) => r.zoneId != cpuReading.zoneId)
                          .map((r) => ZoneChip(
                                reading: r,
                                onTap: () {
                                  ref.read(selectedZoneProvider.notifier).state = r.zoneId;
                                  context.push('/zone_detail');
                                },
                              ))
                          .toList(),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  
                  // ── Sparkline ─────────────────────────────────
                  SparklineChart(readings: readings),
                  const SizedBox(height: 24),
                  
                  // ── Cooling Score ─────────────────────────────
                  CoolingScoreCard(score: coolingScore),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  ThermalReading _emptyReading() => ThermalReading(
        zoneId: 'unknown',
        temperatureCelsius: 0,
        timestamp: DateTime.now(),
        status: ThermalStatus.safe,
      );
}
