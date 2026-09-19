import 'package:basecode/core/theme/app_colors.dart';
import 'package:basecode/core/theme/app_radius.dart';
import 'package:basecode/core/theme/app_spacing.dart';
import 'package:basecode/features/showcase/view/widgets/section_showcase.dart';
import 'package:flutter/material.dart';

/// Etalase token jarak dan sudut di `core/theme/`.
class SpacingShowcaseScreen extends StatelessWidget {
  const SpacingShowcaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = theme.appColors;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.surface,
        title: Text(
          'Spacing',
          style: theme.textTheme.titleLarge?.copyWith(color: AppColors.paper),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          const SectionShowcase(
            'Spacing',
            description:
                'Jarak antar elemen. Dipakai untuk padding, margin, '
                'dan SizedBox.',
          ),
          for (final entry in const <(String, double)>[
            ('xs', AppSpacing.xs),
            ('sm', AppSpacing.sm),
            ('md', AppSpacing.md),
            ('lg', AppSpacing.lg),
            ('xl', AppSpacing.xl),
          ])
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Row(
                children: [
                  SizedBox(
                    width: 72,
                    child: Text(
                      '${entry.$1} (${entry.$2.toInt()})',
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                  Container(width: entry.$2, height: 24, color: c.primary),
                ],
              ),
            ),

          const SectionShowcase(
            'Radius',
            description:
                'Sudut membulat. Kartu dan input memakai md, '
                'tombol memakai lg.',
          ),
          for (final entry in const <(String, double)>[
            ('xs', AppRadius.xs),
            ('sm', AppRadius.sm),
            ('md', AppRadius.md),
            ('lg', AppRadius.lg),
            ('xl', AppRadius.xl),
          ])
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Row(
                children: [
                  SizedBox(
                    width: 72,
                    child: Text(
                      '${entry.$1} (${entry.$2.toInt()})',
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                  Container(
                    width: 96,
                    height: 48,
                    decoration: BoxDecoration(
                      color: c.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(entry.$2),
                      border: Border.all(color: c.primary),
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}
