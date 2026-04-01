import 'package:flutter/material.dart';
import '../../core/constants/app_typography.dart';
import '../../core/constants/app_animations.dart';

/// Animated number counter for stats and dashboards.
class AnimatedCounter extends StatelessWidget {
  final int value;
  final TextStyle? style;
  final String? prefix;
  final String? suffix;
  final Duration duration;

  const AnimatedCounter({
    super.key,
    required this.value,
    this.style,
    this.prefix,
    this.suffix,
    this.duration = AppAnimations.slower,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<int>(
      tween: IntTween(begin: 0, end: value),
      duration: duration,
      curve: AppAnimations.defaultCurve,
      builder: (context, val, child) {
        return Text(
          '${prefix ?? ''}$val${suffix ?? ''}',
          style: style ?? AppTypography.h1,
        );
      },
    );
  }
}
