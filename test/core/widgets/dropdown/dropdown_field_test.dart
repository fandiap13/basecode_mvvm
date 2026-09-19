import 'package:basecode/core/theme/app_colors.dart';
import 'package:basecode/core/theme/app_radius.dart';
import 'package:basecode/core/theme/app_theme.dart';
import 'package:basecode/core/widgets/dropdown/app_dropdown_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const items = <DropdownMenuItem<String>>[
    DropdownMenuItem(value: 'a', child: Text('Alpha')),
    DropdownMenuItem(value: 'b', child: Text('Beta')),
  ];

  Future<void> pumpDropdown(
    WidgetTester tester,
    AppDropdownField<String> field,
  ) {
    return tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(body: field),
      ),
    );
  }

  testWidgets('menampilkan label, hint, dan helperText', (tester) async {
    await pumpDropdown(
      tester,
      const AppDropdownField<String>(
        label: 'Kota',
        hint: 'Pilih kota',
        helperText: 'Bantuan',
        items: items,
        onChanged: null,
      ),
    );

    expect(find.text('Kota'), findsOneWidget);
    expect(find.text('Pilih kota'), findsOneWidget);
    expect(find.text('Bantuan'), findsOneWidget);
  });

  testWidgets('errorText menggantikan helperText', (tester) async {
    await pumpDropdown(
      tester,
      const AppDropdownField<String>(
        helperText: 'Bantuan',
        errorText: 'Salah',
        items: items,
        onChanged: null,
      ),
    );

    expect(find.text('Salah'), findsOneWidget);
    expect(find.text('Bantuan'), findsNothing);
  });

  testWidgets('memilih item memanggil onChanged', (tester) async {
    String? dipilih;

    await pumpDropdown(
      tester,
      AppDropdownField<String>(
        items: items,
        onChanged: (value) => dipilih = value,
      ),
    );

    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Beta').last);
    await tester.pumpAndSettle();

    expect(dipilih, 'b');
  });

  testWidgets('value menampilkan pilihan saat ini', (tester) async {
    await pumpDropdown(
      tester,
      AppDropdownField<String>(value: 'a', items: items, onChanged: (_) {}),
    );

    expect(find.text('Alpha'), findsOneWidget);
  });

  testWidgets('enabled false menonaktifkan dropdown', (tester) async {
    await pumpDropdown(
      tester,
      AppDropdownField<String>(enabled: false, items: items, onChanged: (_) {}),
    );

    final field = tester.widget<DropdownButtonFormField<String>>(
      find.byType(DropdownButtonFormField<String>),
    );
    expect(field.onChanged, isNull);
  });

  testWidgets('bekerja dengan tipe selain String', (tester) async {
    int? dipilih;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: AppDropdownField<int>(
            items: const [
              DropdownMenuItem(value: 1, child: Text('Satu')),
              DropdownMenuItem(value: 2, child: Text('Dua')),
            ],
            onChanged: (value) => dipilih = value,
          ),
        ),
      ),
    );

    await tester.tap(find.byType(DropdownButtonFormField<int>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Dua').last);
    await tester.pumpAndSettle();

    expect(dipilih, 2);
  });

  testWidgets('variant mewarnai border', (tester) async {
    await pumpDropdown(
      tester,
      const AppDropdownField<String>(
        variant: AppDropdownFieldVariant.danger,
        items: items,
        onChanged: null,
      ),
    );

    final field = tester.widget<DropdownButtonFormField<String>>(
      find.byType(DropdownButtonFormField<String>),
    );
    final border = field.decoration.enabledBorder! as OutlineInputBorder;
    final theme = Theme.of(
      tester.element(find.byType(DropdownButtonFormField<String>)),
    );
    expect(border.borderSide.color, theme.appColors.danger);
  });

  testWidgets('size mengatur padding dan huruf', (tester) async {
    await pumpDropdown(
      tester,
      const AppDropdownField<String>(
        size: AppDropdownFieldSize.large,
        items: items,
        onChanged: null,
      ),
    );

    final field = tester.widget<DropdownButtonFormField<String>>(
      find.byType(DropdownButtonFormField<String>),
    );
    expect(
      field.decoration.contentPadding,
      EdgeInsets.symmetric(
        horizontal: AppDropdownFieldSize.large.hPadding,
        vertical: AppDropdownFieldSize.large.vPadding,
      ),
    );
    // style diteruskan ke DropdownButton di dalamnya.
    final inner = tester.widget<DropdownButton<String>>(
      find.byType(DropdownButton<String>),
    );
    expect(inner.style!.fontSize, AppDropdownFieldSize.large.fontSize);
  });

  testWidgets('radius menimpa nilai dari theme', (tester) async {
    await pumpDropdown(
      tester,
      const AppDropdownField<String>(
        radius: AppRadius.xl,
        items: items,
        onChanged: null,
      ),
    );

    final field = tester.widget<DropdownButtonFormField<String>>(
      find.byType(DropdownButtonFormField<String>),
    );
    final border = field.decoration.enabledBorder! as OutlineInputBorder;
    expect(border.borderRadius, BorderRadius.circular(AppRadius.xl));
  });

  testWidgets('label floating dipasang di dalam kolom', (tester) async {
    await pumpDropdown(
      tester,
      const AppDropdownField<String>(
        label: 'Kota',
        labelPosition: AppDropdownFieldLabelPosition.floating,
        items: items,
        onChanged: null,
      ),
    );

    final field = tester.widget<DropdownButtonFormField<String>>(
      find.byType(DropdownButtonFormField<String>),
    );
    expect(field.decoration.labelText, 'Kota');
  });

  testWidgets('label outside dirender di luar kolom', (tester) async {
    await pumpDropdown(
      tester,
      const AppDropdownField<String>(
        label: 'Kota',
        items: items,
        onChanged: null,
      ),
    );

    final field = tester.widget<DropdownButtonFormField<String>>(
      find.byType(DropdownButtonFormField<String>),
    );
    expect(field.decoration.labelText, isNull);
    expect(find.text('Kota'), findsOneWidget);
  });

  testWidgets('onSuffixTap dipanggil saat ikon ditekan', (tester) async {
    var taps = 0;
    await pumpDropdown(
      tester,
      AppDropdownField<String>(
        suffixIcon: Icons.clear,
        onSuffixTap: () => taps++,
        items: items,
        onChanged: null,
      ),
    );

    await tester.tap(find.byIcon(Icons.clear));
    await tester.pump();

    expect(taps, 1);
  });

  testWidgets('contentPadding pemanggil mengalahkan size', (tester) async {
    const rapat = EdgeInsets.symmetric(horizontal: 12, vertical: 8);
    await pumpDropdown(
      tester,
      const AppDropdownField<String>(
        size: AppDropdownFieldSize.large,
        decoration: InputDecoration(contentPadding: rapat),
        items: items,
        onChanged: null,
      ),
    );

    final field = tester.widget<DropdownButtonFormField<String>>(
      find.byType(DropdownButtonFormField<String>),
    );
    expect(field.decoration.contentPadding, rapat);
  });
}
