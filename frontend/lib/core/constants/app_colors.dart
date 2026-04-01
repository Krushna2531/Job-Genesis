import 'package:flutter/material.dart';

/// JobGenesis Design System — Futuristic Color Palette
///
/// Single source of truth for all colors.
/// Never hardcode hex values in widgets. Always reference AppColors.
abstract class AppColors {
  // ─── Brand Colors ──────────────────────────────────────────────
  static const Color primary = Color(0xFF6C63FF); // Electric Violet
  static const Color primaryLight = Color(0xFF9D97FF);
  static const Color primaryDark = Color(0xFF3D35CC);
  static const Color primarySurface = Color(0xFF1A1833); // Tinted bg

  static const Color secondary = Color(0xFF00D4AA); // Emerald Teal
  static const Color secondaryLight = Color(0xFF5FFFD8);
  static const Color secondaryDark = Color(0xFF009E7E);

  static const Color accent = Color(0xFFFF6B6B); // Coral — alerts/CTAs

  // ─── Neon / Futuristic ─────────────────────────────────────────
  static const Color neonCyan = Color(0xFF00F5FF);
  static const Color neonPink = Color(0xFFFF00E5);
  static const Color neonBlue = Color(0xFF4D7CFF);
  static const Color neonGreen = Color(0xFF00FF94);
  static const Color electricPurple = Color(0xFF8B5CF6);

  // ─── Neutral / Background ──────────────────────────────────────
  static const Color background = Color(0xFF0A0A12); // Ultra-deep space
  static const Color surface = Color(0xFF111122); // Card surfaces
  static const Color surfaceElevated = Color(0xFF1A1A2E); // Modals, sheets
  static const Color surfaceBorder = Color(0xFF2A2A3E); // Dividers, borders
  static const Color surfaceHover = Color(0xFF22223A); // Hover states

  // ─── Glass / Frosted ───────────────────────────────────────────
  static const Color glassSurface = Color(0x1AFFFFFF); // 10% white
  static const Color glassBorder = Color(0x33FFFFFF); // 20% white
  static const Color glassHighlight = Color(0x0DFFFFFF); // 5% white

  // ─── Text Colors ───────────────────────────────────────────────
  static const Color textPrimary = Color(0xFFF1F1F5); // Near white
  static const Color textSecondary = Color(0xFF9191A8); // Muted
  static const Color textTertiary = Color(0xFF5A5A72); // Very muted
  static const Color textInverse = Color(0xFF0D0D14); // On light bg

  // ─── Semantic Colors ───────────────────────────────────────────
  static const Color success = Color(0xFF00C48C);
  static const Color successSurface = Color(0xFF0D2E24);
  static const Color warning = Color(0xFFFFB547);
  static const Color warningSurface = Color(0xFF2E2210);
  static const Color error = Color(0xFFFF5252);
  static const Color errorSurface = Color(0xFF2E0F0F);
  static const Color info = Color(0xFF448AFF);
  static const Color infoSurface = Color(0xFF0D1A2E);

  // ─── Job Status Colors ─────────────────────────────────────────
  static const Color statusApplied = Color(0xFF448AFF);
  static const Color statusScreening = Color(0xFFFFB547);
  static const Color statusInterview = Color(0xFF6C63FF);
  static const Color statusOffer = Color(0xFF00C48C);
  static const Color statusRejected = Color(0xFFFF5252);
  static const Color statusWithdrawn = Color(0xFF9191A8);

  // ─── Gradients ─────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6C63FF), Color(0xFF00D4AA)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient neonGradient = LinearGradient(
    colors: [Color(0xFF6C63FF), Color(0xFF00F5FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient auroraGradient = LinearGradient(
    colors: [Color(0xFF6C63FF), Color(0xFFFF00E5), Color(0xFF00F5FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF1A1A2E), Color(0xFF111122)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient splashGradient = LinearGradient(
    colors: [Color(0xFF0A0A12), Color(0xFF1A1833), Color(0xFF0A0A12)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient glassGradient = LinearGradient(
    colors: [Color(0x1AFFFFFF), Color(0x0DFFFFFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient shimmerGradient = LinearGradient(
    colors: [
      Color(0x00FFFFFF),
      Color(0x33FFFFFF),
      Color(0x00FFFFFF),
    ],
    stops: [0.0, 0.5, 1.0],
    begin: Alignment(-1.0, -0.3),
    end: Alignment(1.0, 0.3),
  );
}
