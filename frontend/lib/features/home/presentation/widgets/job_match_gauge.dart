import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';

/// Circular animated gauge showing job match percentage.
class JobMatchGauge extends StatefulWidget {
  final double matchPercent; // 0.0 - 1.0
  final String label;

  const JobMatchGauge({
    super.key,
    required this.matchPercent,
    this.label = 'AI Match',
  });

  @override
  State<JobMatchGauge> createState() => _JobMatchGaugeState();
}

class _JobMatchGaugeState extends State<JobMatchGauge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _animation = Tween<double>(begin: 0, end: widget.matchPercent).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final percent = (_animation.value * 100).round();
        return SizedBox(
          width: 140,
          height: 140,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Glow
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
              ),
              // Ring
              CustomPaint(
                size: const Size(130, 130),
                painter: _GaugePainter(
                  progress: _animation.value,
                ),
              ),
              // Center text
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$percent%',
                    style: AppTypography.h1.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    widget.label,
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double progress;

  _GaugePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 6;
    final rect = Rect.fromCircle(center: center, radius: radius);

    // Background track
    final bgPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..color = AppColors.surfaceBorder;
    canvas.drawArc(rect, -pi * 0.75, pi * 1.5, false, bgPaint);

    // Progress arc
    if (progress > 0) {
      final gradPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8
        ..strokeCap = StrokeCap.round
        ..shader = const SweepGradient(
          startAngle: -pi * 0.75,
          endAngle: pi * 0.75,
          colors: [AppColors.primary, AppColors.neonCyan, AppColors.secondary],
        ).createShader(rect);

      canvas.drawArc(
        rect,
        -pi * 0.75,
        pi * 1.5 * progress,
        false,
        gradPaint,
      );

      // Glow on arc
      final glowPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 14
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8)
        ..shader = SweepGradient(
          startAngle: -pi * 0.75,
          endAngle: pi * 0.75,
          colors: [
            AppColors.primary.withValues(alpha: 0.3),
            AppColors.neonCyan.withValues(alpha: 0.3),
            AppColors.secondary.withValues(alpha: 0.3),
          ],
        ).createShader(rect);

      canvas.drawArc(
        rect,
        -pi * 0.75,
        pi * 1.5 * progress,
        false,
        glowPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) =>
      progress != oldDelegate.progress;
}
