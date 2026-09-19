import 'package:basecode/core/theme/app_breakpoints.dart';
import 'package:basecode/core/theme/app_colors.dart';
import 'package:basecode/core/theme/app_radius.dart';
import 'package:basecode/core/theme/app_spacing.dart';
import 'package:basecode/features/showcase/view/widgets/section_showcase.dart';
import 'package:flutter/material.dart';

/// Etalase token lebar layar di `core/theme/app_breakpoints.dart`.
class BreakpointsShowcaseScreen extends StatelessWidget {
  const BreakpointsShowcaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = theme.appColors;

    final width = MediaQuery.sizeOf(context).width;
    final size = AppBreakpoints.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.surface,
        title: Text(
          'Breakpoints',
          style: theme.textTheme.titleLarge?.copyWith(color: AppColors.paper),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          const SectionShowcase(
            'Layar saat ini',
            description:
                'Putar perangkat atau ubah ukuran jendela untuk '
                'melihat nilainya berubah.',
          ),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: c.tealTint,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: c.primary),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${width.toStringAsFixed(0)} px',
                  style: theme.textTheme.displaySmall,
                ),
                Text(
                  '${size.name} — ${size.columns} kolom',
                  style: theme.textTheme.titleMedium,
                ),
              ],
            ),
          ),

          const SectionShowcase(
            'Token',
            description:
                'Batas lebar tempat tata letak berganti. '
                'Yang aktif ditandai.',
          ),
          for (final entry in const <(String, String, double?)>[
            ('compact', '< 600', null),
            ('medium', '600 – 904', AppBreakpoints.mobile),
            ('expanded', '905 – 1239', AppBreakpoints.tablet),
            ('large', '>= 1240', AppBreakpoints.desktop),
          ])
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Row(
                children: [
                  Icon(
                    entry.$1 == size.name
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                    size: 18,
                    color: entry.$1 == size.name ? c.primary : c.inkFaint,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  SizedBox(
                    width: 92,
                    child: Text(entry.$1, style: theme.textTheme.titleSmall),
                  ),
                  Text('${entry.$2} px', style: theme.textTheme.bodySmall),
                ],
              ),
            ),

          const SectionShowcase(
            'Contoh pemakaian',
            description:
                'Grid menyesuaikan jumlah kolom lewat '
                'AppBreakpoints.of(context).columns.',
          ),
          GridView.count(
            crossAxisCount: size.columns,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: AppSpacing.sm,
            crossAxisSpacing: AppSpacing.sm,
            children: [
              for (var i = 1; i <= size.columns; i++)
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: c.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Text('$i', style: theme.textTheme.bodySmall),
                ),
            ],
          ),

          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}
