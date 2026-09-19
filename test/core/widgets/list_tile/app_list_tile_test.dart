import 'package:basecode/core/theme/app_theme.dart';
import 'package:basecode/core/widgets/list_tile/app_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pumpTile(WidgetTester tester, AppListTile child) {
    return tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(body: child),
      ),
    );
  }

  testWidgets('menampilkan judul, subjudul, dan ikon depan', (tester) async {
    await pumpTile(
      tester,
      const AppListTile(
        leading: Icons.person_outline,
        title: 'Profil',
        subtitle: 'Data diri',
      ),
    );

    expect(find.text('Profil'), findsOneWidget);
    expect(find.text('Data diri'), findsOneWidget);
    expect(find.byIcon(Icons.person_outline), findsOneWidget);
  });

  testWidgets('memanggil onTap saat diketuk', (tester) async {
    var taps = 0;
    await pumpTile(tester, AppListTile(title: 'Profil', onTap: () => taps++));

    await tester.tap(find.byType(AppListTile));
    await tester.pump();

    expect(taps, 1);
  });

  testWidgets('tanpa onTap: baris tidak bisa diketuk', (tester) async {
    await pumpTile(tester, const AppListTile(title: 'Versi'));

    final tile = tester.widget<ListTile>(find.byType(ListTile));
    expect(tile.onTap, isNull);
    expect(tile.enabled, isTrue);
  });

  testWidgets('selected menandai baris terpilih', (tester) async {
    await pumpTile(
      tester,
      AppListTile(title: 'Folder', selected: true, onTap: () {}),
    );

    final tile = tester.widget<ListTile>(find.byType(ListTile));
    expect(tile.selected, isTrue);
  });
}
