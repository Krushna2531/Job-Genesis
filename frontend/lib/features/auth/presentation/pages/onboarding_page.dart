import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/router/app_router.dart';
import '../../../../shared/widgets/gradient_button.dart';

class _OnboardingData {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color accentColor;
  final Color glowColor;

  const _OnboardingData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accentColor,
    required this.glowColor,
  });
}

final _pages = [
  _OnboardingData(
    icon: Icons.explore_rounded,
    title: 'Discover\nOpportunities',
    subtitle:
        'Real-time job crawling from 50+ platforms. Every relevant opening, in one place.',
    accentColor: AppColors.primary,
    glowColor: AppColors.primaryLight,
  ),
  _OnboardingData(
    icon: Icons.auto_awesome_rounded,
    title: 'AI-Powered\nMatching',
    subtitle:
        'Our model learns your skills and goals. You see only the jobs worth your time.',
    accentColor: AppColors.neonCyan,
    glowColor: AppColors.neonCyan,
  ),
  _OnboardingData(
    icon: Icons.psychology_rounded,
    title: 'Ace Every\nInterview',
    subtitle:
        'Mock interviews with AI feedback. Practice coding rounds live. Walk in confident.',
    accentColor: AppColors.accent,
    glowColor: AppColors.accent,
  ),
  _OnboardingData(
    icon: Icons.insights_rounded,
    title: 'Track\nEverything',
    subtitle:
        'Full application pipeline. Know exactly where you stand at every company.',
    accentColor: AppColors.secondary,
    glowColor: AppColors.secondaryLight,
  ),
];

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _entranceController;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _entranceController.dispose();
    super.dispose();
  }

  void _next() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    } else {
      context.go(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: FadeTransition(
          opacity: _entranceController,
          child: Column(
            children: [
              // ─── Skip Button ──────────────────────────────────
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.lg),
                  child: TextButton(
                    onPressed: () => context.go(AppRoutes.login),
                    child: Text(
                      'Skip',
                      style: AppTypography.labelLarge.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ),
                ),
              ),

              // ─── Page Content ─────────────────────────────────
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (i) => setState(() => _currentPage = i),
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    final page = _pages[index];
                    return _OnboardingSlide(data: page);
                  },
                ),
              ),

              // ─── Progress + Button ────────────────────────────
              Padding(
                padding: EdgeInsets.all(AppSpacing.xxl),
                child: Column(
                  children: [
                    // Animated gradient progress bar
                    _GradientProgressBar(
                      progress: (_currentPage + 1) / _pages.length,
                      color: _pages[_currentPage].accentColor,
                    ),
                    SizedBox(height: AppSpacing.xxl),

                    // CTA Button
                    GradientButton(
                      label: _currentPage == _pages.length - 1
                          ? 'Get Started'
                          : 'Continue',
                      onPressed: _next,
                      gradient: LinearGradient(
                        colors: [
                          _pages[_currentPage].accentColor,
                          _pages[_currentPage].glowColor,
                        ],
                      ),
                    ),

                    if (_currentPage == _pages.length - 1) ...[
                      SizedBox(height: AppSpacing.lg),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account? ',
                            style: AppTypography.bodyMedium,
                          ),
                          TextButton(
                            onPressed: () => context.go(AppRoutes.login),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              'Sign in',
                              style: AppTypography.labelLarge.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingSlide extends StatelessWidget {
  final _OnboardingData data;
  const _OnboardingSlide({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.xxxl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated icon container with neon glow
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 600),
            curve: Curves.elasticOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: child,
              );
            },
            child: Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    data.accentColor.withValues(alpha: 0.2),
                    data.accentColor.withValues(alpha: 0.05),
                    Colors.transparent,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: data.accentColor.withValues(alpha: 0.3),
                    blurRadius: 50,
                    spreadRadius: 15,
                  ),
                ],
              ),
              child: Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: data.accentColor.withValues(alpha: 0.15),
                    border: Border.all(
                      color: data.accentColor.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    data.icon,
                    size: 36,
                    color: data.accentColor,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: AppSpacing.xxxl),
          Text(
            data.title,
            style: AppTypography.displayMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSpacing.lg),
          Text(
            data.subtitle,
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _GradientProgressBar extends StatelessWidget {
  final double progress;
  final Color color;

  const _GradientProgressBar({
    required this.progress,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 4,
      decoration: BoxDecoration(
        color: AppColors.surfaceBorder,
        borderRadius: AppSpacing.borderFull,
      ),
      child: AnimatedFractionallySizedBox(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
        alignment: Alignment.centerLeft,
        widthFactor: progress,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color, color.withValues(alpha: 0.6)],
            ),
            borderRadius: AppSpacing.borderFull,
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.5),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
