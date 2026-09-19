import 'package:basecode/core/theme/app_radius.dart';
import 'package:basecode/core/theme/app_theme.dart';
import 'package:basecode/core/widgets/text_field/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pumpField(WidgetTester tester, AppTextField field) {
    return tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(body: field),
      ),
    );
  }

  testWidgets('menampilkan label, hint, dan helperText', (tester) async {
    await pumpField(
      tester,
      const AppTextField(
        label: 'Nama',
        hint: 'Isi nama',
        helperText: 'Bantuan',
      ),
    );

    expect(find.text('Nama'), findsOneWidget);
    expect(find.text('Isi nama'), findsOneWidget);
    expect(find.text('Bantuan'), findsOneWidget);
  });

  testWidgets('errorText menggantikan helperText', (tester) async {
    await pumpField(
      tester,
      const AppTextField(helperText: 'Bantuan', errorText: 'Salah'),
    );

    expect(find.text('Salah'), findsOneWidget);
    expect(find.text('Bantuan'), findsNothing);
  });

  testWidgets('onChanged dipanggil saat mengetik', (tester) async {
    final diketik = <String>[];
    await pumpField(tester, AppTextField(onChanged: diketik.add));

    await tester.enterText(find.byType(TextField), 'halo');

    expect(diketik, ['halo']);
  });

  testWidgets('controller membaca isi kolom', (tester) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);

    await pumpField(tester, AppTextField(controller: controller));
    await tester.enterText(find.byType(TextField), 'isi');

    expect(controller.text, 'isi');
  });

  testWidgets('obscureText memaksa satu baris', (tester) async {
    await pumpField(tester, const AppTextField(obscureText: true, maxLines: 5));

    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.obscureText, isTrue);
    expect(field.maxLines, 1);
  });

  testWidgets('maxLines diteruskan saat tidak obscure', (tester) async {
    await pumpField(tester, const AppTextField(maxLines: 4));

    expect(tester.widget<TextField>(find.byType(TextField)).maxLines, 4);
  });

  testWidgets('enabled false menonaktifkan kolom', (tester) async {
    await pumpField(tester, const AppTextField(enabled: false));

    expect(tester.widget<TextField>(find.byType(TextField)).enabled, isFalse);
  });

  testWidgets('onSuffixTap dipanggil saat ikon ditekan', (tester) async {
    var taps = 0;
    await pumpField(
      tester,
      AppTextField(suffixIcon: Icons.visibility, onSuffixTap: () => taps++),
    );

    await tester.tap(find.byIcon(Icons.visibility));
    await tester.pump();

    expect(taps, 1);
  });

  testWidgets('decoration dari pemanggil dipertahankan', (tester) async {
    await pumpField(
      tester,
      const AppTextField(
        label: 'Nama',
        labelPosition: AppTextFieldLabelPosition.floating,
        decoration: InputDecoration(filled: true),
      ),
    );

    final field = tester.widget<TextField>(find.byType(TextField));
    // filled ikut dari decoration, label tetap dipasang AppTextField.
    expect(field.decoration!.filled, isTrue);
    expect(field.decoration!.labelText, 'Nama');
  });

  testWidgets('label outside dirender di luar kolom', (tester) async {
    await pumpField(tester, const AppTextField(label: 'Nama'));

    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.decoration!.labelText, isNull);
    expect(find.text('Nama'), findsOneWidget);
  });

  testWidgets('radius menimpa nilai dari theme', (tester) async {
    await pumpField(tester, const AppTextField(radius: AppRadius.xl));

    final field = tester.widget<TextField>(find.byType(TextField));
    final border = field.decoration!.enabledBorder! as OutlineInputBorder;

    expect(border.borderRadius, BorderRadius.circular(AppRadius.xl));
  });

  testWidgets('border dan radius mengikuti theme', (tester) async {
    await pumpField(tester, const AppTextField());

    final field = tester.widget<TextField>(find.byType(TextField));
    final border = field.decoration!.enabledBorder! as OutlineInputBorder;
    final fromTheme =
        AppTheme.light().inputDecorationTheme.enabledBorder!
            as OutlineInputBorder;

    expect(border.borderRadius, fromTheme.borderRadius);
  });

  testWidgets('size default adalah medium', (tester) async {
    await pumpField(tester, const AppTextField());

    final field = tester.widget<TextField>(find.byType(TextField));
    expect(
      field.decoration!.contentPadding,
      EdgeInsets.symmetric(
        horizontal: AppTextFieldSize.medium.hPadding,
        vertical: AppTextFieldSize.medium.vPadding,
      ),
    );
    expect(field.style!.fontSize, AppTextFieldSize.medium.fontSize);
  });

  testWidgets('size mengatur padding dan huruf', (tester) async {
    await pumpField(tester, const AppTextField(size: AppTextFieldSize.large));

    final field = tester.widget<TextField>(find.byType(TextField));
    expect(
      field.decoration!.contentPadding,
      EdgeInsets.symmetric(
        horizontal: AppTextFieldSize.large.hPadding,
        vertical: AppTextFieldSize.large.vPadding,
      ),
    );
    expect(field.style!.fontSize, AppTextFieldSize.large.fontSize);
  });

  testWidgets('contentPadding pemanggil mengalahkan size', (tester) async {
    const rapat = EdgeInsets.symmetric(horizontal: 12, vertical: 8);
    await pumpField(
      tester,
      const AppTextField(
        size: AppTextFieldSize.large,
        decoration: InputDecoration(contentPadding: rapat),
      ),
    );

    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.decoration!.contentPadding, rapat);
  });
}
