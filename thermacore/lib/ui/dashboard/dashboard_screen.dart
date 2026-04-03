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
                      temperature: cpuReading.smoothedTemperatureCelsius,
                      status: cpuReading.status,
                      label: 'PU TEMP (SMOOTHED)',
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
                  
                  // ── Zone Guide ────────────────────────────────
                  _ZoneGuide(),
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
        smoothedTemperatureCelsius: 0,
        timestamp: DateTime.now(),
        status: ThermalStatus.safe,
      );
}

class _ZoneGuide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
      ),
      child: ExpansionTile(
        title: const Text(
          'WHAT ARE THESE ZONES?',
          style: TextStyle(
            fontFamily: 'SpaceMono',
            fontSize: 10,
            letterSpacing: 2,
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        tilePadding: const EdgeInsets.symmetric(horizontal: 16),
        childrenPadding: const EdgeInsets.all(16),
        expandedAlignment: Alignment.topLeft,
        children: const [
          Text(
            'Thermal Zones are raw hardware sensors built into your device\'s silicon. Each manufacturer names them differently (e.g., "tsens", "soc", "mtk").\n\n'
            '• CPU zones track individual core clusters.\n'
            '• Battery zones track the charging IC.\n'
            '• GPU zones track graphics processing heat.\n\n'
            'Higher-end devices can have over 50 individual sensors!',
            style: TextStyle(fontFamily: 'SpaceMono', fontSize: 11, color: AppColors.muted, height: 1.5),
          ),
        ],
      ),
    );
  }
}
