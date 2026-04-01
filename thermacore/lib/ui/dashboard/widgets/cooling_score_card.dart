import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/services/cooling_score_calculator.dart';

class CoolingScoreCard extends StatelessWidget {
  final int score;

  const CoolingScoreCard({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    Color color;
    if (score >= 90) color = AppColors.safe;
    else if (score >= 70) color = AppColors.primary;
    else if (score >= 50) color = AppColors.warning;
    else if (score >= 30) color = AppColors.hot;
    else color = AppColors.critical;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.1),
              border: Border.all(color: color.withOpacity(0.5)),
            ),
            child: Text(
              score.toString(),
              style: TextStyle(
                fontFamily: 'Orbitron',
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: color,
                shadows: [Shadow(color: color, blurRadius: 4)],
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'COOLING SCORE',
                  style: TextStyle(
                    fontFamily: 'SpaceMono',
                    fontSize: 10,
                    letterSpacing: 2,
                    color: AppColors.muted,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  CoolingScoreCalculator.scoreLabel(score),
                  style: TextStyle(
                    fontFamily: 'Orbitron',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Aggregated health across all thermal zones.',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white60,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
