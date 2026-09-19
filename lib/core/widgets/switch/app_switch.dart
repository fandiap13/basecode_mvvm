import 'package:basecode/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

// variant
enum AppSwitchVariant { primary, secondary, danger, warning, info, dark }

// widget
class AppSwitch extends StatelessWidget {
  const AppSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.subtitle,
    this.variant = AppSwitchVariant.primary,
    this.activeColor,
    this.enabled = true,
  });

  final bool value;
  final ValueChanged<bool>? onChanged; // null = nonaktif
  final String? label;
  final String? subtitle;
  final AppSwitchVariant variant;
  final Color? activeColor;
  final bool enabled;

  bool get _isEnabled => enabled && onChanged != null;

  // Ketuk label ikut mengubah nilai.
  void _toggle() {
    if (!_isEnabled) return;
    onChanged!(!value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = theme.appColors;

    // Warna aktif dari token tema, bukan nilai hardcode.
    final resolvedActive =
        activeColor ??
        switch (variant) {
          AppSwitchVariant.primary => c.primary,
          AppSwitchVariant.secondary => c.secondary,
          AppSwitchVariant.danger => c.danger,
          AppSwitchVariant.warning => c.warning,
          AppSwitchVariant.info => c.info,
          AppSwitchVariant.dark => c.ink,
        };

    final control = Switch(
      value: value,
      onChanged: _isEnabled ? onChanged : null,
      activeThumbColor: resolvedActive,
      activeTrackColor: resolvedActive.withValues(alpha: 0.4),
      inactiveThumbColor: c.inkFaint,
      inactiveTrackColor: c.line,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );

    if (label == null) return control;

    return InkWell(
      onTap: _isEnabled ? _toggle : null,
      borderRadius: BorderRadius.circular(8),
      child: Row(
        children: [
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
          control,
        ],
      ),
    );
  }
}
