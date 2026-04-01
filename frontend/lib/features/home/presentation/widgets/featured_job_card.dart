import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../shared/widgets/glass_card.dart';

/// Featured job card for horizontal carousel on home.
class FeaturedJobCard extends StatelessWidget {
  final String company;
  final String role;
  final String location;
  final String salary;
  final String timeAgo;
  final Color accentColor;
  final List<String> tags;
  final VoidCallback? onTap;

  const FeaturedJobCard({
    super.key,
    required this.company,
    required this.role,
    required this.location,
    required this.salary,
    this.timeAgo = '2h ago',
    this.accentColor = AppColors.primary,
    this.tags = const [],
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      onTap: onTap,
      glowColor: accentColor,
      padding: EdgeInsets.all(AppSpacing.lg),
      child: SizedBox(
        width: 280,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Company + time
            Row(
              children: [
                // Company avatar
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: accentColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      company.isNotEmpty ? company[0] : '?',
                      style: AppTypography.h3.copyWith(color: accentColor),
                    ),
                  ),
                ),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        company,
                        style: AppTypography.labelLarge,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(timeAgo, style: AppTypography.caption),
                    ],
                  ),
                ),
                // Bookmark
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.bookmark_outline_rounded,
                    size: 18,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.lg),

            // Role
            Text(
              role,
              style: AppTypography.h4,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: AppSpacing.sm),

            // Location
            Row(
              children: [
                Icon(Icons.location_on_outlined,
                    size: 14, color: AppColors.textTertiary),
                const SizedBox(width: 4),
                Text(location, style: AppTypography.bodySmall),
              ],
            ),
            SizedBox(height: AppSpacing.md),

            // Tags
            if (tags.isNotEmpty)
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.xs,
                children: tags.map((tag) {
                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.1),
                      borderRadius: AppSpacing.borderFull,
                      border: Border.all(
                        color: accentColor.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Text(
                      tag,
                      style: AppTypography.labelSmall.copyWith(
                        color: accentColor,
                      ),
                    ),
                  );
                }).toList(),
              ),
            SizedBox(height: AppSpacing.md),

            // Salary badge
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.success.withValues(alpha: 0.15),
                    AppColors.success.withValues(alpha: 0.05),
                  ],
                ),
                borderRadius: AppSpacing.borderFull,
              ),
              child: Text(
                salary,
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.success,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
