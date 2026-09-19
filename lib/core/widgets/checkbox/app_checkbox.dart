import 'package:basecode/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

// variant
enum AppCheckboxVariant { primary, secondary, danger, warning, info, dark }

// widget
class AppCheckbox extends StatelessWidget {
  const AppCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.subtitle,
    this.tristate = false,
    this.variant = AppCheckboxVariant.primary,
    this.activeColor,
    this.enabled = true,
  });

  final bool value;
  final ValueChanged<bool?>? onChanged; // null = nonaktif
  final String? label;
  final String? subtitle;
  final bool tristate;
  final AppCheckboxVariant variant;
  final Color? activeColor;
  final bool enabled;

  bool get _isEnabled => enabled && onChanged != null;

  // Ketuk label ikut mengubah nilai, seperti CheckboxListTile.
  void _toggle() {
    if (!_isEnabled) return;
    onChanged!(!value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = theme.appColors;

    // Warna centang dari token tema, bukan nilai hardcode.
    final resolvedActive =
        activeColor ??
        switch (variant) {
          AppCheckboxVariant.primary => c.primary,
          AppCheckboxVariant.secondary => c.secondary,
          AppCheckboxVariant.danger => c.danger,
          AppCheckboxVariant.warning => c.warning,
          AppCheckboxVariant.info => c.info,
          AppCheckboxVariant.dark => c.ink,
        };

    final box = Checkbox(
      value: value,
      onChanged: _isEnabled ? onChanged : null,
      tristate: tristate,
      activeColor: resolvedActive,
      checkColor: c.surface,
      side: BorderSide(color: c.line),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );

    if (label == null) return box;

    return InkWell(
      onTap: _isEnabled ? _toggle : null,
      borderRadius: BorderRadius.circular(8),
      child: Row(
        children: [
          box,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: _isEnabled ? c.ink : c.inkFaint,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: c.inkSoft,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// widget
class AppRadio<T> extends StatelessWidget {
  const AppRadio({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.label,
    this.subtitle,
    this.variant = AppCheckboxVariant.primary,
    this.activeColor,
    this.enabled = true,
  });

  final T value;
  final T? groupValue;
  final ValueChanged<T?>? onChanged; // null = nonaktif
  final String? label;
  final String? subtitle;
  final AppCheckboxVariant variant;
  final Color? activeColor;
  final bool enabled;

  bool get _isEnabled => enabled && onChanged != null;

  // Ketuk label ikut memilih nilai ini.
  void _select() {
    if (!_isEnabled) return;
    onChanged!(value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = theme.appColors;

    // Warna pilihan dari token tema, bukan nilai hardcode.
    final resolvedActive =
        activeColor ??
        switch (variant) {
          AppCheckboxVariant.primary => c.primary,
          AppCheckboxVariant.secondary => c.secondary,
          AppCheckboxVariant.danger => c.danger,
          AppCheckboxVariant.warning => c.warning,
          AppCheckboxVariant.info => c.info,
          AppCheckboxVariant.dark => c.ink,
        };

    final button = RadioGroup<T>(
      // Grup wajib punya onChanged; saat nonaktif diberi noop dan
      // tombolnya dimatikan lewat `enabled` agar pudar dan tak merespons.
      groupValue: groupValue,
      onChanged: onChanged ?? (_) {},
      child: Radio<T>(
        value: value,
        enabled: _isEnabled,
        activeColor: resolvedActive,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      ),
    );

    if (label == null) return button;

    return InkWell(
      onTap: _isEnabled ? _select : null,
      borderRadius: BorderRadius.circular(8),
      child: Row(
        children: [
          button,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: _isEnabled ? c.ink : c.inkFaint,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: c.inkSoft,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
