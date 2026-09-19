import 'package:basecode/core/theme/app_colors.dart';
import 'package:basecode/core/theme/app_theme.dart';
import 'package:basecode/core/widgets/loading/app_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pumpLoading(WidgetTester tester, AppLoading child) {
    return tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(body: child),
      ),
    );
  }

  testWidgets('menampilkan putaran', (tester) async {
    await pumpLoading(tester, const AppLoading());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('menampilkan label', (tester) async {
    await pumpLoading(tester, const AppLoading(label: 'Memuat data...'));

    expect(find.text('Memuat data...'), findsOneWidget);
  });

  testWidgets('tanpa label: hanya putaran', (tester) async {
    await pumpLoading(tester, const AppLoading());

    expect(find.byType(Text), findsNothing);
  });

  testWidgets('warna default memakai token primary', (tester) async {
    await pumpLoading(tester, const AppLoading());

    final spinner = tester.widget<CircularProgressIndicator>(
      find.byType(CircularProgressIndicator),
    );
    final theme = Theme.of(
      tester.element(find.byType(CircularProgressIndicator)),
    );
    expect(spinner.color, theme.appColors.primary);
  });

  testWidgets('ukuran mengatur diameter putaran', (tester) async {
    await pumpLoading(tester, const AppLoading(size: 48));

    final size = tester.getSize(find.byType(CircularProgressIndicator));
    expect(size.width, 48);
    expect(size.height, 48);
  });
}
