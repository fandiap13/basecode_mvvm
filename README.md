# basecode

Template awal aplikasi Flutter dengan arsitektur MVVM, design token, dan
kumpulan widget siap pakai di `core/widgets/`.

Setiap widget punya layar etalase di `features/showcase/` yang menunjukkan
tiap parameternya, dan widget test di `test/core/widgets/`.

## Menjalankan

```bash
flutter pub get

# per flavor
flutter run -t lib/main_dev.dart  --dart-define-from-file=env/dev.json
flutter run -t lib/main_prod.dart --dart-define-from-file=env/prod.json

# tanpa -t juga bisa; main.dart memanggil bootstrap(Flavor.dev)
flutter run
```

Aplikasi terbuka langsung di layar **Showcase**: daftar semua komponen dan
token, dikelompokkan jadi Components dan Foundation.

> **Windows:** jalankan `flutter run` dari PowerShell atau CMD, bukan Git
> Bash. Git Bash tidak meneruskan `debugPrint` dari perangkat ke terminal.
> Alternatifnya `winpty flutter run`, atau pantau lewat `flutter logs` di
> terminal kedua.

## Setelah setiap perubahan

```bash
dart format .
flutter analyze
flutter test
```

Ketiganya harus lulus. Saat ini: **181 test**, analyze bersih.

## Struktur

```
lib/
├── main_dev.dart / main_prod.dart   # hanya memanggil bootstrap(Flavor.x)
├── app/          # bootstrap.dart, app.dart, dependencies.dart
├── config/       # flavor.dart, env.dart
├── routing/      # routes.dart (konstanta path), app_router.dart
├── core/
│   ├── theme/    # design token + AppTheme
│   └── widgets/  # widget bersama
└── features/
    └── showcase/ # etalase komponen (hapus saat layar asli dibuat)
```

## Design token

Semua di `lib/core/theme/`. Fitur tidak boleh menulis warna, radius, atau
jarak secara langsung — selalu lewat token.

| Berkas | Isi |
|---|---|
| `app_colors.dart` | Warna light & dark, dijembatani `AppColorsTheme` |
| `app_typography.dart` | `AppFontSize`, `AppFontWeight`, `TextTheme` |
| `app_radius.dart` | `xs` 4 · `sm` 6 · `md` 8 · `lg` 12 · `xl` 20 |
| `app_spacing.dart` | `xs` 4 · `sm` 8 · `md` 16 · `lg` 24 · `xl` 32 |
| `app_elevation.dart` | `none` 0 · `sm` 3 · `md` 6 · `lg` 12 |
| `app_breakpoints.dart` | `mobile` 600 · `tablet` 905 · `desktop` 1240 |
| `app_theme.dart` | Merakit semuanya jadi `ThemeData` |

Membaca token di dalam widget:

```dart
final c = Theme.of(context).appColors;

Container(color: c.primary);                 // warna
const EdgeInsets.all(AppSpacing.md);         // jarak
BorderRadius.circular(AppRadius.lg);         // sudut
```

`AppBreakpoints` juga menyediakan pembantu responsif:

```dart
final size = AppBreakpoints.of(context);     // compact / medium / expanded / large
if (size.isCompact) { ... }
GridView.count(crossAxisCount: size.columns, ...);
```

### Diatur sekali di tema

`AppTheme` sudah mengatur `cardTheme`, `inputDecorationTheme`, dan tema
tombol. Artinya widget tidak perlu menulis ulang bentuk dan warnanya —
nilai yang tidak diisi jatuh ke tema.

Untuk `AppTextField` dan `AppDropdownField`, `decoration` dari pemanggil
**melanjutkan** tema, bukan menimpanya:

```
inputDecorationTheme  →  decoration pemanggil  →  yang wajib dipasang widget
      (dasar)               (melanjutkan)          (label, hint, ikon)
```

## Widget

Semua di `lib/core/widgets/`. Pola yang dipakai bersama:

- `variant` menentukan warna, diambil dari token
- `size` adalah enhanced enum yang membawa metriknya sendiri
- `isLoading` datang dari layar, bukan dimiliki widget
- `onPressed: null` berarti nonaktif
- Widget berikon saja wajib punya `tooltip`

### Masukan

