import 'package:basecode/core/theme/app_colors.dart';
import 'package:basecode/core/theme/app_radius.dart';
import 'package:basecode/core/widgets/button/app_icon_button.dart';
import 'package:basecode/features/showcase/view/widgets/section_showcase.dart';
import 'package:flutter/material.dart';

/// Etalase sementara untuk widget di `core/widgets/`.
/// Hapus setelah layar asli pertama dibuat.
class IconButtonShowcaseScreen extends StatefulWidget {
  const IconButtonShowcaseScreen({super.key});

  @override
  State<IconButtonShowcaseScreen> createState() =>
      IconButtonShowcaseScreenState();
}

class IconButtonShowcaseScreenState extends State<IconButtonShowcaseScreen> {
  // State lokal layar: cukup setState, belum perlu viewmodel.
  bool _isLoading = false;
  int _tapCount = 0;

  void _toggleLoading() => setState(() => _isLoading = !_isLoading);

  void _onPressed() => setState(() => _tapCount++);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.surface,
        title: Text(
          'App Icon Button',
          style: theme.textTheme.titleLarge?.copyWith(color: AppColors.paper),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SectionShowcase(
            'Variant',
            description: 'Warna diambil dari token tema, bukan nilai hardcode.',
          ),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              for (final variant in AppIconButtonVariant.values)
                AppIconButton(
                  icon: Icons.favorite_outline,
                  variant: variant,
                  tooltip: variant.name,
                  isLoading: _isLoading,
                  onPressed: _onPressed,
                ),
            ],
          ),

          const SectionShowcase(
            'Size',
            description:
                'Tiap ukuran membawa metrik sendiri (height, '
                'iconSize).',
          ),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              for (final size in AppIconButtonSize.values)
                AppIconButton(
                  icon: Icons.settings_outlined,
                  size: size,
                  tooltip: size.name,
                  isLoading: _isLoading,
                  onPressed: _onPressed,
                ),
            ],
          ),

          const SectionShowcase(
            'Radius',
            description: 'Sudut memakai token di core/theme/app_radius.dart.',
          ),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              for (final entry in const <(String, double)>[
                ('xs', AppRadius.xs),
                ('sm', AppRadius.sm),
                ('md', AppRadius.md),
                ('lg', AppRadius.lg),
                ('xl', AppRadius.xl),
              ])
                AppIconButton(
                  icon: Icons.crop_square_outlined,
                  radius: entry.$2,
                  tooltip: 'radius ${entry.$1}',
                  isLoading: _isLoading,
                  onPressed: _onPressed,
                ),
            ],
          ),

          const SectionShowcase(
            'Tooltip',
            description:
                'Icon-only button wajib punya tooltip agar tetap '
                'terbaca screen reader.',
          ),
          Row(
            children: [
              AppIconButton(
                icon: Icons.delete_outline,
                variant: AppIconButtonVariant.danger,
                tooltip: 'Hapus',
                isLoading: _isLoading,
                onPressed: _onPressed,
              ),
              const SizedBox(width: 12),
              Text('Ditekan: $_tapCount', style: theme.textTheme.bodyMedium),
            ],
          ),

          const SectionShowcase(
            'Border',
            description:
                'Tanpa borderColor: hanya outline yang bergaris, '
                'sewarna ikonnya. Diisi borderColor: garis muncul di variant '
                'mana pun.',
          ),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              AppIconButton(
                icon: Icons.star_outline,
                variant: AppIconButtonVariant.outline,
                tooltip: 'outline (default)',
                isLoading: _isLoading,
                onPressed: _onPressed,
              ),
              AppIconButton(
                icon: Icons.star_outline,
                borderColor: theme.appColors.ink,
                tooltip: 'primary + borderColor',
                isLoading: _isLoading,
                onPressed: _onPressed,
              ),
              AppIconButton(
                icon: Icons.star_outline,
                variant: AppIconButtonVariant.outline,
                borderColor: theme.appColors.danger,
                borderWidth: 1,
                tooltip: 'outline + borderWidth 2',
                isLoading: _isLoading,
                onPressed: _onPressed,
              ),
            ],
          ),

          const SectionShowcase(
            'Disabled',
            description: 'onPressed: null menandakan tombol nonaktif.',
          ),
          const Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              AppIconButton(
                icon: Icons.block_outlined,
                tooltip: 'Disabled',
                onPressed: null,
              ),
              AppIconButton(
                icon: Icons.block_outlined,
                variant: AppIconButtonVariant.outline,
                tooltip: 'Disabled outline: border ikut meredup',
                onPressed: null,
              ),
            ],
          ),

          const SectionShowcase(
            'Expanded',
            description: 'isExpanded membuat tombol selebar induknya.',
          ),
          AppIconButton(
            icon: Icons.check,
            isExpanded: true,
            tooltip: 'Expanded',
            isLoading: _isLoading,
            onPressed: _onPressed,
          ),

          const SizedBox(height: 80),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _toggleLoading,
        icon: Icon(_isLoading ? Icons.stop : Icons.hourglass_empty),
        label: Text(_isLoading ? 'Stop loading' : 'Show loading'),
      ),
    );
  }
}
