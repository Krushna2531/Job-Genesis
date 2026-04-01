import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/responsive.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/widgets/animated_counter.dart';

class _TrackerJob {
  final String company;
  final String role;
  final String date;
  final Color statusColor;

  const _TrackerJob({
    required this.company,
    required this.role,
    required this.date,
    required this.statusColor,
  });
}

class TrackerPage extends StatefulWidget {
  const TrackerPage({super.key});

  @override
  State<TrackerPage> createState() => _TrackerPageState();
}

class _TrackerPageState extends State<TrackerPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _selectedTab = 0;

  final _tabs = [
    'All',
    'Applied',
    'Screening',
    'Interview',
    'Offer',
    'Rejected'
  ];

  final Map<String, List<_TrackerJob>> _jobsByStatus = {
    'Applied': [
      _TrackerJob(
          company: 'Google',
          role: 'Flutter Dev',
          date: 'Mar 28',
          statusColor: AppColors.statusApplied),
      _TrackerJob(
          company: 'Netflix',
          role: 'iOS Engineer',
          date: 'Mar 26',
          statusColor: AppColors.statusApplied),
      _TrackerJob(
          company: 'Vercel',
          role: 'Frontend',
          date: 'Mar 25',
          statusColor: AppColors.statusApplied),
    ],
    'Screening': [
      _TrackerJob(
          company: 'Stripe',
          role: 'Full Stack',
          date: 'Mar 22',
          statusColor: AppColors.statusScreening),
      _TrackerJob(
          company: 'OpenAI',
          role: 'ML Engineer',
          date: 'Mar 20',
          statusColor: AppColors.statusScreening),
    ],
    'Interview': [
      _TrackerJob(
          company: 'Meta',
          role: 'Mobile Eng',
          date: 'Mar 18',
          statusColor: AppColors.statusInterview),
      _TrackerJob(
          company: 'Apple',
          role: 'Swift Dev',
          date: 'Mar 15',
          statusColor: AppColors.statusInterview),
    ],
    'Offer': [
      _TrackerJob(
          company: 'Figma',
          role: 'Designer',
          date: 'Mar 10',
          statusColor: AppColors.statusOffer),
    ],
    'Rejected': [
      _TrackerJob(
          company: 'Amazon',
          role: 'SDE II',
          date: 'Mar 8',
          statusColor: AppColors.statusRejected),
    ],
  };

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<_TrackerJob> get _filteredJobs {
    if (_selectedTab == 0) {
      return _jobsByStatus.values.expand((e) => e).toList();
    }
    return _jobsByStatus[_tabs[_selectedTab]] ?? [];
  }

  Widget _buildStaggered({required int index, required Widget child}) {
    final delay = (index * 0.1).clamp(0.0, 0.8);
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
    final allJobs = _jobsByStatus.values.expand((e) => e).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ResponsiveCenter(
          maxWidth: 800,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                    AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStaggered(
                        index: 0,
                        child: Text('Tracker', style: AppTypography.h1)),
                    SizedBox(height: AppSpacing.sm),
                    _buildStaggered(
                      index: 1,
                      child: Text(
                        '${allJobs.length} applications tracked',
                        style: AppTypography.bodyMedium,
                      ),
                    ),
                    SizedBox(height: AppSpacing.xxl),

                    // Summary stats
                    _buildStaggered(
                      index: 2,
                      child: Row(
                        children: [
                          _StatBadge(
                            label: 'Applied',
                            value: _jobsByStatus['Applied']?.length ?? 0,
                            color: AppColors.statusApplied,
                          ),
                          SizedBox(width: AppSpacing.sm),
                          _StatBadge(
                            label: 'Screening',
                            value:
                                _jobsByStatus['Screening']?.length ?? 0,
                            color: AppColors.statusScreening,
                          ),
                          SizedBox(width: AppSpacing.sm),
                          _StatBadge(
                            label: 'Interview',
                            value:
                                _jobsByStatus['Interview']?.length ?? 0,
                            color: AppColors.statusInterview,
                          ),
                          SizedBox(width: AppSpacing.sm),
                          _StatBadge(
                            label: 'Offer',
                            value: _jobsByStatus['Offer']?.length ?? 0,
                            color: AppColors.statusOffer,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppSpacing.lg),

                    // Tabs
                    _buildStaggered(
                      index: 3,
                      child: SizedBox(
                        height: 38,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: _tabs.length,
                          separatorBuilder: (context, index) =>
                              SizedBox(width: AppSpacing.sm),
                          itemBuilder: (context, i) {
                            final isActive = i == _selectedTab;
                            return GestureDetector(
                              onTap: () =>
                                  setState(() => _selectedTab = i),
                              child: AnimatedContainer(
                                duration:
                                    const Duration(milliseconds: 250),
                                padding: EdgeInsets.symmetric(
                                    horizontal: AppSpacing.lg,
                                    vertical: AppSpacing.sm),
                                decoration: BoxDecoration(
                                  gradient: isActive
                                      ? AppColors.primaryGradient
                                      : null,
                                  color: isActive
                                      ? null
                                      : AppColors.surfaceElevated,
                                  borderRadius: AppSpacing.borderFull,
                                  border: isActive
                                      ? null
                                      : Border.all(
                                          color:
                                              AppColors.surfaceBorder),
                                ),
                                child: Center(
                                  child: Text(
                                    _tabs[i],
                                    style: AppTypography.labelMedium
                                        .copyWith(
                                      color: isActive
                                          ? Colors.white
                                          : AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.lg),

              // Job list
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
                  itemCount: _filteredJobs.length,
                  separatorBuilder: (context, index) =>
                      SizedBox(height: AppSpacing.md),
                  itemBuilder: (context, i) {
                    final job = _filteredJobs[i];
                    return _TrackerCard(job: job);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const _StatBadge({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: AppSpacing.borderMd,
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            AnimatedCounter(
              value: value,
              style: AppTypography.h3.copyWith(color: color),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: AppTypography.caption.copyWith(fontSize: 9),
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}

class _TrackerCard extends StatelessWidget {
  final _TrackerJob job;
  const _TrackerCard({required this.job});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      glowColor: job.statusColor,
      padding: EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: job.statusColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(13),
              border: Border.all(
                color: job.statusColor.withValues(alpha: 0.25),
              ),
            ),
            child: Center(
              child: Text(
                job.company[0],
                style:
                    AppTypography.h4.copyWith(color: job.statusColor),
              ),
            ),
          ),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(job.role, style: AppTypography.labelLarge),
                const SizedBox(height: 2),
                Text(
                  '${job.company} • ${job.date}',
                  style: AppTypography.bodySmall,
                ),
              ],
            ),
          ),
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: job.statusColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: job.statusColor.withValues(alpha: 0.5),
                  blurRadius: 8,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
