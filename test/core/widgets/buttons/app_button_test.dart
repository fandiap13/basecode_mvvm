import 'package:basecode/core/theme/app_colors.dart';
import 'package:basecode/core/theme/app_theme.dart';
import 'package:basecode/core/widgets/button/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // AppButton membaca token lewat Theme.of(context).appColors,
  // jadi tema aplikasi wajib dipasang saat pump.
  Future<void> pumpButton(WidgetTester tester, AppButton button) {
    return tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(body: button),
      ),
    );
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

  // Ambil BorderSide yang dipakai button pada state normal.
  BorderSide? sideOf(WidgetTester tester, Type buttonType) {
    final button = tester.widget<ButtonStyleButton>(find.byType(buttonType));
    return button.style?.side?.resolve(<WidgetState>{});
  }

  testWidgets('variant solid tidak bergaris secara default', (tester) async {
    await pumpButton(tester, AppButton(label: 'Tap', onPressed: () {}));

    expect(sideOf(tester, FilledButton), BorderSide.none);
  });

  testWidgets('outline bergaris sewarna teks secara default', (tester) async {
    await pumpButton(
      tester,
      AppButton(
        label: 'Tap',
        variant: AppButtonVariant.outline,
        onPressed: () {},
      ),
    );

    final side = sideOf(tester, OutlinedButton)!;
    expect(side.color, AppTheme.light().appColors.ink);
    expect(side.width, 1);
  });

  testWidgets('borderColor menimpa default di variant apa pun', (tester) async {
    await pumpButton(
      tester,
      AppButton(
        label: 'Tap',
        borderColor: const Color(0xFF123456),
        borderWidth: 3,
        onPressed: () {},
      ),
    );

    final side = sideOf(tester, FilledButton)!;
    expect(side.color, const Color(0xFF123456));
    expect(side.width, 3);
  });

  testWidgets('border meredup saat disabled', (tester) async {
    await pumpButton(
      tester,
      const AppButton(
        label: 'Tap',
        variant: AppButtonVariant.outline,
        onPressed: null,
      ),
    );

    final button = tester.widget<OutlinedButton>(find.byType(OutlinedButton));
    final side = button.style!.side!.resolve(<WidgetState>{
      WidgetState.disabled,
    })!;

    expect(side.color.a, closeTo(0.38, 0.01));
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
