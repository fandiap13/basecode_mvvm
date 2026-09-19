import 'package:basecode/core/theme/app_colors.dart';
import 'package:basecode/core/theme/app_radius.dart';
import 'package:basecode/core/theme/app_spacing.dart';
import 'package:basecode/core/widgets/button/app_button.dart';
import 'package:flutter/material.dart';

// nada pesan
enum AppFeedbackTone { info, success, warning, danger }

/// Kumpulan pembantu dialog dan snackbar.
///
/// Dibuat sebagai fungsi, bukan widget, karena semuanya memanggil
/// `showDialog` / `ScaffoldMessenger` yang butuh BuildContext dari view.
abstract final class AppFeedback {
  /// Snackbar singkat di bawah layar.
  static void snackbar(
    BuildContext context, {
    required String message,
    AppFeedbackTone tone = AppFeedbackTone.info,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 3),
  }) {
    final c = Theme.of(context).appColors;
    final (warna, ikon) = _toneOf(c, tone);

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(ikon, color: c.surface, size: 20),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: Text(message)),
            ],
          ),
          backgroundColor: warna,
          behavior: SnackBarBehavior.floating,
          duration: duration,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          action: actionLabel != null
              ? SnackBarAction(
                  label: actionLabel,
                  textColor: c.surface,
                  onPressed: onAction ?? () {},
                )
              : null,
        ),
      );
  }

  /// Dialog konfirmasi. Mengembalikan true bila pengguna menyetujui.
  static Future<bool> confirm(
    BuildContext context, {
    required String title,
    String? message,
    String confirmLabel = 'Ya',
    String cancelLabel = 'Batal',
    AppFeedbackTone tone = AppFeedbackTone.info,
  }) async {
    final hasil = await showDialog<bool>(
      context: context,
      builder: (context) => _Dialog(
        title: title,
        message: message,
        tone: tone,
        actions: [
          AppButton(
            label: cancelLabel,
            variant: AppButtonVariant.text,
            onPressed: () => Navigator.of(context).pop(false),
          ),
          const SizedBox(width: AppSpacing.sm),
          AppButton(
            label: confirmLabel,
            variant: tone == AppFeedbackTone.danger
                ? AppButtonVariant.danger
                : AppButtonVariant.primary,
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );

    return hasil ?? false;
  }

  /// Dialog pemberitahuan dengan satu tombol.
  static Future<void> alert(
    BuildContext context, {
    required String title,
    String? message,
    String closeLabel = 'Tutup',
    AppFeedbackTone tone = AppFeedbackTone.info,
  }) {
    return showDialog<void>(
      context: context,
      builder: (context) => _Dialog(
        title: title,
        message: message,
        tone: tone,
        actions: [
          AppButton(
            label: closeLabel,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  static (Color, IconData) _toneOf(AppColorsTheme c, AppFeedbackTone tone) {
    return switch (tone) {
      AppFeedbackTone.info => (c.info, Icons.info_outline),
      AppFeedbackTone.success => (c.success, Icons.check_circle_outline),
      AppFeedbackTone.warning => (c.warning, Icons.warning_amber_outlined),
      AppFeedbackTone.danger => (c.danger, Icons.error_outline),
    };
  }
}

class _Dialog extends StatelessWidget {
  const _Dialog({
    required this.title,
    required this.actions,
    this.message,
    this.tone = AppFeedbackTone.info,
  });

  final String title;
  final String? message;
  final AppFeedbackTone tone;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = theme.appColors;
    final (warna, ikon) = AppFeedback._toneOf(c, tone);

    return AlertDialog(
      backgroundColor: c.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      icon: Icon(ikon, color: warna, size: 32),
      title: Text(title, textAlign: TextAlign.center),
      titleTextStyle: theme.textTheme.titleMedium,
      content: message != null
          ? Text(
              message!,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(color: c.inkSoft),
            )
          : null,
      actionsAlignment: MainAxisAlignment.center,
      actions: actions,
    );
  }
}
