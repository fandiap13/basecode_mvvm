import 'package:basecode/core/theme/app_colors.dart';
import 'package:basecode/core/widgets/switch/app_switch.dart';
import 'package:basecode/features/showcase/view/widgets/section_showcase.dart';
import 'package:flutter/material.dart';

/// Etalase sementara untuk widget di `core/widgets/`.
/// Hapus setelah layar asli pertama dibuat.
class SwitchShowcaseScreen extends StatefulWidget {
  const SwitchShowcaseScreen({super.key});

  @override
  State<SwitchShowcaseScreen> createState() => SwitchShowcaseScreenState();
}

class SwitchShowcaseScreenState extends State<SwitchShowcaseScreen> {
  // State lokal layar: cukup setState, belum perlu viewmodel.
  bool _notifikasi = true;
  bool _modeGelap = false;
  bool _lokasi = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.surface,
        title: Text(
          'App Switch',
          style: theme.textTheme.titleLarge?.copyWith(color: AppColors.paper),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SectionShowcase(
            'Dasar',
            description: 'Saklar dengan label yang bisa diketuk.',
          ),
          AppSwitch(
            value: _notifikasi,
            label: 'Notifikasi',
            onChanged: (value) => setState(() => _notifikasi = value),
          ),

          const SectionShowcase(
            'Subtitle',
            description: 'Keterangan tambahan di bawah label.',
          ),
          AppSwitch(
            value: _modeGelap,
            label: 'Mode gelap',
            subtitle: 'Mengikuti tema perangkat saat mati.',
            onChanged: (value) => setState(() => _modeGelap = value),
          ),

          const SectionShowcase(
            'Variant',
            description: 'Menentukan warna aktif. Diambil dari token tema.',
          ),
          for (final variant in AppSwitchVariant.values)
            AppSwitch(
              value: true,
              label: variant.name,
              variant: variant,
              onChanged: (_) {},
            ),

          const SectionShowcase(
            'Nonaktif',
            description:
                'onChanged: null membuat saklar pudar dan tidak bisa '
                'diketuk. enabled: false efeknya sama.',
          ),
          const AppSwitch(
            value: false,
            label: 'Nonaktif (onChanged null)',
            onChanged: null,
          ),
          AppSwitch(
            value: _lokasi,
            label: 'Lokasi (enabled false)',
            enabled: false,
            onChanged: (value) => setState(() => _lokasi = value),
          ),

          const SizedBox(height: 80),
        ],
      ),
    );
  }
}
