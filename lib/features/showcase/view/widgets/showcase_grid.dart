import 'package:basecode/core/theme/app_colors.dart';
import 'package:basecode/features/showcase/model/showcase_entry.dart';
import 'package:basecode/features/showcase/view/widgets/section_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ShowcaseGrid extends StatefulWidget {
  const ShowcaseGrid({super.key, required this.entries});

  final List<ShowcaseEntry> entries;

  @override
  State<ShowcaseGrid> createState() => _ShowcaseGridState();
}

class _ShowcaseGridState extends State<ShowcaseGrid> {
  bool _showAll = false;

  @override
  Widget build(BuildContext context) {
    final entries = _showAll ? widget.entries : widget.entries.take(6).toList();

    final hasMore = widget.entries.length > 6;

    return Column(
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 3,
            mainAxisSpacing: 3,
            mainAxisExtent: 160,
            // childAspectRatio: 1
          ),
          itemCount: entries.length,
          itemBuilder: (context, index) {
            final entry = entries[index];
            return Opacity(
              opacity: entry.isReady ? 1 : 0.45, // jadi buram opacity 45%
              child: SectionCard(
                onTap: entry.isReady ? () => context.push(entry.route) : null,
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
                      maxLines: 1,
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
            );
          },
        ),

        if (hasMore) ...[
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {
              setState(() {
                _showAll = !_showAll;
              });
            },
            child: Text(_showAll ? 'Tampilkan Lebih Sedikit' : 'Lihat Semua'),
          ),
        ],
      ],
    );
  }
}
