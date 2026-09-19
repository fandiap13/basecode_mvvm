import 'package:basecode/core/theme/app_theme.dart';
import 'package:basecode/core/widgets/checkbox/app_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pumpCheckbox(WidgetTester tester, Widget child) {
    return tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(body: child),
      ),
    );
  }

  testWidgets('menampilkan label dan subtitle', (tester) async {
    await pumpCheckbox(
      tester,
      const AppCheckbox(
        value: false,
        label: 'Setuju',
        subtitle: 'Keterangan',
        onChanged: null,
      ),
    );

    expect(find.text('Setuju'), findsOneWidget);
    expect(find.text('Keterangan'), findsOneWidget);
  });

  testWidgets('memanggil onChanged saat diketuk', (tester) async {
    bool? received;
    await pumpCheckbox(
      tester,
      AppCheckbox(
        value: false,
        label: 'Setuju',
        onChanged: (value) => received = value,
      ),
    );

    await tester.tap(find.byType(AppCheckbox));
    await tester.pump();

    expect(received, true);
  });

  testWidgets('nonaktif: ketukan diabaikan saat onChanged null', (
    tester,
  ) async {
    await pumpCheckbox(
      tester,
      const AppCheckbox(value: false, label: 'Mati', onChanged: null),
    );

    await tester.tap(find.byType(AppCheckbox), warnIfMissed: false);
    await tester.pump();

    expect(tester.takeException(), isNull);
  });

  testWidgets('radio memanggil onChanged dengan nilainya', (tester) async {
    String? received;
    await pumpCheckbox(
      tester,
      AppRadio<String>(
        value: 'id',
        groupValue: 'en',
        label: 'Indonesia',
        onChanged: (value) => received = value,
      ),
    );

    await tester.tap(find.byType(AppRadio<String>));
    await tester.pump();

    expect(received, 'id');
  });

  testWidgets('radio menandai pilihan yang sama dengan groupValue', (
    tester,
  ) async {
    await pumpCheckbox(
      tester,
      const AppRadio<String>(
        value: 'id',
        groupValue: 'id',
        label: 'Indonesia',
        onChanged: null,
      ),
    );

    final group = tester.widget<RadioGroup<String>>(
      find.byType(RadioGroup<String>),
    );
    expect(group.groupValue, 'id');
  });
}
