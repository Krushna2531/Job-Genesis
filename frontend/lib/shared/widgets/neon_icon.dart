import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// Icon with animated neon glow halo.
class NeonIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color color;
  final double glowRadius;

  const NeonIcon({
    super.key,
    required this.icon,
    this.size = 28,
    this.color = AppColors.primary,
    this.glowRadius = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.4),
            blurRadius: glowRadius,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Icon(icon, size: size, color: color),
    );
  }
}
