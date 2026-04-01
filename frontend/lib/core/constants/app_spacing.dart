import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Consistent spacing scale — 4pt base grid system.
/// If screen is >= 600 (Tablet/Desktop), we stop applying .w and .h 
/// because it causes UI elements to become gigangtic.
abstract class AppSpacing {
  // Check if we should scale (mobile screens only)
  static bool get _scale {
    try {
      return ScreenUtil().screenWidth < 600;
    } catch (_) {
      return false; // Safely default to standard pixels if ScreenUtil not ready
    }
  }

  static double get xs => _scale ? 4.0.w : 4.0;
  static double get sm => _scale ? 8.0.w : 8.0;
  static double get md => _scale ? 12.0.w : 12.0;
  static double get lg => _scale ? 16.0.w : 16.0;
  static double get xl => _scale ? 20.0.w : 20.0;
  static double get xxl => _scale ? 24.0.w : 24.0;
  static double get xxxl => _scale ? 32.0.w : 32.0;
  static double get huge => _scale ? 48.0.w : 48.0;
  static double get giant => _scale ? 64.0.w : 64.0;

  static double get xsH => _scale ? 4.0.h : 4.0;
  static double get smH => _scale ? 8.0.h : 8.0;
  static double get mdH => _scale ? 12.0.h : 12.0;
  static double get lgH => _scale ? 16.0.h : 16.0;
  static double get xlH => _scale ? 20.0.h : 20.0;
  static double get xxlH => _scale ? 24.0.h : 24.0;
  static double get xxxlH => _scale ? 32.0.h : 32.0;
  static double get hugeH => _scale ? 48.0.h : 48.0;
  static double get giantH => _scale ? 64.0.h : 64.0;

  // ─── Common EdgeInsets ─────────────────────────────────────────
  static EdgeInsets get screenPadding =>
      EdgeInsets.symmetric(horizontal: lg, vertical: lgH);

  static EdgeInsets get cardPadding =>
      EdgeInsets.symmetric(horizontal: lg, vertical: mdH);

  static EdgeInsets get buttonPadding =>
      EdgeInsets.symmetric(horizontal: xxl, vertical: lgH);

  // ─── Border Radius ─────────────────────────────────────────────
  static double get radiusSm => _scale ? 8.0.r : 8.0;
  static double get radiusMd => _scale ? 12.0.r : 12.0;
  static double get radiusLg => _scale ? 16.0.r : 16.0;
  static double get radiusXl => _scale ? 24.0.r : 24.0;
  static double get radiusFull => _scale ? 999.0.r : 999.0;

  static BorderRadius get borderSm => BorderRadius.circular(radiusSm);
  static BorderRadius get borderMd => BorderRadius.circular(radiusMd);
  static BorderRadius get borderLg => BorderRadius.circular(radiusLg);
  static BorderRadius get borderXl => BorderRadius.circular(radiusXl);
  static BorderRadius get borderFull => BorderRadius.circular(radiusFull);
}
