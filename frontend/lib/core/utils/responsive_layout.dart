import 'package:flutter/material.dart';

/// A utility to build different layouts depending on the screen width.
/// Mobile: < 600
/// Tablet: >= 600 and < 900
/// Desktop: >= 900
class ResponsiveLayout extends StatelessWidget {
  final Widget mobileBody;
  final Widget? tabletBody;
  final Widget? desktopBody;

  const ResponsiveLayout({
    super.key,
    required this.mobileBody,
    this.tabletBody,
    this.desktopBody,
  });

  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < 600;

  static bool isTablet(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= 600 &&
      MediaQuery.sizeOf(context).width < 900;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= 900;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 900) {
          return desktopBody ?? tabletBody ?? mobileBody;
        } else if (constraints.maxWidth >= 600) {
          return tabletBody ?? mobileBody;
        } else {
          return mobileBody;
        }
      },
    );
  }
}
