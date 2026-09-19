import 'package:basecode/core/theme/app_colors.dart';
import 'package:basecode/core/widgets/text_field/app_text_field.dart';
import 'package:basecode/features/showcase/view/widgets/section_showcase.dart';
import 'package:flutter/material.dart';

/// Etalase sementara untuk widget di `core/widgets/`.
/// Hapus setelah layar asli pertama dibuat.
class TextFieldShowcaseScreen extends StatefulWidget {
  const TextFieldShowcaseScreen({super.key});

  @override
  State<TextFieldShowcaseScreen> createState() =>
      TextFieldShowcaseScreenState();
}

class TextFieldShowcaseScreenState extends State<TextFieldShowcaseScreen> {
  // Controller adalah state lokal layar: dibuat di initState,
  // dibersihkan di dispose.
  late final TextEditingController _controllerDasar;
  late final TextEditingController _controllerValidasi;

  // State lokal layar: cukup setState, belum perlu viewmodel.
  bool _obscure = true;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _controllerDasar = TextEditingController();
    _controllerValidasi = TextEditingController();
  }

  @override
  void dispose() {
    _controllerDasar.dispose();
    _controllerValidasi.dispose();
    super.dispose();
  }

  void _toggleObscure() => setState(() => _obscure = !_obscure);

  // Contoh validasi sederhana; di layar asli logika ini milik viewmodel.
  void _validasiEmail(String value) {
    setState(() {
      _errorText = value.isEmpty || value.contains('@')
          ? null
          : 'Format email tidak valid';
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.surface,
        title: Text(
          'App Text Field',
          style: theme.textTheme.titleLarge?.copyWith(color: AppColors.paper),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SectionShowcase(
            'Label & hint',
            description:
                'label melayang di atas saat diisi, hint hanya '
                'tampil selama kolom masih kosong.',
          ),
          const AppTextField(label: 'Nama lengkap', hint: 'Contoh: Fandy'),

          const SectionShowcase(
            'Helper text',
            description: 'Keterangan bantuan di bawah kolom.',
          ),
          const AppTextField(
            label: 'Username',
            helperText: 'Minimal 4 karakter, tanpa spasi.',
          ),

          const SectionShowcase(
            'Error text',
            description:
                'errorText menggantikan helperText dan mewarnai '
                'kolom. Ketik tanpa "@" untuk memunculkannya.',
          ),
          AppTextField(
            controller: _controllerValidasi,
            label: 'Email',
            hint: 'nama@domain.com',
            keyboardType: TextInputType.emailAddress,
            errorText: _errorText,
            onChanged: _validasiEmail,
          ),

          const SectionShowcase(
            'Prefix & suffix icon',
            description:
                'Ikon bisa diberi aksi lewat onPrefixTap / '
                'onSuffixTap. Contoh di bawah: tombol lihat sandi.',
          ),
          const AppTextField(
            label: 'Cari',
            hint: 'Kata kunci',
            prefixIcon: Icons.search,
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: 'Kata sandi',
            obscureText: _obscure,
            prefixIcon: Icons.lock_outline,
            suffixIcon: _obscure ? Icons.visibility_off : Icons.visibility,
            onSuffixTap: _toggleObscure,
          ),

          const SectionShowcase(
            'Keyboard type',
            description: 'Menentukan papan ketik yang muncul di perangkat.',
          ),
          const AppTextField(
            label: 'Nomor telepon',
            hint: '08xxxxxxxxxx',
            prefixIcon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
          ),

          const SectionShowcase(
            'Multi-line',
            description:
                'maxLines > 1 membuat kolom tumbuh ke bawah. '
                'Diabaikan saat obscureText aktif.',
          ),
          const AppTextField(
            label: 'Catatan',
            hint: 'Tulis beberapa baris...',
            maxLines: 4,
          ),

          const SectionShowcase(
            'Enabled & readOnly',
            description:
                'enabled: false membuat kolom pudar dan tidak bisa '
                'difokus. readOnly tetap bisa difokus dan disalin, tapi '
                'isinya tidak dapat diubah.',
          ),
          const AppTextField(
            label: 'Nonaktif',
            hint: 'enabled: false',
            enabled: false,
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: TextEditingController(text: 'Hanya bisa dibaca'),
            label: 'Read only',
            readOnly: true,
          ),

          const SectionShowcase(
            'Controller & onChanged',
            description:
                'controller membaca dan menulis isi kolom; '
                'onChanged dipanggil setiap ketikan.',
          ),
          AppTextField(
            controller: _controllerDasar,
            label: 'Ketik sesuatu',
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 8),
          Text(
            'Isi: "${_controllerDasar.text}" '
            '(${_controllerDasar.text.length} karakter)',
            style: theme.textTheme.bodyMedium,
          ),

          const SectionShowcase(
            'decoration',
            description:
                'Menimpa InputDecoration bawaan untuk kasus khusus. '
                'label, hint, helper, error, dan ikon tetap dipasang '
                'AppTextField di atasnya.',
          ),
          const AppTextField(
            label: 'Border tanpa garis',
            hint: 'filled: true',
            decoration: InputDecoration(
              filled: true,
              border: OutlineInputBorder(borderSide: BorderSide.none),
            ),
          ),

          const SizedBox(height: 80),
        ],
      ),
    );
  }
}
