import 'package:basecode/core/theme/app_colors.dart';
import 'package:basecode/core/theme/app_radius.dart';
import 'package:basecode/core/widgets/card/app_card.dart';
import 'package:basecode/features/showcase/view/widgets/section_showcase.dart';
import 'package:flutter/material.dart';

/// Etalase sementara untuk widget di `core/widgets/`.
/// Hapus setelah layar asli pertama dibuat.
class CardShowcaseScreen extends StatefulWidget {
  const CardShowcaseScreen({super.key});

  @override
  State<CardShowcaseScreen> createState() => CardShowcaseScreenState();
}

class CardShowcaseScreenState extends State<CardShowcaseScreen> {
  // State lokal layar: cukup setState, belum perlu viewmodel.
  bool _isLoading = false;
  int _tapCount = 0;

  void _toggleLoading() => setState(() => _isLoading = !_isLoading);

  void _onCardTap() => setState(() => _tapCount++);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.surface,
        title: Text(
          'App Card',
          style: theme.textTheme.titleLarge?.copyWith(color: AppColors.paper),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SectionShowcase(
            'Basic',
            description: 'Kartu default dengan padding isi sendiri.',
          ),
          const AppCard(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text('Konten kartu sederhana.'),
            ),
          ),

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
            AppCard(
              radius: entry.$2,
              margin: const EdgeInsets.only(bottom: 8),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text('radius ${entry.$1} (${entry.$2.toInt()})'),
              ),
            ),

          const SectionShowcase(
            'Color',
            description: 'Warna latar dari token tema, bukan nilai hardcode.',
          ),
          AppCard(
            color: colors.tealTint,
            margin: const EdgeInsets.only(bottom: 8),
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Text('tealTint'),
            ),
          ),
          AppCard(
            color: colors.amberTint,
            margin: const EdgeInsets.only(bottom: 8),
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Text('amberTint'),
            ),
          ),
          AppCard(
            color: colors.redTint,
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Text('redTint'),
            ),
          ),

          const SectionShowcase(
            'Tappable',
            description: 'onTap aktif; saat loading tap diabaikan.',
          ),
          AppCard(
            onTap: _onCardTap,
            isLoading: _isLoading,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Ketuk kartu ini'),
                  Text('$_tapCount', style: theme.textTheme.titleMedium),
                ],
              ),
            ),
          ),

          const SectionShowcase(
            'Expanded',
            description: 'isExpanded membuat kartu selebar induknya.',
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: AppCard(
              isExpanded: true,
              color: colors.secondaryTint,
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Text('isExpanded: true'),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Align(
            alignment: Alignment.centerLeft,
            child: AppCard(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text('isExpanded: false'),
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
