import 'package:basecode/core/theme/app_colors.dart';
import 'package:basecode/core/theme/app_spacing.dart';
import 'package:basecode/core/theme/app_typography.dart';
import 'package:basecode/features/showcase/view/widgets/section_showcase.dart';
import 'package:flutter/material.dart';

/// Etalase token teks di `core/theme/app_typography.dart`.
class TypographyShowcaseScreen extends StatelessWidget {
  const TypographyShowcaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.surface,
        title: Text(
          'Typography',
          style: theme.textTheme.titleLarge?.copyWith(color: AppColors.paper),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          const SectionShowcase(
            'Display & headline',
            description: 'Judul besar di puncak halaman.',
          ),
          _Sample('displaySmall', t.displaySmall),
          _Sample('headlineSmall', t.headlineSmall),

          const SectionShowcase(
            'Title',
            description: 'Judul bagian dan nama kartu.',
          ),
          _Sample('titleLarge', t.titleLarge),
          _Sample('titleMedium', t.titleMedium),
          _Sample('titleSmall', t.titleSmall),

          const SectionShowcase(
            'Body',
            description: 'Teks isi. bodySmall memakai warna lebih pudar.',
          ),
          _Sample('bodyLarge', t.bodyLarge),
          _Sample('bodyMedium', t.bodyMedium),
          _Sample('bodySmall', t.bodySmall),

          const SectionShowcase(
            'Label',
            description:
                'Teks di dalam tombol dan kolom input. Warnanya '
                'sengaja tidak diatur agar ikut komponennya.',
          ),
          _Sample('labelLarge', t.labelLarge),
          _Sample('labelMedium', t.labelMedium),
          _Sample('labelSmall', t.labelSmall),

          const SectionShowcase(
            'Font size',
            description: 'Token mentah di AppFontSize.',
          ),
          for (final entry in const <(String, double)>[
            ('xs', AppFontSize.xs),
            ('sm', AppFontSize.sm),
            ('md', AppFontSize.md),
            ('lg', AppFontSize.lg),
            ('xl', AppFontSize.xl),
            ('xxl', AppFontSize.xxl),
            ('display', AppFontSize.display),
          ])
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: Text(
                '${entry.$1} — ${entry.$2.toInt()}px',
                style: TextStyle(fontSize: entry.$2),
              ),
            ),

          const SectionShowcase(
            'Font weight',
            description: 'Token mentah di AppFontWeight.',
          ),
          for (final entry in const <(String, FontWeight)>[
            ('regular', AppFontWeight.regular),
            ('medium', AppFontWeight.medium),
            ('semiBold', AppFontWeight.semiBold),
            ('bold', AppFontWeight.bold),
          ])
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: Text(
                entry.$1,
                style: t.bodyLarge?.copyWith(fontWeight: entry.$2),
              ),
            ),

          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}

class _Sample extends StatelessWidget {
  const _Sample(this.name, this.style);

  final String name;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$name — ${style?.fontSize?.toInt()}px', style: t(theme)),
          const SizedBox(height: AppSpacing.xs),
          Text('Sebuah kalimat contoh.', style: style),
        ],
      ),
    );
  }

  TextStyle? t(ThemeData theme) =>
      theme.textTheme.bodySmall?.copyWith(color: theme.appColors.inkFaint);
}
