import 'package:basecode/core/theme/app_colors.dart';
import 'package:basecode/core/widgets/slider/app_slider.dart';
import 'package:basecode/features/showcase/view/widgets/section_showcase.dart';
import 'package:flutter/material.dart';

/// Etalase sementara untuk widget di `core/widgets/`.
/// Hapus setelah layar asli pertama dibuat.
class SliderShowcaseScreen extends StatefulWidget {
  const SliderShowcaseScreen({super.key});

  @override
  State<SliderShowcaseScreen> createState() => SliderShowcaseScreenState();
}

class SliderShowcaseScreenState extends State<SliderShowcaseScreen> {
  // State lokal layar: cukup setState, belum perlu viewmodel.
  double _volume = 40;
  double _kecerahan = 70;
  double _suhu = 22;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.surface,
        title: Text(
          'App Slider',
          style: theme.textTheme.titleLarge?.copyWith(color: AppColors.paper),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SectionShowcase(
            'Dasar',
            description: 'Geser titik untuk mengubah value.',
          ),
          AppSlider(
            value: _volume,
            label: 'Volume',
            showValue: true,
            onChanged: (value) => setState(() => _volume = value),
          ),

          const SectionShowcase(
            'Format nilai',
            description:
                'valueFormatter mengubah angka mentah menjadi teks '
                'tampilan.',
          ),
          AppSlider(
            value: _kecerahan,
            label: 'Kecerahan',
            showValue: true,
            valueFormatter: (value) => '${value.round()}%',
            onChanged: (value) => setState(() => _kecerahan = value),
          ),

          const SectionShowcase(
            'Rentang & langkah',
            description:
                'min/max membatasi rentang; divisions membuat geseran '
                'melompat per langkah.',
          ),
          AppSlider(
            value: _suhu,
            label: 'Suhu ruangan',
            min: 16,
            max: 30,
            divisions: 14,
            showValue: true,
            valueFormatter: (value) => '${value.round()}°C',
            onChanged: (value) => setState(() => _suhu = value),
          ),

          const SectionShowcase(
            'Variant',
            description:
                'Menentukan warna lintasan dan titik. Diambil dari '
                'token tema.',
          ),
          for (final variant in AppSliderVariant.values)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: AppSlider(
                value: 60,
                label: variant.name,
                variant: variant,
                onChanged: (_) {},
              ),
            ),

          const SectionShowcase(
            'Size',
            description:
                'Tiap ukuran membawa metrik sendiri (trackHeight, '
                'thumbRadius).',
          ),
          for (final size in AppSliderSize.values)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: AppSlider(
                value: 60,
                label: size.name,
                size: size,
                onChanged: (_) {},
              ),
            ),

          const SectionShowcase(
            'Nonaktif',
            description:
                'onChanged: null membuat slider pudar dan tidak bisa '
                'digeser. enabled: false efeknya sama.',
          ),
          const AppSlider(
            value: 30,
            label: 'Nonaktif (onChanged null)',
            onChanged: null,
          ),
          const SizedBox(height: 8),
          const AppSlider(
            value: 30,
            label: 'Nonaktif (enabled false)',
            enabled: false,
            onChanged: null,
          ),

          const SizedBox(height: 80),
        ],
      ),
    );
  }
}
