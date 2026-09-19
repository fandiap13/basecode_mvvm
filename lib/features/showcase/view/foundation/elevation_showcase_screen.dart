import 'package:basecode/core/theme/app_colors.dart';
import 'package:basecode/core/theme/app_elevation.dart';
import 'package:basecode/core/theme/app_radius.dart';
import 'package:basecode/core/theme/app_spacing.dart';
import 'package:basecode/features/showcase/view/widgets/section_showcase.dart';
import 'package:flutter/material.dart';

/// Etalase token bayangan di `core/theme/app_elevation.dart`.
class ElevationShowcaseScreen extends StatelessWidget {
  const ElevationShowcaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.surface,
        title: Text(
          'Elevation',
          style: theme.textTheme.titleLarge?.copyWith(color: AppColors.paper),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          const SectionShowcase(
            'Token',
            description:
                'Makin tinggi nilainya, makin jauh permukaan terasa '
                'dari latar.',
          ),
          for (final entry in const <(String, double, String)>[
            ('none', AppElevation.none, 'Kartu dan tombol saat diam'),
            ('sm', AppElevation.sm, 'Tombol saat hover'),
            ('md', AppElevation.md, 'Bottom sheet'),
            ('lg', AppElevation.lg, 'Dialog dan menu'),
          ])
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.lg),
              child: Material(
                elevation: entry.$2,
                borderRadius: BorderRadius.circular(AppRadius.md),
                color: theme.appColors.surface,
                child: Container(
                  height: 85,
                  padding: const EdgeInsets.all(AppSpacing.md),
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${entry.$1} (${entry.$2.toInt()})',
                        style: theme.textTheme.titleSmall,
                      ),
                      Text(entry.$3, style: theme.textTheme.bodySmall),
                    ],
                  ),
                ),
              ),
            ),

          const SectionShowcase(
            'Catatan',
            description:
                'Kartu di app ini sengaja rata (none) dan memakai '
                'garis tipis, bukan bayangan. Bayangan disediakan untuk '
                'permukaan yang benar-benar mengambang.',
          ),

          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}
