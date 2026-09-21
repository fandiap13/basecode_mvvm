import 'package:basecode/core/theme/app_theme.dart';
import 'package:basecode/core/widgets/tab/app_tab_bussines.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pumpTab(
    WidgetTester tester, {
    int jumlah = 3,
    bool isScrollable = false,
    TabController? controller,
    List<String?>? deskripsi,
  }) {
    return tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: AppTabBussines(
            controller: controller,
            isScrollable: isScrollable,
            tabs: [for (var i = 1; i <= jumlah; i++) 'Tab $i'],
            descriptions: deskripsi,
            children: [
              for (var i = 1; i <= jumlah; i++) Center(child: Text('Isi $i')),
            ],
          ),
        ),
      ),
    );
  }

  testWidgets('menampilkan semua tab dan isi tab pertama', (tester) async {
    await pumpTab(tester);

    expect(find.text('Tab 1'), findsOneWidget);
    expect(find.text('Tab 3'), findsOneWidget);
    expect(find.text('Isi 1'), findsOneWidget);
  });

  testWidgets('berpindah isi saat tab diketuk', (tester) async {
    await pumpTab(tester);

    await tester.tap(find.text('Tab 2'));
    await tester.pumpAndSettle();

    expect(find.text('Isi 2'), findsOneWidget);
  });

  testWidgets('bekerja tanpa controller dari pemanggil', (tester) async {
    await pumpTab(tester);

    // Tidak melempar; controller internal dibuat sendiri.
    expect(find.byType(TabBar), findsOneWidget);
    expect(find.byType(TabBarView), findsOneWidget);
  });

  testWidgets('memakai controller dari pemanggil bila diberikan', (
    tester,
  ) async {
    late TabController controller;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: DefaultTabController(
          length: 3,
          child: Builder(
            builder: (context) {
              controller = DefaultTabController.of(context);
              return Scaffold(
                body: AppTabBussines(
                  controller: controller,
                  tabs: const ['A', 'B', 'C'],
                  children: const [Text('isi A'), Text('isi B'), Text('isi C')],
                ),
              );
            },
          ),
        ),
      ),
    );

    controller.animateTo(2);
    await tester.pumpAndSettle();

    expect(controller.index, 2);
    expect(find.text('isi C'), findsOneWidget);
  });

  testWidgets('jumlah tab berubah tidak melempar', (tester) async {
    await pumpTab(tester, jumlah: 3);
    await pumpTab(tester, jumlah: 5);
    await tester.pumpAndSettle();

    expect(find.text('Tab 5'), findsOneWidget);
  });

  testWidgets('keterangan tampil di bawah judul tab', (tester) async {
    await pumpTab(tester, deskripsi: const ['Ringkasan', 'Rincian', null]);

    expect(find.text('Ringkasan'), findsOneWidget);
    expect(find.text('Rincian'), findsOneWidget);
  });

  testWidgets('tanpa descriptions hanya judul yang tampil', (tester) async {
    await pumpTab(tester);

    expect(find.text('Tab 1'), findsOneWidget);
    expect(find.text('Ringkasan'), findsNothing);
  });

  testWidgets('tab dengan keterangan lebih tinggi', (tester) async {
    await pumpTab(tester);
    final tanpa = tester.getSize(find.byType(TabBar)).height;

    await pumpTab(tester, deskripsi: const ['Ringkasan', 'Rincian', 'Lain']);
    await tester.pumpAndSettle();
    final dengan = tester.getSize(find.byType(TabBar)).height;

    expect(dengan, greaterThan(tanpa));
  });

  testWidgets('judul dan keterangan rata kiri', (tester) async {
    await pumpTab(tester, deskripsi: const ['Ringkasan', 'Rincian', 'Lain']);

    final judul = tester.getRect(find.text('Tab 1'));
    final keterangan = tester.getRect(find.text('Ringkasan'));

    expect(keterangan.left, closeTo(judul.left, 0.01));
  });

  testWidgets('descriptions lebih pendek dari tabs tidak melempar', (
    tester,
  ) async {
    await pumpTab(tester, deskripsi: const ['Ringkasan']);

    expect(find.text('Ringkasan'), findsOneWidget);
    expect(find.text('Tab 3'), findsOneWidget);
  });

  group('penanda tab aktif', () {
    /// Batang penanda yang menonjol di atas tab aktif.
    Finder indicatorFinder() => find.byWidgetPredicate((w) {
      if (w is! Container) return false;
      final c = w.constraints;
      return c != null && c.maxHeight == 6.0 && c.maxWidth == 35.0;
    });

    /// Jarak penanda dari tepi kiri tab ke-[index].
    double gapAt(WidgetTester tester, int index) {
      final tab = tester.getRect(find.byType(Tab).at(index));
      final bar = tester.getRect(indicatorFinder().first);
      return bar.left - tab.left;
    }

    testWidgets('jaraknya tetap di tiap tab (lebar tetap)', (tester) async {
      await pumpTab(tester);
      await tester.pumpAndSettle();

      for (var i = 0; i < 3; i++) {
        if (i > 0) {
          await tester.tap(find.text('Tab ${i + 1}'));
          await tester.pumpAndSettle();
        }
        expect(gapAt(tester, i), closeTo(12, 0.01), reason: 'tab ke-$i');
      }
    });

    testWidgets('tetap tampil dan sejajar saat isScrollable', (tester) async {
      await pumpTab(tester, isScrollable: true);
      await tester.pumpAndSettle();

      expect(indicatorFinder(), findsOneWidget);

      // Lebar tab berbeda-beda di mode ini, jadi posisi penanda dibaca
      // dari tab yang sebenarnya, bukan hasil bagi rata.
      for (var i = 0; i < 3; i++) {
        if (i > 0) {
          await tester.tap(find.text('Tab ${i + 1}'));
          await tester.pumpAndSettle();
        }
        expect(gapAt(tester, i), closeTo(12, 0.01), reason: 'tab ke-$i');
      }
    });
  });

  group('jahitan garis', () {
    /// Ambil painter yang menggambar garis pemisah.
    CustomPainter painterOf(WidgetTester tester) {
      final paint = tester.widgetList<CustomPaint>(find.byType(CustomPaint));
      return paint
          .map((p) => p.painter)
          .whereType<CustomPainter>()
          .firstWhere((p) => p.runtimeType.toString() == '_TabSeamPainter');
    }

    testWidgets('digambar saat lebar tab tetap', (tester) async {
      await pumpTab(tester);

      expect(() => painterOf(tester), returnsNormally);
    });

    testWidgets('garis putus tepat di bawah tab aktif', (tester) async {
      await pumpTab(tester);

      final canvas = TestCanvas();
      painterOf(tester).paint(canvas, const Size(300, 48));

      // 3 tab pada lebar 300 -> tiap tab 100px. Tab pertama aktif, jadi
      // hanya ruas kanan (100..300) yang digambar.
      expect(canvas.lines, hasLength(1));
      expect(canvas.lines.first.$1.dx, closeTo(100, 0.01));
      expect(canvas.lines.first.$2.dx, closeTo(300, 0.01));
    });

    testWidgets('celah berpindah mengikuti tab aktif', (tester) async {
      await pumpTab(tester);

      await tester.tap(find.text('Tab 2'));
      await tester.pumpAndSettle();

      final canvas = TestCanvas();
      painterOf(tester).paint(canvas, const Size(300, 48));

      // Tab tengah aktif: ada dua ruas, kiri (0..100) dan kanan (200..300).
      expect(canvas.lines, hasLength(2));
      expect(canvas.lines[0].$2.dx, closeTo(100, 0.01));
      expect(canvas.lines[1].$1.dx, closeTo(200, 0.01));
    });

    testWidgets('tab terakhir aktif hanya menyisakan ruas kiri', (
      tester,
    ) async {
      await pumpTab(tester);

      await tester.tap(find.text('Tab 3'));
      await tester.pumpAndSettle();

      final canvas = TestCanvas();
      painterOf(tester).paint(canvas, const Size(300, 48));

      expect(canvas.lines, hasLength(1));
      expect(canvas.lines.first.$1.dx, closeTo(0, 0.01));
      expect(canvas.lines.first.$2.dx, closeTo(200, 0.01));
    });

    testWidgets('tidak menggambar saat isScrollable', (tester) async {
      await pumpTab(tester, isScrollable: true);

      final canvas = TestCanvas();
      painterOf(tester).paint(canvas, const Size(300, 48));

      expect(canvas.lines, isEmpty);
    });
  });
}

/// Kanvas palsu yang hanya mencatat garis yang digambar.
class TestCanvas implements Canvas {
  final lines = <(Offset, Offset)>[];

  @override
  void drawLine(Offset p1, Offset p2, Paint paint) => lines.add((p1, p2));

  @override
  void noSuchMethod(Invocation invocation) {}
}
