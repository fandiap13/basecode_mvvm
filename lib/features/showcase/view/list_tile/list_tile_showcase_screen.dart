import 'package:basecode/core/theme/app_colors.dart';
import 'package:basecode/core/widgets/list_tile/app_list_tile.dart';
import 'package:basecode/features/showcase/view/widgets/section_showcase.dart';
import 'package:flutter/material.dart';

/// Etalase sementara untuk widget di `core/widgets/`.
/// Hapus setelah layar asli pertama dibuat.
class ListTileShowcaseScreen extends StatefulWidget {
  const ListTileShowcaseScreen({super.key});

  @override
  State<ListTileShowcaseScreen> createState() => ListTileShowcaseScreenState();
}

class ListTileShowcaseScreenState extends State<ListTileShowcaseScreen> {
  // State lokal layar: cukup setState, belum perlu viewmodel.
  int _tapCount = 0;
  int _selected = 0;

  void _onTileTap() => setState(() => _tapCount++);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.surface,
        title: Text(
          'App List Tile',
          style: theme.textTheme.titleLarge?.copyWith(color: AppColors.paper),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SectionShowcase(
            'Dasar',
            description: 'Baris dengan ikon depan, judul, dan aksi belakang.',
          ),
          AppListTile(
            leading: Icons.person_outline,
            title: 'Profil',
            subtitle: 'Nama, foto, dan data diri.',
            trailing: const Icon(Icons.chevron_right),
            onTap: _onTileTap,
          ),
          const SizedBox(height: 8),
          Text('Diketuk $_tapCount kali', style: theme.textTheme.bodyMedium),

          const SectionShowcase(
            'Tanpa aksi',
            description: 'Tanpa onTap: baris tidak bisa diketuk.',
          ),
          const AppListTile(
            leading: Icons.info_outline,
            title: 'Versi aplikasi',
            subtitle: '1.0.0+1',
          ),

          const SectionShowcase(
            'Trailing kustom',
            description: 'Sisi belakang bisa diisi widget apa pun.',
          ),
          AppListTile(
            leading: Icons.notifications_outlined,
            title: 'Notifikasi',
            trailing: Switch(value: true, onChanged: (_) {}),
            onTap: () {},
          ),

          const SectionShowcase(
            'Selected',
            description: 'Baris terpilih memakai latar dari token tema.',
          ),
          for (var i = 0; i < 3; i++)
            AppListTile(
              leading: Icons.folder_outlined,
              title: 'Folder ${i + 1}',
              selected: _selected == i,
              onTap: () => setState(() => _selected = i),
            ),

          const SectionShowcase(
            'Dense',
            description: 'Baris rapat untuk daftar yang panjang.',
          ),
          const AppListTile(
            leading: Icons.inbox_outlined,
            title: 'Kotak masuk',
            dense: true,
            onTap: null,
          ),
          const AppListTile(
            leading: Icons.send_outlined,
            title: 'Terkirim',
            dense: true,
            onTap: null,
          ),

          const SectionShowcase(
            'Nonaktif',
            description: 'enabled: false membuat baris pudar.',
          ),
          const AppListTile(
            leading: Icons.cloud_off_outlined,
            title: 'Sinkronisasi',
            subtitle: 'Butuh koneksi internet.',
            enabled: false,
          ),

          const SizedBox(height: 80),
        ],
      ),
    );
  }
}
