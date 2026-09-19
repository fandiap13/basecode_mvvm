import 'package:basecode/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

enum AppSliderVariant {
  primary,
  secondary,
  success,
  warning,
  danger,
  info,
  dark,
}

enum AppSliderSize {
  small(trackHeight: 4, thumbRadius: 8),
  medium(trackHeight: 6, thumbRadius: 10),
  large(trackHeight: 8, thumbRadius: 12);

  const AppSliderSize({required this.trackHeight, required this.thumbRadius});

  final double trackHeight;
  final double thumbRadius;
}

class AppSlider extends StatelessWidget {
  const AppSlider({
    super.key,
    required this.value,
    this.min = 0,
    this.max = 100,
    this.divisions,
    this.label,
    this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.enabled = true,
    this.showValue = false,
    this.valueFormatter,
    this.variant = AppSliderVariant.primary,
    this.size = AppSliderSize.medium,
  });

  final double value;
  final double min;
  final double max;
  final int? divisions;

  final String? label;

  final ValueChanged<double>? onChanged;
  final ValueChanged<double>? onChangeStart;
  final ValueChanged<double>? onChangeEnd;

  final bool enabled;
  final bool showValue;
  final String Function(double value)? valueFormatter;

  final AppSliderVariant variant;
  final AppSliderSize size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = theme.appColors;

    final sliderColor = switch (variant) {
      AppSliderVariant.primary => c.primary,
      AppSliderVariant.secondary => c.secondary,
      AppSliderVariant.success => c.success,
      AppSliderVariant.warning => c.warning,
      AppSliderVariant.danger => c.danger,
      AppSliderVariant.info => c.info,
      AppSliderVariant.dark => c.ink,
    };

    final displayValue = valueFormatter?.call(value) ?? value.toString();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null || showValue)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (label != null)
                Text(label!, style: theme.textTheme.labelMedium),
              if (showValue)
                Text(displayValue, style: theme.textTheme.labelMedium),
            ],
          ),
        if (label != null || showValue) const SizedBox(height: 4),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: sliderColor,
            inactiveTrackColor: sliderColor.withValues(alpha: 0.15),
            thumbColor: sliderColor,
            overlayColor: sliderColor.withValues(alpha: 0.12),
            trackHeight: size.trackHeight,
            thumbShape: RoundSliderThumbShape(
              enabledThumbRadius: size.thumbRadius,
            ),
          ),
          child: Slider(
            value: value.clamp(min, max),
            min: min,
            max: max,
            divisions: divisions,
            label: label,
            onChanged: enabled ? onChanged : null,
            onChangeStart: onChangeStart,
            onChangeEnd: onChangeEnd,
          ),
        ),
      ],
    );
  }
}
