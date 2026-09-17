import 'package:basecode/core/theme/app_colors.dart';
import 'package:basecode/features/showcase/model/showcase_catalog.dart';
import 'package:basecode/features/showcase/model/showcase_entry.dart';
import 'package:basecode/features/showcase/view/widgets/section_showcase.dart';
import 'package:basecode/features/showcase/view/widgets/showcase_grid.dart';
import 'package:basecode/features/showcase/view/widgets/showcase_slider.dart';
import 'package:flutter/material.dart';

class ShowcaseScreen extends StatelessWidget {
  const ShowcaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final components = showcaseEntries
        .where((e) => e.category == ShowcaseCategory.component)
        .toList();
    final foundations = showcaseEntries
        .where((e) => e.category == ShowcaseCategory.foundation)
        .toList();

    return Scaffold(
      backgroundColor: AppColors.paper,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.surface,
        title: Text(
          'Showcase',
          style: Theme.of(context).textTheme.titleLarge
              ?.copyWith(color: AppColors.paper),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SectionShowcase(
            'Component Catalog',
            description: 'Reusable Flutter components.',
          ),
          const SizedBox(height: 10),
          ShowcaseGrid(entries: components),
          const SectionShowcase(
            'Foundation',
            description: 'Design tokens: colors, typography, spacing.',
          ),
          const SizedBox(height: 10),
          ShowcaseSlider(entries: foundations),
        ],
      ),
    );
  }
}
