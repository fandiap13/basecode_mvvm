import 'package:basecode/core/theme/app_colors.dart';
import 'package:basecode/core/theme/app_spacing.dart';
import 'package:basecode/core/widgets/button/app_button.dart';
import 'package:flutter/material.dart';

// jenis keadaan
enum AppStateViewKind { empty, error, offline, search }

/// Penampil keadaan non-sukses: kosong, galat, offline, hasil cari nihil.
///
/// Strukturnya sama untuk semua jenis (ikon, judul, pesan, tombol aksi),
/// jadi dibuat satu widget agar tidak ada duplikasi.
class AppStateView extends StatelessWidget {
  const AppStateView({
    super.key,
    required this.kind,
    this.title,
    this.message,
    this.icon,
    this.actionLabel,
    this.onAction,
    this.compact = false,
  });

  /// Tidak ada data sama sekali.
  const AppStateView.empty({
    Key? key,
    String? title,
    String? message,
    IconData? icon,
    String? actionLabel,
    VoidCallback? onAction,
    bool compact = false,
  }) : this(
         key: key,
         kind: AppStateViewKind.empty,
         title: title,
         message: message,
         icon: icon,
         actionLabel: actionLabel,
         onAction: onAction,
         compact: compact,
       );

  /// Gagal memuat; biasanya disertai tombol coba lagi.
  const AppStateView.error({
    Key? key,
    String? title,
    String? message,
    IconData? icon,
    String? actionLabel,
    VoidCallback? onAction,
    bool compact = false,
  }) : this(
         key: key,
         kind: AppStateViewKind.error,
         title: title,
         message: message,
         icon: icon,
         actionLabel: actionLabel,
         onAction: onAction,
         compact: compact,
       );

  /// Tidak ada koneksi.
  const AppStateView.offline({
    Key? key,
    String? title,
    String? message,
    IconData? icon,
    String? actionLabel,
    VoidCallback? onAction,
    bool compact = false,
  }) : this(
         key: key,
         kind: AppStateViewKind.offline,
         title: title,
         message: message,
         icon: icon,
         actionLabel: actionLabel,
         onAction: onAction,
         compact: compact,
       );

  /// Pencarian tidak menemukan apa pun.
  const AppStateView.search({
    Key? key,
    String? title,
    String? message,
    IconData? icon,
    String? actionLabel,
    VoidCallback? onAction,
    bool compact = false,
  }) : this(
         key: key,
         kind: AppStateViewKind.search,
         title: title,
         message: message,
         icon: icon,
         actionLabel: actionLabel,
         onAction: onAction,
         compact: compact,
       );

  final AppStateViewKind kind;

  final String? title;
  final String? message;
  final IconData? icon;

  final String? actionLabel;
  final VoidCallback? onAction;

  /// Versi ringkas untuk dipakai di dalam kartu atau bagian kecil.
  final bool compact;

  /// Judul bawaan per jenis; ditimpa bila [title] diisi.
  String get _defaultTitle => switch (kind) {
    AppStateViewKind.empty => 'Belum ada data',
    AppStateViewKind.error => 'Terjadi kesalahan',
    AppStateViewKind.offline => 'Tidak ada koneksi',
    AppStateViewKind.search => 'Tidak ditemukan',
  };

  IconData get _defaultIcon => switch (kind) {
    AppStateViewKind.empty => Icons.inbox_outlined,
    AppStateViewKind.error => Icons.error_outline,
    AppStateViewKind.offline => Icons.wifi_off_outlined,
    AppStateViewKind.search => Icons.search_off_outlined,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = theme.appColors;

    // Hanya galat yang diwarnai; sisanya netral agar tidak terlalu ramai.
    final warna = kind == AppStateViewKind.error ? c.danger : c.inkFaint;
    final ukuranIkon = compact ? 40.0 : 64.0;

    return Padding(
      padding: EdgeInsets.all(compact ? AppSpacing.md : AppSpacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon ?? _defaultIcon, size: ukuranIkon, color: warna),
          SizedBox(height: compact ? AppSpacing.sm : AppSpacing.md),
          Text(
            title ?? _defaultTitle,
            textAlign: TextAlign.center,
            style: compact
                ? theme.textTheme.titleSmall
                : theme.textTheme.titleMedium,
          ),
          if (message != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              message!,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(color: c.inkSoft),
            ),
          ],
          if (onAction != null) ...[
            SizedBox(height: compact ? AppSpacing.md : AppSpacing.lg),
            AppButton(
              label: actionLabel ?? 'Coba lagi',
              variant: kind == AppStateViewKind.error
                  ? AppButtonVariant.primary
                  : AppButtonVariant.outline,
              size: compact ? AppButtonSize.small : AppButtonSize.medium,
              onPressed: onAction,
            ),
          ],
        ],
      ),
    );
  }
}
