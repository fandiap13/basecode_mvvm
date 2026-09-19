import 'package:basecode/core/theme/app_colors.dart';
import 'package:basecode/core/theme/app_radius.dart';
import 'package:basecode/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

// variant
enum AppChipVariant { primary, secondary, success, warning, danger, neutral }

// size
enum AppChipSize {
  small(height: 24, hPadding: 8, fontSize: 11, iconSize: 12),
  medium(height: 32, hPadding: 12, fontSize: 12, iconSize: 14);

  const AppChipSize({
    required this.height,
    required this.hPadding,
    required this.fontSize,
    required this.iconSize,
  });

  final double height;
  final double hPadding;
  final double fontSize;
  final double iconSize;
}

/// Label ringkas untuk status, kategori, atau filter.
class AppChip extends StatelessWidget {
  const AppChip({
    super.key,
    required this.label,
    this.variant = AppChipVariant.neutral,
    this.size = AppChipSize.medium,
    this.icon,
    this.onTap,
    this.onDeleted,
    this.selected = false,
    this.outlined = false,
  });

  final String label;
  final AppChipVariant variant;
  final AppChipSize size;

  final IconData? icon;

  final VoidCallback? onTap;

  /// Menampilkan tombol silang di kanan; dipakai untuk filter aktif.
  final VoidCallback? onDeleted;

  /// Keadaan terpilih memakai warna pekat, bukan tint.
  final bool selected;

  /// Hanya garis tepi, tanpa latar.
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = theme.appColors;

    final (dasar, tint) = switch (variant) {
      AppChipVariant.primary => (c.primary, c.tealTint),
      AppChipVariant.secondary => (c.secondary, c.secondaryTint),
      AppChipVariant.success => (c.success, c.tealTint),
      AppChipVariant.warning => (c.warning, c.amberTint),
      AppChipVariant.danger => (c.danger, c.redTint),
      AppChipVariant.neutral => (c.inkSoft, c.line),
    };

    final latar = outlined
        ? Colors.transparent
        : selected
        ? dasar
        : tint;

    final teks = selected && !outlined ? c.surface : dasar;

    final isi = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: size.iconSize, color: teks),
          const SizedBox(width: AppSpacing.xs),
        ],
        Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            fontSize: size.fontSize,
            color: teks,
            height: 1,
          ),
        ),
        if (onDeleted != null) ...[
          const SizedBox(width: AppSpacing.xs),
          // Area sentuh kecil; chip sendiri sudah pendek.
          GestureDetector(
            onTap: onDeleted,
            child: Icon(Icons.close, size: size.iconSize, color: teks),
          ),
        ],
      ],
    );

    final chip = Container(
      height: size.height,
      padding: EdgeInsets.symmetric(horizontal: size.hPadding),
      decoration: BoxDecoration(
        color: latar,
        borderRadius: BorderRadius.circular(size.height / 2),
        border: outlined ? Border.all(color: dasar) : null,
      ),
      alignment: Alignment.center,
      child: isi,
    );

    if (onTap == null) return chip;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(size.height / 2),
      child: chip,
    );
  }
}

/// Penanda angka atau titik, biasanya menempel di ikon.
class AppBadge extends StatelessWidget {
  const AppBadge({
    super.key,
    this.count,
    this.label,
    this.variant = AppChipVariant.danger,
    this.child,
    this.maxCount = 99,
    this.showZero = false,
  });

  /// Angka yang ditampilkan; null berarti badge titik.
  final int? count;

  /// Teks bebas sebagai ganti angka.
  final String? label;

  final AppChipVariant variant;

  /// Widget yang ditempeli badge, mis. ikon notifikasi.
  final Widget? child;

  /// Angka di atas ini ditampilkan sebagai "99+".
  final int maxCount;

  /// Secara bawaan badge disembunyikan saat count nol.
  final bool showZero;

  bool get _hidden => count == 0 && !showZero;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = theme.appColors;

    final warna = switch (variant) {
      AppChipVariant.primary => c.primary,
      AppChipVariant.secondary => c.secondary,
      AppChipVariant.success => c.success,
      AppChipVariant.warning => c.warning,
      AppChipVariant.danger => c.danger,
      AppChipVariant.neutral => c.inkSoft,
    };

    if (_hidden) return child ?? const SizedBox.shrink();

    final teks = label ?? (count != null ? _formatCount(count!) : null);
    final isDot = teks == null;

    final badge = Container(
      constraints: BoxConstraints(minWidth: isDot ? 8 : 18),
      height: isDot ? 8 : 18,
      padding: isDot
          ? EdgeInsets.zero
          : const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: warna,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        // Cincin sewarna latar agar badge terpisah dari ikon di baliknya.
        border: child != null ? Border.all(color: c.surface, width: 1.5) : null,
      ),
      alignment: Alignment.center,
      child: isDot
          ? null
          : Text(
              teks,
              style: theme.textTheme.labelSmall?.copyWith(
                color: c.surface,
                fontSize: 10,
                height: 1,
              ),
            ),
    );

    // Tanpa child, badge berdiri sendiri. UnconstrainedBox melepas batas
    // dari parent agar badge hanya sebesar isinya.
    if (child == null) {
      return UnconstrainedBox(child: badge);
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        child!,
        Positioned(right: -4, top: -4, child: badge),
      ],
    );
  }

  String _formatCount(int value) => value > maxCount ? '$maxCount+' : '$value';
}
