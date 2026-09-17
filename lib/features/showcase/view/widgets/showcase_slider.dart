import 'package:basecode/core/theme/app_colors.dart';
import 'package:basecode/features/showcase/model/showcase_entry.dart';
import 'package:basecode/features/showcase/view/widgets/section_card.dart';
import 'package:flutter/material.dart';

class ShowcaseSlider extends StatelessWidget {
  const ShowcaseSlider({super.key, required this.entries});

  final List<ShowcaseEntry> entries;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: entries.length,
        itemBuilder: (context, index) {
          final entry = entries[index];

          return SizedBox(
            width: 150,
            child: Padding(
              padding: const EdgeInsets.only(right: 3),
              child: SectionCard(
                onTap: () => Navigator.of(context).pushNamed(entry.route),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        entry.icon,
                        size: 20,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      entry.title,
                      style: Theme.of(context).textTheme.titleSmall,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      entry.subtitle,
                      style: Theme.of(context).textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
