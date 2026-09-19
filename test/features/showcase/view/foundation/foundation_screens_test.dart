import 'package:basecode/core/theme/app_theme.dart';
import 'package:basecode/features/showcase/view/foundation/breakpoints_showcase_screen.dart';
import 'package:basecode/features/showcase/view/foundation/colors_showcase_screen.dart';
import 'package:basecode/features/showcase/view/foundation/elevation_showcase_screen.dart';
import 'package:basecode/features/showcase/view/foundation/spacing_showcase_screen.dart';
import 'package:basecode/features/showcase/view/foundation/typography_showcase_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pump(WidgetTester tester, Widget screen) {
    return tester.pumpWidget(
      MaterialApp(theme: AppTheme.light(), home: screen),
    );
  }

  testWidgets('ColorsShowcaseScreen render tanpa error', (tester) async {
    await pump(tester, const ColorsShowcaseScreen());

    expect(find.text('Colors'), findsOneWidget);
    expect(find.text('primary'), findsOneWidget);
  });

  testWidgets('TypographyShowcaseScreen render tanpa error', (tester) async {
    await pump(tester, const TypographyShowcaseScreen());

    expect(find.text('Typography'), findsOneWidget);
    expect(find.textContaining('displaySmall'), findsOneWidget);
  });

  testWidgets('SpacingShowcaseScreen render tanpa error', (tester) async {
    await pump(tester, const SpacingShowcaseScreen());

    expect(find.text('Spacing'), findsWidgets);
    expect(find.text('Radius'), findsOneWidget);
  });

  testWidgets('ElevationShowcaseScreen render tanpa error', (tester) async {
    await pump(tester, const ElevationShowcaseScreen());

    expect(find.text('Elevation'), findsOneWidget);
    expect(find.text('none (0)'), findsOneWidget);
    expect(find.text('lg (12)'), findsOneWidget);
  });

  testWidgets('BreakpointsShowcaseScreen render tanpa error', (tester) async {
    await pump(tester, const BreakpointsShowcaseScreen());

    expect(find.text('Breakpoints'), findsOneWidget);
    expect(find.textContaining('px'), findsWidgets);
  });
}
