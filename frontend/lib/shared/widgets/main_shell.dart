import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/responsive.dart';
import '../../core/router/app_router.dart';
import '../../features/auth/providers/auth_provider.dart';

/// Adaptive shell — side rail on desktop, floating bottom nav on mobile.
class MainShell extends StatelessWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  int _locationToIndex(String location) {
    if (location.startsWith(AppRoutes.jobFeed)) return 1;
    if (location.startsWith(AppRoutes.tracker)) return 2;
    if (location.startsWith(AppRoutes.mockInterview)) return 3;
    if (location.startsWith(AppRoutes.profile)) return 4;
    return 0;
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(AppRoutes.home);
        break;
      case 1:
        context.go(AppRoutes.jobFeed);
        break;
      case 2:
        context.go(AppRoutes.tracker);
        break;
      case 3:
        context.go(AppRoutes.mockInterview);
        break;
      case 4:
        context.go(AppRoutes.profile);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final currentIndex = _locationToIndex(location);
    final isDesktop = Responsive.isDesktop(context);

    if (isDesktop) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Row(
          children: [
            // Side rail
            _DesktopSideRail(
              currentIndex: currentIndex,
              onTap: (i) => _onTap(context, i),
            ),
            // Divider
            Container(
              width: 1,
              color: AppColors.surfaceBorder,
            ),
            // Main content
            Expanded(child: child),
          ],
        ),
      );
    }

    // Mobile / Tablet — floating bottom nav
    return Scaffold(
      body: child,
      extendBody: true,
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: ClipRRect(
          borderRadius: AppSpacing.borderXl,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: AppColors.surface.withValues(alpha: 0.85),
                borderRadius: AppSpacing.borderXl,
                border: Border.all(
                  color: AppColors.glassBorder,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(5, (i) {
                  final data = _navItems[i];
                  return _NavItem(
                    icon: data.icon,
                    activeIcon: data.activeIcon,
                    label: data.label,
                    isActive: i == currentIndex,
                    onTap: () => _onTap(context, i),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Desktop Side Rail ──────────────────────────────────────────

class _DesktopSideRail extends ConsumerWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _DesktopSideRail({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider).value;
    return Container(
      width: 220,
      color: AppColors.surface,
      child: Column(
        children: [
          SizedBox(height: AppSpacing.xxl),
          // Logo
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'JG',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: AppSpacing.md),
                ShaderMask(
                  shaderCallback: (bounds) =>
                      AppColors.neonGradient.createShader(bounds),
                  child: Text(
                    'JobGenesis',
                    style: AppTypography.h4.copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.xxxl),
          // Nav items
          ...List.generate(5, (i) {
            final data = _navItems[i];
            final isActive = i == currentIndex;
            return _SideNavItem(
              icon: isActive ? data.activeIcon : data.icon,
              label: data.label,
              isActive: isActive,
              onTap: () => onTap(i),
            );
          }),
          const Spacer(),
          // Bottom section
          Padding(
            padding: EdgeInsets.all(AppSpacing.lg),
            child: Container(
              padding: EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: AppSpacing.borderMd,
                border: Border.all(color: AppColors.surfaceBorder),
              ),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(authState?.fullName.isNotEmpty == true ? authState!.fullName[0].toUpperCase() : 'JG',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          )),
                    ),
                  ),
                  SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(authState?.fullName ?? 'Guest',
                            style: AppTypography.labelMedium
                                .copyWith(color: AppColors.textPrimary)),
                        Text(authState?.role.toUpperCase() ?? 'GUEST',
                            style: AppTypography.caption
                                .copyWith(color: AppColors.neonCyan)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: AppSpacing.sm),
        ],
      ),
    );
  }
}

class _SideNavItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _SideNavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_SideNavItem> createState() => _SideNavItemState();
}

class _SideNavItemState extends State<_SideNavItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: 2,
      ),
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
            decoration: BoxDecoration(
              color: widget.isActive
                  ? AppColors.primary.withValues(alpha: 0.12)
                  : _hovered
                      ? AppColors.surfaceHover
                      : Colors.transparent,
              borderRadius: AppSpacing.borderMd,
              border: widget.isActive
                  ? Border.all(
                      color: AppColors.primary.withValues(alpha: 0.25))
                  : null,
            ),
            child: Row(
              children: [
                // Active indicator
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 3,
                  height: widget.isActive ? 20 : 0,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: AppSpacing.borderFull,
                    boxShadow: widget.isActive
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.5),
                              blurRadius: 6,
                            ),
                          ]
                        : null,
                  ),
                ),
                SizedBox(width: widget.isActive ? AppSpacing.md : AppSpacing.sm),
                Icon(
                  widget.icon,
                  size: 20,
                  color: widget.isActive
                      ? AppColors.primary
                      : _hovered
                          ? AppColors.textPrimary
                          : AppColors.textTertiary,
                ),
                SizedBox(width: AppSpacing.md),
                Text(
                  widget.label,
                  style: AppTypography.labelMedium.copyWith(
                    color: widget.isActive
                        ? AppColors.primary
                        : _hovered
                            ? AppColors.textPrimary
                            : AppColors.textSecondary,
                    fontWeight:
                        widget.isActive ? FontWeight.w600 : FontWeight.w400,
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

// ─── Shared Nav Data ────────────────────────────────────────────

class _NavData {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _NavData(this.icon, this.activeIcon, this.label);
}

const _navItems = [
  _NavData(Icons.home_outlined, Icons.home_rounded, 'Home'),
  _NavData(Icons.work_outline_rounded, Icons.work_rounded, 'Jobs'),
  _NavData(
      Icons.track_changes_outlined, Icons.track_changes_rounded, 'Tracker'),
  _NavData(Icons.mic_none_rounded, Icons.mic_rounded, 'Interview'),
  _NavData(Icons.person_outline_rounded, Icons.person_rounded, 'Profile'),
];

// ─── Mobile Bottom Nav Item ─────────────────────────────────────

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 60,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              width: isActive ? 24 : 0,
              height: 3,
              decoration: BoxDecoration(
                gradient: isActive ? AppColors.primaryGradient : null,
                borderRadius: AppSpacing.borderFull,
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.5),
                          blurRadius: 8,
                        ),
                      ]
                    : null,
              ),
            ),
            const SizedBox(height: 6),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, anim) =>
                  ScaleTransition(scale: anim, child: child),
              child: Icon(
                isActive ? activeIcon : icon,
                key: ValueKey(isActive),
                size: 24,
                color: isActive ? AppColors.primary : AppColors.textTertiary,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive ? AppColors.primary : AppColors.textTertiary,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}
