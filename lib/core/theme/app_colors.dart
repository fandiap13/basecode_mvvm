import 'package:flutter/material.dart';

// versi light
abstract final class AppColors {
  static const Color paper = Color(0xFFF1F8F3);
  static const Color surface = Color(0xFFFFFFFF);
  // static const Color paper = Color(0xFFE4EFE7);

  static const Color ink = Color(0xFF12352A);
  static const Color inkSoft = Color(0xFF527064);
  static const Color inkFaint = Color(0xFF8AA49A);

  static const Color line = Color(0xFFD5E6DA);

  static const Color teal = Color(0xFF17834B);
  static const Color tealTint = Color(0xFFDDF3E5);

  static const Color amber = Color(0xFFC97A2A);
  static const Color amberTint = Color(0xFFF8EADA);

  static const Color red = Color(0xFFB14B3F);
  static const Color redTint = Color(0xFFF6E4E1);

  static const Color gridDot = Color(0xFFCFE4D5);

  static const Color brand = Color(0xFF2563EB);

  static const Color green = teal;

  static const Color white = surface;

  // Semantic
  static const Color info = brand;
  static const Color primary = teal;
  static const Color success = teal;
  static const Color warning = amber;
  static const Color danger = red;
  static const Color secondary = Color(0xFF397D8A);
  static const Color secondaryTint = Color(0xFFE2F1F3);
}

/// Versi dark.
abstract final class AppColorsDark {
  static const Color paper = Color(0xFF0D1712);
  static const Color surface = Color(0xFF15231C);

  static const Color ink = Color(0xFFE6F2EA);
  static const Color inkSoft = Color(0xFFA3BDB0);
  static const Color inkFaint = Color(0xFF6B8579);

  static const Color line = Color(0xFF2A3C33);

  static const Color teal = Color(0xFF4ADE80);
  static const Color tealTint = Color(0xFF1B3327);

  static const Color amber = Color(0xFFE8A55C);
  static const Color amberTint = Color(0xFF33261A);

  static const Color red = Color(0xFFE08379);
  static const Color redTint = Color(0xFF331F1C);

  static const Color gridDot = Color(0xFF243830);

  static const Color brand = Color(0xFF60A5FA);

  static const Color green = teal;

  static const Color white = surface;

  // Semantic
  static const Color info = brand;
  static const Color primary = teal;
  static const Color success = teal;
  static const Color warning = amber;
  static const Color danger = red;
  static const Color secondary = Color(0xFF5FB3C2);
  static const Color secondaryTint = Color(0xFF1A2E33);
}

/// Jembatan token ke ThemeData supaya widget dapat nilai sesuai tema aktif:
/// `Theme.of(context).appColors.paper`.
@immutable
class AppColorsTheme extends ThemeExtension<AppColorsTheme> {
  const AppColorsTheme({
    required this.paper,
    required this.surface,
    required this.ink,
    required this.inkSoft,
    required this.inkFaint,
    required this.line,
    required this.teal,
    required this.tealTint,
    required this.amber,
    required this.amberTint,
    required this.red,
    required this.redTint,
    required this.gridDot,
    required this.brand,
    required this.primary,
    required this.success,
    required this.warning,
    required this.danger,
    required this.secondary,
    required this.secondaryTint,
    required this.info,
  });

  final Color paper;
  final Color surface;
  final Color ink;
  final Color inkSoft;
  final Color inkFaint;
  final Color line;
  final Color teal;
  final Color tealTint;
  final Color amber;
  final Color amberTint;
  final Color red;
  final Color redTint;
  final Color gridDot;
  final Color brand;
  final Color info;
  final Color primary;
  final Color success;
  final Color warning;
  final Color danger;
  final Color secondary;
  final Color secondaryTint;

  Color get green => teal;
  Color get white => surface;

  static const light = AppColorsTheme(
    paper: AppColors.paper,
    surface: AppColors.surface,
    ink: AppColors.ink,
    inkSoft: AppColors.inkSoft,
    inkFaint: AppColors.inkFaint,
    line: AppColors.line,
    teal: AppColors.teal,
    tealTint: AppColors.tealTint,
    amber: AppColors.amber,
    amberTint: AppColors.amberTint,
    red: AppColors.red,
    redTint: AppColors.redTint,
    gridDot: AppColors.gridDot,
    brand: AppColors.brand,
    primary: AppColors.primary,
    success: AppColors.success,
    warning: AppColors.warning,
    danger: AppColors.danger,
    secondary: AppColors.secondary,
    secondaryTint: AppColors.secondaryTint,
    info: AppColors.brand,
  );

