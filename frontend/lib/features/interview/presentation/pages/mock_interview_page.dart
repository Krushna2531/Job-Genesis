import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/widgets/gradient_button.dart';

class _InterviewCategory {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final int questions;

  const _InterviewCategory({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.questions,
  });
}

class MockInterviewPage extends StatefulWidget {
  const MockInterviewPage({super.key});

  @override
  State<MockInterviewPage> createState() => _MockInterviewPageState();
}

class _MockInterviewPageState extends State<MockInterviewPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _difficulty = 0.5;
  int _selectedCategory = -1;

  final _categories = const [
    _InterviewCategory(
      title: 'Behavioral',
      subtitle: 'STAR method, leadership, teamwork',
      icon: Icons.psychology_rounded,
      color: AppColors.primary,
      questions: 120,
    ),
    _InterviewCategory(
      title: 'Technical',
      subtitle: 'DSA, coding, problem solving',
      icon: Icons.code_rounded,
      color: AppColors.neonCyan,
      questions: 250,
    ),
    _InterviewCategory(
      title: 'System Design',
      subtitle: 'Architecture, scalability, trade-offs',
      icon: Icons.account_tree_rounded,
      color: AppColors.electricPurple,
      questions: 80,
    ),
    _InterviewCategory(
      title: 'HR Round',
      subtitle: 'Salary, culture fit, expectations',
      icon: Icons.people_rounded,
      color: AppColors.secondary,
      questions: 60,
    ),
  ];

  final _pastSessions = [
    _PastSession('System Design', 85, AppColors.electricPurple, '2d ago'),
    _PastSession('Technical', 72, AppColors.neonCyan, '4d ago'),
    _PastSession('Behavioral', 91, AppColors.primary, '1w ago'),
  ];

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

  String get _difficultyLabel {
    if (_difficulty < 0.33) return 'Easy';
    if (_difficulty < 0.67) return 'Medium';
    return 'Hard';
  }

  Color get _difficultyColor {
    if (_difficulty < 0.33) return AppColors.success;
    if (_difficulty < 0.67) return AppColors.warning;
    return AppColors.accent;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: AppSpacing.lg),
              _buildStaggered(
                index: 0,
                child: Text('Mock Interview', style: AppTypography.h1),
              ),
              SizedBox(height: AppSpacing.sm),
              _buildStaggered(
                index: 1,
                child: Text(
                  'Practice with AI-powered interviewer',
                  style: AppTypography.bodyMedium,
                ),
              ),
              SizedBox(height: AppSpacing.xxl),

              // Categories
              _buildStaggered(
                index: 2,
                child: Text('Choose Category', style: AppTypography.h4),
              ),
              SizedBox(height: AppSpacing.md),
              ...List.generate(_categories.length, (i) {
                final cat = _categories[i];
                final isSelected = _selectedCategory == i;
                return Padding(
                  padding: EdgeInsets.only(bottom: AppSpacing.md),
                  child: _buildStaggered(
                    index: 3 + i,
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedCategory = i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        padding: EdgeInsets.all(AppSpacing.lg),
                        decoration: BoxDecoration(
                          gradient: isSelected
                              ? LinearGradient(
                                  colors: [
                                    cat.color.withValues(alpha: 0.15),
                                    cat.color.withValues(alpha: 0.05),
                                  ],
                                )
                              : null,
                          color: isSelected ? null : AppColors.surfaceElevated,
                          borderRadius: AppSpacing.borderLg,
                          border: Border.all(
                            color: isSelected
                                ? cat.color
                                : AppColors.surfaceBorder,
                            width: isSelected ? 1.5 : 1,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: cat.color.withValues(alpha: 0.15),
                                    blurRadius: 16,
                                  ),
                                ]
                              : null,
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: cat.color.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color:
                                              cat.color.withValues(alpha: 0.3),
                                          blurRadius: 12,
                                        ),
                                      ]
                                    : null,
                              ),
                              child:
                                  Icon(cat.icon, size: 24, color: cat.color),
                            ),
                            SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(cat.title,
                                      style: AppTypography.labelLarge),
                                  const SizedBox(height: 2),
                                  Text(cat.subtitle,
                                      style: AppTypography.bodySmall),
                                ],
                              ),
                            ),
                            Text(
                              '${cat.questions}',
                              style: AppTypography.labelMedium
                                  .copyWith(color: cat.color),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
              SizedBox(height: AppSpacing.lg),

              // Difficulty slider
              _buildStaggered(
                index: 7,
                child: GlassCard(
                  padding: EdgeInsets.all(AppSpacing.xl),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Difficulty', style: AppTypography.h4),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                              vertical: AppSpacing.xs,
                            ),
                            decoration: BoxDecoration(
                              color: _difficultyColor.withValues(alpha: 0.15),
                              borderRadius: AppSpacing.borderFull,
                            ),
                            child: Text(
                              _difficultyLabel,
                              style: AppTypography.labelSmall
                                  .copyWith(color: _difficultyColor),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSpacing.md),
                      SliderTheme(
                        data: SliderThemeData(
                          activeTrackColor: _difficultyColor,
                          inactiveTrackColor: AppColors.surfaceBorder,
                          thumbColor: Colors.white,
                          overlayColor:
                              _difficultyColor.withValues(alpha: 0.15),
                          trackHeight: 4,
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 8,
                          ),
                        ),
                        child: Slider(
                          value: _difficulty,
                          onChanged: (v) => setState(() => _difficulty = v),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.xxl),

              // Start button
              _buildStaggered(
                index: 8,
                child: GradientButton(
                  label: 'Start Interview',
                  icon: Icons.mic_rounded,
                  onPressed: _selectedCategory >= 0 ? () {} : null,
                ),
              ),
              SizedBox(height: AppSpacing.xxxl),

              // Past sessions
              _buildStaggered(
                index: 9,
                child: Text('Past Sessions', style: AppTypography.h4),
              ),
              SizedBox(height: AppSpacing.md),
              ...List.generate(_pastSessions.length, (i) {
                final session = _pastSessions[i];
                return Padding(
                  padding: EdgeInsets.only(bottom: AppSpacing.md),
                  child: _buildStaggered(
                    index: 10 + i,
                    child: GlassCard(
                      glowColor: session.color,
                      padding: EdgeInsets.all(AppSpacing.lg),
                      child: Row(
                        children: [
                          // Score
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: session.color.withValues(alpha: 0.15),
                              border: Border.all(
                                color: session.color.withValues(alpha: 0.4),
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '${session.score}',
                                style: AppTypography.labelLarge
                                    .copyWith(color: session.color),
                              ),
                            ),
                          ),
                          SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(session.category,
                                    style: AppTypography.labelLarge),
                                const SizedBox(height: 2),
                                Text(
                                  'Score: ${session.score}% • ${session.timeAgo}',
                                  style: AppTypography.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.chevron_right_rounded,
                            color: AppColors.textTertiary,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
              SizedBox(height: AppSpacing.giant),
            ],
          ),
        ),
      ),
    );
  }
}

class _PastSession {
  final String category;
  final int score;
  final Color color;
  final String timeAgo;

  _PastSession(this.category, this.score, this.color, this.timeAgo);
}
