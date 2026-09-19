import 'package:basecode/core/theme/app_colors.dart';
import 'package:basecode/core/theme/app_radius.dart';
import 'package:basecode/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

/// Pembantu bottom sheet dengan gaya seragam.
abstract final class AppBottomSheet {
  /// Sheet modal biasa; tingginya mengikuti isi.
  static Future<T?> show<T>(
    BuildContext context, {
    required Widget child,
    String? title,
    bool showHandle = true,
    bool isDismissible = true,
    EdgeInsetsGeometry? padding,
  }) {
    final c = Theme.of(context).appColors;

    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: c.surface,
      isDismissible: isDismissible,
      enableDrag: isDismissible,
      // Sheet ikut naik saat papan ketik muncul.
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (context) => _Sheet(
        title: title,
        showHandle: showHandle,
        padding: padding,
        child: child,
      ),
    );
  }

  /// Sheet yang bisa ditarik tinggi-rendah, untuk isi panjang.
  static Future<T?> showScrollable<T>(
    BuildContext context, {
    required ScrollableWidgetBuilder builder,
    String? title,
    double initialSize = 0.5,
    double minSize = 0.25,
    double maxSize = 0.9,
  }) {
    final c = Theme.of(context).appColors;

    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: initialSize,
        minChildSize: minSize,
        maxChildSize: maxSize,
        expand: false,
        builder: (context, controller) => DecoratedBox(
          decoration: BoxDecoration(
            color: c.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppRadius.xl),
            ),
          ),
          child: _Sheet(title: title, child: builder(context, controller)),
        ),
      ),
    );
  }

  /// Daftar pilihan; mengembalikan nilai yang dipilih.
  static Future<T?> showOptions<T>(
    BuildContext context, {
    required List<AppBottomSheetOption<T>> options,
    String? title,
    T? selected,
  }) {
    return show<T>(
      context,
      title: title,
      padding: EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final option in options)
            ListTile(
              leading: option.icon != null ? Icon(option.icon) : null,
              title: Text(option.label),
              subtitle: option.subtitle != null ? Text(option.subtitle!) : null,
              trailing: option.value == selected
                  ? const Icon(Icons.check)
                  : null,
              onTap: () => Navigator.of(context).pop(option.value),
            ),
          const SizedBox(height: AppSpacing.sm),
        ],
      ),
    );
  }
}

/// Satu baris pilihan untuk [AppBottomSheet.showOptions].
class AppBottomSheetOption<T> {
  const AppBottomSheetOption({
    required this.value,
    required this.label,
    this.subtitle,
    this.icon,
  });

  final T value;
  final String label;
  final String? subtitle;
  final IconData? icon;
}

class _Sheet extends StatelessWidget {
  const _Sheet({
    required this.child,
    this.title,
    this.showHandle = true,
    this.padding,
  });

  final Widget child;
  final String? title;
  final bool showHandle;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = theme.appColors;

    return SafeArea(
      child: Padding(
        // Beri ruang untuk papan ketik bila sheet berisi kolom input.
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showHandle) ...[
              const SizedBox(height: AppSpacing.sm),
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: c.line,
                  borderRadius: BorderRadius.circular(AppRadius.xs),
                ),
              ),
            ],
            if (title != null) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.md,
                  AppSpacing.md,
                  AppSpacing.sm,
                ),
                child: Text(title!, style: theme.textTheme.titleMedium),
              ),
              Divider(height: 1, color: c.line),
            ],
            Flexible(
              child: Padding(
                padding: padding ?? const EdgeInsets.all(AppSpacing.md),
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
