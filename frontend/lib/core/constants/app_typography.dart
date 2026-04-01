import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';

/// JobGenesis Typography System — Futuristic
///
/// Based on Space Grotesk (geometric, futuristic) via Google Fonts.
abstract class AppTypography {
  // Check if we should scale (mobile screens only)
  static bool get _scale {
    try {
      return ScreenUtil().screenWidth < 600;
    } catch (_) {
      return false; // Safely default to standard pixels if ScreenUtil not ready
    }
  }

  // Helper constraint
  static double _sp(double size) => _scale ? size.sp : size;

  // ─── Base Style ─────────────────────────────────────────────────
  static TextStyle get _base => GoogleFonts.spaceGrotesk();

  // ─── Display ───────────────────────────────────────────────────
  static TextStyle get displayLarge => _base.copyWith(
        fontSize: _sp(48),
        fontWeight: FontWeight.w700,
        letterSpacing: -1.5,
        color: AppColors.textPrimary,
        height: 1.1,
      );

  static TextStyle get displayMedium => _base.copyWith(
        fontSize: _sp(36),
        fontWeight: FontWeight.w700,
        letterSpacing: -1.0,
        color: AppColors.textPrimary,
        height: 1.15,
      );

  // ─── Headings ──────────────────────────────────────────────────
  static TextStyle get h1 => _base.copyWith(
        fontSize: _sp(28),
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        color: AppColors.textPrimary,
        height: 1.2,
      );

  static TextStyle get h2 => _base.copyWith(
        fontSize: _sp(22),
        fontWeight: FontWeight.w600,
        letterSpacing: -0.3,
        color: AppColors.textPrimary,
        height: 1.25,
      );

  static TextStyle get h3 => _base.copyWith(
        fontSize: _sp(18),
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
        color: AppColors.textPrimary,
        height: 1.3,
      );

  static TextStyle get h4 => _base.copyWith(
        fontSize: _sp(16),
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        color: AppColors.textPrimary,
        height: 1.35,
      );

  // ─── Body ──────────────────────────────────────────────────────
  static TextStyle get bodyLarge => _base.copyWith(
        fontSize: _sp(16),
        fontWeight: FontWeight.w400,
        letterSpacing: 0.1,
        color: AppColors.textPrimary,
        height: 1.6,
      );

  static TextStyle get bodyMedium => _base.copyWith(
        fontSize: _sp(14),
        fontWeight: FontWeight.w400,
        letterSpacing: 0.1,
        color: AppColors.textSecondary,
        height: 1.6,
      );

  static TextStyle get bodySmall => _base.copyWith(
        fontSize: _sp(12),
        fontWeight: FontWeight.w400,
        letterSpacing: 0.2,
        color: AppColors.textTertiary,
        height: 1.5,
      );

  // ─── Labels ────────────────────────────────────────────────────
  static TextStyle get labelLarge => _base.copyWith(
        fontSize: _sp(14),
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        color: AppColors.textPrimary,
        height: 1.4,
      );

  static TextStyle get labelMedium => _base.copyWith(
        fontSize: _sp(12),
        fontWeight: FontWeight.w500,
        letterSpacing: 0.4,
        color: AppColors.textSecondary,
        height: 1.4,
      );

  static TextStyle get labelSmall => _base.copyWith(
        fontSize: _sp(10),
        fontWeight: FontWeight.w500,
        letterSpacing: 0.6,
        color: AppColors.textTertiary,
        height: 1.4,
      );

  // ─── Special ───────────────────────────────────────────────────
  static TextStyle get buttonText => _base.copyWith(
        fontSize: _sp(15),
        fontWeight: FontWeight.w600,
        letterSpacing: 0.3,
        color: AppColors.textPrimary,
        height: 1.0,
      );

  static TextStyle get caption => _base.copyWith(
        fontSize: _sp(11),
        fontWeight: FontWeight.w400,
        letterSpacing: 0.3,
        color: AppColors.textTertiary,
        height: 1.4,
      );

  static TextStyle get overline => _base.copyWith(
        fontSize: _sp(10),
        fontWeight: FontWeight.w600,
        letterSpacing: 1.5,
        color: AppColors.textSecondary,
        height: 1.4,
      );

  // ─── Mono (for code editor, stats) ─────────────────────────────
  static TextStyle get mono => GoogleFonts.jetBrainsMono(
        fontSize: _sp(14),
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
        height: 1.6,
      );

  static TextStyle get monoSmall => GoogleFonts.jetBrainsMono(
        fontSize: _sp(12),
        fontWeight: FontWeight.w400,
        color: AppColors.neonCyan,
        height: 1.5,
      );
}
