import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/router/app_router.dart';
import '../../../../shared/widgets/gradient_button.dart';
import '../../../../shared/widgets/particle_background.dart';

import '../../providers/auth_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      // Attempt the real backend login call
      await ref.read(authProvider.notifier).login(
        _emailController.text.trim(),
        _passwordController.text,
      );
      if (mounted) context.go(AppRoutes.home);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _buildStaggered({required int index, required Widget child}) {
    final delay = index * 0.1;
    return AnimatedBuilder(
      animation: _animController,
      builder: (context, _) {
        final progress = ((_animController.value - delay) / (1 - delay))
            .clamp(0.0, 1.0);
        final curved = Curves.easeOutCubic.transform(progress);
        return Opacity(
          opacity: curved,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - curved)),
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: ParticleBackground(
        particleCount: 15,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: AppSpacing.screenPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: AppSpacing.xxxl),

                // ─── Logo ───────────────────────────────────────
                _buildStaggered(
                  index: 0,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.4),
                          blurRadius: 24,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'JG',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: AppSpacing.xxl),

                // ─── Header ─────────────────────────────────────
                _buildStaggered(
                  index: 1,
                  child: Text('Welcome back', style: AppTypography.h1),
                ),
                SizedBox(height: AppSpacing.sm),
                _buildStaggered(
                  index: 2,
                  child: Text(
                    'Sign in to continue your job search',
                    style: AppTypography.bodyLarge.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                SizedBox(height: AppSpacing.xxxl),

                // ─── Glass Form Card ────────────────────────────
                _buildStaggered(
                  index: 3,
                  child: ClipRRect(
                    borderRadius: AppSpacing.borderLg,
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: EdgeInsets.all(AppSpacing.xl),
                        decoration: BoxDecoration(
                          gradient: AppColors.glassGradient,
                          borderRadius: AppSpacing.borderLg,
                          border: Border.all(
                            color: AppColors.glassBorder,
                          ),
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              // Email
                              TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                style: AppTypography.bodyLarge,
                                decoration: const InputDecoration(
                                  labelText: 'Email',
                                  hintText: 'you@example.com',
                                  prefixIcon: Icon(Icons.email_outlined),
                                ),
                                validator: (v) =>
                                    v != null && v.contains('@')
                                        ? null
                                        : 'Enter a valid email',
                              ),
                              SizedBox(height: AppSpacing.lg),

                              // Password
                              TextFormField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                style: AppTypography.bodyLarge,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  hintText: '••••••••',
                                  prefixIcon:
                                      const Icon(Icons.lock_outline),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                    ),
                                    onPressed: () => setState(() =>
                                        _obscurePassword =
                                            !_obscurePassword),
                                  ),
                                ),
                                validator: (v) =>
                                    v != null && v.length >= 8
                                        ? null
                                        : 'Minimum 8 characters',
                              ),

                              // Forgot password
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    'Forgot password?',
                                    style: AppTypography.labelMedium
                                        .copyWith(
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: AppSpacing.md),

                              // Login Button
                              GradientButton(
                                label: 'Sign In',
                                isLoading: _isLoading,
                                onPressed: _isLoading ? null : _login,
                                icon: Icons.arrow_forward_rounded,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: AppSpacing.xxl),

                // ─── Divider ────────────────────────────────────
                _buildStaggered(
                  index: 4,
                  child: Row(
                    children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: AppSpacing.lg),
                        child: Text('or', style: AppTypography.labelMedium),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),
                ),
                SizedBox(height: AppSpacing.xxl),

                // ─── Social Buttons ─────────────────────────────
                _buildStaggered(
                  index: 5,
                  child: _SocialButton(
                    label: 'Continue with Google',
                    icon: Icons.g_mobiledata_rounded,
                    onTap: () {},
                  ),
                ),
                SizedBox(height: AppSpacing.md),
                _buildStaggered(
                  index: 6,
                  child: _SocialButton(
                    label: 'Continue with LinkedIn',
                    icon: Icons.business_center_outlined,
                    onTap: () {},
                  ),
                ),

                SizedBox(height: AppSpacing.xxxl),

                // ─── Register Link ──────────────────────────────
                _buildStaggered(
                  index: 7,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: AppTypography.bodyMedium,
                      ),
                      TextButton(
                        onPressed: () => context.go(AppRoutes.register),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Create one',
                          style: AppTypography.labelLarge.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SocialButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _SocialButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  State<_SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<_SocialButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.surfaceElevated,
            borderRadius: AppSpacing.borderMd,
            border: Border.all(color: AppColors.surfaceBorder),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.icon, size: 22, color: AppColors.textSecondary),
              SizedBox(width: AppSpacing.md),
              Text(widget.label, style: AppTypography.labelLarge),
            ],
          ),
        ),
      ),
    );
  }
}
