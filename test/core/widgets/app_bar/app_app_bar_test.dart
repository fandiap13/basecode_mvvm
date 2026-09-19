import 'package:basecode/core/theme/app_colors.dart';
import 'package:basecode/core/theme/app_theme.dart';
import 'package:basecode/core/widgets/app_bar/app_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pumpBar(WidgetTester tester, AppAppBar child) {
    return tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(appBar: child, body: const SizedBox()),
      ),
    );
  }

  testWidgets('menampilkan judul', (tester) async {
    await pumpBar(tester, const AppAppBar(title: 'Judul'));

    expect(find.text('Judul'), findsOneWidget);
  });

  testWidgets('menampilkan subjudul', (tester) async {
    await pumpBar(
      tester,
      const AppAppBar(title: 'Judul', subtitle: 'Subjudul'),
    );

    expect(find.text('Subjudul'), findsOneWidget);
  });

  testWidgets('memanggil aksi saat diketuk', (tester) async {
    var taps = 0;
    await pumpBar(
      tester,
      AppAppBar(
        title: 'Judul',
        automaticallyImplyLeading: false,
        actions: [
          IconButton(onPressed: () => taps++, icon: const Icon(Icons.search)),
        ],
      ),
    );

    await tester.tap(find.byIcon(Icons.search));
    await tester.pump();

    expect(taps, 1);
  });

  testWidgets('latar default memakai token primary', (tester) async {
    await pumpBar(tester, const AppAppBar(title: 'Judul'));

    final bar = tester.widget<AppBar>(find.byType(AppBar));
    final theme = Theme.of(tester.element(find.byType(AppBar)));
    expect(bar.backgroundColor, theme.appColors.primary);
  });

  testWidgets('tanpa tombol kembali saat automaticallyImplyLeading mati', (
    tester,
  ) async {
    await pumpBar(
      tester,
      const AppAppBar(title: 'Judul', automaticallyImplyLeading: false),
    );

    expect(find.byType(BackButton), findsNothing);
  });
}
