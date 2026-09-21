import 'package:basecode/core/theme/app_colors.dart';
import 'package:basecode/core/theme/app_radius.dart';
import 'package:basecode/core/theme/app_spacing.dart';
import 'package:basecode/core/widgets/carousel/carousel_slider.dart';
import 'package:basecode/features/showcase/view/widgets/section_showcase.dart';
import 'package:flutter/material.dart';

/// Etalase sementara untuk widget di `core/widgets/`.
/// Hapus setelah layar asli pertama dibuat.
class CarouselShowcaseScreen extends StatefulWidget {
  const CarouselShowcaseScreen({super.key});

  @override
  State<CarouselShowcaseScreen> createState() => CarouselShowcaseScreenState();
}

class CarouselShowcaseScreenState extends State<CarouselShowcaseScreen> {
  // State lokal layar: cukup setState, belum perlu viewmodel.
  int _halamanAktif = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.surface,
        title: Text(
          'App Carousel',
          style: theme.textTheme.titleLarge?.copyWith(color: AppColors.paper),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          const SectionShowcase(
            'Dasar',
            description:
                'Geser ke samping untuk berpindah. Indikator titik '
                'menandai halaman aktif.',
          ),
          AppCarousel(
            height: 160,
            items: [for (var i = 1; i <= 3; i++) _Slide(index: i)],
          ),

          const SectionShowcase(
            'viewportFraction',
            description:
                'Nilai di bawah 1 menyisakan ruang sehingga slide '
                'tetangga ikut terlihat.',
          ),
          AppCarousel(
            height: 140,
            viewportFraction: 0.8,
            items: [for (var i = 1; i <= 4; i++) _Slide(index: i)],
          ),

          const SectionShowcase(
            'initialPage',
            description: 'Carousel dimulai dari halaman ketiga.',
          ),
          AppCarousel(
            height: 140,
            initialPage: 2,
            items: [for (var i = 1; i <= 4; i++) _Slide(index: i)],
          ),

          const SectionShowcase(
            'autoPlay',
            description:
                'Berpindah sendiri tiap autoPlayDuration. '
                'Contoh ini 2 detik.',
          ),
          AppCarousel(
            height: 140,
            autoPlay: true,
            autoPlayDuration: const Duration(seconds: 2),
            items: [for (var i = 1; i <= 3; i++) _Slide(index: i)],
          ),

          const SectionShowcase(
            'Variant',
            description:
                'Menentukan warna indikator aktif. Diambil dari '
                'token tema.',
          ),
          for (final variant in AppCarouselVariant.values)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(variant.name, style: theme.textTheme.bodyMedium),
                  const SizedBox(height: AppSpacing.xs),
                  AppCarousel(
                    height: 120,
                    variant: variant,
                    items: [for (var i = 1; i <= 3; i++) _Slide(index: i)],
                  ),
                ],
              ),
            ),

          const SectionShowcase(
            'onPageChanged',
            description:
                'Dipanggil tiap halaman berganti; dipakai layar '
                'untuk menampilkan posisi saat ini.',
          ),
          AppCarousel(
            height: 140,
            onPageChanged: (index) => setState(() => _halamanAktif = index),
            items: [for (var i = 1; i <= 4; i++) _Slide(index: i)],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Halaman aktif: ${_halamanAktif + 1}',
            style: theme.textTheme.bodyMedium,
          ),

          const SectionShowcase(
            'showIndicator',
            description:
                'Indikator dapat disembunyikan. Otomatis hilang '
                'juga bila hanya ada satu slide.',
          ),
          AppCarousel(
            height: 140,
            showIndicator: false,
            items: [for (var i = 1; i <= 3; i++) _Slide(index: i)],
          ),

          const SectionShowcase(
            'Satu item',
            description:
                'Indikator tidak muncul karena tidak ada yang '
                'perlu dibandingkan.',
          ),
          const AppCarousel(height: 140, items: [_Slide(index: 1)]),

          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}

/// Slide contoh; isi carousel bebas widget apa pun.
class _Slide extends StatelessWidget {
  const _Slide({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = theme.appColors;

    // Warna bergantian agar perpindahan slide terlihat jelas.
    final warna = [c.tealTint, c.amberTint, c.redTint, c.secondaryTint];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
      decoration: BoxDecoration(
        color: warna[(index - 1) % warna.length],
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: c.line),
      ),
      alignment: Alignment.center,
      child: Text('Slide $index', style: theme.textTheme.titleMedium),
    );
  }
}
