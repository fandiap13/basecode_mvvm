import 'package:basecode/core/theme/app_theme.dart';
import 'package:basecode/core/widgets/button/app_button.dart';
import 'package:basecode/core/widgets/state_view/app_state_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pumpView(WidgetTester tester, Widget view) {
    return tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(body: view),
      ),
    );
  }

  testWidgets('judul bawaan berbeda tiap jenis', (tester) async {
    await pumpView(tester, const AppStateView.empty());
    expect(find.text('Belum ada data'), findsOneWidget);

    await pumpView(tester, const AppStateView.error());
    expect(find.text('Terjadi kesalahan'), findsOneWidget);

    await pumpView(tester, const AppStateView.offline());
    expect(find.text('Tidak ada koneksi'), findsOneWidget);

    await pumpView(tester, const AppStateView.search());
    expect(find.text('Tidak ditemukan'), findsOneWidget);
  });

  testWidgets('title menimpa judul bawaan', (tester) async {
    await pumpView(tester, const AppStateView.empty(title: 'Kosong melompong'));

    expect(find.text('Kosong melompong'), findsOneWidget);
    expect(find.text('Belum ada data'), findsNothing);
  });

  testWidgets('ikon bawaan berbeda tiap jenis', (tester) async {
    await pumpView(tester, const AppStateView.empty());
    expect(find.byIcon(Icons.inbox_outlined), findsOneWidget);

    await pumpView(tester, const AppStateView.error());
    expect(find.byIcon(Icons.error_outline), findsOneWidget);
  });

  testWidgets('pesan hanya tampil bila diisi', (tester) async {
    await pumpView(tester, const AppStateView.empty());
    expect(find.byType(Text), findsOneWidget);

    await pumpView(tester, const AppStateView.empty(message: 'Pesan tambahan'));
    expect(find.text('Pesan tambahan'), findsOneWidget);
  });

  testWidgets('tombol aksi muncul hanya bila onAction diisi', (tester) async {
    await pumpView(tester, const AppStateView.empty());
    expect(find.byType(AppButton), findsNothing);

    await pumpView(tester, AppStateView.empty(onAction: () {}));
    expect(find.byType(AppButton), findsOneWidget);
  });

  testWidgets('label aksi bawaan adalah Coba lagi', (tester) async {
    await pumpView(tester, AppStateView.error(onAction: () {}));

    expect(find.text('Coba lagi'), findsOneWidget);
  });

  testWidgets('onAction dipanggil saat tombol ditekan', (tester) async {
    var taps = 0;
    await pumpView(tester, AppStateView.error(onAction: () => taps++));

    await tester.tap(find.byType(AppButton));
    await tester.pump();

    expect(taps, 1);
  });

  testWidgets('compact memakai ukuran lebih kecil', (tester) async {
    await pumpView(tester, const AppStateView.empty());
    final normal = tester.getSize(find.byType(AppStateView)).height;

    await pumpView(tester, const AppStateView.empty(compact: true));
    final ringkas = tester.getSize(find.byType(AppStateView)).height;

    expect(ringkas, lessThan(normal));
  });
}
