import 'package:basecode/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

// widget
class AppLoading extends StatelessWidget {
  const AppLoading({
    super.key,
    this.label,
    this.size = 32,
    this.color,
    this.strokeWidth = 3,
  });

  final String? label;
  final double size;
  final Color? color;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = theme.appColors;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox.square(
          dimension: size,
          child: CircularProgressIndicator(
            strokeWidth: strokeWidth,
            // Warna default dari token tema, bukan nilai hardcode.
            color: color ?? c.primary,
          ),
        ),
        if (label != null) ...[
          const SizedBox(height: 12),
          Text(
            label!,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(color: c.inkSoft),
          ),
        ],
      ],
    );
  }
}
