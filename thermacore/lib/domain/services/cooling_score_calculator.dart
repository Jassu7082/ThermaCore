import '../../data/models/thermal_reading.dart';

/// Computes an overall thermal health score (0–100) from current readings.
/// Higher = better (cooler and less throttling).
class CoolingScoreCalculator {
  static int compute(List<ThermalReading> readings) {
    if (readings.isEmpty) return 100;

    // Start with 100, deduct for each zone
    double deductions = 0;

    for (final r in readings) {
      // Weight CPU zones more heavily
      final weight = r.zoneId.toLowerCase().contains('cpu') ? 2.0 : 1.0;

      switch (r.status) {
        case ThermalStatus.safe:
          break; // no deduction
        case ThermalStatus.warm:
          deductions += 5 * weight;
        case ThermalStatus.hot:
          deductions += 15 * weight;
        case ThermalStatus.critical:
          deductions += 30 * weight;
      }

      if (r.isThrottling) deductions += 10;
    }

    // Normalize to 0–100
    final score = (100 - deductions).clamp(0.0, 100.0);
    return score.round();
  }

  /// Computes a score based on a list of historical readings (e.g. over 24h).
  /// Penalizes frequent spikes and sustained high temperatures.
  static int computeHistorical(List<ThermalReading> historicalReadings) {
    if (historicalReadings.isEmpty) return 100;

    // We can average the instant scores over time, or look for peak stress.
    // For now, let's take a weighted average of the last N points.
    double totalScore = 0;
    int weightSum = 0;

    // Give more weight to recent points (last 10% of data)
    final recentCount = (historicalReadings.length * 0.1).ceil();
    
    for (int i = 0; i < historicalReadings.length; i++) {
        final r = historicalReadings[i];
        final instantScore = compute([r]);
        final weight = (i >= historicalReadings.length - recentCount) ? 3 : 1;
        
        totalScore += instantScore * weight;
        weightSum += weight;
    }

    return (totalScore / weightSum).round();
  }

  static String scoreLabel(int score) {
    if (score >= 90) return 'EXCELLENT';
    if (score >= 70) return 'GOOD';
    if (score >= 50) return 'FAIR';
    if (score >= 30) return 'POOR';
    return 'CRITICAL';
  }
}
