import 'package:basecode/core/theme/app_colors.dart';
import 'package:basecode/core/theme/app_spacing.dart';
import 'package:basecode/core/widgets/tab/app_tab.dart';
import 'package:basecode/features/showcase/view/widgets/section_showcase.dart';
import 'package:flutter/material.dart';

/// Etalase sementara untuk widget di `core/widgets/`.
/// Hapus setelah layar asli pertama dibuat.
///
/// AppTab memakai Expanded di dalamnya, jadi tiap contoh dibungkus
/// SizedBox setinggi tetap agar bisa tampil di dalam ListView.
class TabShowcaseScreen extends StatefulWidget {
  const TabShowcaseScreen({super.key});

  @override
  State<TabShowcaseScreen> createState() => TabShowcaseScreenState();
}

class TabShowcaseScreenState extends State<TabShowcaseScreen> {
  // State lokal layar: cukup setState, belum perlu viewmodel.
  static const _tabs = [
    Tab(text: 'Beranda'),
    Tab(text: 'Pesanan'),
    Tab(text: 'Profil'),
  ];

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
          'App Tab',
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
                'berpasangan.',
          ),
          SizedBox(
            height: 200,
            child: AppTab(tabs: _tabs, children: _isi(context, 'Konten')),
          ),

          const SectionShowcase(
            'Variant',
            description:
                'Menentukan warna label aktif dan garis penanda. '
                'Diambil dari token tema.',
          ),
          for (final variant in AppTabVariant.values)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(variant.name, style: theme.textTheme.bodyMedium),
                  const SizedBox(height: AppSpacing.xs),
                  SizedBox(
                    height: 160,
                    child: AppTab(
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
          for (final size in AppTabSize.values)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(size.name, style: theme.textTheme.bodyMedium),
                  const SizedBox(height: AppSpacing.xs),
                  SizedBox(
                    height: 160,
                    child: AppTab(
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
                'digeser ke samping.',
          ),
          SizedBox(
            height: 200,
            child: AppTab(
              isScrollable: true,
              tabs: const [
                Tab(text: 'Semua'),
                Tab(text: 'Menunggu'),
                Tab(text: 'Diproses'),
                Tab(text: 'Dikirim'),
                Tab(text: 'Selesai'),
                Tab(text: 'Batal'),
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
