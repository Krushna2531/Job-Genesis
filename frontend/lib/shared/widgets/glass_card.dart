import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';

/// Glassmorphic card with frosted blur, gradient border, and subtle glow.
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final Color? glowColor;
  final double blurAmount;
  final VoidCallback? onTap;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
    this.glowColor,
    this.blurAmount = 12.0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final glow = glowColor ?? AppColors.primary;
    final br = borderRadius ?? AppSpacing.radiusLg;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(br),
          boxShadow: [
            BoxShadow(
              color: glow.withValues(alpha: 0.08),
              blurRadius: 24,
              spreadRadius: -4,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(br),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: blurAmount,
              sigmaY: blurAmount,
            ),
            child: Container(
              padding: padding ?? AppSpacing.cardPadding,
              decoration: BoxDecoration(
                gradient: AppColors.glassGradient,
                borderRadius: BorderRadius.circular(br),
                border: Border.all(
                  color: AppColors.glassBorder,
                  width: 1,
                ),
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
