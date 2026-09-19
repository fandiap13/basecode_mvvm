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
        decoration: InputDecoration(filled: true),
      ),
    );

    final field = tester.widget<TextField>(find.byType(TextField));
    // filled ikut dari decoration, label tetap dipasang AppTextField.
    expect(field.decoration!.filled, isTrue);
    expect(field.decoration!.labelText, 'Nama');
  });
}
