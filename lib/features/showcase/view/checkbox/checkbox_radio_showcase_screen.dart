import 'package:basecode/core/theme/app_colors.dart';
import 'package:basecode/core/widgets/checkbox/app_checkbox.dart';
import 'package:basecode/features/showcase/view/widgets/section_showcase.dart';
import 'package:flutter/material.dart';

/// Etalase sementara untuk widget di `core/widgets/`.
/// Hapus setelah layar asli pertama dibuat.
class CheckboxRadioShowcaseScreen extends StatefulWidget {
  const CheckboxRadioShowcaseScreen({super.key});

  @override
  State<CheckboxRadioShowcaseScreen> createState() =>
      CheckboxRadioShowcaseScreenState();
}

class CheckboxRadioShowcaseScreenState
    extends State<CheckboxRadioShowcaseScreen> {
  // State lokal layar: cukup setState, belum perlu viewmodel.
  bool _setuju = false;
  bool _berita = true;
  String _bahasa = 'id';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.surface,
        title: Text(
          'Checkbox & Radio',
          style: theme.textTheme.titleLarge?.copyWith(color: AppColors.paper),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SectionShowcase(
            'Dasar',
            description: 'Kotak centang dengan label yang bisa diketuk.',
          ),
          AppCheckbox(
            value: _setuju,
            label: 'Saya menyetujui syarat',
            onChanged: (value) => setState(() => _setuju = value ?? false),
          ),

          const SectionShowcase(
            'Subtitle',
            description: 'Keterangan tambahan di bawah label.',
          ),
          AppCheckbox(
            value: _berita,
            label: 'Kirim kabar terbaru',
            subtitle: 'Maksimal satu email per minggu.',
            onChanged: (value) => setState(() => _berita = value ?? false),
          ),

          const SectionShowcase(
            'Variant',
            description: 'Menentukan warna centang. Diambil dari token tema.',
          ),
          for (final variant in AppCheckboxVariant.values)
            AppCheckbox(
              value: true,
              label: variant.name,
              variant: variant,
              onChanged: (_) {},
            ),

          const SectionShowcase(
            'Nonaktif',
            description:
                'onChanged: null membuat kotak pudar dan tidak bisa '
                'diketuk. enabled: false efeknya sama.',
          ),
          const AppCheckbox(
            value: false,
            label: 'Nonaktif (onChanged null)',
            onChanged: null,
          ),
          const AppCheckbox(
            value: true,
            label: 'Nonaktif tercentang',
            enabled: false,
            onChanged: null,
          ),

          const SectionShowcase(
            'Radio',
            description:
                'Pilihan tunggal: satu groupValue untuk satu kelompok.',
          ),
          for (final entry in const <(String, String)>[
            ('id', 'Bahasa Indonesia'),
            ('en', 'English'),
          ])
            AppRadio<String>(
              value: entry.$1,
              groupValue: _bahasa,
              label: entry.$2,
              onChanged: (value) => setState(() => _bahasa = value ?? 'id'),
            ),
          const SizedBox(height: 8),
          Text('Terpilih: $_bahasa', style: theme.textTheme.bodyMedium),

          const SectionShowcase(
            'Radio nonaktif',
            description: 'onChanged: null membuat pilihan tidak bisa diketuk.',
          ),
          const AppRadio<String>(
            value: 'x',
            groupValue: 'y',
            label: 'Nonaktif',
            onChanged: null,
          ),

          const SizedBox(height: 80),
        ],
      ),
    );
  }
}
