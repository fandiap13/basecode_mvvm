import 'package:basecode/core/theme/app_theme.dart';
import 'package:basecode/core/widgets/feedback/app_feedback.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  /// Pasang layar dengan satu tombol yang menjalankan [onPressed].
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

  group('snackbar', () {
    testWidgets('menampilkan pesan', (tester) async {
      await pumpPemicu(
        tester,
        (context) => AppFeedback.snackbar(context, message: 'Tersimpan'),
      );

      await tester.tap(find.text('Picu'));
      await tester.pump();

      expect(find.text('Tersimpan'), findsOneWidget);
    });

    testWidgets('aksi dipanggil saat ditekan', (tester) async {
      var urung = 0;

      await pumpPemicu(
        tester,
        (context) => AppFeedback.snackbar(
          context,
          message: 'Dihapus',
          actionLabel: 'Urungkan',
          onAction: () => urung++,
        ),
      );

      await tester.tap(find.text('Picu'));
      // Snackbar perlu animasi masuk selesai sebelum aksinya bisa ditekan.
      await tester.pumpAndSettle();
      await tester.tap(find.text('Urungkan'));
      await tester.pump();

      expect(urung, 1);
    });
  });

  group('confirm', () {
    testWidgets('mengembalikan true saat disetujui', (tester) async {
      bool? hasil;

      await pumpPemicu(tester, (context) async {
        hasil = await AppFeedback.confirm(context, title: 'Yakin?');
      });

      await tester.tap(find.text('Picu'));
      await tester.pumpAndSettle();

      expect(find.text('Yakin?'), findsOneWidget);

      await tester.tap(find.text('Ya'));
      await tester.pumpAndSettle();

      expect(hasil, isTrue);
    });

    testWidgets('mengembalikan false saat dibatalkan', (tester) async {
      bool? hasil;

      await pumpPemicu(tester, (context) async {
        hasil = await AppFeedback.confirm(context, title: 'Yakin?');
      });

      await tester.tap(find.text('Picu'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Batal'));
      await tester.pumpAndSettle();

      expect(hasil, isFalse);
    });

    testWidgets('label tombol dapat diganti', (tester) async {
      await pumpPemicu(
        tester,
        (context) => AppFeedback.confirm(
          context,
          title: 'Hapus?',
          confirmLabel: 'Hapus',
          cancelLabel: 'Jangan',
        ),
      );

      await tester.tap(find.text('Picu'));
      await tester.pumpAndSettle();

      expect(find.text('Hapus'), findsOneWidget);
      expect(find.text('Jangan'), findsOneWidget);
    });

    testWidgets('pesan opsional tampil bila diisi', (tester) async {
      await pumpPemicu(
        tester,
        (context) => AppFeedback.confirm(
          context,
          title: 'Yakin?',
          message: 'Tidak dapat dibatalkan.',
        ),
      );

      await tester.tap(find.text('Picu'));
      await tester.pumpAndSettle();

      expect(find.text('Tidak dapat dibatalkan.'), findsOneWidget);
    });
  });

  group('alert', () {
    testWidgets('menampilkan judul dan satu tombol', (tester) async {
      await pumpPemicu(
        tester,
        (context) => AppFeedback.alert(context, title: 'Berhasil'),
      );

      await tester.tap(find.text('Picu'));
      await tester.pumpAndSettle();

      expect(find.text('Berhasil'), findsOneWidget);
      expect(find.text('Tutup'), findsOneWidget);
    });

    testWidgets('tertutup saat tombol ditekan', (tester) async {
      await pumpPemicu(
        tester,
        (context) => AppFeedback.alert(context, title: 'Berhasil'),
      );

      await tester.tap(find.text('Picu'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Tutup'));
      await tester.pumpAndSettle();

      expect(find.text('Berhasil'), findsNothing);
    });
  });
}
