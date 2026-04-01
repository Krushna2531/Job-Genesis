import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/responsive.dart';
import '../../../../shared/widgets/glass_card.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with SingleTickerProviderStateMixin {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();
  bool _isFocused = false;
  late AnimationController _animController;

  final _recentSearches = [
    'Flutter Developer',
    'Remote React',
    'Senior Engineer Google',
    'Product Designer',
    'ML Engineer',
  ];

  final _categories = [
    _Category('Technology', Icons.computer_rounded, AppColors.primary,
        '12k+ jobs'),
    _Category('Design', Icons.palette_rounded, AppColors.electricPurple,
        '5k+ jobs'),
    _Category(
        'Marketing', Icons.campaign_rounded, AppColors.accent, '3k+ jobs'),
    _Category('Finance', Icons.trending_up_rounded, AppColors.neonCyan,
        '4k+ jobs'),
    _Category('Healthcare', Icons.health_and_safety_rounded, AppColors.success,
        '6k+ jobs'),
    _Category(
        'Education', Icons.school_rounded, AppColors.warning, '2k+ jobs'),
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    _animController.dispose();
    super.dispose();
  }

  Widget _buildStaggered({required int index, required Widget child}) {
    final delay = (index * 0.1).clamp(0.0, 0.8);
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
    final gridCols = Responsive.gridColumns(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: ResponsiveCenter(
            maxWidth: 800,
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: AppSpacing.lg),
                _buildStaggered(
                    index: 0,
                    child: Text('Search', style: AppTypography.h1)),
                SizedBox(height: AppSpacing.sm),
                _buildStaggered(
                  index: 1,
                  child: Text('Find your dream job',
                      style: AppTypography.bodyMedium),
                ),
                SizedBox(height: AppSpacing.xxl),

                // Search bar
                _buildStaggered(
                  index: 2,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceElevated,
                      borderRadius: AppSpacing.borderMd,
                      border: Border.all(
                        color: _isFocused
                            ? AppColors.primary
                            : AppColors.surfaceBorder,
                        width: _isFocused ? 1.5 : 1,
                      ),
                      boxShadow: _isFocused
                          ? [
                              BoxShadow(
                                color: AppColors.primary
                                    .withValues(alpha: 0.15),
                                blurRadius: 20,
                                spreadRadius: -4,
                              ),
                            ]
                          : null,
                    ),
                    child: TextField(
                      controller: _searchController,
                      focusNode: _focusNode,
                      style: AppTypography.bodyLarge,
                      decoration: InputDecoration(
                        hintText: 'Role, company, or keyword...',
                        prefixIcon: const Icon(Icons.search_rounded),
                        suffixIcon: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: _isFocused
                              ? IconButton(
                                  icon: const Icon(Icons.tune_rounded,
                                      size: 20),
                                  onPressed: () {},
                                )
                              : const SizedBox.shrink(),
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        filled: false,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: AppSpacing.md,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: AppSpacing.xxl),

                // Recent searches
                _buildStaggered(
                  index: 3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Recent Searches', style: AppTypography.h4),
                      TextButton(
                        onPressed: () {},
                        child: Text('Clear',
                            style: AppTypography.labelMedium
                                .copyWith(color: AppColors.textTertiary)),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppSpacing.md),
                _buildStaggered(
                  index: 4,
                  child: Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: _recentSearches.map((search) {
                      return GestureDetector(
                        onTap: () {
                          _searchController.text = search;
                          _focusNode.requestFocus();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.sm,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceElevated,
                            borderRadius: AppSpacing.borderFull,
                            border:
                                Border.all(color: AppColors.surfaceBorder),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.history_rounded,
                                  size: 14, color: AppColors.textTertiary),
                              SizedBox(width: AppSpacing.xs),
                              Text(search,
                                  style: AppTypography.labelMedium),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: AppSpacing.xxxl),

                // Categories — adaptive grid
                _buildStaggered(
                    index: 5,
                    child: Text('Browse Categories',
                        style: AppTypography.h4)),
                SizedBox(height: AppSpacing.lg),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: gridCols,
                    mainAxisSpacing: AppSpacing.md,
                    crossAxisSpacing: AppSpacing.md,
                    childAspectRatio: 1.5,
                  ),
                  itemCount: _categories.length,
                  itemBuilder: (context, i) {
                    final cat = _categories[i];
                    return _buildStaggered(
                      index: 6 + i,
                      child: _CategoryCard(category: cat),
                    );
                  },
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

class _Category {
  final String name;
  final IconData icon;
  final Color color;
  final String count;
  _Category(this.name, this.icon, this.color, this.count);
}

class _CategoryCard extends StatefulWidget {
  final _Category category;
  const _CategoryCard({required this.category});

  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard> {
  bool _isPressed = false;
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final cat = widget.category;
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedScale(
          scale: _isPressed
              ? 0.95
              : _isHovered
                  ? 1.02
                  : 1.0,
          duration: const Duration(milliseconds: 150),
          child: GlassCard(
            glowColor: cat.color,
            padding: EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: cat.color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: cat.color.withValues(alpha: 0.25),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Icon(cat.icon, size: 20, color: cat.color),
                ),
                SizedBox(height: AppSpacing.sm),
                Text(cat.name, style: AppTypography.labelLarge),
                Text(cat.count, style: AppTypography.caption),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
