import 'package:basecode/core/theme/app_colors.dart';
import 'package:basecode/core/theme/app_radius.dart';
import 'package:flutter/material.dart';

// widget
class AppCard extends StatefulWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.radius = AppRadius.lg,
    this.onTap,
    this.isLoading = false,
    this.isExpanded = false,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final double radius;
  final VoidCallback? onTap; // null = tidak bisa diketuk
  final bool isLoading;
  final bool isExpanded;

  static void _noop() {}

  @override
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardTheme = theme.cardTheme;
    final callback = (widget.isLoading && widget.onTap != null)
        ? AppCard._noop
        : widget.onTap;
    final borderRadius = BorderRadius.circular(widget.radius);

    Widget content = widget.padding == null
        ? widget.child
        : Padding(padding: widget.padding!, child: widget.child);

    // InkWell dipasang di dalam Card agar ripple terpotong mengikuti sudut
    // dan card tetap punya focus + semantics. Tanpa onTap tidak dibungkus
    // supaya card biasa tidak ikut menangkap gesture.
    if (widget.onTap != null) {
      content = InkWell(
        onTap: () {
          // debugPrint("Tab Card");
          callback?.call();
        },
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return theme.appColors.primary.withValues(alpha: 0.08);
          }

          if (states.contains(WidgetState.hovered)) {
            return theme.appColors.primary.withValues(alpha: 0.04);
          }

          return null;
        }),
        onHighlightChanged: (value) {
          setState(() {
            _isPressed = value;
          });
        },
        borderRadius: borderRadius,
        child: content,
      );
    }

    // Warna, elevation, dan margin default diambil dari cardTheme.
    // Shape ditimpa karena radius bisa dikustom per card, tapi border-nya
    // tetap ikut tema supaya tidak ada nilai hardcode di sini.

    final side = switch (cardTheme.shape) {
      final RoundedRectangleBorder shape => BorderSide(
        color: _isPressed ? theme.appColors.primary : shape.side.color,
        width: shape.side.width,
      ),
      _ => BorderSide(
        color: _isPressed ? theme.appColors.primary : theme.appColors.line,
      ),
    };

    final Widget card = Card(
      margin: widget.margin,
      color: widget.color,
      shape: RoundedRectangleBorder(borderRadius: borderRadius, side: side),
      child: content,
    );

    // memblokir interaksi tap saat loading
    return IgnorePointer(
      ignoring: widget.isLoading,
      child: widget.isExpanded
          ? SizedBox(width: double.infinity, child: card)
          : card,
    );
  }
}
