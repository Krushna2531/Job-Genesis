import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_animations.dart';

/// Animated gradient CTA button with shimmer sweep and press scale.
class GradientButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final LinearGradient? gradient;
  final IconData? icon;
  final double height;

  const GradientButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.gradient,
    this.icon,
    this.height = 54,
  });

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final grad = widget.gradient ?? AppColors.primaryGradient;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.96 : 1.0,
        duration: AppAnimations.fast,
        curve: AppAnimations.defaultCurve,
        child: AnimatedBuilder(
          animation: _shimmerController,
          builder: (context, child) {
            return Container(
              width: double.infinity,
              height: widget.height,
              decoration: BoxDecoration(
                gradient: grad,
                borderRadius: AppSpacing.borderMd,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Shimmer sweep
                  if (!widget.isLoading)
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: AppSpacing.borderMd,
                        child: ShaderMask(
                          shaderCallback: (bounds) {
                            return LinearGradient(
                              colors: const [
                                Color(0x00FFFFFF),
                                Color(0x40FFFFFF),
                                Color(0x00FFFFFF),
                              ],
                              stops: const [0.0, 0.5, 1.0],
                              begin: Alignment(
                                -2 + 4 * _shimmerController.value,
                                0,
                              ),
                              end: Alignment(
                                -1 + 4 * _shimmerController.value,
                                0,
                              ),
                            ).createShader(bounds);
                          },
                          blendMode: BlendMode.srcATop,
                          child: Container(
                            color: Colors.white.withValues(alpha: 0.1),
                          ),
                        ),
                      ),
                    ),
                  // Content
                  Center(
                    child: widget.isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (widget.icon != null) ...[
                                Icon(widget.icon, size: 20, color: Colors.white),
                                SizedBox(width: AppSpacing.sm),
                              ],
                              Text(widget.label, style: AppTypography.buttonText),
                            ],
                          ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
