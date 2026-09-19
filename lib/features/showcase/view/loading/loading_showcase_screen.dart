import 'package:basecode/core/theme/app_colors.dart';
import 'package:basecode/core/widgets/card/app_card.dart';
import 'package:basecode/core/widgets/loading/app_loading.dart';
import 'package:basecode/features/showcase/view/widgets/section_showcase.dart';
import 'package:flutter/material.dart';

/// Etalase sementara untuk widget di `core/widgets/`.
/// Hapus setelah layar asli pertama dibuat.
class LoadingShowcaseScreen extends StatelessWidget {
  const LoadingShowcaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.surface,
        title: Text(
          'App Loading',
          style: theme.textTheme.titleLarge?.copyWith(color: AppColors.paper),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SectionShowcase(
            'Dasar',
            description: 'Putaran saja, warna mengikuti token primary.',
          ),
          const Center(child: AppLoading()),

          const SectionShowcase(
            'Ukuran',
            description: 'Diameter dan ketebalan diatur pemanggil.',
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              AppLoading(size: 20, strokeWidth: 2),
              AppLoading(),
              AppLoading(size: 48, strokeWidth: 4),
            ],
          ),

          const SectionShowcase(
            'Label',
            description: 'Keterangan di bawah putaran.',
          ),
          const Center(child: AppLoading(label: 'Memuat data...')),

          const SectionShowcase(
            'Warna',
            description: 'Diisi: menimpa warna token untuk kasus khusus.',
          ),
          Center(
            child: AppLoading(
              label: 'Warna danger',
              color: theme.appColors.danger,
            ),
          ),

          const SectionShowcase(
            'Di dalam kartu',
            description: 'Dipakai sebagai isi sementara kartu.',
          ),
          const AppCard(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: AppLoading(label: 'Memuat...')),
            ),
          ),

          const SizedBox(height: 80),
        ],
      ),
    );
  }
}
