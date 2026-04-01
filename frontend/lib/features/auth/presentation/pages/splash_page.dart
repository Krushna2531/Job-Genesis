import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/router/app_router.dart';
import '../../../../shared/widgets/particle_background.dart';
import '../../providers/auth_provider.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _pulseController;
  late AnimationController _ringController;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;
  late Animation<double> _pulseAnim;
  late Animation<double> _ringAnim;
  late Animation<double> _taglineFade;

  @override
  void initState() {
    super.initState();

    // Main entrance animation
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _scaleAnim = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    _taglineFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
      ),
    );

    // Pulse glow
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _pulseAnim = Tween<double>(begin: 0.3, end: 0.7).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Progress ring
    _ringController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );

    _ringAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _ringController, curve: Curves.easeInOut),
    );

    _mainController.forward();
    Future.delayed(const Duration(milliseconds: 400), () {
      _ringController.forward();
    });

    // Navigate after splash
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted && !ref.read(authProvider).isLoading) {
        _checkAuthAndNavigate();
      }
    });
  }

  void _checkAuthAndNavigate() {
    // Determine the state from auth provider
    final authState = ref.read(authProvider);

    if (authState.isLoading) {
      return; // wait a bit more
    }
    
    // Smooth transition buffer
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        if (authState.value != null) {
          context.go(AppRoutes.home);
        } else {
          context.go(AppRoutes.onboarding);
        }
      }
    });
  }

  @override
  void dispose() {
    _mainController.dispose();
    _pulseController.dispose();
    _ringController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Optionally we can listen for auth variations right here
    ref.listen(authProvider, (prev, next) {
      if (!next.isLoading) {
        _checkAuthAndNavigate();
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: ParticleBackground(
        particleCount: 25,
        child: Center(
          child: AnimatedBuilder(
            animation: Listenable.merge([_mainController, _pulseController, _ringController]),
            builder: (context, child) {
              return Opacity(
                opacity: _fadeAnim.value,
                child: Transform.scale(
                  scale: _scaleAnim.value,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Logo with ring and glow
                      SizedBox(
                        width: 130,
                        height: 130,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Progress ring
                            SizedBox(
                              width: 130,
                              height: 130,
                              child: CustomPaint(
                                painter: _RingPainter(
                                  progress: _ringAnim.value,
                                  glowOpacity: _pulseAnim.value,
                                ),
                              ),
                            ),
                            // Logo mark
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                gradient: AppColors.primaryGradient,
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withValues(
                                      alpha: _pulseAnim.value,
                                    ),
                                    blurRadius: 40,
                                    spreadRadius: 8,
                                  ),
                                  BoxShadow(
                                    color: AppColors.neonCyan.withValues(
                                      alpha: _pulseAnim.value * 0.3,
                                    ),
                                    blurRadius: 60,
                                    spreadRadius: 12,
                                  ),
                                ],
                              ),
                              child: const Center(
                                child: Text(
                                  'JG',
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      // App Name with gradient
                      ShaderMask(
                        shaderCallback: (bounds) =>
                            AppColors.neonGradient.createShader(bounds),
                        child: Text(
                          'JobGenesis',
                          style: AppTypography.displayLarge.copyWith(
                            color: Colors.white,
                            fontSize: 42,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Tagline with fade
                      Opacity(
                        opacity: _taglineFade.value,
                        child: Text(
                          'Your career. Evolved.',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Custom ring painter with gradient and glow.
class _RingPainter extends CustomPainter {
  final double progress;
  final double glowOpacity;

  _RingPainter({required this.progress, required this.glowOpacity});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;

    // Background ring
    final bgPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = AppColors.surfaceBorder;
    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc with gradient
    if (progress > 0) {
      final rect = Rect.fromCircle(center: center, radius: radius);
      final gradientPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round
        ..shader = const SweepGradient(
          colors: [AppColors.primary, AppColors.neonCyan, AppColors.primary],
        ).createShader(rect);

      canvas.drawArc(
        rect,
        -pi / 2,
        2 * pi * progress,
        false,
        gradientPaint,
      );

      // Glow
      final glowPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8)
        ..shader = SweepGradient(
          colors: [
            AppColors.primary.withValues(alpha: glowOpacity * 0.5),
            AppColors.neonCyan.withValues(alpha: glowOpacity * 0.5),
            AppColors.primary.withValues(alpha: glowOpacity * 0.5),
          ],
        ).createShader(rect);

      canvas.drawArc(
        rect,
        -pi / 2,
        2 * pi * progress,
        false,
        glowPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) =>
      progress != oldDelegate.progress ||
      glowOpacity != oldDelegate.glowOpacity;
}
