import 'package:basecode/core/theme/app_colors.dart';
import 'package:basecode/core/theme/app_spacing.dart';
import 'package:basecode/core/widgets/button/app_button.dart';
import 'package:basecode/core/widgets/feedback/app_feedback.dart';
import 'package:basecode/features/showcase/view/widgets/section_showcase.dart';
import 'package:flutter/material.dart';

/// Etalase sementara untuk widget di `core/widgets/`.
/// Hapus setelah layar asli pertama dibuat.
class FeedbackShowcaseScreen extends StatefulWidget {
  const FeedbackShowcaseScreen({super.key});

  @override
  State<FeedbackShowcaseScreen> createState() => FeedbackShowcaseScreenState();
}

class FeedbackShowcaseScreenState extends State<FeedbackShowcaseScreen> {
  // State lokal layar: cukup setState, belum perlu viewmodel.
  String _hasil = '-';

  Future<void> _konfirmasiHapus() async {
    final setuju = await AppFeedback.confirm(
      context,
      title: 'Hapus item ini?',
      message: 'Tindakan ini tidak dapat dibatalkan.',
      confirmLabel: 'Hapus',
      tone: AppFeedbackTone.danger,
    );

    if (!mounted) return;
    setState(() => _hasil = setuju ? 'Dikonfirmasi hapus' : 'Dibatalkan');
  }

  Future<void> _konfirmasiSimpan() async {
    final setuju = await AppFeedback.confirm(
      context,
      title: 'Simpan perubahan?',
      message: 'Perubahan akan langsung berlaku.',
      confirmLabel: 'Simpan',
    );

    if (!mounted) return;
    setState(() => _hasil = setuju ? 'Disimpan' : 'Dibatalkan');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.surface,
        title: Text(
          'Feedback',
          style: theme.textTheme.titleLarge?.copyWith(color: AppColors.paper),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          const SectionShowcase(
            'Snackbar',
            description:
                'Pesan singkat di bawah layar. Nada menentukan '
                'warna dan ikonnya.',
          ),
          for (final tone in AppFeedbackTone.values)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: AppButton(
                label: 'Snackbar ${tone.name}',
                isExpanded: true,
                variant: switch (tone) {
                  AppFeedbackTone.danger => AppButtonVariant.danger,
                  AppFeedbackTone.warning => AppButtonVariant.warning,
                  AppFeedbackTone.success => AppButtonVariant.primary,
                  AppFeedbackTone.info => AppButtonVariant.info,
                },
                onPressed: () => AppFeedback.snackbar(
                  context,
                  message: 'Ini pesan bernada ${tone.name}.',
                  tone: tone,
                ),
              ),
            ),

          const SectionShowcase(
            'Snackbar dengan aksi',
            description: 'actionLabel memberi jalan keluar, mis. urungkan.',
          ),
          AppButton(
            label: 'Hapus dengan Urungkan',
            isExpanded: true,
            variant: AppButtonVariant.outline,
            onPressed: () => AppFeedback.snackbar(
              context,
              message: 'Item dihapus.',
              actionLabel: 'Urungkan',
              onAction: () => setState(() => _hasil = 'Penghapusan diurungkan'),
            ),
          ),

          const SectionShowcase(
            'Dialog konfirmasi',
            description:
                'Mengembalikan true atau false. Nada danger '
                'membuat tombol utama berwarna merah.',
          ),
          AppButton(
            label: 'Konfirmasi hapus',
            isExpanded: true,
            variant: AppButtonVariant.danger,
            onPressed: _konfirmasiHapus,
          ),
          const SizedBox(height: AppSpacing.sm),
          AppButton(
            label: 'Konfirmasi simpan',
            isExpanded: true,
            onPressed: _konfirmasiSimpan,
          ),

          const SectionShowcase(
            'Dialog pemberitahuan',
            description: 'Satu tombol; dipakai saat tidak ada pilihan.',
          ),
          AppButton(
            label: 'Tampilkan pemberitahuan',
            isExpanded: true,
            variant: AppButtonVariant.outline,
            onPressed: () => AppFeedback.alert(
              context,
              title: 'Pendaftaran berhasil',
              message: 'Silakan cek email untuk verifikasi.',
              tone: AppFeedbackTone.success,
            ),
          ),

          const SizedBox(height: AppSpacing.lg),
          Text('Hasil terakhir: $_hasil', style: theme.textTheme.bodyMedium),

          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}
