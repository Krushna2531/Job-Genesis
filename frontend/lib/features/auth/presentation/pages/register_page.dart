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

enum UserRole { candidate, recruiter }

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  UserRole _selectedRole = UserRole.candidate;
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
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _animController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      // Send request backend using Auth Provider
      await ref.read(authProvider.notifier).register(
            _nameController.text.trim(),
            _emailController.text.trim(),
            _passwordController.text,
            _selectedRole == UserRole.candidate ? 'candidate' : 'recruiter',
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

  double _passwordStrength(String password) {
    if (password.isEmpty) return 0;
    double strength = 0;
    if (password.length >= 8) strength += 0.25;
    if (password.contains(RegExp(r'[A-Z]'))) strength += 0.25;
    if (password.contains(RegExp(r'[0-9]'))) strength += 0.25;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength += 0.25;
    return strength;
  }

  Color _strengthColor(double strength) {
    if (strength <= 0.25) return AppColors.error;
    if (strength <= 0.5) return AppColors.warning;
    if (strength <= 0.75) return AppColors.info;
    return AppColors.success;
  }

  String _strengthLabel(double strength) {
    if (strength <= 0.25) return 'Weak';
    if (strength <= 0.5) return 'Fair';
    if (strength <= 0.75) return 'Good';
    return 'Strong';
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
    final strength = _passwordStrength(_passwordController.text);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: ParticleBackground(
        particleCount: 12,
        child: SafeArea(
          child: Column(
            children: [
              // ─── App Bar ──────────────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceElevated,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.surfaceBorder),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 16,
                        ),
                      ),
                      onPressed: () => context.go(AppRoutes.login),
                    ),
                  ],
                ),
              ),

              // ─── Content ──────────────────────────────────────
              Expanded(
                child: SingleChildScrollView(
                  padding: AppSpacing.screenPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStaggered(
                        index: 0,
                        child: Text('Create Account',
                            style: AppTypography.h1),
                      ),
                      SizedBox(height: AppSpacing.sm),
                      _buildStaggered(
                        index: 1,
                        child: Text(
                          'Join thousands of professionals on JobGenesis',
                          style: AppTypography.bodyLarge
                              .copyWith(color: AppColors.textSecondary),
                        ),
                      ),
                      SizedBox(height: AppSpacing.xxl),

                      // ─── Role Selector ────────────────────────
                      _buildStaggered(
                        index: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('I am a...',
                                style: AppTypography.labelLarge),
                            SizedBox(height: AppSpacing.md),
                            Row(
                              children: [
                                Expanded(
                                  child: _RoleCard(
                                    label: 'Candidate',
                                    icon: Icons.person_outline_rounded,
                                    isSelected:
                                        _selectedRole == UserRole.candidate,
                                    accentColor: AppColors.primary,
                                    onTap: () => setState(() =>
                                        _selectedRole = UserRole.candidate),
                                  ),
                                ),
                                SizedBox(width: AppSpacing.md),
                                Expanded(
                                  child: _RoleCard(
                                    label: 'Recruiter',
                                    icon: Icons.business_outlined,
                                    isSelected:
                                        _selectedRole == UserRole.recruiter,
                                    accentColor: AppColors.neonCyan,
                                    onTap: () => setState(() =>
                                        _selectedRole = UserRole.recruiter),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: AppSpacing.xxl),

                      // ─── Glass Form ───────────────────────────
                      _buildStaggered(
                        index: 3,
                        child: ClipRRect(
                          borderRadius: AppSpacing.borderLg,
                          child: BackdropFilter(
                            filter:
                                ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              padding:
                                  EdgeInsets.all(AppSpacing.xl),
                              decoration: BoxDecoration(
                                gradient: AppColors.glassGradient,
                                borderRadius: AppSpacing.borderLg,
                                border: Border.all(
                                    color: AppColors.glassBorder),
                              ),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    TextFormField(
                                      controller: _nameController,
                                      style: AppTypography.bodyLarge,
                                      decoration: const InputDecoration(
                                        labelText: 'Full Name',
                                        hintText: 'John Doe',
                                        prefixIcon: Icon(
                                            Icons.person_outline),
                                      ),
                                      validator: (v) =>
                                          v != null && v.length >= 2
                                              ? null
                                              : 'Enter your name',
                                    ),
                                    SizedBox(height: AppSpacing.lg),
                                    TextFormField(
                                      controller: _emailController,
                                      keyboardType:
                                          TextInputType.emailAddress,
                                      style: AppTypography.bodyLarge,
                                      decoration: const InputDecoration(
                                        labelText: 'Email',
                                        hintText: 'you@example.com',
                                        prefixIcon:
                                            Icon(Icons.email_outlined),
                                      ),
                                      validator: (v) =>
                                          v != null && v.contains('@')
                                              ? null
                                              : 'Enter a valid email',
                                    ),
                                    SizedBox(height: AppSpacing.lg),
                                    TextFormField(
                                      controller: _passwordController,
                                      obscureText: _obscurePassword,
                                      style: AppTypography.bodyLarge,
                                      onChanged: (_) => setState(() {}),
                                      decoration: InputDecoration(
                                        labelText: 'Password',
                                        hintText: '••••••••',
                                        prefixIcon: const Icon(
                                            Icons.lock_outline),
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _obscurePassword
                                                ? Icons
                                                    .visibility_outlined
                                                : Icons
                                                    .visibility_off_outlined,
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

                                    // Password strength bar
                                    if (_passwordController
                                        .text.isNotEmpty) ...[
                                      SizedBox(
                                          height: AppSpacing.md),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: AnimatedContainer(
                                              duration: const Duration(
                                                  milliseconds: 300),
                                              height: 3,
                                              decoration: BoxDecoration(
                                                borderRadius: AppSpacing
                                                    .borderFull,
                                                color: AppColors
                                                    .surfaceBorder,
                                              ),
                                              child:
                                                  FractionallySizedBox(
                                                alignment:
                                                    Alignment.centerLeft,
                                                widthFactor: strength,
                                                child: Container(
                                                  decoration:
                                                      BoxDecoration(
                                                    borderRadius:
                                                        AppSpacing
                                                            .borderFull,
                                                    gradient:
                                                        LinearGradient(
                                                      colors: [
                                                        _strengthColor(
                                                            strength),
                                                        _strengthColor(
                                                                strength)
                                                            .withValues(
                                                                alpha:
                                                                    0.6),
                                                      ],
                                                    ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: _strengthColor(
                                                                strength)
                                                            .withValues(
                                                                alpha:
                                                                    0.4),
                                                        blurRadius: 6,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                              width: AppSpacing.sm),
                                          Text(
                                            _strengthLabel(strength),
                                            style: AppTypography
                                                .labelSmall
                                                .copyWith(
                                              color: _strengthColor(
                                                  strength),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],

                                    SizedBox(
                                        height: AppSpacing.xxl),
                                    GradientButton(
                                      label: 'Create Account',
                                      isLoading: _isLoading,
                                      onPressed:
                                          _isLoading ? null : _register,
                                      icon:
                                          Icons.rocket_launch_rounded,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: AppSpacing.xxl),
                      _buildStaggered(
                        index: 4,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account? ',
                              style: AppTypography.bodyMedium,
                            ),
                            TextButton(
                              onPressed: () =>
                                  context.go(AppRoutes.login),
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                tapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                'Sign in',
                                style: AppTypography.labelLarge
                                    .copyWith(color: AppColors.primary),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: AppSpacing.xxxl),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatefulWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final Color accentColor;
  final VoidCallback onTap;

  const _RoleCard({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.accentColor,
    required this.onTap,
  });

  @override
  State<_RoleCard> createState() => _RoleCardState();
}

class _RoleCardState extends State<_RoleCard> {
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
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
          decoration: BoxDecoration(
            gradient: widget.isSelected
                ? LinearGradient(
                    colors: [
                      widget.accentColor.withValues(alpha: 0.15),
                      widget.accentColor.withValues(alpha: 0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: widget.isSelected ? null : AppColors.surfaceElevated,
            borderRadius: AppSpacing.borderLg,
            border: Border.all(
              color: widget.isSelected
                  ? widget.accentColor
                  : AppColors.surfaceBorder,
              width: widget.isSelected ? 1.5 : 1,
            ),
            boxShadow: widget.isSelected
                ? [
                    BoxShadow(
                      color: widget.accentColor.withValues(alpha: 0.2),
                      blurRadius: 20,
                      spreadRadius: -2,
                    ),
                  ]
                : null,
          ),
          child: Column(
            children: [
              Icon(
                widget.icon,
                size: 32,
                color: widget.isSelected
                    ? widget.accentColor
                    : AppColors.textSecondary,
              ),
              SizedBox(height: AppSpacing.sm),
              Text(
                widget.label,
                style: AppTypography.labelLarge.copyWith(
                  color: widget.isSelected
                      ? widget.accentColor
                      : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
