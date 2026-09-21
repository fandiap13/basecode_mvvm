import 'package:basecode/core/theme/app_colors.dart';
import 'package:basecode/core/theme/app_spacing.dart';
import 'package:basecode/core/widgets/tab/app_tab_bussines.dart';
import 'package:basecode/features/showcase/view/widgets/section_showcase.dart';
import 'package:flutter/material.dart';

/// Etalase sementara untuk widget di `core/widgets/`.
/// Hapus setelah layar asli pertama dibuat.
///
/// AppTabBussines memakai Expanded di dalamnya, jadi tiap contoh dibungkus
/// SizedBox setinggi tetap agar bisa tampil di dalam ListView.
class TabBussinesShowcaseScreen extends StatefulWidget {
  const TabBussinesShowcaseScreen({super.key});

  @override
  State<TabBussinesShowcaseScreen> createState() =>
      TabBussinesShowcaseScreenState();
}

class TabBussinesShowcaseScreenState extends State<TabBussinesShowcaseScreen> {
  // State lokal layar: cukup setState, belum perlu viewmodel.
  static const _tabs = ['Beranda', 'Pesanan', 'Profil'];

  static const _keterangan = ['Ringkasan', '3 aktif', 'Akun saya'];

  static List<Widget> _isi(
    BuildContext context,
    String nama, [
    int jumlah = 3,
  ]) => [
    for (var i = 1; i <= jumlah; i++)
      Center(
        child: Text('$nama $i', style: Theme.of(context).textTheme.bodyMedium),
      ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.surface,
        title: Text(
          'App Tab Bussines',
          style: theme.textTheme.titleLarge?.copyWith(color: AppColors.paper),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          const SectionShowcase(
            'Dasar',
            description:
                'tabs dan children harus sama jumlahnya; urutannya '
                'berpasangan. Tab aktif menyatu dengan panel di bawahnya, '
                'dan ditandai batang kecil di atasnya.',
          ),
          SizedBox(
            height: 205,
            child: AppTabBussines(
              tabs: _tabs,
              children: _isi(context, 'Konten'),
            ),
          ),

          const SectionShowcase(
            'Keterangan',
            description:
                'descriptions menambah baris kecil di bawah judul '
                'tiap tab. Isi null untuk tab tanpa keterangan.',
          ),
          SizedBox(
            height: 225,
            child: AppTabBussines(
              tabs: _tabs,
              descriptions: _keterangan,
              children: _isi(context, 'Konten'),
            ),
          ),

          const SectionShowcase(
            'Variant',
            description:
                'Menentukan warna label tab aktif, keterangannya, dan '
                'batang penanda di atasnya. Diambil dari token tema.',
          ),
          for (final variant in AppTabBussinesVariant.values)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(variant.name, style: theme.textTheme.bodyMedium),
                  const SizedBox(height: AppSpacing.xs),
                  SizedBox(
                    height: 165,
                    child: AppTabBussines(
                      variant: variant,
                      tabs: _tabs,
                      children: _isi(context, 'Konten'),
                    ),
                  ),
                ],
              ),
            ),

          const SectionShowcase(
            'Size',
            description:
                'Tiap ukuran membawa metrik sendiri (fontSize, '
                'horizontalPadding).',
          ),
          for (final size in AppTabBussinesSize.values)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(size.name, style: theme.textTheme.bodyMedium),
                  const SizedBox(height: AppSpacing.xs),
                  SizedBox(
                    height: 165,
                    child: AppTabBussines(
                      size: size,
                      tabs: _tabs,
                      children: _isi(context, 'Konten'),
                    ),
                  ),
                ],
              ),
            ),

          const SectionShowcase(
            'Scrollable',
            description:
                'isScrollable untuk tab yang banyak; bilah bisa '
                'digeser ke samping. Penanda tetap mengikuti tab aktif, '
                'tapi sambungan garis tidak dipakai di sini karena lebar '
                'tab tidak seragam.',
          ),
          SizedBox(
            height: 205,
            child: AppTabBussines(
              isScrollable: true,
              tabs: const [
                'Semua',
                'Menunggu',
                'Diproses',
                'Dikirim',
                'Selesai',
                'Batal',
              ],
              children: _isi(context, 'Pesanan', 6),
            ),
          ),

          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}
