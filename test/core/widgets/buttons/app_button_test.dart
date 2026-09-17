import 'package:basecode/core/widgets/button/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pumpButton(WidgetTester tester, AppButton button) {
    return tester.pumpWidget(MaterialApp(home: Scaffold(body: button)));
  }

  testWidgets('memanggil onPressed saat ditekan', (tester) async {
    var taps = 0;
    await pumpButton(tester, AppButton(label: 'Tap', onPressed: () => taps++));

    await tester.tap(find.byType(AppButton));
    await tester.pump();

    expect(taps, 1);
  });

  testWidgets('onPressed null membuat button disabled', (tester) async {
    await pumpButton(tester, const AppButton(label: 'Tap', onPressed: null));

    final button = tester.widget<FilledButton>(find.byType(FilledButton));
    expect(button.onPressed, isNull);
  });

  testWidgets('saat loading: tap diabaikan dan spinner tampil', (tester) async {
    var taps = 0;
    await pumpButton(
      tester,
      AppButton(label: 'Tap', isLoading: true, onPressed: () => taps++),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.tap(find.byType(AppButton), warnIfMissed: false);
    await tester.pump();

    expect(taps, 0);
  });

  testWidgets('ukuran tidak berubah saat loading', (tester) async {
    await pumpButton(tester, AppButton(label: 'Tap', onPressed: () {}));
    final idleSize = tester.getSize(find.byType(FilledButton));

    await pumpButton(
      tester,
      AppButton(label: 'Tap', isLoading: true, onPressed: () {}),
    );
    final loadingSize = tester.getSize(find.byType(FilledButton));

    expect(loadingSize, idleSize);
  });

  testWidgets('isExpanded melebar mengikuti parent', (tester) async {
    await pumpButton(
      tester,
      AppButton(label: 'Tap', isExpanded: true, onPressed: () {}),
    );

    final width = tester.getSize(find.byType(FilledButton)).width;
    expect(
      width,
      tester.view.physicalSize.width / tester.view.devicePixelRatio,
    );
  });

  testWidgets('variant memetakan ke tipe button Material', (tester) async {
    await pumpButton(
      tester,
      AppButton(
        label: 'Tap',
        variant: AppButtonVariant.outline,
        onPressed: () {},
      ),
    );
    expect(find.byType(OutlinedButton), findsOneWidget);

    await pumpButton(
      tester,
      AppButton(label: 'Tap', variant: AppButtonVariant.text, onPressed: () {}),
    );
    expect(find.byType(TextButton), findsOneWidget);
  });
}
