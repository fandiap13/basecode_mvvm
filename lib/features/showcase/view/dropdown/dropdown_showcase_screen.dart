import 'package:basecode/core/theme/app_colors.dart';
import 'package:basecode/core/theme/app_radius.dart';
import 'package:basecode/core/theme/app_spacing.dart';
import 'package:basecode/core/widgets/dropdown/app_dropdown_field.dart';
import 'package:basecode/features/showcase/view/widgets/section_showcase.dart';
import 'package:flutter/material.dart';

/// Etalase sementara untuk widget di `core/widgets/`.
/// Hapus setelah layar asli pertama dibuat.
class DropdownShowcaseScreen extends StatefulWidget {
  const DropdownShowcaseScreen({super.key});

  @override
  State<DropdownShowcaseScreen> createState() => DropdownShowcaseScreenState();
}

class DropdownShowcaseScreenState extends State<DropdownShowcaseScreen> {
  // State lokal layar: cukup setState, belum perlu viewmodel.
  String? _kota;
  String? _kotaValidasi;
  String? _kotaSuffix;
  int? _jumlah;
  String? _errorText;

  static const _kotaList = ['Jakarta', 'Bandung', 'Surabaya', 'Medan'];

  // Item bertipe String; dipakai ulang beberapa contoh di bawah.
  List<DropdownMenuItem<String>> get _kotaItems => [
    for (final kota in _kotaList)
      DropdownMenuItem(value: kota, child: Text(kota)),
  ];

  void _validasiKota(String? value) {
    setState(() {
      _kotaValidasi = value;
      // Contoh validasi sederhana; di layar asli ini milik viewmodel.
      _errorText = value == 'Medan' ? 'Kota ini belum dilayani' : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.surface,
        title: Text(
          'App Dropdown',
          style: theme.textTheme.titleLarge?.copyWith(color: AppColors.paper),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          const SectionShowcase(
            'Label & hint',
            description:
                'hint tampil selama belum ada pilihan. '
                'value menyimpan pilihan saat ini.',
          ),
          AppDropdownField<String>(
            label: 'Kota',
            hint: 'Pilih kota',
            value: _kota,
            items: _kotaItems,
            onChanged: (value) => setState(() => _kota = value),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text('Terpilih: ${_kota ?? "-"}', style: theme.textTheme.bodyMedium),

          const SectionShowcase(
            'Label position',
            description:
                'outside (default): label sebagai teks di atas '
                'kolom. floating: label menempel di dalam kolom.',
          ),
          AppDropdownField<String>(
            label: 'Kota',
            hint: 'Pilih kota',
            items: _kotaItems,
            onChanged: (_) {},
          ),
          const SizedBox(height: AppSpacing.md),
          AppDropdownField<String>(
            label: 'Kota',
            hint: 'Pilih kota',
            labelPosition: AppDropdownFieldLabelPosition.floating,
            items: _kotaItems,
            onChanged: (_) {},
          ),

          const SectionShowcase(
            'Variant',
            description:
                'Menentukan warna border dan latar kolom. '
                'Diambil dari token tema.',
          ),
          for (final variant in AppDropdownFieldVariant.values)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: AppDropdownField<String>(
                label: variant.name,
                hint: 'variant: ${variant.name}',
                variant: variant,
                items: _kotaItems,
                onChanged: (_) {},
              ),
            ),

          const SectionShowcase(
            'Size',
            description:
                'Tiap ukuran membawa metrik sendiri (vPadding, '
                'hPadding, fontSize).',
          ),
          for (final size in AppDropdownFieldSize.values)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: AppDropdownField<String>(
                label: size.name,
                hint: 'size: ${size.name}',
                size: size,
                items: _kotaItems,
                onChanged: (_) {},
              ),
            ),

          const SectionShowcase(
            'Radius',
            description:
                'Tanpa radius: ikut inputDecorationTheme. '
                'Diisi: menimpa untuk kolom itu saja.',
          ),
          for (final entry in const <(String, double)>[
            ('xs', AppRadius.xs),
            ('md', AppRadius.md),
            ('xl', AppRadius.xl),
          ])
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: AppDropdownField<String>(
                label: 'radius ${entry.$1}',
                hint: 'Pilih kota',
                radius: entry.$2,
                items: _kotaItems,
                onChanged: (_) {},
              ),
            ),

          const SectionShowcase(
            'Helper text',
            description: 'Keterangan bantuan di bawah kolom.',
          ),
          AppDropdownField<String>(
            label: 'Kota',
            hint: 'Pilih kota',
            helperText: 'Kota tujuan pengiriman.',
            items: _kotaItems,
            onChanged: (_) {},
          ),

          const SectionShowcase(
            'Error text',
            description:
                'errorText menggantikan helperText dan mewarnai '
                'kolom. Pilih "Medan" untuk memunculkannya.',
          ),
          AppDropdownField<String>(
            label: 'Kota',
            hint: 'Pilih kota',
            value: _kotaValidasi,
            errorText: _errorText,
            items: _kotaItems,
            onChanged: _validasiKota,
          ),

          const SectionShowcase(
            'Prefix & suffix icon',
            description:
                'Ikon bisa diberi aksi lewat onPrefixTap / '
                'onSuffixTap. Contoh di bawah: tombol hapus pilihan.',
          ),
          AppDropdownField<String>(
            label: 'Kota',
            hint: 'Pilih kota',
            prefixIcon: Icons.location_city_outlined,
            items: _kotaItems,
            onChanged: (_) {},
          ),
          const SizedBox(height: AppSpacing.md),
          AppDropdownField<String>(
            label: 'Kota',
            hint: 'Pilih kota',
            value: _kotaSuffix,
            suffixIcon: Icons.clear,
            onSuffixTap: () => setState(() => _kotaSuffix = null),
            items: _kotaItems,
            onChanged: (value) => setState(() => _kotaSuffix = value),
          ),

          const SectionShowcase(
            'Tipe generik',
            description:
                'AppDropdownField<T> menerima tipe apa pun, tidak harus '
                'String. Contoh ini memakai int.',
          ),
          AppDropdownField<int>(
            label: 'Jumlah',
            hint: 'Pilih jumlah',
            value: _jumlah,
            items: const [
              DropdownMenuItem(value: 1, child: Text('1 barang')),
              DropdownMenuItem(value: 5, child: Text('5 barang')),
              DropdownMenuItem(value: 10, child: Text('10 barang')),
            ],
            onChanged: (value) => setState(() => _jumlah = value),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Terpilih: ${_jumlah ?? "-"}',
            style: theme.textTheme.bodyMedium,
          ),

          const SectionShowcase(
            'Disabled',
            description:
                'enabled: false membuat kolom pudar dan tidak bisa '
                'dibuka.',
          ),
          AppDropdownField<String>(
            label: 'Nonaktif',
            hint: 'Pilih kota',
            enabled: false,
            items: _kotaItems,
            onChanged: (_) {},
          ),

          const SectionShowcase(
            'decoration',
            description:
                'Melanjutkan InputDecoration bawaan. Yang tidak '
                'diisi tetap ikut nilai dari widget.',
          ),
          AppDropdownField<String>(
            label: 'Rapat',
            hint: 'contentPadding dipersempit',
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
            ),
            items: _kotaItems,
            onChanged: (_) {},
          ),

          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}