  static const dark = AppColorsTheme(
    paper: AppColorsDark.paper,
    surface: AppColorsDark.surface,
    ink: AppColorsDark.ink,
    inkSoft: AppColorsDark.inkSoft,
    inkFaint: AppColorsDark.inkFaint,
    line: AppColorsDark.line,
    teal: AppColorsDark.teal,
    tealTint: AppColorsDark.tealTint,
    amber: AppColorsDark.amber,
    amberTint: AppColorsDark.amberTint,
    red: AppColorsDark.red,
    redTint: AppColorsDark.redTint,
    gridDot: AppColorsDark.gridDot,
    brand: AppColorsDark.brand,
    primary: AppColorsDark.primary,
    success: AppColorsDark.success,
    warning: AppColorsDark.warning,
    danger: AppColorsDark.danger,
    secondary: AppColorsDark.secondary,
    secondaryTint: AppColorsDark.secondaryTint,
    info: AppColors.brand,
  );

  // membuat salinan dengan beberapa nilai diubah
  // contoh: final newTheme = theme.appColors.copyWith(
  //   primary: Colors.blue,
  // );
  @override
  AppColorsTheme copyWith({
    Color? paper,
    Color? surface,
    Color? ink,
    Color? inkSoft,
    Color? inkFaint,
    Color? line,
    Color? teal,
    Color? tealTint,
    Color? amber,
    Color? amberTint,
    Color? red,
    Color? redTint,
    Color? gridDot,
    Color? brand,
    Color? primary,
    Color? success,
    Color? warning,
    Color? danger,
    Color? secondary,
    Color? secondaryTint,
    Color? info,
  }) {
    return AppColorsTheme(
      paper: paper ?? this.paper,
      surface: surface ?? this.surface,
      ink: ink ?? this.ink,
      inkSoft: inkSoft ?? this.inkSoft,
      inkFaint: inkFaint ?? this.inkFaint,
      line: line ?? this.line,
      teal: teal ?? this.teal,
      tealTint: tealTint ?? this.tealTint,
      amber: amber ?? this.amber,
      amberTint: amberTint ?? this.amberTint,
      red: red ?? this.red,
      redTint: redTint ?? this.redTint,
      gridDot: gridDot ?? this.gridDot,
      brand: brand ?? this.brand,
      primary: primary ?? this.primary,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      danger: danger ?? this.danger,
      secondary: secondary ?? this.secondary,
      secondaryTint: secondaryTint ?? this.secondaryTint,
      info: info ?? this.info,
    );
  }

  // transisii antar theme dark / light
  // contoh: final result = Color.lerp(colorA, colorB, 0.5);
  @override
  AppColorsTheme lerp(covariant AppColorsTheme? other, double t) {
    if (other == null) return this;
    return AppColorsTheme(
      paper: Color.lerp(paper, other.paper, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      ink: Color.lerp(ink, other.ink, t)!,
      inkSoft: Color.lerp(inkSoft, other.inkSoft, t)!,
      inkFaint: Color.lerp(inkFaint, other.inkFaint, t)!,
      line: Color.lerp(line, other.line, t)!,
      teal: Color.lerp(teal, other.teal, t)!,
      tealTint: Color.lerp(tealTint, other.tealTint, t)!,
      amber: Color.lerp(amber, other.amber, t)!,
      amberTint: Color.lerp(amberTint, other.amberTint, t)!,
      red: Color.lerp(red, other.red, t)!,
      redTint: Color.lerp(redTint, other.redTint, t)!,
      gridDot: Color.lerp(gridDot, other.gridDot, t)!,
      brand: Color.lerp(brand, other.brand, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      secondaryTint: Color.lerp(secondaryTint, other.secondaryTint, t)!,
      info: Color.lerp(info, other.info, t)!,
    );
  }
}

extension AppColorsThemeX on ThemeData {
  AppColorsTheme get appColors => extension<AppColorsTheme>()!;
}
