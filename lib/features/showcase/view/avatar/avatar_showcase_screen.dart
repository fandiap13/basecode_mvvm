import 'package:basecode/core/theme/app_colors.dart';
import 'package:basecode/core/theme/app_spacing.dart';
import 'package:basecode/core/widgets/avatar/app_avatar.dart';
import 'package:basecode/features/showcase/view/widgets/section_showcase.dart';
import 'package:flutter/material.dart';

/// Etalase sementara untuk widget di `core/widgets/`.
/// Hapus setelah layar asli pertama dibuat.
class AvatarShowcaseScreen extends StatefulWidget {
  const AvatarShowcaseScreen({super.key});

  @override
  State<AvatarShowcaseScreen> createState() => AvatarShowcaseScreenState();
}

class AvatarShowcaseScreenState extends State<AvatarShowcaseScreen> {
  // State lokal layar: cukup setState, belum perlu viewmodel.
  int _tapCount = 0;

  // Gambar contoh; URL yang sengaja salah dipakai menguji cadangan.
  static const _foto = 'https://i.pravatar.cc/150?img=12';
  static const _fotoRusak = 'https://contoh.invalid/tidak-ada.png';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.surface,
        title: Text(
          'App Avatar',
          style: theme.textTheme.titleLarge?.copyWith(color: AppColors.paper),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          const SectionShowcase(
            'Isi',
            description:
                'Urutan cadangan: gambar → inisial → ikon. '
                'Avatar kedua memakai URL rusak, jadi jatuh ke inisial.',
          ),
          Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.md,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: const [
              AppAvatar(imageUrl: _foto, size: AppAvatarSize.lg),
              AppAvatar(
                imageUrl: _fotoRusak,
                name: 'Fandy Wangdef',
                size: AppAvatarSize.lg,
              ),
              AppAvatar(name: 'Fandy Wangdef', size: AppAvatarSize.lg),
              AppAvatar(size: AppAvatarSize.lg),
              AppAvatar(
                icon: Icons.storefront_outlined,
                size: AppAvatarSize.lg,
              ),
            ],
          ),

          const SectionShowcase(
            'Inisial',
            description:
                'Dua kata diambil huruf pertama tiap kata, '
                'satu kata diambil satu huruf.',
          ),
          Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.md,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              for (final nama in const [
                'Fandy Wangdef',
                'Fandy',
                'Ahmad Rizki Pratama',
              ])
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppAvatar(name: nama, size: AppAvatarSize.lg),
                    const SizedBox(height: AppSpacing.xs),
                    Text(nama, style: theme.textTheme.bodySmall),
                  ],
                ),
            ],
          ),

          const SectionShowcase(
            'Size',
            description:
                'Tiap ukuran membawa metrik sendiri '
                '(diameter, fontSize, statusSize).',
          ),
          Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.md,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              for (final size in AppAvatarSize.values)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppAvatar(name: 'Fandy Wangdef', size: size),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '${size.name} (${size.diameter.toInt()})',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
            ],
          ),

          const SectionShowcase(
            'Variant',
            description: 'Warna latar dari token tema.',
          ),
          Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.md,
            children: [
              for (final variant in AppAvatarVariant.values)
                AppAvatar(
                  name: 'Fandy Wangdef',
                  variant: variant,
                  size: AppAvatarSize.lg,
                  tooltip: variant.name,
                ),
            ],
          ),

          const SectionShowcase(
            'Shape',
            description:
                'circle untuk orang, rounded untuk entitas '
                'seperti toko atau tim.',
          ),
          const Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.md,
            children: [
              AppAvatar(name: 'Fandy Wangdef', size: AppAvatarSize.lg),
              AppAvatar(
                name: 'Toko Maju',
                shape: AppAvatarShape.rounded,
                variant: AppAvatarVariant.secondary,
                size: AppAvatarSize.lg,
              ),
              AppAvatar(
                imageUrl: _foto,
                shape: AppAvatarShape.rounded,
                size: AppAvatarSize.lg,
              ),
            ],
          ),

          const SectionShowcase(
            'Status',
            description: 'Titik penanda daring di pojok kanan bawah.',
          ),
          const Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.md,
            children: [
              AppAvatar(
                name: 'Fandy Wangdef',
                size: AppAvatarSize.lg,
                showStatus: true,
                isOnline: true,
              ),
              AppAvatar(
                name: 'Fandy Wangdef',
                size: AppAvatarSize.lg,
                showStatus: true,
              ),
              AppAvatar(
                imageUrl: _foto,
                size: AppAvatarSize.lg,
                showStatus: true,
                isOnline: true,
              ),
            ],
          ),

          const SectionShowcase(
            'Dapat diketuk',
            description: 'onTap memberi ripple dan area sentuh.',
          ),
          Row(
            children: [
              AppAvatar(
                name: 'Fandy Wangdef',
                size: AppAvatarSize.lg,
                tooltip: 'Buka profil',
                onTap: () => setState(() => _tapCount++),
              ),
              const SizedBox(width: AppSpacing.md),
              Text('Diketuk: $_tapCount', style: theme.textTheme.bodyMedium),
            ],
          ),

          const SectionShowcase(
            'Grup',
            description:
                'AppAvatarGroup menumpuk beberapa avatar; '
                'sisanya diringkas jadi "+N".',
          ),
          const AppAvatarGroup(
            avatars: [
              AppAvatar(name: 'Fandy Wangdef'),
              AppAvatar(name: 'Ahmad Rizki', variant: AppAvatarVariant.info),
              AppAvatar(name: 'Siti Nur', variant: AppAvatarVariant.warning),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const AppAvatarGroup(
            max: 3,
            avatars: [
              AppAvatar(name: 'Fandy Wangdef'),
              AppAvatar(name: 'Ahmad Rizki', variant: AppAvatarVariant.info),
              AppAvatar(name: 'Siti Nur', variant: AppAvatarVariant.warning),
              AppAvatar(name: 'Budi Santoso'),
              AppAvatar(name: 'Dewi Lestari'),
            ],
          ),

          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}
