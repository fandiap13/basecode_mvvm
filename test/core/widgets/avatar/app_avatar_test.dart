import 'package:basecode/core/theme/app_theme.dart';
import 'package:basecode/core/widgets/avatar/app_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pumpAvatar(WidgetTester tester, Widget avatar) {
    return tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(body: Center(child: avatar)),
      ),
    );
  }

  group('initialsOf', () {
    test('dua kata diambil huruf awal masing-masing', () {
      expect(AppAvatar.initialsOf('Fandy Wangdef'), 'FW');
    });

    test('satu kata diambil satu huruf', () {
      expect(AppAvatar.initialsOf('Fandy'), 'F');
    });

    test('tiga kata diambil yang pertama dan terakhir', () {
      expect(AppAvatar.initialsOf('Ahmad Rizki Pratama'), 'AP');
    });

    test('spasi berlebih diabaikan', () {
      expect(AppAvatar.initialsOf('  Fandy   Wangdef  '), 'FW');
    });

    test('nama kosong menghasilkan string kosong', () {
      expect(AppAvatar.initialsOf(''), '');
      expect(AppAvatar.initialsOf('   '), '');
    });

    test('huruf kecil diubah jadi kapital', () {
      expect(AppAvatar.initialsOf('fandy wangdef'), 'FW');
    });
  });

  testWidgets('menampilkan inisial saat tidak ada gambar', (tester) async {
    await pumpAvatar(tester, const AppAvatar(name: 'Fandy Wangdef'));

    expect(find.text('FW'), findsOneWidget);
  });

  testWidgets('jatuh ke ikon saat nama kosong', (tester) async {
    await pumpAvatar(tester, const AppAvatar());

    expect(find.byIcon(Icons.person_outline), findsOneWidget);
  });

  testWidgets('ikon khusus dipakai saat diberikan', (tester) async {
    await pumpAvatar(tester, const AppAvatar(icon: Icons.storefront_outlined));

    expect(find.byIcon(Icons.storefront_outlined), findsOneWidget);
  });

  testWidgets('size menentukan diameter', (tester) async {
    for (final size in AppAvatarSize.values) {
      await pumpAvatar(tester, AppAvatar(name: 'Fandy', size: size));

      expect(
        tester.getSize(find.byType(AppAvatar)),
        Size(size.diameter, size.diameter),
        reason: 'ukuran ${size.name}',
      );
    }
  });

  testWidgets('onTap dipanggil saat diketuk', (tester) async {
    var taps = 0;
    await pumpAvatar(tester, AppAvatar(name: 'Fandy', onTap: () => taps++));

    await tester.tap(find.byType(AppAvatar));
    await tester.pump();

    expect(taps, 1);
  });

  testWidgets('tanpa onTap tidak ada InkWell', (tester) async {
    await pumpAvatar(tester, const AppAvatar(name: 'Fandy'));

    expect(find.byType(InkWell), findsNothing);
  });

  testWidgets('tooltip terpasang saat diisi', (tester) async {
    await pumpAvatar(tester, const AppAvatar(name: 'Fandy', tooltip: 'Profil'));

    expect(find.byType(Tooltip), findsOneWidget);
  });

  testWidgets('status memakai warna berbeda saat daring', (tester) async {
    await pumpAvatar(
      tester,
      const AppAvatar(name: 'Fandy', showStatus: true, isOnline: true),
    );
    final daring = tester
        .widgetList<Container>(find.byType(Container))
        .map((c) => (c.decoration as BoxDecoration?)?.color)
        .toList();

    await pumpAvatar(tester, const AppAvatar(name: 'Fandy', showStatus: true));
    final luring = tester
        .widgetList<Container>(find.byType(Container))
        .map((c) => (c.decoration as BoxDecoration?)?.color)
        .toList();

    expect(daring, isNot(luring));
  });

  group('AppAvatarGroup', () {
    testWidgets('menampilkan semua avatar saat di bawah max', (tester) async {
      await pumpAvatar(
        tester,
        const AppAvatarGroup(
          avatars: [
            AppAvatar(name: 'Fandy Wangdef'),
            AppAvatar(name: 'Ahmad Rizki'),
          ],
        ),
      );

      expect(find.text('FW'), findsOneWidget);
      expect(find.text('AR'), findsOneWidget);
      expect(find.textContaining('+'), findsNothing);
    });

    testWidgets('meringkas sisanya jadi +N', (tester) async {
      await pumpAvatar(
        tester,
        const AppAvatarGroup(
          max: 2,
          avatars: [
            AppAvatar(name: 'Fandy Wangdef'),
            AppAvatar(name: 'Ahmad Rizki'),
            AppAvatar(name: 'Siti Nur'),
            AppAvatar(name: 'Budi Santoso'),
          ],
        ),
      );

      expect(find.text('FW'), findsOneWidget);
      expect(find.text('AR'), findsOneWidget);
      expect(find.text('+2'), findsOneWidget);
      expect(find.text('SN'), findsNothing);
    });
  });
}
