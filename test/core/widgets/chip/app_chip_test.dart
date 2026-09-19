import 'package:basecode/core/theme/app_theme.dart';
import 'package:basecode/core/widgets/chip/app_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pump(WidgetTester tester, Widget widget) {
    return tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(body: Center(child: widget)),
      ),
    );
  }

  group('AppChip', () {
    testWidgets('menampilkan label', (tester) async {
      await pump(tester, const AppChip(label: 'Baru'));

      expect(find.text('Baru'), findsOneWidget);
    });

    testWidgets('ikon tampil bila diisi', (tester) async {
      await pump(
        tester,
        const AppChip(label: 'Verified', icon: Icons.verified_outlined),
      );

      expect(find.byIcon(Icons.verified_outlined), findsOneWidget);
    });

    testWidgets('onTap dipanggil saat diketuk', (tester) async {
      var taps = 0;
      await pump(tester, AppChip(label: 'Filter', onTap: () => taps++));

      await tester.tap(find.byType(AppChip));
      await tester.pump();

      expect(taps, 1);
    });

    testWidgets('tanpa onTap tidak ada InkWell', (tester) async {
      await pump(tester, const AppChip(label: 'Statis'));

      expect(find.byType(InkWell), findsNothing);
    });

    testWidgets('onDeleted memunculkan tombol silang', (tester) async {
      var hapus = 0;
      await pump(tester, AppChip(label: 'Tag', onDeleted: () => hapus++));

      expect(find.byIcon(Icons.close), findsOneWidget);

      await tester.tap(find.byIcon(Icons.close));
      await tester.pump();

      expect(hapus, 1);
    });

    testWidgets('selected mengubah warna latar', (tester) async {
      await pump(
        tester,
        const AppChip(label: 'X', variant: AppChipVariant.primary),
      );
      final normal =
          tester.widget<Container>(find.byType(Container)).decoration!
              as BoxDecoration;

      await pump(
        tester,
        const AppChip(
          label: 'X',
          variant: AppChipVariant.primary,
          selected: true,
        ),
      );
      final terpilih =
          tester.widget<Container>(find.byType(Container)).decoration!
              as BoxDecoration;

      expect(terpilih.color, isNot(normal.color));
    });

    testWidgets('outlined memakai latar transparan dan bergaris', (
      tester,
    ) async {
      await pump(tester, const AppChip(label: 'X', outlined: true));

      final dec =
          tester.widget<Container>(find.byType(Container)).decoration!
              as BoxDecoration;

      expect(dec.color, Colors.transparent);
      expect(dec.border, isNotNull);
    });

    testWidgets('size menentukan tinggi', (tester) async {
      for (final size in AppChipSize.values) {
        await pump(tester, AppChip(label: 'X', size: size));

        expect(
          tester.getSize(find.byType(AppChip)).height,
          size.height,
          reason: size.name,
        );
      }
    });
  });

  group('AppBadge', () {
    testWidgets('menampilkan angka', (tester) async {
      await pump(tester, const AppBadge(count: 5));

      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('angka di atas maxCount jadi 99+', (tester) async {
      await pump(tester, const AppBadge(count: 150));

      expect(find.text('99+'), findsOneWidget);
    });

    testWidgets('maxCount dapat diubah', (tester) async {
      await pump(tester, const AppBadge(count: 15, maxCount: 9));

      expect(find.text('9+'), findsOneWidget);
    });

    testWidgets('nol disembunyikan secara bawaan', (tester) async {
      await pump(tester, const AppBadge(count: 0));

      expect(find.text('0'), findsNothing);
    });

    testWidgets('showZero menampilkan nol', (tester) async {
      await pump(tester, const AppBadge(count: 0, showZero: true));

      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('label menggantikan angka', (tester) async {
      await pump(tester, const AppBadge(count: 5, label: 'Baru'));

      expect(find.text('Baru'), findsOneWidget);
      expect(find.text('5'), findsNothing);
    });

    testWidgets('tanpa count dan label jadi titik', (tester) async {
      await pump(tester, const AppBadge());

      expect(find.byType(Text), findsNothing);
      expect(tester.getSize(find.byType(AppBadge)), const Size(8, 8));
    });

    testWidgets('child ditempeli badge', (tester) async {
      await pump(
        tester,
        const AppBadge(count: 3, child: Icon(Icons.notifications_outlined)),
      );

      expect(find.byIcon(Icons.notifications_outlined), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
    });

    testWidgets('count nol tetap merender child', (tester) async {
      await pump(
        tester,
        const AppBadge(count: 0, child: Icon(Icons.mail_outline)),
      );

      expect(find.byIcon(Icons.mail_outline), findsOneWidget);
      expect(find.text('0'), findsNothing);
    });
  });
}
