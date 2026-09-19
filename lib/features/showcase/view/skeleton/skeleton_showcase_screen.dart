import 'package:basecode/core/theme/app_colors.dart';
import 'package:basecode/core/theme/app_radius.dart';
import 'package:basecode/core/widgets/card/app_card.dart';
import 'package:basecode/core/widgets/skeleton/app_skeleton.dart';
import 'package:basecode/features/showcase/view/widgets/section_showcase.dart';
import 'package:flutter/material.dart';

/// Etalase sementara untuk widget di `core/widgets/`.
/// Hapus setelah layar asli pertama dibuat.
class SkeletonShowcaseScreen extends StatefulWidget {
  const SkeletonShowcaseScreen({super.key});

  @override
  State<SkeletonShowcaseScreen> createState() => SkeletonShowcaseScreenState();
}

class SkeletonShowcaseScreenState extends State<SkeletonShowcaseScreen> {
  // State lokal layar: cukup setState, belum perlu viewmodel.
  bool _isLoading = true;

  void _toggleLoading() => setState(() => _isLoading = !_isLoading);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.surface,
        title: Text(
          'Skeleton',
          style: theme.textTheme.titleLarge?.copyWith(color: AppColors.paper),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SectionShowcase(
            'SkeletonBox',
            description: 'Blok dasar. Ukuran dan radius diatur pemanggil.',
          ),
          const SkeletonBox(width: 120, height: 32),
          const SizedBox(height: 8),
          const SkeletonBox(height: 32),

          const SectionShowcase(
            'Radius',
            description: 'Sudut memakai token di core/theme/app_radius.dart.',
          ),
          for (final entry in const <(String, double)>[
            ('xs', AppRadius.xs),
            ('sm', AppRadius.sm),
            ('md', AppRadius.md),
            ('lg', AppRadius.lg),
            ('xl', AppRadius.xl),
          ])
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  SizedBox(
                    width: 56,
                    child: Text(entry.$1, style: theme.textTheme.bodySmall),
                  ),
                  Expanded(child: SkeletonBox(height: 32, radius: entry.$2)),
                ],
              ),
            ),

          const SectionShowcase(
            'SkeletonCircle',
            description: 'Untuk avatar atau ikon bulat.',
          ),
          const Row(
            children: [
              SkeletonCircle(size: 24),
              SizedBox(width: 12),
              SkeletonCircle(),
              SizedBox(width: 12),
              SkeletonCircle(size: 56),
              SizedBox(width: 12),
              SkeletonCircle(size: 72),
            ],
          ),

          const SectionShowcase(
            'SkeletonText',
            description:
                'Baris teks tiruan. Baris terakhir dibuat lebih '
                'pendek agar menyerupai paragraf asli.',
          ),
          const SkeletonText(),
          const SizedBox(height: 8),
          const SkeletonText(),
          const SizedBox(height: 8),
          const SkeletonText(width: 180),

          const SectionShowcase(
            'Komposisi: list tile',
            description: 'Avatar, judul, dan subjudul.',
          ),
          for (var i = 0; i < 3; i++)
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonCircle(size: 44),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SkeletonText(height: 16),
                        SizedBox(height: 8),
                        SkeletonText(width: 140),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          const SectionShowcase(
            'Komposisi: kartu',
            description:
                'Skeleton di dalam AppCard, bentuknya mengikuti '
                'konten asli yang akan menggantikannya.',
          ),
          const AppCard(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonBox(height: 140, radius: AppRadius.md),
                  SizedBox(height: 16),
                  SkeletonText(height: 18),
                  SizedBox(height: 8),
                  SkeletonText(),
                  SizedBox(height: 8),
                  SkeletonText(width: 200),
                ],
              ),
            ),
          ),

          const SectionShowcase(
            'Loading → konten',
            description:
                'Pemakaian sebenarnya: skeleton ditukar dengan '
                'konten asli. Ukurannya sengaja dibuat mirip agar tidak '
                'terjadi lompatan layout.',
          ),
          AppCard(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: _isLoading
                  ? const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SkeletonCircle(size: 44),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SkeletonText(height: 16),
                              SizedBox(height: 8),
                              SkeletonText(width: 140),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: theme.appColors.tealTint,
                          child: Icon(
                            Icons.person_outline,
                            color: theme.appColors.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Fandy Wangdef',
                                style: theme.textTheme.titleSmall,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Flutter developer',
                                style: theme.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
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
