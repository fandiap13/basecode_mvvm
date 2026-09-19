import 'package:basecode/core/theme/app_colors.dart';
import 'package:basecode/core/theme/app_theme.dart';
import 'package:basecode/core/widgets/button/app_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // AppIconButton membaca token lewat Theme.of(context).appColors,
  // jadi tema aplikasi wajib dipasang saat pump.
  Future<void> pumpButton(WidgetTester tester, AppIconButton button) {
    return tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(body: button),
      ),
    );
  }

  testWidgets('memanggil onPressed saat ditekan', (tester) async {
    var taps = 0;
    await pumpButton(
      tester,
      AppIconButton(icon: Icons.add, onPressed: () => taps++),
    );

    await tester.tap(find.byType(AppIconButton));
    await tester.pump();

    expect(taps, 1);
  });

  testWidgets('onPressed null membuat button disabled', (tester) async {
    await pumpButton(
      tester,
      const AppIconButton(icon: Icons.add, onPressed: null),
    );

    final button = tester.widget<IconButton>(find.byType(IconButton));
    expect(button.onPressed, isNull);
  });

  testWidgets('saat loading: tap diabaikan dan spinner tampil', (tester) async {
    var taps = 0;
    await pumpButton(
      tester,
      AppIconButton(icon: Icons.add, isLoading: true, onPressed: () => taps++),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.tap(find.byType(AppIconButton), warnIfMissed: false);
    await tester.pump();

    expect(taps, 0);
  });

  testWidgets('spinner mengikuti foregroundColor variant', (tester) async {
    final colors = AppTheme.light().appColors;

    // Variant solid: ikon putih di atas background pekat.
    await pumpButton(
      tester,
      AppIconButton(icon: Icons.add, isLoading: true, onPressed: () {}),
    );

    var spinner = tester.widget<CircularProgressIndicator>(
      find.byType(CircularProgressIndicator),
    );
    expect(spinner.color, colors.surface);

    // Variant datar: ikon gelap di atas latar halaman.
    await pumpButton(
      tester,
      AppIconButton(
        icon: Icons.add,
        variant: AppIconButtonVariant.outline,
        isLoading: true,
        onPressed: () {},
      ),
    );

    spinner = tester.widget<CircularProgressIndicator>(
      find.byType(CircularProgressIndicator),
    );
    expect(spinner.color, colors.ink);
  });

  testWidgets('tooltip terpasang saat diisi', (tester) async {
    await pumpButton(
      tester,
      AppIconButton(icon: Icons.add, tooltip: 'Tambah', onPressed: () {}),
    );

    expect(find.byType(Tooltip), findsOneWidget);
  });

  // Ambil BorderSide yang dipakai button pada state normal.
  BorderSide? sideOf(WidgetTester tester) {
    final button = tester.widget<IconButton>(find.byType(IconButton));
    return button.style?.side?.resolve(<WidgetState>{});
  }

  testWidgets('variant solid tidak bergaris secara default', (tester) async {
    await pumpButton(tester, AppIconButton(icon: Icons.add, onPressed: () {}));

    expect(sideOf(tester), BorderSide.none);
  });

  testWidgets('outline bergaris sewarna ikon secara default', (tester) async {
    await pumpButton(
      tester,
      AppIconButton(
        icon: Icons.add,
        variant: AppIconButtonVariant.outline,
        onPressed: () {},
      ),
    );

    final side = sideOf(tester)!;
    expect(side.color, AppTheme.light().appColors.ink);
    expect(side.width, 1);
  });

  testWidgets('borderColor menimpa default di variant apa pun', (tester) async {
    await pumpButton(
      tester,
      AppIconButton(
        icon: Icons.add,
        borderColor: const Color(0xFF123456),
        borderWidth: 3,
        onPressed: () {},
      ),
    );

    final side = sideOf(tester)!;
    expect(side.color, const Color(0xFF123456));
    expect(side.width, 3);
  });
}
