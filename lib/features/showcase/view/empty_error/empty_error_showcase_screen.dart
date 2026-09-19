import 'package:basecode/core/theme/app_colors.dart';
import 'package:basecode/core/theme/app_spacing.dart';
import 'package:basecode/core/widgets/card/app_card.dart';
import 'package:basecode/core/widgets/state_view/app_state_view.dart';
import 'package:basecode/features/showcase/view/widgets/section_showcase.dart';
import 'package:flutter/material.dart';

/// Etalase sementara untuk widget di `core/widgets/`.
/// Hapus setelah layar asli pertama dibuat.
class EmptyErrorShowcaseScreen extends StatefulWidget {
  const EmptyErrorShowcaseScreen({super.key});

  @override
  State<EmptyErrorShowcaseScreen> createState() =>
      EmptyErrorShowcaseScreenState();
}

class EmptyErrorShowcaseScreenState extends State<EmptyErrorShowcaseScreen> {
  // State lokal layar: cukup setState, belum perlu viewmodel.
  int _aksiCount = 0;

  void _onAksi() => setState(() => _aksiCount++);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.surface,
        title: Text(
          'Empty & Error',
          style: theme.textTheme.titleLarge?.copyWith(color: AppColors.paper),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          const SectionShowcase(
            'Empty',
            description:
                'Belum ada data sama sekali. Tombol aksi biasanya '
                'mengarah ke pembuatan data pertama.',
          ),
          AppCard(
            child: AppStateView.empty(
              message: 'Tambahkan item pertama untuk memulai.',
              actionLabel: 'Tambah item',
              onAction: _onAksi,
            ),
          ),

          const SectionShowcase(
            'Error',
            description:
                'Gagal memuat. Hanya jenis ini yang diwarnai '
                'danger; sisanya netral.',
          ),
          AppCard(
            child: AppStateView.error(
              message:
                  'Tidak dapat memuat data. Periksa koneksi lalu '
                  'coba lagi.',
              onAction: _onAksi,
            ),
          ),

          const SectionShowcase(
            'Offline',
            description: 'Perangkat tidak terhubung ke jaringan.',
          ),
          AppCard(
            child: AppStateView.offline(
              message: 'Sambungkan ke internet untuk melanjutkan.',
              actionLabel: 'Muat ulang',
              onAction: _onAksi,
            ),
          ),

          const SectionShowcase(
            'Search',
            description: 'Pencarian tidak menemukan hasil.',
          ),
          AppCard(
            child: AppStateView.search(
              message: 'Tidak ada hasil untuk "wangdef".',
            ),
          ),

          const SectionShowcase(
            'Tanpa aksi',
            description:
                'onAction dikosongkan bila tidak ada yang bisa '
                'dilakukan pengguna.',
          ),
          const AppCard(
            child: AppStateView.empty(
              message: 'Riwayat akan muncul setelah transaksi pertama.',
            ),
          ),

          const SectionShowcase(
            'Compact',
            description:
                'Versi ringkas untuk bagian kecil di dalam '
                'halaman, bukan satu layar penuh.',
          ),
          AppCard(
            child: AppStateView.error(
              compact: true,
              title: 'Gagal memuat grafik',
              onAction: _onAksi,
            ),
          ),

          const SectionShowcase(
            'Kustom',
            description: 'Judul, pesan, dan ikon dapat diganti seluruhnya.',
          ),
          AppCard(
            child: AppStateView.empty(
              icon: Icons.shopping_cart_outlined,
              title: 'Keranjang kosong',
              message: 'Yuk, pilih barang dulu.',
              actionLabel: 'Belanja sekarang',
              onAction: _onAksi,
            ),
          ),

          const SizedBox(height: AppSpacing.md),
          Text('Aksi ditekan: $_aksiCount', style: theme.textTheme.bodyMedium),

          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}
