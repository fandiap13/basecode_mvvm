import 'package:basecode/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

// font size
abstract final class AppFontSize {
  static const double xs = 11;
  static const double sm = 12;
  static const double md = 14;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double display = 32;
}

// font weight
abstract final class AppFontWeight {
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
}

abstract final class AppTypography {
  /// Dipakai `AppTheme`; null = font bawaan platform (Roboto di Android).
  static const String? fontFamily = null;

  static TextTheme textTheme(ColorScheme cs) {
    final isLight = cs.brightness == Brightness.light; // check selected theme

    // final text = isLight ? AppColors.ink : cs.onSurface;
    // final textSoft = isLight ? AppColors.inkSoft : cs.onSurfaceVariant;
    final text = isLight ? AppColors.ink : cs.onSurface;
    final textSoft = isLight ? AppColors.inkSoft : cs.onSurfaceVariant;

    return TextTheme(
      displaySmall: TextStyle(
        fontSize: AppFontSize.display,
        fontWeight: AppFontWeight.bold,
        height: 1.2,
        color: text,
      ),
      headlineSmall: TextStyle(
        fontSize: AppFontSize.xxl,
        fontWeight: AppFontWeight.semiBold,
        height: 1.3,
        color: text,
      ),
      titleLarge: TextStyle(
        fontSize: AppFontSize.xl,
        fontWeight: AppFontWeight.semiBold,
        height: 1.3,
        color: text,
      ),
      titleMedium: TextStyle(
        fontSize: AppFontSize.lg,
        fontWeight: AppFontWeight.semiBold,
        height: 1.4,
        color: text,
      ),
      titleSmall: TextStyle(
        fontSize: AppFontSize.md,
        fontWeight: AppFontWeight.semiBold,
        height: 1.4,
        color: text,
      ),
      bodyLarge: TextStyle(
        fontSize: AppFontSize.lg,
        fontWeight: AppFontWeight.regular,
        height: 1.5,
        color: text,
      ),
      bodyMedium: TextStyle(
        fontSize: AppFontSize.md,
        fontWeight: AppFontWeight.regular,
        height: 1.5,
        color: text,
      ),
      bodySmall: TextStyle(
        fontSize: AppFontSize.sm,
        fontWeight: AppFontWeight.regular,
        height: 1.4,
        color: textSoft,
      ),
      labelLarge: TextStyle(
        fontSize: AppFontSize.md,
        fontWeight: AppFontWeight.medium,
        height: 1.2,
      ),
      labelMedium: TextStyle(
        fontSize: AppFontSize.sm,
        fontWeight: AppFontWeight.medium,
        height: 1.2,
      ),
      labelSmall: TextStyle(
        fontSize: AppFontSize.xs,
        fontWeight: AppFontWeight.medium,
        height: 1.2,
      ),
    );
  }
}
