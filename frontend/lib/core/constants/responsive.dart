import 'package:flutter/material.dart';

/// Responsive breakpoints and helpers.
abstract class Responsive {
  static const double mobileMax = 600;
  static const double tabletMax = 1024;
  static const double contentMaxWidth = 500; // Mobile-optimized content
  static const double desktopContentMaxWidth = 1200;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobileMax;

  static bool isTablet(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return w >= mobileMax && w < tabletMax;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= tabletMax;

  /// Returns appropriate column count for grids.
  static int gridColumns(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    if (w >= tabletMax) return 4;
    if (w >= mobileMax) return 3;
    return 2;
  }
}

/// Wraps content with max-width constraint + centered on larger screens.
/// Use this on every page body to prevent content from stretching too wide.
class ResponsiveCenter extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry? padding;

  const ResponsiveCenter({
    super.key,
    required this.child,
    this.maxWidth = Responsive.contentMaxWidth,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: padding != null
            ? Padding(padding: padding!, child: child)
            : child,
      ),
    );
  }
}
