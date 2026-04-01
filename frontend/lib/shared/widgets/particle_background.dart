import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// Floating particle/orb background for splash and auth screens.
class ParticleBackground extends StatefulWidget {
  final Widget child;
  final int particleCount;
  final List<Color>? colors;

  const ParticleBackground({
    super.key,
    required this.child,
    this.particleCount = 30,
    this.colors,
  });

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_Particle> _particles;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    final colors = widget.colors ??
        [
          AppColors.primary.withValues(alpha: 0.15),
          AppColors.neonCyan.withValues(alpha: 0.1),
          AppColors.neonPink.withValues(alpha: 0.08),
          AppColors.secondary.withValues(alpha: 0.1),
        ];

    _particles = List.generate(widget.particleCount, (i) {
      return _Particle(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        radius: _random.nextDouble() * 60 + 10,
        speedX: (_random.nextDouble() - 0.5) * 0.02,
        speedY: (_random.nextDouble() - 0.5) * 0.015,
        color: colors[_random.nextInt(colors.length)],
        phase: _random.nextDouble() * 2 * pi,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Gradient base
        Container(
          decoration: const BoxDecoration(
            gradient: AppColors.splashGradient,
          ),
        ),
        // Particles
        AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return CustomPaint(
              size: MediaQuery.of(context).size,
              painter: _ParticlePainter(
                particles: _particles,
                progress: _controller.value,
              ),
            );
          },
        ),
        // Child content
        widget.child,
      ],
    );
  }
}

class _Particle {
  double x, y;
  final double radius;
  final double speedX, speedY;
  final Color color;
  final double phase;

  _Particle({
    required this.x,
    required this.y,
    required this.radius,
    required this.speedX,
    required this.speedY,
    required this.color,
    required this.phase,
  });
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress;

  _ParticlePainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final time = progress * 2 * pi;
      final x = (p.x + sin(time + p.phase) * 0.05) * size.width;
      final y = (p.y + cos(time * 0.7 + p.phase) * 0.04) * size.height;

      final paint = Paint()
        ..color = p.color
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, p.radius * 0.6);

      canvas.drawCircle(Offset(x, y), p.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) => true;
}
