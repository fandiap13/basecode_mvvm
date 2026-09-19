import 'package:basecode/core/theme/app_theme.dart';
import 'package:basecode/core/widgets/switch/app_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pumpSwitch(WidgetTester tester, AppSwitch child) {
    return tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(body: child),
      ),
    );
  }

  testWidgets('menampilkan label dan subtitle', (tester) async {
    await pumpSwitch(
      tester,
      const AppSwitch(
        value: true,
        label: 'Notifikasi',
        subtitle: 'Keterangan',
        onChanged: null,
      ),
    );

    expect(find.text('Notifikasi'), findsOneWidget);
    expect(find.text('Keterangan'), findsOneWidget);
  });

  testWidgets('memanggil onChanged dengan nilai berbalik saat diketuk', (
    tester,
  ) async {
    bool? received;
    await pumpSwitch(
      tester,
      AppSwitch(
        value: false,
        label: 'Notifikasi',
        onChanged: (value) => received = value,
      ),
    );

    await tester.tap(find.byType(AppSwitch));
    await tester.pump();

    expect(received, true);
  });

  testWidgets('nonaktif: saklar tidak bisa diubah saat onChanged null', (
    tester,
  ) async {
    await pumpSwitch(
      tester,
      const AppSwitch(value: false, label: 'Mati', onChanged: null),
    );

    final control = tester.widget<Switch>(find.byType(Switch));
    expect(control.onChanged, isNull);
  });
}
