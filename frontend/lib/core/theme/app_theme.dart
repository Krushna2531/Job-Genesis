import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/app_typography.dart';
import '../constants/app_spacing.dart';

/// Centralized MaterialApp theme — futuristic dark mode.
class AppTheme {
  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background,
        primaryColor: AppColors.primary,

        // ─── Color Scheme ────────────────────────────────────────
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          surface: AppColors.surface,
          error: AppColors.error,
          onPrimary: AppColors.textPrimary,
          onSecondary: AppColors.textInverse,
          onSurface: AppColors.textPrimary,
          onError: AppColors.textPrimary,
        ),

        // ─── App Bar ─────────────────────────────────────────────
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: false,
          iconTheme: const IconThemeData(color: AppColors.textPrimary),
          titleTextStyle: AppTypography.h3,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
          ),
        ),

        // ─── Card ────────────────────────────────────────────────
        cardTheme: CardThemeData(
          color: AppColors.surface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.borderLg,
            side: const BorderSide(color: AppColors.surfaceBorder, width: 1),
          ),
          margin: EdgeInsets.zero,
        ),

        // ─── Input Decoration ────────────────────────────────────
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surfaceElevated,
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          border: OutlineInputBorder(
            borderRadius: AppSpacing.borderMd,
            borderSide: const BorderSide(color: AppColors.surfaceBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: AppSpacing.borderMd,
            borderSide: const BorderSide(color: AppColors.surfaceBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: AppSpacing.borderMd,
            borderSide:
                const BorderSide(color: AppColors.primary, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: AppSpacing.borderMd,
            borderSide: const BorderSide(color: AppColors.error),
          ),
          hintStyle: AppTypography.bodyMedium,
          labelStyle: AppTypography.labelMedium,
          prefixIconColor: AppColors.textTertiary,
          suffixIconColor: AppColors.textTertiary,
        ),

        // ─── Elevated Button ─────────────────────────────────────
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.textPrimary,
            elevation: 0,
            padding: AppSpacing.buttonPadding,
            shape: RoundedRectangleBorder(
                borderRadius: AppSpacing.borderMd),
            textStyle: AppTypography.buttonText,
            minimumSize: const Size(double.infinity, 52),
          ),
        ),

        // ─── Text Button ─────────────────────────────────────────
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            textStyle: AppTypography.labelLarge,
          ),
        ),

        // ─── Chip ────────────────────────────────────────────────
        chipTheme: ChipThemeData(
          backgroundColor: AppColors.surfaceElevated,
          selectedColor: AppColors.primary.withValues(alpha: 0.2),
          side: const BorderSide(color: AppColors.surfaceBorder),
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.borderFull,
          ),
          labelStyle: AppTypography.labelMedium,
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
        ),

        // ─── Bottom Navigation ───────────────────────────────────
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.transparent,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textTertiary,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
        ),

        // ─── Divider ─────────────────────────────────────────────
        dividerTheme: const DividerThemeData(
          color: AppColors.surfaceBorder,
          thickness: 1,
          space: 0,
        ),

        // ─── Dialog ──────────────────────────────────────────────
        dialogTheme: DialogThemeData(
          backgroundColor: AppColors.surfaceElevated,
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.borderLg,
          ),
          elevation: 0,
        ),

        // ─── Snackbar ────────────────────────────────────────────
        snackBarTheme: SnackBarThemeData(
          backgroundColor: AppColors.surfaceElevated,
          contentTextStyle: AppTypography.bodyMedium,
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.borderMd,
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
}
