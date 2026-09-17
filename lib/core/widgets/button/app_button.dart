import 'package:flutter/material.dart';

enum AppButtonVariant {
  primary,
  secondary,
  danger,
  warning,
  info,
  outline,
  text,
}

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

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isExpanded = false,
    this.leadingIcon,
    this.trailingIcon,
  });

  final String label;
  final VoidCallback? onPressed; // null = disabled
  final AppButtonVariant variant;
  final AppButtonSize size;
  final bool isLoading;
  final bool isExpanded;
  final IconData? leadingIcon;
  final IconData? trailingIcon;

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

    return IgnorePointer(
      ignoring: isLoading,
      child: isExpanded
          ? SizedBox(width: double.infinity, child: button)
          : button,
    );
  }

  ButtonStyle _style(ThemeData theme) {
    final cs = theme.colorScheme;
    final base = ButtonStyle(
      minimumSize: WidgetStatePropertyAll(Size(0, size.height)),
      padding: WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: size.hPadding),
      ),
      textStyle: WidgetStatePropertyAll(theme.textTheme.labelLarge),
    );
    if (variant != AppButtonVariant.danger) return base;

    return base.copyWith(
      backgroundColor: WidgetStateProperty.resolveWith(
        (s) => s.contains(WidgetState.disabled)
            ? cs.onSurface.withValues(alpha: 0.12)
            : cs.error,
      ),
      foregroundColor: WidgetStateProperty.resolveWith(
        (s) => s.contains(WidgetState.disabled)
            ? cs.onSurface.withValues(alpha: 0.38)
            : cs.onError,
      ),
    );
  }
}

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
