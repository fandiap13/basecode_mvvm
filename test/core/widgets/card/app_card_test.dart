import 'package:basecode/core/theme/app_radius.dart';
import 'package:basecode/core/theme/app_theme.dart';
import 'package:basecode/core/widgets/card/app_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pumpCard(WidgetTester tester, AppCard card) {
    return tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(body: card),
      ),
    );
  }

  testWidgets('menampilkan child', (tester) async {
    await pumpCard(tester, const AppCard(child: Text('isi')));

    expect(find.text('isi'), findsOneWidget);
  });

  testWidgets('memanggil onTap saat ditekan', (tester) async {
    var taps = 0;
    await pumpCard(
      tester,
      AppCard(onTap: () => taps++, child: const Text('isi')),
    );

    await tester.tap(find.byType(AppCard));
    await tester.pump();

    expect(taps, 1);
  });

  testWidgets('saat loading: tap diabaikan', (tester) async {
    var taps = 0;
    await pumpCard(
      tester,
      AppCard(isLoading: true, onTap: () => taps++, child: const Text('isi')),
    );

    await tester.tap(find.byType(AppCard), warnIfMissed: false);
    await tester.pump();

    expect(taps, 0);
  });

  testWidgets('radius default memakai token lg', (tester) async {
    await pumpCard(tester, const AppCard(child: Text('isi')));

    final card = tester.widget<Card>(find.byType(Card));
    final shape = card.shape! as RoundedRectangleBorder;
    expect(shape.borderRadius, BorderRadius.circular(AppRadius.lg));
  });

  testWidgets('isExpanded melebar mengikuti parent', (tester) async {
    await pumpCard(tester, const AppCard(isExpanded: true, child: Text('isi')));

    final width = tester.getSize(find.byType(Card)).width;
    expect(
      width,
      tester.view.physicalSize.width / tester.view.devicePixelRatio,
    );
  });
}
