import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/thermal_reading.dart';
import '../../../providers.dart';

class SparklineChart extends ConsumerWidget {
  final List<ThermalReading> readings;

  const SparklineChart({super.key, required this.readings});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(historyProvider);

    // Pick primary CPU zone for the sparkline
    final cpuZoneId = readings
        .firstWhere(
          (r) => r.zoneId.toLowerCase().contains('cpu'),
          orElse: () => readings.isNotEmpty ? readings.first : _emptyReading(),
        )
        .zoneId;

    final points = history[cpuZoneId] ?? [];

    return Container(
      height: 90,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 8, top: 8),
            child: Text(
              'CPU HISTORY',
              style: TextStyle(
                fontFamily: 'SpaceMono',
                fontSize: 8,
                letterSpacing: 2,
                color: AppColors.muted,
              ),
            ),
          ),
          Expanded(
            child: points.length < 2
                ? const Center(
                    child: Text(
                      'Collecting data...',
                      style: TextStyle(color: AppColors.muted, fontSize: 11),
                    ),
                  )
                : LineChart(
                    _buildChart(points),
                    duration: const Duration(milliseconds: 200),
                  ),
          ),
        ],
      ),
    );
  }

  LineChartData _buildChart(List<ThermalReading> points) {
    final spots = points.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value.temperatureCelsius);
    }).toList();

    final latest = points.last;
    final color = AppColors.forStatus(latest.status);

    return LineChartData(
      gridData: FlGridData(
        show: true,
        horizontalInterval: 15,
        getDrawingHorizontalLine: (_) => FlLine(
          color: AppColors.border.withOpacity(0.4),
          strokeWidth: 0.5,
        ),
        drawVerticalLine: false,
      ),
      titlesData: FlTitlesData(
        show: true,
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 32,
            interval: 20,
            getTitlesWidget: (v, _) => Text(
              '${v.toInt()}°',
              style: const TextStyle(color: AppColors.muted, fontSize: 8),
            ),
          ),
        ),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(show: false),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: color,
          barWidth: 2,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [color.withOpacity(0.2), color.withOpacity(0)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
      minY: 20,
      maxY: 90,
    );
  }

  ThermalReading _emptyReading() => ThermalReading(
    zoneId: 'unknown',
    temperatureCelsius: 0,
    timestamp: DateTime.now(),
    status: ThermalStatus.safe,
  );
}
