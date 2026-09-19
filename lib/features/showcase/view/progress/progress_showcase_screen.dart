import 'package:basecode/core/theme/app_colors.dart';
import 'package:basecode/core/widgets/button/app_button.dart';
import 'package:basecode/core/widgets/card/app_card.dart';
import 'package:basecode/core/widgets/progress/app_progress.dart';
import 'package:basecode/features/showcase/view/widgets/section_showcase.dart';
import 'package:flutter/material.dart';

/// Etalase sementara untuk widget di `core/widgets/`.
/// Hapus setelah layar asli pertama dibuat.
class ProgressShowcaseScreen extends StatefulWidget {
  const ProgressShowcaseScreen({super.key});

  @override
  State<ProgressShowcaseScreen> createState() => ProgressShowcaseScreenState();
}

class ProgressShowcaseScreenState extends State<ProgressShowcaseScreen> {
  // State lokal layar: cukup setState, belum perlu viewmodel.
  double _unduhan = 0.35;

  void _tambah() =>
      setState(() => _unduhan = (_unduhan + 0.15).clamp(0.0, 1.0));

  void _ulangi() => setState(() => _unduhan = 0);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.surface,
        title: Text(
          'App Progress',
          style: theme.textTheme.titleLarge?.copyWith(color: AppColors.paper),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SectionShowcase(
            'Tak tentu',
            description: 'Tanpa value: batang berjalan terus.',
          ),
          const AppProgress(),

          const SectionShowcase(
            'Nilai pasti',
            description: 'value 0.0 sampai 1.0. Di luar itu dijepit.',
          ),
          for (final value in const [0.15, 0.5, 0.85])
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: AppProgress(value: value),
            ),

          const SectionShowcase(
            'Label & persen',
            description: 'showPercentage hanya tampil saat nilainya pasti.',
          ),
          AppProgress(
            value: _unduhan,
            label: 'Mengunduh berkas',
            showPercentage: true,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: 'Tambah',
                  size: AppButtonSize.small,
                  onPressed: _tambah,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: AppButton(
                  label: 'Ulangi',
                  size: AppButtonSize.small,
                  variant: AppButtonVariant.outline,
                  onPressed: _ulangi,
                ),
              ),
            ],
          ),

          const SectionShowcase(
            'Variant',
            description: 'Menentukan warna batang. Diambil dari token tema.',
          ),
          for (final variant in AppProgressVariant.values)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: AppProgress(
                value: 0.6,
                label: variant.name,
                showPercentage: true,
                variant: variant,
              ),
            ),

          const SectionShowcase(
            'Di dalam kartu',
            description: 'Tinggi batang diatur lewat minHeight.',
          ),
          const AppCard(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: AppProgress(
                value: 0.7,
                label: 'Penyimpanan',
                showPercentage: true,
                minHeight: 12,
              ),
            ),
          ),

          const SizedBox(height: 80),
        ],
      ),
    );
  }
}
