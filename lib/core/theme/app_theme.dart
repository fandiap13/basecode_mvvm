import 'package:basecode/core/theme/app_colors.dart';
import 'package:basecode/core/theme/app_radius.dart';
import 'package:basecode/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

abstract final class AppTheme {
  static ThemeData light() => _build(Brightness.light);
  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final colors = isDark ? AppColorsTheme.dark : AppColorsTheme.light;

    // ColorScheme adalah sistem warna semantic Flutter Material.
    // Warna dari AppColorsTheme dipetakan ke role yang digunakan widget Material.
    final cs =
        ColorScheme.fromSeed(
          seedColor: colors.brand,
          brightness: brightness,
        ).copyWith(
          primary: colors.primary,
          surface: colors.surface,
          onSurface: colors.ink,
          error: colors.danger,
          outline: colors.line,
        );

    const buttonStyle = ButtonStyle(
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
        ),
      ),
    );

    return ThemeData(
      colorScheme: cs,

      // background utama app
      scaffoldBackgroundColor: colors.paper,

      // Custom design tokens yang dapat diakses melalui:
      // Theme.of(context).appColors
      extensions: [colors],

      // config typograpy aplikasi
      fontFamily: AppTypography.fontFamily, // font setting
      textTheme: AppTypography.textTheme(cs), // text setting
      // button theme
      filledButtonTheme: const FilledButtonThemeData(style: buttonStyle),
      outlinedButtonTheme: const OutlinedButtonThemeData(style: buttonStyle),
      textButtonTheme: const TextButtonThemeData(style: buttonStyle),

      // card theme
      // Default card: rata (tanpa bayangan), bersandar pada surface + garis
      // tipis. AppCard hanya override shape saat radius-nya dikustomisasi.
      cardTheme: CardThemeData(
        color: colors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(AppRadius.md)),
          side: BorderSide(color: colors.line),
        ),
      ),
    );
  }
}
