import 'package:basecode/core/theme/app_colors.dart';
import 'package:basecode/core/theme/app_radius.dart';
import 'package:flutter/material.dart';

// variant
enum AppAvatarVariant { primary, secondary, danger, warning, info, dark }

// bentuk
enum AppAvatarShape { circle, rounded }

// size
enum AppAvatarSize {
  xs(diameter: 24, fontSize: 10, statusSize: 8),
  sm(diameter: 32, fontSize: 12, statusSize: 10),
  md(diameter: 40, fontSize: 14, statusSize: 12),
  lg(diameter: 56, fontSize: 18, statusSize: 14),
  xl(diameter: 80, fontSize: 24, statusSize: 18);

  const AppAvatarSize({
    required this.diameter,
    required this.fontSize,
    required this.statusSize,
  });

  final double diameter;
  final double fontSize;
  final double statusSize;
}

// widget
class AppAvatar extends StatelessWidget {
  const AppAvatar({
    super.key,
    this.imageUrl,
    this.name,
    this.icon,
    this.size = AppAvatarSize.md,
    this.variant = AppAvatarVariant.primary,
    this.shape = AppAvatarShape.circle,
    this.backgroundColor,
    this.foregroundColor,
    this.onTap,
    this.showStatus = false,
    this.isOnline = false,
    this.tooltip,
  });

  /// Sumber gambar. Gagal dimuat akan jatuh ke inisial atau ikon.
  final String? imageUrl;

  /// Dipakai untuk mengambil inisial saat tidak ada gambar.
  final String? name;

  /// Cadangan terakhir bila nama juga kosong.
  final IconData? icon;

  final AppAvatarSize size;
  final AppAvatarVariant variant;
  final AppAvatarShape shape;

  final Color? backgroundColor;
  final Color? foregroundColor;

  final VoidCallback? onTap;

  /// Titik penanda daring di pojok kanan bawah.
  final bool showStatus;
  final bool isOnline;

  final String? tooltip;

  /// Ambil maksimal dua huruf awal dari nama.
  /// "Fandy Wangdef" -> "FW", "Fandy" -> "F".
  static String initialsOf(String name) {
    final kata = name.trim().split(RegExp(r'\s+'))
      ..removeWhere((k) => k.isEmpty);

    if (kata.isEmpty) return '';
    if (kata.length == 1) return kata.first.characters.first.toUpperCase();

    return (kata.first.characters.first + kata.last.characters.first)
        .toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = theme.appColors;

    // Warna dari token tema, bukan nilai hardcode.
    final base =
        backgroundColor ??
        switch (variant) {
          AppAvatarVariant.primary => c.primary,
          AppAvatarVariant.secondary => c.secondary,
          AppAvatarVariant.danger => c.danger,
          AppAvatarVariant.warning => c.warning,
          AppAvatarVariant.info => c.info,
          AppAvatarVariant.dark => c.ink,
        };

    final onBase = foregroundColor ?? c.surface;

    final borderRadius = shape == AppAvatarShape.circle
        ? BorderRadius.circular(size.diameter / 2)
        : BorderRadius.circular(AppRadius.md);

    Widget avatar = Container(
      width: size.diameter,
      height: size.diameter,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(color: base, borderRadius: borderRadius),
      child: _content(theme, onBase),
    );

    if (showStatus) avatar = _withStatus(avatar, c);

    if (onTap != null) {
      avatar = InkWell(onTap: onTap, borderRadius: borderRadius, child: avatar);
    }

    if (tooltip == null) return avatar;

    return Tooltip(message: tooltip!, child: avatar);
  }

  /// Urutan cadangan: gambar -> inisial -> ikon.
  Widget _content(ThemeData theme, Color onBase) {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return Image.network(
        imageUrl!,
        width: size.diameter,
        height: size.diameter,
        fit: BoxFit.cover,
        // Gambar gagal dimuat: pakai cadangan, jangan tampilkan ikon rusak.
        errorBuilder: (context, error, stack) => _fallback(theme, onBase),
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Center(
            child: SizedBox.square(
              dimension: size.fontSize,
              child: CircularProgressIndicator(strokeWidth: 2, color: onBase),
            ),
          );
        },
      );
    }

    return _fallback(theme, onBase);
  }

  Widget _fallback(ThemeData theme, Color onBase) {
    final inisial = name != null ? initialsOf(name!) : '';

    if (inisial.isNotEmpty) {
      return Center(
        child: Text(
          inisial,
          style: theme.textTheme.labelLarge?.copyWith(
            fontSize: size.fontSize,
            color: onBase,
            height: 1,
          ),
        ),
      );
    }

    return Center(
      child: Icon(
        icon ?? Icons.person_outline,
        size: size.fontSize * 1.2,
        color: onBase,
      ),
    );
  }

  Widget _withStatus(Widget avatar, AppColorsTheme c) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        avatar,
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            width: size.statusSize,
            height: size.statusSize,
            decoration: BoxDecoration(
              color: isOnline ? c.success : c.inkFaint,
              shape: BoxShape.circle,
              // Cincin sewarna latar agar titik terpisah dari avatar.
              border: Border.all(color: c.surface, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}

/// Deretan avatar yang saling tumpang tindih, mis. anggota tim.
class AppAvatarGroup extends StatelessWidget {
  const AppAvatarGroup({
    super.key,
    required this.avatars,
    this.size = AppAvatarSize.md,
    this.max = 3,
  });

  final List<AppAvatar> avatars;
  final AppAvatarSize size;

  /// Sisanya diringkas jadi "+N".
  final int max;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = theme.appColors;

    final tampil = avatars.take(max).toList();
    final sisa = avatars.length - tampil.length;

    // Tumpang tindih sepertiga lebar avatar.
    final offset = size.diameter * 0.66;

    return SizedBox(
      height: size.diameter,
      width:
          offset * (tampil.length + (sisa > 0 ? 1 : 0)) +
          (size.diameter - offset),
      child: Stack(
        children: [
          for (var i = 0; i < tampil.length; i++)
            Positioned(
              left: i * offset,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: c.surface, width: 2),
                ),
                child: tampil[i],
              ),
            ),
          if (sisa > 0)
            Positioned(
              left: tampil.length * offset,
              child: Container(
                width: size.diameter,
                height: size.diameter,
                decoration: BoxDecoration(
                  color: c.line,
                  shape: BoxShape.circle,
                  border: Border.all(color: c.surface, width: 2),
                ),
                child: Center(
                  child: Text(
                    '+$sisa',
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontSize: size.fontSize,
                      color: c.ink,
                      height: 1,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
