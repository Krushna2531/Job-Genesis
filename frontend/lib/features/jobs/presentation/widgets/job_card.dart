import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../shared/widgets/glass_card.dart';

/// Job card for feed list.
class JobCard extends StatefulWidget {
  final String company;
  final String role;
  final String location;
  final String salary;
  final String timeAgo;
  final List<String> tags;
  final Color accentColor;
  final bool isBookmarked;
  final VoidCallback? onTap;
  final VoidCallback? onBookmark;

  const JobCard({
    super.key,
    required this.company,
    required this.role,
    required this.location,
    required this.salary,
    this.timeAgo = '2h ago',
    this.tags = const [],
    this.accentColor = AppColors.primary,
    this.isBookmarked = false,
    this.onTap,
    this.onBookmark,
  });

  @override
  State<JobCard> createState() => _JobCardState();
}

class _JobCardState extends State<JobCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: GlassCard(
          glowColor: widget.accentColor,
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: widget.accentColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: widget.accentColor.withValues(alpha: 0.25),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        widget.company.isNotEmpty
                            ? widget.company[0]
                            : '?',
                        style: AppTypography.h3.copyWith(
                          color: widget.accentColor,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.company,
                            style: AppTypography.labelLarge),
                        const SizedBox(height: 2),
                        Text(widget.timeAgo,
                            style: AppTypography.caption),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.onBookmark,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, anim) =>
                          ScaleTransition(scale: anim, child: child),
                      child: Icon(
                        widget.isBookmarked
                            ? Icons.bookmark_rounded
                            : Icons.bookmark_outline_rounded,
                        key: ValueKey(widget.isBookmarked),
                        size: 24,
                        color: widget.isBookmarked
                            ? AppColors.primary
                            : AppColors.textTertiary,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.md),

              // Role
              Text(widget.role, style: AppTypography.h4),
              SizedBox(height: AppSpacing.sm),

              // Location + salary row
              Row(
                children: [
                  Icon(Icons.location_on_outlined,
                      size: 14, color: AppColors.textTertiary),
                  SizedBox(width: 4),
                  Text(widget.location, style: AppTypography.bodySmall),
                  const Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: 3,
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
                      widget.salary,
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.success,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.md),

              // Tags
              if (widget.tags.isNotEmpty)
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.xs,
                  children: widget.tags.map((tag) {
                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: widget.accentColor.withValues(alpha: 0.1),
                        borderRadius: AppSpacing.borderFull,
                        border: Border.all(
                          color: widget.accentColor.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Text(
                        tag,
                        style: AppTypography.labelSmall.copyWith(
                          color: widget.accentColor,
                        ),
                      ),
                    );
                  }).toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
