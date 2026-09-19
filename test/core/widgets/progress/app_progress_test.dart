import 'package:basecode/core/theme/app_colors.dart';
import 'package:basecode/core/theme/app_theme.dart';
import 'package:basecode/core/widgets/progress/app_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pumpProgress(WidgetTester tester, AppProgress child) {
    return tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(body: child),
      ),
    );
  }

  testWidgets('menampilkan batang', (tester) async {
    await pumpProgress(tester, const AppProgress(value: 0.5));

    expect(find.byType(LinearProgressIndicator), findsOneWidget);
  });

  testWidgets('tanpa value: berjalan terus', (tester) async {
    await pumpProgress(tester, const AppProgress());

    final bar = tester.widget<LinearProgressIndicator>(
      find.byType(LinearProgressIndicator),
    );
    expect(bar.value, isNull);
  });

  testWidgets('menampilkan persen saat showPercentage', (tester) async {
    await pumpProgress(
      tester,
      const AppProgress(value: 0.35, showPercentage: true),
    );

    expect(find.text('35%'), findsOneWidget);
  });

  testWidgets('persen disembunyikan saat nilainya tak tentu', (tester) async {
    await pumpProgress(tester, const AppProgress(showPercentage: true));

    expect(find.textContaining('%'), findsNothing);
  });

  testWidgets('nilai di luar 0-1 dijepit', (tester) async {
    await pumpProgress(tester, const AppProgress(value: 1.5));

    final bar = tester.widget<LinearProgressIndicator>(
      find.byType(LinearProgressIndicator),
    );
    expect(bar.value, 1.0);
  });

  testWidgets('warna batang default memakai token primary', (tester) async {
    await pumpProgress(tester, const AppProgress(value: 0.5));

    final bar = tester.widget<LinearProgressIndicator>(
      find.byType(LinearProgressIndicator),
    );
    final theme = Theme.of(
      tester.element(find.byType(LinearProgressIndicator)),
    );
    final valueColor = bar.valueColor as AlwaysStoppedAnimation<Color?>;
    expect(valueColor.value, theme.appColors.primary);
  });
}
