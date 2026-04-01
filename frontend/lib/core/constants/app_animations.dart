import 'package:flutter/material.dart';

/// Centralized animation constants — consistent motion language.
abstract class AppAnimations {
  // ─── Durations ─────────────────────────────────────────────────
  static const Duration instant = Duration(milliseconds: 100);
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration slower = Duration(milliseconds: 800);
  static const Duration slowest = Duration(milliseconds: 1200);
  static const Duration splash = Duration(milliseconds: 2000);

  // ─── Curves ────────────────────────────────────────────────────
  static const Curve defaultCurve = Curves.easeOutCubic;
  static const Curve bounceCurve = Curves.elasticOut;
  static const Curve smoothCurve = Curves.easeInOutCubic;
  static const Curve sharpCurve = Curves.easeOutQuart;

  // ─── Stagger Delays ────────────────────────────────────────────
  static const Duration staggerDelay = Duration(milliseconds: 60);
  static const Duration staggerDelayLong = Duration(milliseconds: 100);

  // ─── Page Transitions ──────────────────────────────────────────
  static const Duration pageTransition = Duration(milliseconds: 350);
  static const Curve pageTransitionCurve = Curves.easeInOutCubic;
}
