import 'package:basecode/core/theme/app_theme.dart';
import 'package:basecode/core/widgets/carousel/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  List<Widget> slides(int jumlah) => [
    for (var i = 1; i <= jumlah; i++) Center(child: Text('Slide $i')),
  ];

  Future<void> pumpCarousel(WidgetTester tester, AppCarousel carousel) {
    return tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(body: carousel),
      ),
    );
  }

  testWidgets('menampilkan slide pertama', (tester) async {
    await pumpCarousel(tester, AppCarousel(height: 120, items: slides(3)));

    expect(find.text('Slide 1'), findsOneWidget);
  });

  testWidgets('daftar kosong tidak merender apa pun', (tester) async {
    await pumpCarousel(tester, const AppCarousel(height: 120, items: []));

    expect(find.byType(PageView), findsNothing);
  });

  testWidgets('initialPage menentukan slide awal', (tester) async {
    await pumpCarousel(
      tester,
      AppCarousel(height: 120, initialPage: 2, items: slides(4)),
    );

    expect(find.text('Slide 3'), findsOneWidget);
  });

  testWidgets('geser berpindah halaman dan memanggil onPageChanged', (
    tester,
  ) async {
    final terpanggil = <int>[];

    await pumpCarousel(
      tester,
      AppCarousel(height: 120, items: slides(3), onPageChanged: terpanggil.add),
    );

    await tester.drag(find.byType(PageView), const Offset(-400, 0));
    await tester.pumpAndSettle();

    expect(terpanggil, [1]);
    expect(find.text('Slide 2'), findsOneWidget);
  });

  testWidgets('indikator tampil sesuai jumlah slide', (tester) async {
    await pumpCarousel(tester, AppCarousel(height: 120, items: slides(3)));

    expect(find.byType(AnimatedContainer), findsNWidgets(3));
  });

  testWidgets('showIndicator false menyembunyikan indikator', (tester) async {
    await pumpCarousel(
      tester,
      AppCarousel(height: 120, showIndicator: false, items: slides(3)),
    );

    expect(find.byType(AnimatedContainer), findsNothing);
  });

  testWidgets('satu slide tidak memunculkan indikator', (tester) async {
    await pumpCarousel(tester, AppCarousel(height: 120, items: slides(1)));

    expect(find.byType(AnimatedContainer), findsNothing);
  });

  testWidgets('autoPlay berpindah sendiri setelah durasinya', (tester) async {
    await pumpCarousel(
      tester,
      AppCarousel(
        height: 120,
        autoPlay: true,
        autoPlayDuration: const Duration(seconds: 1),
        items: slides(3),
      ),
    );

    expect(find.text('Slide 1'), findsOneWidget);

    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(find.text('Slide 2'), findsOneWidget);
  });
}