| Widget | Berkas | Catatan |
|---|---|---|
| `AppTextField` | `text_field/` | `labelPosition` outside/floating, `prefixIcon`, `obscureText` |
| `AppDropdownField<T>` | `dropdown/` | Generik; `T` tidak harus `String` |
| `AppCheckbox` · `AppRadio` | `checkbox/` | `label` + `subtitle`, ketuk label ikut mengubah |
| `AppSwitch` | `switch/` | Untuk setelan yang langsung berlaku |
| `AppSlider` | `slider/` | `valueFormatter` mengubah angka jadi teks terbaca |

### Aksi

| Widget | Berkas | Catatan |
|---|---|---|
| `AppButton` | `button/` | 8 variant, 3 size, ikon depan/belakang |
| `AppIconButton` | `button/` | Wajib `tooltip` |

Keduanya memakai aturan border yang sama: hanya variant `outline` yang
bergaris secara bawaan, sewarna teksnya. Mengisi `borderColor` memunculkan
garis di variant mana pun.

### Tampilan

| Widget | Berkas | Catatan |
|---|---|---|
| `AppCard` | `card/` | Rata tanpa bayangan, bersandar garis tipis |
| `AppListTile` | `list_tile/` | |
| `AppAvatar` | `avatar/` | Cadangan berjenjang: gambar → inisial → ikon |
| `AppAvatarGroup` | `avatar/` | Bertumpuk, sisanya jadi `+N` |
| `AppChip` | `chip/` | Status, kategori, filter yang bisa dihapus |
| `AppBadge` | `chip/` | Angka atau titik; `maxCount` jadi `99+` |
| `AppCarousel` | `carousel/` | `autoPlay`, indikator titik |
| `AppTab` · `AppTabBussines` | `tab/` | Bussines: tab aktif menyatu dengan panel |

### Keadaan

| Widget | Berkas | Catatan |
|---|---|---|
| `AppLoading` | `loading/` | Spinner dengan label opsional |
| `AppProgress` | `progress/` | Determinate & indeterminate |
| `SkeletonBox` · `SkeletonCircle` · `SkeletonText` | `skeleton/` | Shimmer; animasi dipegang `SkeletonBase` |
| `AppStateView` | `state_view/` | `.empty()` · `.error()` · `.offline()` · `.search()` |

### Umpan balik

Ketiganya fungsi statis, bukan widget, karena butuh `BuildContext` dari
view:

```dart
AppFeedback.snackbar(context, message: 'Tersimpan', tone: AppFeedbackTone.success);

final setuju = await AppFeedback.confirm(
  context,
  title: 'Hapus item ini?',
  tone: AppFeedbackTone.danger,
);

final pilihan = await AppBottomSheet.showOptions<String>(
  context,
  title: 'Urutkan',
  options: const [
    AppBottomSheetOption(value: 'baru', label: 'Terbaru'),
  ],
);
```

`AppBottomSheet` juga punya `show()` untuk sheet biasa dan
`showScrollable()` yang tingginya bisa ditarik.

## Showcase

Etalase di `lib/features/showcase/` memamerkan tiap parameter widget.
Layar **Form** berbeda sendiri: ia merangkai semua komponen masukan jadi
satu form utuh dengan validasi, submit, dan keadaan loading — contoh
pemakaian sebenarnya, bukan galeri.

Foundation berisi Colors, Typography, Spacing, Elevation, dan Breakpoints.

Seluruh folder `showcase/` sementara; hapus setelah layar asli pertama
dibuat.

## Menambah widget baru

1. Buat di `lib/core/widgets/<nama>/app_<nama>.dart`
2. Ambil warna dari `Theme.of(context).appColors`, jangan nilai tetap
3. Buat layar etalasenya di `lib/features/showcase/view/<nama>/`
4. Daftarkan `GoRoute` di `routing/app_router.dart` memakai konstanta dari
   `routing/routes.dart`
5. Tulis widget test di `test/core/widgets/<nama>/`
6. Jalankan `dart format .`, `flutter analyze`, `flutter test`

## Dependensi

Prioritas SDK dulu. Yang terpasang saat ini:

| Paket | Alasan |
|---|---|
| `go_router` | Routing deklaratif |
| `cupertino_icons` | Bawaan template |

<!-- Tanpa code generation, tanpa pustaka state management pihak ketiga.
Detail aturannya ada di `CLAUDE.md`. -->
