import 'package:basecode/core/theme/app_colors.dart';
import 'package:basecode/core/widgets/button/app_button.dart';
import 'package:basecode/features/showcase/view/widgets/section_showcase.dart';
import 'package:flutter/material.dart';

/// Etalase sementara untuk widget di `core/widgets/`.
/// Hapus setelah layar asli pertama dibuat.
class ButtonShowcaseScreen extends StatefulWidget {
  const ButtonShowcaseScreen({super.key});

  @override
  State<ButtonShowcaseScreen> createState() => ButtonShowcaseScreenState();
}

class ButtonShowcaseScreenState extends State<ButtonShowcaseScreen> {
  // State lokal layar: cukup setState, belum perlu viewmodel.
  bool _isLoading = false;

  void _toggleLoading() => setState(() => _isLoading = !_isLoading);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.surface,
        title: Text(
          'App Button',
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
          for (final variant in AppButtonVariant.values)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: AppButton(
                label: variant.name,
                variant: variant,
                isLoading: _isLoading,
                onPressed: () {},
              ),
            ),

          const SectionShowcase(
            'Size',
            description:
                'Tiap ukuran membawa metrik sendiri (height, '
                'hPadding, iconSize, gap).',
          ),
          for (final size in AppButtonSize.values)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: AppButton(
                label: size.name,
                size: size,
                isLoading: _isLoading,
                onPressed: () {},
              ),
            ),

          const SectionShowcase(
            'Icon',
            description: 'Ikon depan atau belakang label.',
          ),
          AppButton(
            label: 'Leading icon',
            leadingIcon: Icons.add,
            isLoading: _isLoading,
            onPressed: () {},
          ),
          const SizedBox(height: 8),
          AppButton(
            label: 'Trailing icon',
            trailingIcon: Icons.arrow_forward,
            isLoading: _isLoading,
            onPressed: () {},
          ),

          const SectionShowcase(
            'Border',
            description:
                'Tanpa borderColor: hanya outline yang bergaris, '
                'sewarna teksnya. Diisi borderColor: garis muncul di variant '
                'mana pun.',
          ),
          AppButton(
            label: 'outline (default)',
            variant: AppButtonVariant.outline,
            isLoading: _isLoading,
            onPressed: () {},
          ),
          const SizedBox(height: 8),
          AppButton(
            label: 'primary + borderColor',
            borderColor: theme.appColors.ink,
            isLoading: _isLoading,
            onPressed: () {},
          ),
          const SizedBox(height: 8),
          AppButton(
            label: 'outline + borderWidth 2',
            variant: AppButtonVariant.outline,
            borderColor: theme.appColors.danger,
            borderWidth: 2,
            isLoading: _isLoading,
            onPressed: () {},
          ),

          const SectionShowcase(
            'Disabled',
            description:
                'onPressed: null menandakan tombol nonaktif. '
                'Border ikut meredup.',
          ),
          const AppButton(label: 'Disabled', onPressed: null),
          const SizedBox(height: 8),
          const AppButton(
            label: 'Disabled outline',
            variant: AppButtonVariant.outline,
            onPressed: null,
          ),

          const SectionShowcase(
            'Expanded',
            description: 'isExpanded membuat tombol selebar induknya.',
          ),
          AppButton(
            label: 'Expanded',
            isExpanded: true,
            isLoading: _isLoading,
            onPressed: () {},
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
