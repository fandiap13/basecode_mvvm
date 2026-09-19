import 'package:basecode/core/theme/app_colors.dart';
import 'package:basecode/core/theme/app_spacing.dart';
import 'package:basecode/core/widgets/bottom_sheet/app_bottom_sheet.dart';
import 'package:basecode/core/widgets/button/app_button.dart';
import 'package:basecode/core/widgets/text_field/app_text_field.dart';
import 'package:flutter/material.dart';

import 'package:basecode/features/showcase/view/widgets/section_showcase.dart';

/// Etalase sementara untuk widget di `core/widgets/`.
/// Hapus setelah layar asli pertama dibuat.
class BottomSheetShowcaseScreen extends StatefulWidget {
  const BottomSheetShowcaseScreen({super.key});

  @override
  State<BottomSheetShowcaseScreen> createState() =>
      BottomSheetShowcaseScreenState();
}

class BottomSheetShowcaseScreenState extends State<BottomSheetShowcaseScreen> {
  // State lokal layar: cukup setState, belum perlu viewmodel.
  String _hasil = '-';
  String _urutan = 'terbaru';

  Future<void> _sheetDasar() async {
    await AppBottomSheet.show<void>(
      context,
      title: 'Detail pesanan',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nomor: INV-00123',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: AppSpacing.sm),
          const Text('Status: Sedang dikirim'),
          const SizedBox(height: AppSpacing.lg),
          AppButton(
            label: 'Tutup',
            isExpanded: true,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Future<void> _sheetPilihan() async {
    final pilihan = await AppBottomSheet.showOptions<String>(
      context,
      title: 'Urutkan berdasarkan',
      selected: _urutan,
      options: const [
        AppBottomSheetOption(
          value: 'terbaru',
          label: 'Terbaru',
          icon: Icons.schedule,
        ),
        AppBottomSheetOption(
          value: 'termurah',
          label: 'Harga terendah',
          icon: Icons.arrow_downward,
        ),
        AppBottomSheetOption(
          value: 'termahal',
          label: 'Harga tertinggi',
          icon: Icons.arrow_upward,
        ),
        AppBottomSheetOption(
          value: 'populer',
          label: 'Paling populer',
          subtitle: 'Berdasarkan jumlah pembelian',
          icon: Icons.local_fire_department_outlined,
        ),
      ],
    );

    if (!mounted || pilihan == null) return;
    setState(() {
      _urutan = pilihan;
      _hasil = 'Urutan: $pilihan';
    });
  }

  Future<void> _sheetPanjang() async {
    await AppBottomSheet.showScrollable<void>(
      context,
      title: 'Syarat & ketentuan',
      builder: (context, controller) => ListView.builder(
        controller: controller,
        padding: EdgeInsets.zero,
        itemCount: 30,
        itemBuilder: (context, index) => ListTile(
          dense: true,
          leading: Text('${index + 1}'),
          title: Text('Ketentuan nomor ${index + 1}'),
        ),
      ),
    );
  }

  Future<void> _sheetForm() async {
    final controller = TextEditingController();

    final catatan = await AppBottomSheet.show<String>(
      context,
      title: 'Tambah catatan',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppTextField(
            controller: controller,
            label: 'Catatan',
            hint: 'Tulis catatan untuk penjual',
            maxLines: 3,
          ),
          const SizedBox(height: AppSpacing.md),
          AppButton(
            label: 'Simpan',
            isExpanded: true,
            onPressed: () => Navigator.of(context).pop(controller.text),
          ),
        ],
      ),
    );

    controller.dispose();
    if (!mounted || catatan == null) return;
    setState(() => _hasil = catatan.isEmpty ? 'Catatan kosong' : catatan);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.surface,
        title: Text(
          'Bottom Sheet',
          style: theme.textTheme.titleLarge?.copyWith(color: AppColors.paper),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          const SectionShowcase(
            'Modal dasar',
            description:
                'Tinggi mengikuti isi. Ada gagang di atas dan '
                'judul opsional.',
          ),
          AppButton(
            label: 'Buka sheet',
            isExpanded: true,
            onPressed: _sheetDasar,
          ),

          const SectionShowcase(
            'Daftar pilihan',
            description:
                'showOptions mengembalikan nilai yang dipilih; '
                'yang aktif ditandai centang.',
          ),
          AppButton(
            label: 'Pilih urutan',
            isExpanded: true,
            variant: AppButtonVariant.outline,
            onPressed: _sheetPilihan,
          ),

          const SectionShowcase(
            'Dapat ditarik',
            description:
                'showScrollable untuk isi panjang; tinggi sheet '
                'bisa ditarik naik-turun.',
          ),
          AppButton(
            label: 'Buka daftar panjang',
            isExpanded: true,
            variant: AppButtonVariant.outline,
            onPressed: _sheetPanjang,
          ),

          const SectionShowcase(
            'Berisi form',
            description:
                'Sheet ikut naik saat papan ketik muncul, jadi '
                'kolom input tidak tertutup.',
          ),
          AppButton(
            label: 'Tambah catatan',
            isExpanded: true,
            variant: AppButtonVariant.secondary,
            onPressed: _sheetForm,
          ),

          const SizedBox(height: AppSpacing.lg),
          Text('Hasil terakhir: $_hasil', style: theme.textTheme.bodyMedium),

          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}
