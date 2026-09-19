import 'package:basecode/core/theme/app_colors.dart';
import 'package:basecode/core/theme/app_radius.dart';
import 'package:flutter/material.dart';

// variant
enum AppIconButtonVariant {
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
enum AppIconButtonSize {
  small(height: 36, iconSize: 16),
  medium(height: 44, iconSize: 18),
  large(height: 52, iconSize: 20);

  const AppIconButtonSize({required this.height, required this.iconSize});

  final double height;
  final double iconSize;
}

// widget
class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    this.icon,
    required this.onPressed,
    this.variant = AppIconButtonVariant.primary,
    this.radius = AppRadius.sm,
    this.size = AppIconButtonSize.medium,
    this.isLoading = false,
    this.isExpanded = false,
    this.tooltip,
    this.borderColor,
    this.borderWidth = 1,
  });

  final VoidCallback? onPressed; // null = disabled
  final AppIconButtonVariant variant;
  final AppIconButtonSize size;
  final bool isLoading;
  final bool isExpanded;
  final double radius;
  final IconData? icon;
  final String? tooltip;
  final Color? borderColor;
  final double borderWidth;

  static void _noop() {}

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final callback = (isLoading && onPressed != null) ? _noop : onPressed;
    final style = _style(theme);
    final child = _AppIconButtonContent(
      size: size,
      isLoading: isLoading,
      icon: icon,
    );

    final Widget button = switch (variant) {
      AppIconButtonVariant.primary || AppIconButtonVariant.danger =>
        IconButton.filled(onPressed: callback, style: style, icon: child),
      AppIconButtonVariant.secondary ||
      AppIconButtonVariant.dark ||
      AppIconButtonVariant.info ||
      AppIconButtonVariant.warning => IconButton.filledTonal(
        onPressed: callback,
        style: style,
        icon: child,
      ),
      AppIconButtonVariant.outline => IconButton.outlined(
        onPressed: callback,
        style: style,
        icon: child,
      ),
      AppIconButtonVariant.text => IconButton(
        onPressed: callback,
        style: style,
        icon: child,
      ),
    };

    // memblokir interaksi tab saat loading
    final result = IgnorePointer(
      ignoring: isLoading,
      child:
          isExpanded // button memenuhi lebar parent
          ? SizedBox(width: double.infinity, child: button)
          : button,
    );

    if (tooltip == null) return result;

    // dengan tooltip
    return Tooltip(message: tooltip!, child: result);
  }

  ButtonStyle _style(ThemeData theme) {
    final c = theme.appColors;

    final base = ButtonStyle(
      minimumSize: WidgetStatePropertyAll(Size(size.height, size.height)),
      fixedSize: isExpanded
          ? null
          : WidgetStatePropertyAll(Size.square(size.height)),
      padding: const WidgetStatePropertyAll(EdgeInsets.zero),
      iconSize: WidgetStatePropertyAll(size.iconSize),
    );

    final backgroundColor = switch (variant) {
      AppIconButtonVariant.primary => c.primary,
      AppIconButtonVariant.secondary => c.secondary,
      AppIconButtonVariant.danger => c.danger,
      AppIconButtonVariant.warning => c.warning,
      AppIconButtonVariant.info => c.brand,
      AppIconButtonVariant.outline => Colors.transparent,
      AppIconButtonVariant.text => Colors.transparent,
      AppIconButtonVariant.dark => c.ink,
    };

    final foregroundColor = switch (variant) {
      AppIconButtonVariant.primary => c.surface,
      AppIconButtonVariant.secondary => c.surface,
      AppIconButtonVariant.danger => c.surface,
      AppIconButtonVariant.warning => c.surface,
      AppIconButtonVariant.info => c.surface,
      AppIconButtonVariant.outline => c.ink,
      AppIconButtonVariant.text => c.ink,
      AppIconButtonVariant.dark => c.surface,
    };

    // Variant tanpa background: overlay diambil dari warna teks agar terlihat.
    final isFlat =
        variant == AppIconButtonVariant.outline ||
        variant == AppIconButtonVariant.text;

    // Border default mengikuti peran variant, bukan warna background:
    // garis sewarna background tidak akan terlihat, jadi mubazir.
    // - outline  : garis sewarna ikon supaya menyatu
    // - lainnya  : tanpa garis, bentuk sudah jelas dari blok warnanya
    // borderColor dari pemanggil menimpa semuanya.
    final resolvedBorder =
        borderColor ??
        (variant == AppIconButtonVariant.outline ? foregroundColor : null);

    final overlayBase = isFlat ? foregroundColor : c.ink;

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
class _AppIconButtonContent extends StatelessWidget {
  const _AppIconButtonContent({
    required this.size,
    required this.isLoading,
    this.icon,
  });

  final AppIconButtonSize size;
  final bool isLoading;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    if (!isLoading) return Icon(icon, size: size.iconSize);

    // IconButton menurunkan foregroundColor lewat IconTheme, bukan
    // DefaultTextStyle (itu untuk Text). Spinner ikut warna ikonnya.
    return SizedBox.square(
      dimension: size.iconSize,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: IconTheme.of(context).color,
      ),
    );
  }
}
