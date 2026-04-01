import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/router/app_router.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/widgets/animated_counter.dart';
import '../../providers/profile_provider.dart';
import '../../../auth/providers/auth_provider.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final _skills = [
    'Flutter',
    'Dart',
    'React',
    'Node.js',
    'Python',
    'Firebase',
    'AWS',
    'Docker',
    'Git',
    'CI/CD',
  ];

  final _menuItems = [
    _MenuItem('Experience', Icons.work_outline_rounded, AppColors.primary),
    _MenuItem('Education', Icons.school_rounded, AppColors.neonCyan),
    _MenuItem('Resume', Icons.description_outlined, AppColors.electricPurple),
    _MenuItem('Certificates', Icons.verified_outlined, AppColors.secondary),
    _MenuItem('Settings', Icons.settings_outlined, AppColors.textSecondary),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildStaggered({required int index, required Widget child}) {
    final delay = (index * 0.08).clamp(0.0, 0.8);
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final progress = ((_controller.value - delay) / (1 - delay))
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
    final profileAsync = ref.watch(profileProvider);
    final authUser = ref.watch(authProvider).value;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: profileAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error: $err', style: TextStyle(color: Colors.red))),
          data: (profile) => SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Column(
              children: [
              SizedBox(height: AppSpacing.lg),

              // ─── Header ───────────────────────────────────────
              _buildStaggered(
                index: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Profile', style: AppTypography.h1),
                    GlassCard(
                      padding: const EdgeInsets.all(8),
                      borderRadius: 12,
                      child: const Icon(
                        Icons.edit_outlined,
                        size: 20,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.xxl),

              // ─── Avatar + Name ────────────────────────────────
              _buildStaggered(
                index: 1,
                child: Column(
                  children: [
                    // Gradient ring avatar
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppColors.auroraGradient,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Container(
                        width: 90,
                        height: 90,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.background,
                        ),
                        child: Center(
                          child: Text(
                            authUser?.fullName.isNotEmpty == true ? authUser!.fullName[0].toUpperCase() : '?',
                            style: AppTypography.h1.copyWith(
                              color: AppColors.primary,
                              fontSize: 32,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: AppSpacing.lg),
                    Text(authUser?.fullName ?? 'User',
                        style: AppTypography.h2),
                    SizedBox(height: AppSpacing.xs),
                    Text(
                      profile.headline ?? 'Update your headline',
                      style: AppTypography.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.xxl),

              // ─── Stats Row ────────────────────────────────────
              _buildStaggered(
                index: 2,
                child: GlassCard(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.xl,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _ProfileStat(
                        label: 'Profile',
                        value: profile.profileCompletion,
                        suffix: '%',
                        color: AppColors.success,
                      ),
                      Container(
                        width: 1,
                        height: 40,
                        color: AppColors.surfaceBorder,
                      ),
                      _ProfileStat(
                        label: 'Applied',
                        value: (profile.stats['applied'] ?? 0) as int,
                        color: AppColors.primary,
                      ),
                      Container(
                        width: 1,
                        height: 40,
                        color: AppColors.surfaceBorder,
                      ),
                      _ProfileStat(
                        label: 'Interviews',
                        value: (profile.stats['interview'] ?? 0) as int,
                        color: AppColors.neonCyan,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.xxl),

              // ─── Skills ───────────────────────────────────────
              _buildStaggered(
                index: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Skills', style: AppTypography.h4),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            '+ Add',
                            style: AppTypography.labelMedium
                                .copyWith(color: AppColors.primary),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacing.md),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: _skills.map((skill) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.sm,
                          ),
                          decoration: BoxDecoration(
                            color:
                                AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: AppSpacing.borderFull,
                            border: Border.all(
                              color:
                                  AppColors.primary.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Text(
                            skill,
                            style: AppTypography.labelMedium
                                .copyWith(color: AppColors.primaryLight),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.xxl),

              // ─── Menu Items ───────────────────────────────────
              ...List.generate(_menuItems.length, (i) {
                final item = _menuItems[i];
                return _buildStaggered(
                  index: 4 + i,
                  child: Padding(
                    padding:
                        EdgeInsets.only(bottom: AppSpacing.sm),
                    child: _MenuTile(item: item),
                  ),
                );
              }),
              SizedBox(height: AppSpacing.lg),

              // ─── Logout ───────────────────────────────────────
              _buildStaggered(
                index: 9,
                child: GestureDetector(
                  onTap: () async {
                    await ref.read(authProvider.notifier).logout();
                    if (context.mounted) context.go(AppRoutes.login);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                        vertical: AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.08),
                      borderRadius: AppSpacing.borderMd,
                      border: Border.all(
                        color: AppColors.error.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.logout_rounded,
                            size: 20, color: AppColors.error),
                        SizedBox(width: AppSpacing.sm),
                        Text(
                          'Sign Out',
                          style: AppTypography.labelLarge
                              .copyWith(color: AppColors.error),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.giant),
            ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  final String label;
  final int value;
  final String? suffix;
  final Color color;

  const _ProfileStat({
    required this.label,
    required this.value,
    this.suffix,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedCounter(
          value: value,
          suffix: suffix,
          style: AppTypography.h2.copyWith(color: color),
        ),
        const SizedBox(height: 4),
        Text(label, style: AppTypography.caption),
      ],
    );
  }
}

class _MenuItem {
  final String label;
  final IconData icon;
  final Color color;

  _MenuItem(this.label, this.icon, this.color);
}

class _MenuTile extends StatefulWidget {
  final _MenuItem item;
  const _MenuTile({required this.item});

  @override
  State<_MenuTile> createState() => _MenuTileState();
}

class _MenuTileState extends State<_MenuTile> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          padding: EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.surfaceElevated,
            borderRadius: AppSpacing.borderMd,
            border: Border.all(color: AppColors.surfaceBorder),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: widget.item.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(widget.item.icon,
                    size: 20, color: widget.item.color),
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(widget.item.label,
                    style: AppTypography.labelLarge),
              ),
              const Icon(Icons.chevron_right_rounded,
                  size: 20, color: AppColors.textTertiary),
            ],
          ),
        ),
      ),
    );
  }
}
