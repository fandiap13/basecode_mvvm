import 'package:basecode/core/theme/app_colors.dart';
import 'package:basecode/core/theme/app_radius.dart';
import 'package:flutter/material.dart';

// variant
enum AppProgressVariant { primary, secondary, danger, warning, info, dark }

// widget
class AppProgress extends StatelessWidget {
  const AppProgress({
    super.key,
    this.value,
    this.label,
    this.showPercentage = false,
    this.variant = AppProgressVariant.primary,
    this.barColor,
    this.minHeight = 8,
    this.radius = AppRadius.sm,
  });

  // 0.0 - 1.0; null = berjalan terus (tak tentu).
  final double? value;
  final String? label;
  final bool showPercentage;
  final AppProgressVariant variant;
  final Color? barColor;
  final double minHeight;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = theme.appColors;

    // Warna batang dari token tema, bukan nilai hardcode.
    final resolvedBar =
        barColor ??
        switch (variant) {
          AppProgressVariant.primary => c.primary,
          AppProgressVariant.secondary => c.secondary,
          AppProgressVariant.danger => c.danger,
          AppProgressVariant.warning => c.warning,
          AppProgressVariant.info => c.info,
          AppProgressVariant.dark => c.ink,
        };

    // Nilai di luar 0-1 dijepit agar bar tidak meluap.
    final clamped = value?.clamp(0.0, 1.0);

    final bar = ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: LinearProgressIndicator(
        value: clamped,
        valueColor: AlwaysStoppedAnimation(resolvedBar),
        backgroundColor: resolvedBar.withValues(alpha: 0.15),
        minHeight: minHeight,
      ),
    );

    // Teks persen hanya saat nilainya pasti.
    final hasPercent = showPercentage && clamped != null;

    if (label == null && !hasPercent) return bar;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            if (label != null)
              Expanded(
                child: Text(
                  label!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            if (hasPercent)
              Text(
                '${(clamped * 100).round()}%',
                style: theme.textTheme.bodySmall?.copyWith(color: c.inkSoft),
              ),
          ],
        ),
        const SizedBox(height: 8),
        bar,
      ],
    );
  }
}
