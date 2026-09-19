import 'package:basecode/core/theme/app_colors.dart';
import 'package:basecode/core/theme/app_spacing.dart';
import 'package:basecode/core/widgets/button/app_button.dart';
import 'package:basecode/core/widgets/button/app_icon_button.dart';
import 'package:basecode/core/widgets/card/app_card.dart';
import 'package:basecode/core/widgets/checkbox/app_checkbox.dart';
import 'package:basecode/core/widgets/dropdown/app_dropdown_field.dart';
import 'package:basecode/core/widgets/slider/app_slider.dart';
import 'package:basecode/core/widgets/switch/app_switch.dart';
import 'package:basecode/core/widgets/text_field/app_text_field.dart';
import 'package:basecode/features/showcase/view/widgets/section_showcase.dart';
import 'package:flutter/material.dart';

/// Etalase sementara untuk widget di `core/widgets/`.
/// Hapus setelah layar asli pertama dibuat.
///
/// Berbeda dari showcase lain yang memamerkan satu widget, layar ini
/// menunjukkan semua komponen form bekerja sama: validasi, submit,
/// dan keadaan loading.
class FormShowcaseScreen extends StatefulWidget {
  const FormShowcaseScreen({super.key});

  @override
  State<FormShowcaseScreen> createState() => FormShowcaseScreenState();
}

class FormShowcaseScreenState extends State<FormShowcaseScreen> {
  late final TextEditingController _nama;
  late final TextEditingController _email;
  late final TextEditingController _sandi;

  // State lokal layar: cukup setState, belum perlu viewmodel.
  String? _kota;
  bool _setuju = false;
  bool _notifikasi = true;
  double _budget = 500000;
  bool _obscure = true;
  bool _isLoading = false;

  // Pesan galat per kolom; null berarti kolom itu lolos validasi.
  String? _errNama;
  String? _errEmail;
  String? _errSandi;
  String? _errKota;

  static const _kotaList = ['Jakarta', 'Bandung', 'Surabaya', 'Yogyakarta'];

  @override
  void initState() {
    super.initState();
    _nama = TextEditingController();
    _email = TextEditingController();
    _sandi = TextEditingController();
  }

  @override
  void dispose() {
    _nama.dispose();
    _email.dispose();
    _sandi.dispose();
    super.dispose();
  }

  void _toggleObscure() => setState(() => _obscure = !_obscure);

  /// Validasi sederhana. Di layar asli logika ini milik viewmodel.
  bool _validasi() {
    setState(() {
      _errNama = _nama.text.trim().isEmpty ? 'Nama wajib diisi' : null;

      final email = _email.text.trim();
      _errEmail = email.isEmpty
          ? 'Email wajib diisi'
          : !email.contains('@')
          ? 'Format email tidak valid'
          : null;

      _errSandi = _sandi.text.length < 6 ? 'Kata sandi terlalu pendek' : null;

      _errKota = _kota == null ? 'Kota wajib dipilih' : null;
    });

    return _errNama == null &&
        _errEmail == null &&
        _errSandi == null &&
        _errKota == null;
  }

  Future<void> _submit() async {
    if (!_validasi()) return;

    if (!_setuju) {
      _pesan('Centang persetujuan dulu.');
      return;
    }

    setState(() => _isLoading = true);
    // Meniru panggilan jaringan; di layar asli ini lewat repository.
    await Future<void>.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    setState(() => _isLoading = false);
    _pesan(
      'Pendaftaran ${_nama.text.trim()} terkirim '
      '(budget ${_rupiah(_budget)}).',
    );
  }

  void _reset() {
    setState(() {
      _nama.clear();
      _email.clear();
      _sandi.clear();
      _kota = null;
      _setuju = false;
      _notifikasi = true;
      _budget = 500000;
      _errNama = _errEmail = _errSandi = _errKota = null;
    });
  }

  /// Ubah angka jadi format rupiah sederhana, mis. 1500000 -> "Rp1,5 jt".
  String _rupiah(double value) {
    final juta = value / 1000000;
    if (juta >= 1) {
      final teks = juta.toStringAsFixed(1).replaceAll('.', ',');
      return 'Rp$teks jt';
    }
    return 'Rp${(value / 1000).round()} rb';
  }

