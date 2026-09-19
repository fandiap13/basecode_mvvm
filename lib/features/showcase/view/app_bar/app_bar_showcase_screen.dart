import 'package:basecode/core/theme/app_colors.dart';
import 'package:basecode/core/widgets/app_bar/app_app_bar.dart';
import 'package:basecode/core/widgets/card/app_card.dart';
import 'package:basecode/features/showcase/view/widgets/section_showcase.dart';
import 'package:flutter/material.dart';

/// Etalase sementara untuk widget di `core/widgets/`.
/// Hapus setelah layar asli pertama dibuat.
///
/// Layar ini sendiri memakai AppAppBar sebagai contoh nyata; varian lain
/// ditampilkan sebagai batang di dalam kartu.
class AppBarShowcaseScreen extends StatelessWidget {
  const AppBarShowcaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppAppBar(
        title: 'App Bar',
        subtitle: 'Layar ini memakainya langsung',
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
            tooltip: 'Cari',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SectionShowcase(
            'Dasar + subtitle + aksi',
            description: 'Batang di atas adalah AppAppBar yang sesungguhnya.',
          ),
          Text(
            'Judul, subjudul, dan tombol aksi di kanan.',
            style: theme.textTheme.bodyMedium,
          ),

          const SectionShowcase(
            'Judul saja',
            description: 'Tanpa subtitle dan tanpa aksi.',
          ),
          const AppCard(
            child: AppAppBar(title: 'Judul saja', centerTitle: false),
          ),

          const SectionShowcase(
            'Tengah',
            description: 'centerTitle untuk judul di tengah.',
          ),
          const AppCard(child: AppAppBar(title: 'Tengah', centerTitle: true)),

          const SectionShowcase(
            'Tanpa tombol kembali',
            description: 'automaticallyImplyLeading: false.',
          ),
          const AppCard(
            child: AppAppBar(
              title: 'Tanpa kembali',
              automaticallyImplyLeading: false,
            ),
          ),

          const SectionShowcase(
            'Leading kustom',
            description: 'Sisi kiri bisa diisi widget apa pun.',
          ),
          AppCard(
            child: AppAppBar(
              title: 'Menu kustom',
              automaticallyImplyLeading: false,
              leading: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.menu),
                tooltip: 'Menu',
              ),
            ),
          ),

          const SectionShowcase(
            'Warna',
            description: 'Diisi: menimpa warna token untuk kasus khusus.',
          ),
          AppCard(
            child: AppAppBar(
              title: 'Warna danger',
              backgroundColor: theme.appColors.danger,
              automaticallyImplyLeading: false,
            ),
          ),

          const SizedBox(height: 80),
        ],
      ),
    );
  }
}
