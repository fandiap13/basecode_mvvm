import 'package:basecode/core/theme/app_theme.dart';
import 'package:basecode/core/widgets/button/app_button.dart';
import 'package:basecode/core/widgets/checkbox/app_checkbox.dart';
import 'package:basecode/core/widgets/dropdown/app_dropdown_field.dart';
import 'package:basecode/core/widgets/slider/app_slider.dart';
import 'package:basecode/core/widgets/text_field/app_text_field.dart';
import 'package:basecode/features/showcase/view/form/form_showcase_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pumpForm(WidgetTester tester) async {
    // Layar dibuat tinggi agar seluruh form muat tanpa perlu scroll.
    tester.view.physicalSize = const Size(1200, 4000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.light(), home: const FormShowcaseScreen()),
    );
  }

  Future<void> isi(WidgetTester tester, String label, String teks) {
    return tester.enterText(find.widgetWithText(AppTextField, label), teks);
  }

  Future<void> tapDaftar(WidgetTester tester) async {
    await tester.tap(find.widgetWithText(AppButton, 'Daftar'));
    await tester.pump();
  }

  Future<void> isiSemuaValid(WidgetTester tester) async {
    await isi(tester, 'Nama lengkap', 'Fandy');
    await isi(tester, 'Email', 'fandy@mail.com');
    await isi(tester, 'Kata sandi', 'rahasia');

    await tester.tap(find.byType(AppDropdownField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Bandung').last);
    await tester.pumpAndSettle();
  }

  testWidgets('submit kosong memunculkan galat tiap kolom', (tester) async {
    await pumpForm(tester);
    await tapDaftar(tester);

    expect(find.text('Nama wajib diisi'), findsOneWidget);
    expect(find.text('Email wajib diisi'), findsOneWidget);
    expect(find.text('Kata sandi terlalu pendek'), findsOneWidget);
    expect(find.text('Kota wajib dipilih'), findsOneWidget);
  });

  testWidgets('email tanpa @ ditolak', (tester) async {
    await pumpForm(tester);

    await isi(tester, 'Email', 'bukanemail');
    await tapDaftar(tester);

    expect(find.text('Format email tidak valid'), findsOneWidget);
  });

  testWidgets('galat hilang saat kolom diperbaiki', (tester) async {
    await pumpForm(tester);
    await tapDaftar(tester);
    expect(find.text('Nama wajib diisi'), findsOneWidget);

    await isi(tester, 'Nama lengkap', 'Fandy');
    await tester.pump();

    expect(find.text('Nama wajib diisi'), findsNothing);
  });

  testWidgets('form valid tanpa centang setuju ditolak', (tester) async {
    await pumpForm(tester);
    await isiSemuaValid(tester);
    await tapDaftar(tester);

    expect(find.text('Centang persetujuan dulu.'), findsOneWidget);
  });

  testWidgets('submit lengkap: loading lalu sukses', (tester) async {
    await pumpForm(tester);
    await isiSemuaValid(tester);

    await tester.tap(find.byType(AppCheckbox));
    await tester.pump();

    await tapDaftar(tester);

    // Selama loading: spinner tampil dan kolom ikut nonaktif.
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    final kolom = tester.widget<AppTextField>(
      find.widgetWithText(AppTextField, 'Nama lengkap'),
    );
    expect(kolom.enabled, isFalse);

    await tester.pump(const Duration(seconds: 2));
    await tester.pump();

    expect(find.textContaining('Pendaftaran Fandy terkirim'), findsOneWidget);
  });

  testWidgets('reset mengosongkan kolom dan galat', (tester) async {
    await pumpForm(tester);
    await tapDaftar(tester);
    expect(find.text('Nama wajib diisi'), findsOneWidget);

    await isi(tester, 'Nama lengkap', 'Fandy');
    await tester.pump();

    await tester.tap(find.widgetWithText(AppButton, 'Reset'));
    await tester.pump();

    expect(find.text('Fandy'), findsNothing);
    expect(find.text('Nama wajib diisi'), findsNothing);
  });

  testWidgets('slider tampil dengan nilai awal terformat', (tester) async {
    await pumpForm(tester);

    expect(find.byType(AppSlider), findsOneWidget);
    // 500000 -> "Rp500 rb" lewat valueFormatter.
    expect(find.text('Rp500 rb'), findsOneWidget);
  });

  testWidgets('slider ikut nonaktif saat loading', (tester) async {
    await pumpForm(tester);
    await isiSemuaValid(tester);

    await tester.tap(find.byType(AppCheckbox));
    await tester.pump();
    await tapDaftar(tester);

    final slider = tester.widget<AppSlider>(find.byType(AppSlider));
    expect(slider.enabled, isFalse);

    await tester.pump(const Duration(seconds: 2));
    await tester.pump();
  });
}
