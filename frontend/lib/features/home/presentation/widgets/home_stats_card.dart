import 'package:flutter/material.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../shared/widgets/animated_counter.dart';
import '../../../../shared/widgets/glass_card.dart';

/// Stats card with animated counter and icon glow.
class HomeStatsCard extends StatelessWidget {
  final String label;
  final int value;
  final IconData icon;
  final Color color;
  final String? suffix;

  const HomeStatsCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      glowColor: color,
      padding: EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.3),
                  blurRadius: 12,
                  spreadRadius: -2,
                ),
              ],
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          SizedBox(height: AppSpacing.md),
          AnimatedCounter(
            value: value,
            suffix: suffix,
            style: AppTypography.h2.copyWith(color: Colors.white),
          ),
          SizedBox(height: AppSpacing.xs),
          Text(
            label,
            style: AppTypography.labelSmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
