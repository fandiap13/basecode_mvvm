import 'package:basecode/core/theme/app_colors.dart';
import 'package:basecode/core/theme/app_spacing.dart';
import 'package:basecode/core/widgets/chip/app_chip.dart';
import 'package:basecode/features/showcase/view/widgets/section_showcase.dart';
import 'package:flutter/material.dart';

/// Etalase sementara untuk widget di `core/widgets/`.
/// Hapus setelah layar asli pertama dibuat.
class ChipBadgeShowcaseScreen extends StatefulWidget {
  const ChipBadgeShowcaseScreen({super.key});

  @override
  State<ChipBadgeShowcaseScreen> createState() =>
      ChipBadgeShowcaseScreenState();
}

class ChipBadgeShowcaseScreenState extends State<ChipBadgeShowcaseScreen> {
  // State lokal layar: cukup setState, belum perlu viewmodel.
  final _filterAktif = <String>{'Baru'};
  final _tag = <String>['Flutter', 'Dart', 'Mobile'];
  int _notifikasi = 3;

  static const _semuaFilter = ['Baru', 'Populer', 'Diskon', 'Gratis Ongkir'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.surface,
        title: Text(
          'Chip & Badge',
          style: theme.textTheme.titleLarge?.copyWith(color: AppColors.paper),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          const SectionShowcase(
            'Chip variant',
            description: 'Latar memakai tint, teks memakai warna pekat.',
          ),
          const Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              AppChip(label: 'primary', variant: AppChipVariant.primary),
              AppChip(label: 'secondary', variant: AppChipVariant.secondary),
              AppChip(label: 'success', variant: AppChipVariant.success),
              AppChip(label: 'warning', variant: AppChipVariant.warning),
              AppChip(label: 'danger', variant: AppChipVariant.danger),
              AppChip(label: 'neutral'),
            ],
          ),

          const SectionShowcase(
            'Size',
            description:
                'small untuk di dalam baris padat, medium untuk '
                'berdiri sendiri.',
          ),
          const Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              AppChip(
                label: 'small',
                size: AppChipSize.small,
                variant: AppChipVariant.primary,
              ),
              AppChip(label: 'medium', variant: AppChipVariant.primary),
            ],
          ),

          const SectionShowcase(
            'Ikon & outlined',
            description:
                'Ikon menegaskan makna; outlined dipakai saat '
                'latar sudah ramai.',
          ),
          const Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              AppChip(
                label: 'Terverifikasi',
                icon: Icons.verified_outlined,
                variant: AppChipVariant.success,
              ),
              AppChip(
                label: 'Kedaluwarsa',
                icon: Icons.schedule,
                variant: AppChipVariant.danger,
              ),
              AppChip(
                label: 'Outlined',
                variant: AppChipVariant.primary,
                outlined: true,
              ),
            ],
          ),

          const SectionShowcase(
            'Filter',
            description:
                'selected memakai warna pekat. Ketuk untuk '
                'menyalakan atau mematikan.',
          ),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final filter in _semuaFilter)
                AppChip(
                  label: filter,
                  variant: AppChipVariant.primary,
                  selected: _filterAktif.contains(filter),
                  onTap: () => setState(() {
                    if (!_filterAktif.remove(filter)) _filterAktif.add(filter);
                  }),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Aktif: ${_filterAktif.isEmpty ? '-' : _filterAktif.join(', ')}',
            style: theme.textTheme.bodyMedium,
          ),

          const SectionShowcase(
            'Dapat dihapus',
            description: 'onDeleted memunculkan tombol silang.',
          ),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final tag in _tag)
                AppChip(
                  label: tag,
                  variant: AppChipVariant.secondary,
                  onDeleted: () => setState(() => _tag.remove(tag)),
                ),
              if (_tag.isEmpty)
                Text('Semua tag dihapus.', style: theme.textTheme.bodyMedium),
            ],
          ),

          const SectionShowcase(
            'Badge angka',
            description:
                'Di atas maxCount ditampilkan sebagai 99+. '
                'Nol disembunyikan kecuali showZero.',
          ),
          const Wrap(
            spacing: AppSpacing.lg,
            runSpacing: AppSpacing.sm,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              AppBadge(count: 3),
              AppBadge(count: 42, variant: AppChipVariant.primary),
              AppBadge(count: 150),
              AppBadge(
                count: 0,
                showZero: true,
                variant: AppChipVariant.neutral,
              ),
              AppBadge(label: 'Baru', variant: AppChipVariant.success),
              AppBadge(variant: AppChipVariant.danger),
            ],
          ),

          const SectionShowcase(
            'Badge menempel',
            description: 'child membuat badge menempel di pojok widget lain.',
          ),
          Row(
            children: [
              AppBadge(
                count: _notifikasi,
                child: const Icon(Icons.notifications_outlined, size: 28),
              ),
              const SizedBox(width: AppSpacing.lg),
              const AppBadge(
                count: 12,
                variant: AppChipVariant.primary,
                child: Icon(Icons.shopping_cart_outlined, size: 28),
              ),
              const SizedBox(width: AppSpacing.lg),
              const AppBadge(child: Icon(Icons.mail_outline, size: 28)),
              const Spacer(),
              IconButton(
                onPressed: () => setState(() => _notifikasi++),
                icon: const Icon(Icons.add),
                tooltip: 'Tambah notifikasi',
              ),
              IconButton(
                onPressed: () => setState(
                  () => _notifikasi = _notifikasi > 0 ? _notifikasi - 1 : 0,
                ),
                icon: const Icon(Icons.remove),
                tooltip: 'Kurangi notifikasi',
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}
