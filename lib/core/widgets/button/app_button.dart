import 'package:basecode/core/theme/app_colors.dart';
import 'package:basecode/core/theme/app_radius.dart';
import 'package:flutter/material.dart';

// variant
enum AppButtonVariant {
  primary,
  secondary,
  danger,
  warning,
  info,
  outline,
  text,
  dark,
}

// size
enum AppButtonSize {
  small(height: 36, hPadding: 12, iconSize: 16, gap: 6),
  medium(height: 44, hPadding: 16, iconSize: 18, gap: 8),
  large(height: 52, hPadding: 20, iconSize: 20, gap: 8);

  const AppButtonSize({
    required this.height,
    required this.hPadding,
    required this.iconSize,
    required this.gap,
  });

  final double height;
  final double hPadding;
  final double iconSize;
  final double gap;
}

// widget
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.radius = AppRadius.lg,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isExpanded = false,
    this.leadingIcon,
    this.trailingIcon,
    this.borderColor,
    this.borderWidth = 1,
  });

  final String label;
  final VoidCallback? onPressed; // null = disabled
  final AppButtonVariant variant;
  final AppButtonSize size;
  final bool isLoading;
  final bool isExpanded;
  final double radius;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final Color? borderColor;
  final double borderWidth;

  static void _noop() {}

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Saat loading: tetap tampil aktif, tapi tap tidak berefek.
    final callback = (isLoading && onPressed != null) ? _noop : onPressed;
    final style = _style(theme);
    final child = _AppButtonContent(
      label: label,
      size: size,
      isLoading: isLoading,
      leadingIcon: leadingIcon,
      trailingIcon: trailingIcon,
    );

    final Widget button = switch (variant) {
      AppButtonVariant.primary || AppButtonVariant.danger => FilledButton(
        onPressed: callback,
        style: style,
        child: child,
      ),
      AppButtonVariant.secondary => FilledButton.tonal(
        onPressed: callback,
        style: style,
        child: child,
      ),
      AppButtonVariant.dark => FilledButton.tonal(
        onPressed: callback,
        style: style,
        child: child,
      ),
      AppButtonVariant.info => FilledButton.tonal(
        onPressed: callback,
        style: style,
        child: child,
      ),
      AppButtonVariant.warning => FilledButton.tonal(
        onPressed: callback,
        style: style,
        child: child,
      ),
      AppButtonVariant.outline => OutlinedButton(
        onPressed: callback,
        style: style,
        child: child,
      ),
      AppButtonVariant.text => TextButton(
        onPressed: callback,
        style: style,
        child: child,
      ),
    };

    // memblokir interaksi tab saat loading
    return IgnorePointer(
      ignoring: isLoading,
      child:
          isExpanded // button memenuhi lebar parent
          ? SizedBox(width: double.infinity, child: button)
          : button,
    );
  }

  ButtonStyle _style(ThemeData theme) {
    // final cs = theme.colorScheme;
    final c = theme.appColors;
    final base = ButtonStyle(
      minimumSize: WidgetStatePropertyAll(Size(0, size.height)),
      padding: WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: size.hPadding),
      ),
      textStyle: WidgetStatePropertyAll(theme.textTheme.labelLarge),
    );

    final backgroundColor = switch (variant) {
      AppButtonVariant.primary => c.primary,
      AppButtonVariant.secondary => c.secondary,
      AppButtonVariant.danger => c.danger,
      AppButtonVariant.warning => c.warning,
      AppButtonVariant.info => c.brand,
      AppButtonVariant.outline => Colors.transparent,
      AppButtonVariant.text => Colors.transparent,
      AppButtonVariant.dark => c.ink,
    };

    final foregroundColor = switch (variant) {
      AppButtonVariant.primary => c.surface,
      AppButtonVariant.secondary => c.surface,
      AppButtonVariant.danger => c.surface,
      AppButtonVariant.warning => c.surface,
      AppButtonVariant.info => c.surface,
      AppButtonVariant.outline => c.ink,
      AppButtonVariant.text => c.ink,
      AppButtonVariant.dark => c.surface,
    };

    // Variant tanpa background: overlay diambil dari warna teks agar terlihat.
    final isFlat =
        variant == AppButtonVariant.outline || variant == AppButtonVariant.text;
    final overlayBase = isFlat ? foregroundColor : c.ink;

    // Border default mengikuti peran variant, bukan warna background:
    // garis sewarna background tidak akan terlihat, jadi mubazir.
    // - outline  : garis sewarna teks supaya menyatu
    // - lainnya  : tanpa garis, bentuk sudah jelas dari blok warnanya
    // borderColor dari pemanggil menimpa semuanya.
    final resolvedBorder =
        borderColor ??
        (variant == AppButtonVariant.outline ? foregroundColor : null);

    return base.copyWith(
      backgroundColor: WidgetStateProperty.resolveWith(
        (s) => s.contains(WidgetState.disabled)
            ? backgroundColor.withValues(alpha: 0.12)
            : backgroundColor,
      ),
      foregroundColor: WidgetStateProperty.resolveWith(
        (s) => s.contains(WidgetState.disabled)
            ? backgroundColor.withValues(alpha: 0.38)
            : foregroundColor,
      ),
      // Border ikut meredup saat disabled agar sejalan dengan background
      // dan foreground.
      side: WidgetStateProperty.resolveWith((s) {
        if (resolvedBorder == null) return BorderSide.none;
        return BorderSide(
          color: s.contains(WidgetState.disabled)
              ? resolvedBorder.withValues(alpha: 0.38)
              : resolvedBorder,
          width: borderWidth,
        );
      }),
      // Feedback hover/press/focus. Tanpa ini warna button sama di semua state
      // dan hanya ripple yang terlihat.
      overlayColor: WidgetStateProperty.resolveWith((s) {
        if (s.contains(WidgetState.pressed)) {
          return overlayBase.withValues(alpha: 0.18);
        }
        if (s.contains(WidgetState.hovered)) {
          return overlayBase.withValues(alpha: 0.10);
        }
        if (s.contains(WidgetState.focused)) {
          return overlayBase.withValues(alpha: 0.14);
        }
        return null;
      }),
      // Sedikit terangkat saat hover, rata lagi saat ditekan.
      elevation: WidgetStateProperty.resolveWith<double?>((s) {
        if (isFlat || s.contains(WidgetState.disabled)) return 0;
        if (s.contains(WidgetState.pressed)) return 0;
        if (s.contains(WidgetState.hovered)) return 3;

        return 0;
      }),
      shadowColor: WidgetStatePropertyAll(backgroundColor),
      animationDuration: const Duration(milliseconds: 150),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
      ),
    );
  }
}

// mengatur isi dalam button
class _AppButtonContent extends StatelessWidget {
  const _AppButtonContent({
    required this.label,
    required this.size,
    required this.isLoading,
    this.leadingIcon,
    this.trailingIcon,
  });

  final String label;
  final AppButtonSize size;
  final bool isLoading;
  final IconData? leadingIcon;
  final IconData? trailingIcon;

  @override
  Widget build(BuildContext context) {
    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (leadingIcon != null) ...[
          Icon(leadingIcon, size: size.iconSize),
          SizedBox(width: size.gap),
        ],
        Flexible(
          child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
        if (trailingIcon != null) ...[
          SizedBox(width: size.gap),
          Icon(trailingIcon, size: size.iconSize),
        ],
      ],
    );

    if (!isLoading) return content;

    // Konten tetap memakan ruang agar ukuran button tidak berubah.
    return Stack(
      alignment: Alignment.center,
      children: [
        Visibility(
          visible: false,
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          child: content,
        ),
        SizedBox.square(
          dimension: size.iconSize,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: DefaultTextStyle.of(context).style.color,
          ),
        ),
      ],
    );
  }
}
