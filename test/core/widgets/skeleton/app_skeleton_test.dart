import 'package:basecode/core/theme/app_theme.dart';
import 'package:basecode/core/widgets/skeleton/app_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pump(WidgetTester tester, Widget child) {
    return tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(body: Center(child: child)),
      ),
    );
  }

  // Animasi repeat() tidak pernah selesai; ganti widget agar controller
  // ter-dispose dan test tidak menggantung saat teardown.
  Future<void> stopAnimation(WidgetTester tester) {
    return tester.pumpWidget(const SizedBox.shrink());
  }

  ShapeDecoration decorationOf(WidgetTester tester) {
    final box = tester.widget<DecoratedBox>(find.byType(DecoratedBox).first);
    return box.decoration as ShapeDecoration;
  }

  group('SkeletonBox', () {
    testWidgets('memakai ukuran yang diberikan', (tester) async {
      await pump(tester, const SkeletonBox(width: 120, height: 32));

      expect(tester.getSize(find.byType(SkeletonBox)), const Size(120, 32));

      await stopAnimation(tester);
    });

    testWidgets('berbentuk persegi membulat', (tester) async {
      await pump(tester, const SkeletonBox(width: 40, height: 40));

      expect(decorationOf(tester).shape, isA<RoundedRectangleBorder>());

      await stopAnimation(tester);
    });
  });

  group('SkeletonCircle', () {
    testWidgets('berbentuk lingkaran dengan ukuran default', (tester) async {
      await pump(tester, const SkeletonCircle());

      expect(tester.getSize(find.byType(SkeletonCircle)), const Size(40, 40));
      expect(decorationOf(tester).shape, isA<CircleBorder>());

      await stopAnimation(tester);
    });
  });

  group('SkeletonText', () {
    testWidgets('tinggi default 14 dan memakai SkeletonBox', (tester) async {
      await pump(tester, const SkeletonText(width: 100));

      expect(find.byType(SkeletonBox), findsOneWidget);
      expect(tester.getSize(find.byType(SkeletonText)), const Size(100, 14));

      await stopAnimation(tester);
    });
  });

  group('SkeletonBase', () {
    testWidgets('shimmer bergerak seiring waktu', (tester) async {
      await pump(tester, const SkeletonBox(width: 100, height: 20));

      final awal = tester.widget<ShaderMask>(find.byType(ShaderMask));

      await tester.pump(const Duration(milliseconds: 400));

      final berikut = tester.widget<ShaderMask>(find.byType(ShaderMask));

      // shaderCallback dibuat ulang tiap frame animasi.
      expect(berikut.shaderCallback, isNot(same(awal.shaderCallback)));

      await stopAnimation(tester);
    });
  });
}
