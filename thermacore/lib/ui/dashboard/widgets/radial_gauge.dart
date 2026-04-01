import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/thermal_reading.dart';

class RadialGauge extends StatelessWidget {
  final double temperature;
  final ThermalStatus status;
  final String label;
  final double minTemp;
  final double maxTemp;

  const RadialGauge({
    super.key,
    required this.temperature,
    required this.status,
    required this.label,
    this.minTemp = 20,
    this.maxTemp = 90,
  });

  @override
  Widget build(BuildContext context) {
    final color = AppColors.forStatus(status);
    final progress =
        ((temperature - minTemp) / (maxTemp - minTemp)).clamp(0.0, 1.0);

    return SizedBox(
      width: 240,
      height: 150,
      child: CustomPaint(
        painter: _GaugePainter(
          progress: progress,
          color: color,
          backgroundColor: AppColors.border,
        ),
        child: Align(
          alignment: const Alignment(0, 0.5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${temperature.toStringAsFixed(1)}°',
                style: TextStyle(
                  fontFamily: 'Orbitron',
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  color: color,
                  shadows: [Shadow(color: color.withOpacity(0.6), blurRadius: 16)],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'SpaceMono',
                  fontSize: 9,
                  letterSpacing: 3,
                  color: AppColors.muted,
                ),
              ),
              const SizedBox(height: 4),
              _StatusBadge(status: status),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final ThermalStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = AppColors.forStatus(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: color.withOpacity(0.6)),
        borderRadius: BorderRadius.circular(4),
        color: color.withOpacity(0.1),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          fontFamily: 'SpaceMono',
          fontSize: 8,
          letterSpacing: 2,
          color: color,
        ),
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color backgroundColor;

  const _GaugePainter({
    required this.progress,
    required this.color,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.88);
    final radius = size.width * 0.44;
    const startAngle = math.pi;
    const sweepAngle = math.pi;

    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    // Track — coloured glow
    final fgPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    // Solid track on top (thinner)
    final fgSolidPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle, sweepAngle, false, bgPaint,
    );
    // Glow
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle, sweepAngle * progress, false, fgPaint,
    );
    // Solid
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle, sweepAngle * progress, false, fgSolidPaint,
    );

    // Tick marks
    _drawTicks(canvas, center, radius, bgPaint);
  }

  void _drawTicks(Canvas canvas, Offset center, double radius, Paint paint) {
    final tickPaint = Paint()
      ..color = AppColors.border
      ..strokeWidth = 1.5;
    for (int i = 0; i <= 10; i++) {
      final angle = math.pi + (math.pi * i / 10);
      final inner = radius - 8;
      final outer = radius + 2;
      canvas.drawLine(
        Offset(center.dx + inner * math.cos(angle),
               center.dy + inner * math.sin(angle)),
        Offset(center.dx + outer * math.cos(angle),
               center.dy + outer * math.sin(angle)),
        tickPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_GaugePainter old) =>
      old.progress != progress || old.color != color;
}