  void _pesan(String teks) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(teks)));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.surface,
        title: Text(
          'Form',
          style: theme.textTheme.titleLarge?.copyWith(color: AppColors.paper),
        ),
        actions: [
          AppIconButton(
            icon: Icons.refresh,
            variant: AppIconButtonVariant.text,
            tooltip: 'Reset form',
            onPressed: _isLoading ? null : _reset,
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          const SectionShowcase(
            'Data diri',
            description:
                'AppTextField dengan validasi per kolom. '
                'errorText diisi saat submit gagal.',
          ),
          AppTextField(
            controller: _nama,
            label: 'Nama lengkap',
            hint: 'Contoh: Fandy',
            prefixIcon: Icons.person_outline,
            errorText: _errNama,
            enabled: !_isLoading,
            onChanged: (_) {
              if (_errNama != null) setState(() => _errNama = null);
            },
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            controller: _email,
            label: 'Email',
            hint: 'nama@domain.com',
            prefixIcon: Icons.mail_outline,
            keyboardType: TextInputType.emailAddress,
            errorText: _errEmail,
            enabled: !_isLoading,
            onChanged: (_) {
              if (_errEmail != null) setState(() => _errEmail = null);
            },
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            controller: _sandi,
            label: 'Kata sandi',
            hint: 'Minimal 6 karakter',
            prefixIcon: Icons.lock_outline,
            suffixIcon: _obscure ? Icons.visibility_off : Icons.visibility,
            onSuffixTap: _toggleObscure,
            obscureText: _obscure,
            errorText: _errSandi,
            enabled: !_isLoading,
            onChanged: (_) {
              if (_errSandi != null) setState(() => _errSandi = null);
            },
          ),

          const SectionShowcase(
            'Pilihan',
            description: 'AppDropdownField untuk daftar tertutup.',
          ),
          AppDropdownField<String>(
            label: 'Kota',
            hint: 'Pilih kota',
            value: _kota,
            prefixIcon: Icons.location_city_outlined,
            errorText: _errKota,
            enabled: !_isLoading,
            items: [
              for (final kota in _kotaList)
                DropdownMenuItem(value: kota, child: Text(kota)),
            ],
            onChanged: (value) => setState(() {
              _kota = value;
              _errKota = null;
            }),
          ),

          const SectionShowcase(
            'Anggaran',
            description:
                'AppSlider untuk nilai rentang. valueFormatter '
                'mengubah angka mentah jadi teks yang terbaca.',
          ),
          AppSlider(
            value: _budget,
            min: 100000,
            max: 2000000,
            divisions: 19,
            label: 'Budget maksimum',
            showValue: true,
            enabled: !_isLoading,
            valueFormatter: _rupiah,
            onChanged: (value) => setState(() => _budget = value),
          ),

          const SectionShowcase(
            'Preferensi',
            description:
                'AppSwitch untuk setelan yang langsung berlaku, '
                'AppCheckbox untuk persetujuan.',
          ),
          AppCard(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Column(
                children: [
                  AppSwitch(
                    value: _notifikasi,
                    label: 'Notifikasi email',
                    subtitle: 'Kabar promo dan pembaruan produk.',
                    enabled: !_isLoading,
                    onChanged: (value) => setState(() => _notifikasi = value),
                  ),
                  const Divider(height: AppSpacing.lg),
                  AppCheckbox(
                    value: _setuju,
                    label: 'Saya setuju dengan syarat & ketentuan',
                    subtitle: 'Wajib dicentang sebelum mendaftar.',
                    enabled: !_isLoading,
                    onChanged: (value) =>
                        setState(() => _setuju = value ?? false),
                  ),
                ],
              ),
            ),
          ),

          const SectionShowcase(
            'Submit',
            description:
                'isLoading berasal dari layar, bukan dari tombol. '
                'Selama loading semua kolom ikut nonaktif.',
          ),
          AppButton(
            label: 'Daftar',
            isExpanded: true,
            isLoading: _isLoading,
            leadingIcon: Icons.check,
            onPressed: _submit,
          ),
          const SizedBox(height: AppSpacing.sm),
          AppButton(
            label: 'Reset',
            variant: AppButtonVariant.outline,
            isExpanded: true,
            onPressed: _isLoading ? null : _reset,
          ),

          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}
