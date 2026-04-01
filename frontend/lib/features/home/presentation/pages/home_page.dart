import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/responsive.dart';
import '../../../../core/router/app_router.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../auth/providers/auth_provider.dart';
import '../../../profile/providers/candidate_profile_provider.dart';
import '../../../jobs/providers/recommended_jobs_provider.dart';
import '../../../jobs/providers/applications_provider.dart';
import '../widgets/home_stats_card.dart';
import '../widgets/job_match_gauge.dart';
import '../widgets/featured_job_card.dart';
import '../widgets/activity_timeline.dart';
import '../widgets/quick_action_tile.dart';
import 'package:timeago/timeago.dart' as timeago;

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildStaggered({required int index, required Widget child}) {
    final delay = index * 0.08;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final progress = ((_controller.value - delay) / (1 - delay))
            .clamp(0.0, 1.0);
        final curved = Curves.easeOutCubic.transform(progress);
        return Opacity(
          opacity: curved,
          child: Transform.translate(
            offset: Offset(0, 24 * (1 - curved)),
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    final isTablet = Responsive.isTablet(context);
    final isMobile = Responsive.isMobile(context);

    // Riverpod Data Streams
    final authState = ref.watch(authProvider);
    final user = authState.value;
    final initials = user?.fullName.split(' ').take(2).map((e) => e.isNotEmpty ? e[0] : '').join('').toUpperCase() ?? 'U';
    final firstName = user?.fullName.split(' ').first ?? 'User';

    final profileAsync = ref.watch(candidateProfileProvider);
    final recJobsAsync = ref.watch(recommendedJobsProvider);
    final appsAsync = ref.watch(applicationsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: ResponsiveCenter(
            maxWidth: 800,
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? AppSpacing.xxl : AppSpacing.lg,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: AppSpacing.lg),

                // ─── Header ────────────────────────────────────
                _buildStaggered(
                  index: 0,
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.3),
                              blurRadius: 12,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            initials,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Good evening 👋',
                                style: AppTypography.bodyMedium),
                            Text(firstName, style: AppTypography.h3),
                          ],
                        ),
                      ),
                      GlassCard(
                        padding: const EdgeInsets.all(10),
                        borderRadius: 14,
                        child: Stack(
                          children: [
                            const Icon(Icons.notifications_outlined,
                                size: 22, color: AppColors.textPrimary),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: AppColors.accent,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.accent
                                          .withValues(alpha: 0.5),
                                      blurRadius: 6,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppSpacing.xxl),

                // ─── Stats Row ─────────────────────────────────
                _buildStaggered(
                  index: 1,
                  child: profileAsync.when(
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (err, stack) => Text('Could not load stats', style: AppTypography.bodySmall.copyWith(color: AppColors.error)),
                    data: (profile) {
                      final applied = profile.stats['applied'] ?? 0;
                      final interview = profile.stats['interview'] ?? 0;
                      final offered = profile.stats['offered'] ?? 0;
                      
                      return LayoutBuilder(
                        builder: (context, constraints) {
                          return Row(
                            children: [
                              Expanded(
                                child: HomeStatsCard(
                                  label: 'Applied',
                                  value: applied,
                                  icon: Icons.send_rounded,
                                  color: AppColors.primary,
                                ),
                              ),
                              SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: HomeStatsCard(
                                  label: 'Interviews',
                                  value: interview,
                                  icon: Icons.mic_rounded,
                                  color: AppColors.neonCyan,
                                ),
                              ),
                              SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: HomeStatsCard(
                                  label: 'Offers',
                                  value: offered,
                                  icon: Icons.star_rounded,
                                  color: AppColors.success,
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  ),
                ),
                SizedBox(height: AppSpacing.xxl),

                // ─── Match Score ───────────────────────────────
                _buildStaggered(
                  index: 2,
                  child: profileAsync.when(
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                    data: (profile) {
                      // We'll use profileCompletion for this demo if a matchPercent isn't available
                      final score = profile.profileCompletion / 100.0;
                      return GlassCard(
                        padding: EdgeInsets.all(AppSpacing.xl),
                        child: isMobile
                            ? Column(
                                children: [
                                  JobMatchGauge(matchPercent: score),
                                  SizedBox(height: AppSpacing.lg),
                                  _matchDescription(score),
                                ],
                              )
                            : Row(
                                children: [
                                  JobMatchGauge(matchPercent: score),
                                  SizedBox(width: AppSpacing.xl),
                                  Expanded(child: _matchDescription(score)),
                                ],
                              ),
                      );
                    }
                  )
                ),
                SizedBox(height: AppSpacing.xxl),

                // ─── Featured Jobs ─────────────────────────────
                _buildStaggered(
                  index: 3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Recommended Jobs', style: AppTypography.h3),
                      TextButton(
                        onPressed: () => context.go(AppRoutes.jobFeed),
                        child: Text(
                          'See All',
                          style: AppTypography.labelMedium.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppSpacing.md),
                _buildStaggered(
                  index: 4,
                  child: SizedBox(
                    height: 240,
                    child: recJobsAsync.when(
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (err, _) => Center(child: Text('Error loading recommendations', style: AppTypography.bodySmall)),
                      data: (jobs) {
                        if (jobs.isEmpty) {
                          return Center(
                            child: Text('No recommendations yet.', style: AppTypography.bodyMedium),
                          );
                        }
                        
                        // Map our list of colors dynamically
                        final brandColors = [AppColors.primary, AppColors.neonCyan, AppColors.electricPurple, AppColors.success, AppColors.accent];

                        return ListView.separated(
                          scrollDirection: Axis.horizontal,
                          clipBehavior: Clip.none,
                          itemCount: jobs.length < 5 ? jobs.length : 5,
                          separatorBuilder: (_, __) => SizedBox(width: AppSpacing.md),
                          itemBuilder: (context, index) {
                            final job = jobs[index];
                            final color = brandColors[index % brandColors.length];
                            
                            return FeaturedJobCard(
                              company: job.company,
                              role: job.title,
                              location: job.location ?? 'Remote',
                              salary: job.displaySalary,
                              tags: job.requiredSkills.take(3).toList(),
                              accentColor: color,
                              onTap: () {
                                // Can navigate to job detail here
                              },
                            );
                          },
                        );
                      }
                    ),
                  ),
                ),
                SizedBox(height: AppSpacing.xxl),

                // ─── Quick Actions ─────────────────────────────
                _buildStaggered(
                  index: 5,
                  child: Text('Quick Actions', style: AppTypography.h3),
                ),
                SizedBox(height: AppSpacing.md),
                _buildStaggered(
                  index: 6,
                  child: GridView.count(
                    crossAxisCount: (isDesktop || isTablet) ? 4 : 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: AppSpacing.md,
                    crossAxisSpacing: AppSpacing.md,
                    childAspectRatio: isMobile ? 1.3 : 1.5,
                    children: [
                       QuickActionTile(
                        label: 'Search Jobs',
                        icon: Icons.search_rounded,
                        color: AppColors.primary,
                        onTap: () => context.go(AppRoutes.search),
                      ),
                      QuickActionTile(
                        label: 'Tracker',
                        icon: Icons.track_changes_rounded,
                        color: AppColors.neonCyan,
                        onTap: () => context.go(AppRoutes.tracker),
                      ),
                      QuickActionTile(
                        label: 'Interview',
                        icon: Icons.psychology_rounded,
                        color: AppColors.accent,
                        onTap: () => context.go(AppRoutes.mockInterview),
                      ),
                      QuickActionTile(
                        label: 'Profile',
                        icon: Icons.person_rounded,
                        color: AppColors.secondary,
                        onTap: () => context.go(AppRoutes.profile),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppSpacing.xxl),

                // ─── Recent Activity ───────────────────────────
                _buildStaggered(
                  index: 7,
                  child: Text('Recent Activity', style: AppTypography.h3),
                ),
                SizedBox(height: AppSpacing.lg),
                _buildStaggered(
                  index: 8,
                  child: appsAsync.when(
                    loading: () => const Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()),
                    error: (err, _) => Text('Could not load activity', style: AppTypography.bodySmall),
                    data: (apps) {
                       if (apps.isEmpty) {
                         return Text('No recent activity.', style: AppTypography.bodyMedium);
                       }
                       
                       // Map the Application models from API into ActivityItem UI elements
                       final items = apps.take(5).map((app) {
                         Color color = AppColors.primary;
                         IconData icon = Icons.send_rounded;
                         String title = 'Applied';
                         
                         if (app.status == 'interview') {
                           color = AppColors.neonCyan;
                           icon = Icons.mic_rounded;
                           title = 'Interviewing';
                         } else if (app.status == 'offered') {
                           color = AppColors.success;
                           icon = Icons.star_rounded;
                           title = 'Offer Received';
                         } else if (app.status == 'rejected') {
                           color = AppColors.error;
                           icon = Icons.cancel_rounded;
                           title = 'Application Rejected';
                         }
                         
                         return ActivityItem(
                           title: '$title — ${app.company}',
                           subtitle: app.title,
                           time: timeago.format(DateTime.parse(app.appliedAt)),
                           icon: icon,
                           color: color,
                         );
                       }).toList();
                       
                       return ActivityTimeline(items: items);
                    }
                  )
                ),
                SizedBox(height: AppSpacing.giant),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _matchDescription(double profileCompletion) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShaderMask(
          shaderCallback: (bounds) =>
              AppColors.neonGradient.createShader(bounds),
          child: Text(
            'Profile Strength',
            style: AppTypography.h4.copyWith(color: Colors.white),
          ),
        ),
        SizedBox(height: AppSpacing.sm),
        Text(
          'Your profile is ${(profileCompletion * 100).toInt()}% complete. Add more details to improve job matches.',
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: AppSpacing.md),
        GestureDetector(
          onTap: () => context.go(AppRoutes.profile),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              borderRadius: AppSpacing.borderFull,
            ),
            child: Text(
              'Improve →',
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}