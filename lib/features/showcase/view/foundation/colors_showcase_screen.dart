import 'package:basecode/core/theme/app_colors.dart';
import 'package:basecode/core/theme/app_radius.dart';
import 'package:basecode/core/theme/app_spacing.dart';
import 'package:basecode/features/showcase/view/widgets/section_showcase.dart';
import 'package:flutter/material.dart';

/// Etalase token warna di `core/theme/app_colors.dart`.
class ColorsShowcaseScreen extends StatelessWidget {
  const ColorsShowcaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = theme.appColors;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.surface,
        title: Text(
          'Colors',
          style: theme.textTheme.titleLarge?.copyWith(color: AppColors.paper),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          const SectionShowcase(
            'Semantic',
            description:
                'Dipakai berdasarkan makna, bukan warnanya. '
                'Ini yang paling sering dipakai di fitur.',
          ),
          _Swatch('primary', c.primary),
          _Swatch('secondary', c.secondary),
          _Swatch('success', c.success),
          _Swatch('warning', c.warning),
          _Swatch('danger', c.danger),
          _Swatch('info', c.info),
          _Swatch('brand', c.brand),

          const SectionShowcase(
            'Surface',
            description: 'Latar halaman dan permukaan kartu.',
          ),
          _Swatch('paper', c.paper),
          _Swatch('surface', c.surface),
          _Swatch('line', c.line),

          const SectionShowcase(
            'Ink',
            description: 'Warna teks, dari paling pekat ke paling pudar.',
          ),
          _Swatch('ink', c.ink),
          _Swatch('inkSoft', c.inkSoft),
          _Swatch('inkFaint', c.inkFaint),

          const SectionShowcase(
            'Tint',
            description: 'Versi lembut untuk latar badge atau banner.',
          ),
          _Swatch('tealTint', c.tealTint),
          _Swatch('amberTint', c.amberTint),
          _Swatch('redTint', c.redTint),
          _Swatch('secondaryTint', c.secondaryTint),

          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}

class _Swatch extends StatelessWidget {
  const _Swatch(this.name, this.color);

  final String name;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // toRadixString(16) memberi nilai hex seperti yang ditulis di token.
    final hex = color.toARGB32().toRadixString(16).padLeft(8, '0');

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: theme.appColors.line),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: theme.textTheme.titleSmall),
                Text(
                  '#${hex.substring(2).toUpperCase()}',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
