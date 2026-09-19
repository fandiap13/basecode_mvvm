import 'package:basecode/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

// widget
class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AppAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.actions,
    this.centerTitle = false,
    this.backgroundColor,
    this.automaticallyImplyLeading = true,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final List<Widget>? actions;
  final bool centerTitle;
  final Color? backgroundColor;
  final bool automaticallyImplyLeading;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = theme.appColors;

    return AppBar(
      // Warna default dari token tema, bukan nilai hardcode.
      backgroundColor: backgroundColor ?? c.primary,
      foregroundColor: c.surface,
      centerTitle: centerTitle,
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: leading,
      actions: actions,
      title: subtitle == null
          ? Text(title)
          : Column(
              crossAxisAlignment: centerTitle
                  ? CrossAxisAlignment.center
                  : CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(
                  subtitle!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: c.surface.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
      titleTextStyle: theme.textTheme.titleLarge?.copyWith(color: c.surface),
    );
  }
}
