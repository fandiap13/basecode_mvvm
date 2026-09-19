import 'package:basecode/core/theme/app_breakpoints.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Bungkus dengan MediaQuery agar lebar layar bisa diatur per test.
  Future<AppScreenSize> sizeAt(WidgetTester tester, double width) async {
    late AppScreenSize hasil;

    await tester.pumpWidget(
      MediaQuery(
        data: MediaQueryData(size: Size(width, 800)),
        child: Builder(
          builder: (context) {
            hasil = AppBreakpoints.of(context);
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    return hasil;
  }

  testWidgets('memetakan lebar ke ukuran layar', (tester) async {
    expect(await sizeAt(tester, 360), AppScreenSize.compact);
    expect(await sizeAt(tester, 599), AppScreenSize.compact);
    expect(await sizeAt(tester, 600), AppScreenSize.medium);
    expect(await sizeAt(tester, 904), AppScreenSize.medium);
    expect(await sizeAt(tester, 905), AppScreenSize.expanded);
    expect(await sizeAt(tester, 1239), AppScreenSize.expanded);
    expect(await sizeAt(tester, 1240), AppScreenSize.large);
  });

  test('kolom grid sesuai ukuran layar', () {
    expect(AppScreenSize.compact.columns, 4);
    expect(AppScreenSize.medium.columns, 8);
    expect(AppScreenSize.expanded.columns, 12);
    expect(AppScreenSize.large.columns, 12);
  });

  test('pembantu is* hanya benar untuk dirinya', () {
    expect(AppScreenSize.compact.isCompact, isTrue);
    expect(AppScreenSize.compact.isLarge, isFalse);
    expect(AppScreenSize.large.isLarge, isTrue);
  });
}
