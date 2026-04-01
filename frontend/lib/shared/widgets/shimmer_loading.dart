import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';

/// Skeleton loading widget with electric shimmer sweep.
class ShimmerLoading extends StatelessWidget {
  final double width;
  final double height;
  final double? borderRadius;

  const ShimmerLoading({
    super.key,
    this.width = double.infinity,
    this.height = 80,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final br = borderRadius ?? AppSpacing.radiusMd;
    return Shimmer.fromColors(
      baseColor: AppColors.surfaceElevated,
      highlightColor: AppColors.surfaceBorder,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(br),
        ),
      ),
    );
  }
}

/// Card-shaped shimmer placeholder.
class ShimmerCard extends StatelessWidget {
  const ShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.surfaceElevated,
      highlightColor: AppColors.surfaceBorder,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: AppColors.surfaceElevated,
          borderRadius: AppSpacing.borderLg,
          border: Border.all(color: AppColors.surfaceBorder),
        ),
      ),
    );
  }
}
