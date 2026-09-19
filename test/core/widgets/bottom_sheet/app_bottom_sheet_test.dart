import 'package:basecode/core/theme/app_theme.dart';
import 'package:basecode/core/widgets/bottom_sheet/app_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pumpPemicu(
    WidgetTester tester,
    void Function(BuildContext context) onPressed,
  ) {
    return tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: Builder(
            builder: (context) => Center(
              child: ElevatedButton(
                onPressed: () => onPressed(context),
                child: const Text('Picu'),
              ),
            ),
          ),
        ),
      ),
    );
  }

  group('show', () {
    testWidgets('menampilkan isi dan judul', (tester) async {
      await pumpPemicu(
        tester,
        (context) => AppBottomSheet.show<void>(
          context,
          title: 'Judul sheet',
          child: const Text('Isi sheet'),
        ),
      );

      await tester.tap(find.text('Picu'));
      await tester.pumpAndSettle();

      expect(find.text('Judul sheet'), findsOneWidget);
      expect(find.text('Isi sheet'), findsOneWidget);
    });

    testWidgets('mengembalikan nilai dari pop', (tester) async {
      String? hasil;

      await pumpPemicu(tester, (context) async {
        hasil = await AppBottomSheet.show<String>(
          context,
          child: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => Navigator.of(context).pop('oke'),
              child: const Text('Kirim'),
            ),
          ),
        );
      });

      await tester.tap(find.text('Picu'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Kirim'));
      await tester.pumpAndSettle();

      expect(hasil, 'oke');
    });

    testWidgets('tanpa judul tidak ada pemisah', (tester) async {
      await pumpPemicu(
        tester,
        (context) =>
            AppBottomSheet.show<void>(context, child: const Text('Isi')),
      );

      await tester.tap(find.text('Picu'));
      await tester.pumpAndSettle();

      expect(find.byType(Divider), findsNothing);
    });
  });

  group('showOptions', () {
    testWidgets('menampilkan semua pilihan', (tester) async {
      await pumpPemicu(
        tester,
        (context) => AppBottomSheet.showOptions<String>(
          context,
          title: 'Urutkan',
          options: const [
            AppBottomSheetOption(value: 'a', label: 'Terbaru'),
            AppBottomSheetOption(value: 'b', label: 'Terlama'),
          ],
        ),
      );

      await tester.tap(find.text('Picu'));
      await tester.pumpAndSettle();

      expect(find.text('Terbaru'), findsOneWidget);
      expect(find.text('Terlama'), findsOneWidget);
    });

    testWidgets('mengembalikan nilai yang dipilih', (tester) async {
      String? hasil;

      await pumpPemicu(tester, (context) async {
        hasil = await AppBottomSheet.showOptions<String>(
          context,
          options: const [
            AppBottomSheetOption(value: 'a', label: 'Terbaru'),
            AppBottomSheetOption(value: 'b', label: 'Terlama'),
          ],
        );
      });

      await tester.tap(find.text('Picu'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Terlama'));
      await tester.pumpAndSettle();

      expect(hasil, 'b');
    });

    testWidgets('pilihan aktif ditandai centang', (tester) async {
      await pumpPemicu(
        tester,
        (context) => AppBottomSheet.showOptions<String>(
          context,
          selected: 'a',
          options: const [
            AppBottomSheetOption(value: 'a', label: 'Terbaru'),
            AppBottomSheetOption(value: 'b', label: 'Terlama'),
          ],
        ),
      );

      await tester.tap(find.text('Picu'));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.check), findsOneWidget);
    });
  });
}
