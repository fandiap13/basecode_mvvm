import 'package:basecode/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

// widget
class AppListTile extends StatelessWidget {
  const AppListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap, // null = tidak bisa diketuk
    this.selected = false,
    this.enabled = true,
    this.dense = false,
    this.contentPadding,
  });

  final String title;
  final String? subtitle;
  final IconData? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool selected;
  final bool enabled;
  final bool dense;
  final EdgeInsetsGeometry? contentPadding;

  bool get _isEnabled => enabled && onTap != null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = theme.appColors;

    return ListTile(
      title: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: enabled ? c.ink : c.inkFaint,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(color: c.inkSoft),
            )
          : null,
      // Ikon depan memakai warna token; ikut redup saat nonaktif.
      leading: leading != null
          ? Icon(leading, color: enabled ? c.primary : c.inkFaint)
          : null,
      trailing: trailing,
      onTap: _isEnabled ? onTap : null,
      selected: selected,
      enabled: enabled,
      dense: dense,
      contentPadding: contentPadding,
      // Latar saat terpilih dari token tema, bukan nilai hardcode.
      selectedTileColor: c.primary.withValues(alpha: 0.08),
      selectedColor: c.primary,
      iconColor: c.primary,
      textColor: c.ink,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}
