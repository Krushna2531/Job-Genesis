import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/job_model.dart';
import '../../providers/jobs_provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/responsive.dart';
import '../widgets/job_card.dart';

class JobFeedPage extends ConsumerStatefulWidget {
  const JobFeedPage({super.key});

  @override
  ConsumerState<JobFeedPage> createState() => _JobFeedPageState();
}

class _JobFeedPageState extends ConsumerState<JobFeedPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  String _selectedFilter = 'All';
  final _searchController = TextEditingController();
  final _searchFocus = FocusNode();

  final _filters = [
    'All',
    'Remote',
    'Full-time',
    'Tech',
    'Design',
    'Finance'
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
    _searchController.dispose();
    _searchFocus.dispose();
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
    final jobsAsync = ref.watch(jobsProvider);
    final isDesktop = Responsive.isDesktop(context);

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
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.lg,
                  0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStaggered(
                      index: 0,
                      child: Text('Job Feed', style: AppTypography.h1),
                    ),
                    _buildStaggered(
                      index: 1,
                      child: jobsAsync.when(
                        loading: () => Text('Loading jobs...', style: AppTypography.bodyMedium),
                        error: (err, _) => Text('Error loading jobs', style: AppTypography.bodyMedium.copyWith(color: AppColors.error)),
                        data: (jobs) => Text(
                          '${jobs.length} jobs matching your profile',
                          style: AppTypography.bodyMedium,
                        ),
                      ),
                    ),
                    SizedBox(height: AppSpacing.lg),

                    // Search bar
                    _buildStaggered(
                      index: 2,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.surfaceElevated,
                          borderRadius: AppSpacing.borderMd,
                          border:
                              Border.all(color: AppColors.surfaceBorder),
                        ),
                        child: TextField(
                          controller: _searchController,
                          focusNode: _searchFocus,
                          style: AppTypography.bodyLarge,
                          decoration: InputDecoration(
                            hintText: 'Search roles, companies...',
                            prefixIcon:
                                const Icon(Icons.search_rounded),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            filled: false,
                            contentPadding:
                                EdgeInsets.symmetric(
                              vertical: AppSpacing.md,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: AppSpacing.md),

                    // Filter chips
                    _buildStaggered(
                      index: 3,
                      child: SizedBox(
                        height: 38,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: _filters.length,
                          separatorBuilder: (context, index) =>
                              SizedBox(width: AppSpacing.sm),
                          itemBuilder: (context, i) {
                            final filter = _filters[i];
                            final isActive =
                                filter == _selectedFilter;
                            return GestureDetector(
                              onTap: () => setState(
                                  () => _selectedFilter = filter),
                              child: AnimatedContainer(
                                duration: const Duration(
                                    milliseconds: 250),
                                padding:
                                    EdgeInsets.symmetric(
                                  horizontal: AppSpacing.lg,
                                  vertical: AppSpacing.sm,
                                ),
                                decoration: BoxDecoration(
                                  gradient: isActive
                                      ? AppColors.primaryGradient
                                      : null,
                                  color: isActive
                                      ? null
                                      : AppColors.surfaceElevated,
                                  borderRadius:
                                      AppSpacing.borderFull,
                                  border: isActive
                                      ? null
                                      : Border.all(
                                          color: AppColors
                                              .surfaceBorder),
                                  boxShadow: isActive
                                      ? [
                                          BoxShadow(
                                            color: AppColors.primary
                                                .withValues(
                                                    alpha: 0.3),
                                            blurRadius: 8,
                                          ),
                                        ]
                                      : null,
                                ),
                                child: Center(
                                  child: Text(
                                    filter,
                                    style: AppTypography.labelMedium
                                        .copyWith(
                                      color: isActive
                                          ? Colors.white
                                          : AppColors
                                              .textSecondary,
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

              // Job list — 2 columns on desktop, 1 on mobile
              Expanded(
                child: jobsAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Center(child: Text('Error: $err')),
                  data: (jobList) {
                    if (jobList.isEmpty) {
                      return Center(child: Text('No jobs found.', style: AppTypography.bodyLarge));
                    }
                    return isDesktop
                        ? GridView.builder(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSpacing.lg,
                              vertical: AppSpacing.sm,
                            ),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: AppSpacing.md,
                              crossAxisSpacing: AppSpacing.md,
                              childAspectRatio: 1.8,
                            ),
                            itemCount: jobList.length,
                            itemBuilder: (context, i) {
                              final job = jobList[i];
                              return _buildStaggered(
                                index: 4 + i,
                                child: JobCard(
                                  company: job.company,
                                  role: job.title,
                                  location: job.location ?? 'Remote',
                                  salary: job.displaySalary,
                                  timeAgo: job.timeAgo,
                                  tags: job.requiredSkills.take(3).toList(),
                                  accentColor: AppColors.primary,
                                  isBookmarked: false,
                                  onBookmark: () {},
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            _JobDetailInline(job: job),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          )
                        : ListView.separated(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSpacing.lg,
                              vertical: AppSpacing.sm,
                            ),
                            itemCount: jobList.length,
                            separatorBuilder: (context, index) =>
                                SizedBox(height: AppSpacing.md),
                            itemBuilder: (context, i) {
                              final job = jobList[i];
                              return _buildStaggered(
                                index: 4 + i,
                                child: JobCard(
                                  company: job.company,
                                  role: job.title,
                                  location: job.location ?? 'Remote',
                                  salary: job.displaySalary,
                                  timeAgo: job.timeAgo,
                                  tags: job.requiredSkills.take(3).toList(),
                                  accentColor: AppColors.primary,
                                  isBookmarked: false,
                                  onBookmark: () {},
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            _JobDetailInline(job: job),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          );
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

/// Inline job detail page.
class _JobDetailInline extends StatelessWidget {
  final JobModel job;
  const _JobDetailInline({required this.job});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(job.company)),
      body: SingleChildScrollView(
        child: ResponsiveCenter(
          maxWidth: 700,
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.3),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.2),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      job.company.isNotEmpty ? job.company[0] : 'J',
                      style:
                          AppTypography.h1.copyWith(color: AppColors.primary),
                    ),
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.lg),
              Center(
                child: Text(job.title,
                    style: AppTypography.h2,
                    textAlign: TextAlign.center),
              ),
              SizedBox(height: AppSpacing.sm),
              Center(
                child: Text(
                  '${job.company} • ${job.location ?? 'Remote'}',
                  style: AppTypography.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: AppSpacing.xxl),
              _InfoSection(
                icon: Icons.attach_money_rounded,
                label: 'Salary',
                value: job.displaySalary,
                color: AppColors.success,
              ),
              SizedBox(height: AppSpacing.md),
              _InfoSection(
                icon: Icons.schedule_rounded,
                label: 'Posted',
                value: job.timeAgo,
                color: AppColors.info,
              ),
              SizedBox(height: AppSpacing.md),
              _InfoSection(
                icon: Icons.work_outline_rounded,
                label: 'Type',
                value: job.workMode ?? 'Full-time',
                color: AppColors.primary,
              ),
              SizedBox(height: AppSpacing.xxl),
              Text('Required Skills', style: AppTypography.h4),
              SizedBox(height: AppSpacing.md),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: job.requiredSkills.map((tag) {
                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: AppSpacing.borderFull,
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.25),
                      ),
                    ),
                    child: Text(
                      tag,
                      style: AppTypography.labelMedium
                          .copyWith(color: AppColors.primary),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: AppSpacing.xxl),
              Text('About the Role', style: AppTypography.h4),
              SizedBox(height: AppSpacing.md),
              Text(
                'We are looking for an experienced ${job.title} to join our team at ${job.company}. '
                'You will work on cutting-edge technologies and collaborate with world-class engineers '
                'to build products used by millions of people around the world.\n\n'
                'Requirements:\n'
                '• 5+ years of experience in software development\n'
                '• Strong problem-solving skills\n'
                '• Experience with ${job.requiredSkills.take(3).join(", ")}\n'
                '• Excellent communication abilities',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.8,
                ),
              ),
              SizedBox(height: AppSpacing.xxxl),
              Container(
                width: double.infinity,
                height: 54,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.primary.withValues(alpha: 0.7)
                    ],
                  ),
                  borderRadius: AppSpacing.borderMd,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: MaterialButton(
                  onPressed: () {},
                  shape: RoundedRectangleBorder(
                      borderRadius: AppSpacing.borderMd),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       const Icon(Icons.rocket_launch_rounded,
                           size: 20, color: Colors.white),
                       SizedBox(width: AppSpacing.sm),
                       Text('Apply Now',
                           style: AppTypography.buttonText),
                    ],
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.giant),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _InfoSection({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          SizedBox(width: AppSpacing.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTypography.labelSmall),
              Text(value, style: AppTypography.labelLarge),
            ],
          ),
        ],
      ),
    );
  }
}
