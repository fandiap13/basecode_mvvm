import 'package:basecode/core/theme/app_colors.dart';
import 'package:basecode/core/theme/app_radius.dart';
import 'package:flutter/material.dart';

enum AppTabBussinesVariant { primary, secondary, danger, warning, info, dark }

enum AppTabBussinesSize {
  small(fontSize: 13, horizontalPadding: 12),
  medium(fontSize: 14, horizontalPadding: 16),
  large(fontSize: 16, horizontalPadding: 20);

  const AppTabBussinesSize({
    required this.fontSize,
    required this.horizontalPadding,
  });

  final double fontSize;
  final double horizontalPadding;
}

class AppTabBussines extends StatefulWidget {
  const AppTabBussines({
    super.key,
    required this.tabs,
    required this.children,
    this.descriptions,
    this.controller,
    this.variant = AppTabBussinesVariant.primary,
    this.size = AppTabBussinesSize.medium,
    this.isScrollable = false,
    this.padding,
  });

  final List<String> tabs;
  final List<Widget> children;

  /// Keterangan kecil di bawah judul tiap tab, sejajar dengan [tabs].
  /// Boleh lebih pendek; tab sisanya tampil tanpa keterangan.
  final List<String?>? descriptions;

  final TabController? controller;

  final AppTabBussinesVariant variant;
  final AppTabBussinesSize size;

  final bool isScrollable;
  final EdgeInsetsGeometry? padding;

  @override
  State<AppTabBussines> createState() => _AppTabBussinesState();
}

// TickerProviderStateMixin, bukan Single: controller dibuat ulang saat
// jumlah tab berubah, jadi ticker bisa lebih dari satu sepanjang hidup state.
class _AppTabBussinesState extends State<AppTabBussines>
    with TickerProviderStateMixin {
  // Ukuran penanda kecil di atas tab aktif.
  static const _indicatorWidth = 35.0;
  static const _indicatorHeight = 6.0;

  // Jarak penanda dari tepi kiri tab.
  static const _indicatorGap = 12.0;

  TabController? _internal;

  /// Controller milik pemanggil bila ada; kalau tidak, buat sendiri.
  TabController get _controller => widget.controller ?? _internal!;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _internal = TabController(length: widget.tabs.length, vsync: this);
    }

    // Posisi tab baru terbaca setelah layout pertama; minta satu repaint
    // agar penanda langsung berada di tempatnya.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void didUpdateWidget(AppTabBussines oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Jumlah tab berubah: controller internal harus dibuat ulang.
    if (widget.controller == null &&
        widget.tabs.length != oldWidget.tabs.length) {
      _internal?.dispose();
      _internal = TabController(length: widget.tabs.length, vsync: this);
    }
  }

  @override
  void dispose() {
    _internal?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = theme.appColors;

    final tabColor = switch (widget.variant) {
      AppTabBussinesVariant.primary => c.primary,
      AppTabBussinesVariant.secondary => c.secondary,
      AppTabBussinesVariant.danger => c.danger,
      AppTabBussinesVariant.warning => c.warning,
      AppTabBussinesVariant.info => c.info,
      AppTabBussinesVariant.dark => c.ink,
    };

    const radius = Radius.circular(AppRadius.md);
    final border = BorderSide(color: c.line);

    return Column(
      children: [
        const SizedBox(height: _indicatorHeight),
        // Baris tab digambar di atas kanvas yang memegang garis pemisah.
        // Garis itu diputus di bawah tab aktif oleh _TabSeamPainter.
        Stack(
          clipBehavior: Clip.none,
          children: [
            AnimatedBuilder(
              animation: _controller.animation ?? _controller,
              builder: (context, child) => CustomPaint(
                painter: _TabSeamPainter(
                  animation: _controller.animation,
                  tabCount: widget.tabs.length,
                  color: c.line,
                  // Tab yang dapat digulir lebarnya tidak seragam, jadi jahitan
                  // hanya digambar pada mode lebar tetap.
                  enabled: !widget.isScrollable,
                ),
                child: child,
              ),
              child: TabBar(
                controller: _controller,
                isScrollable: widget.isScrollable,
                padding: widget.padding,
                unselectedLabelColor: c.ink,
                labelColor: tabColor,
                labelStyle: theme.textTheme.labelMedium?.copyWith(
                  fontSize: widget.size.fontSize,
                ),
                labelPadding: EdgeInsets.symmetric(
                  horizontal: widget.size.horizontalPadding,
                ),
                // Tab aktif: bertepi tiga sisi, dasarnya dibiarkan terbuka
                // agar menyambung ke panel.
                indicator: BoxDecoration(
                  color: c.surface,
                  border: Border(top: border, left: border, right: border),
                  borderRadius: const BorderRadius.only(
                    topLeft: radius,
                    topRight: radius,
                  ),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                splashBorderRadius: const BorderRadius.only(
                  topLeft: radius,
                  topRight: radius,
                ),
                tabs: _buildTabs(theme, tabColor, c.inkSoft),
              ),
            ),

            // Penanda kecil yang menonjol di atas tab aktif.
            // Posisi dan lebar tab dibaca dari render tree, bukan dari
            // hasil bagi rata, supaya tetap tepat saat mode scrollable
            // (lebar tiap tab mengikuti panjang teksnya).
            Positioned(
              top: -_indicatorHeight,
              left: 0,
              right: 0,
              child: AnimatedBuilder(
                animation: _controller.animation ?? _controller,
                builder: (context, child) => Transform.translate(
                  offset: Offset(_indicatorOffset(), 0),
                  child: child,
                ),
                // Align menahan Container agar tidak ikut melebar
                // mengikuti Positioned.
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: _indicatorWidth,
                    height: _indicatorHeight,
                    decoration: BoxDecoration(
                      color: tabColor,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(_indicatorHeight / 2),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: c.surface,
              border: Border(left: border, right: border, bottom: border),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(AppRadius.md),
                bottomLeft: Radius.circular(AppRadius.md),
                bottomRight: Radius.circular(AppRadius.md),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(AppRadius.md),
              ),
              child: TabBarView(
                controller: _controller,
                children: widget.children,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Kunci tiap Tab, dipakai membaca posisi dan lebarnya yang sebenarnya.
  final _tabKeys = <int, GlobalKey>{};

  GlobalKey _tabKey(int index) => _tabKeys.putIfAbsent(index, GlobalKey.new);

  /// Geseran penanda dari tepi kiri bilah tab.
  ///
  /// Posisi dibaca dari Tab yang sebenarnya, bukan dari lebar dibagi rata,
  /// supaya tetap tepat saat lebar tiap tab berbeda (mode scrollable).
  /// Di antara dua tab, nilainya diinterpolasi agar geserannya mulus.
  double _indicatorOffset() {
    final position = _controller.animation?.value ?? _controller.index;
    final from = position.floor().clamp(0, widget.tabs.length - 1);
    final to = position.ceil().clamp(0, widget.tabs.length - 1);

    final left = _tabLeft(from);
    if (left == null) return _indicatorGap;

    if (from == to) return left + _indicatorGap;

    final nextLeft = _tabLeft(to);
    if (nextLeft == null) return left + _indicatorGap;

    final t = position - from;
    return left + (nextLeft - left) * t + _indicatorGap;
  }

  /// Tepi kiri Tab ke-[index] relatif terhadap bilah tab, atau null bila
  /// tab itu belum terpasang.
  double? _tabLeft(int index) {
    final box = _tabKeys[index]?.currentContext?.findRenderObject();
    final bar = context.findRenderObject();
    if (box is! RenderBox || bar is! RenderBox || !box.hasSize) return null;

    // Pada mode scrollable, ScrollPosition bisa belum siap saat build
    // frame pertama; localToGlobal melempar di situ.
    try {
      return box.localToGlobal(Offset.zero, ancestor: bar).dx;
    } catch (_) {
      return null;
    }
  }

  /// Keterangan untuk tab ke-[index], atau null bila tidak ada.
  String? _descriptionAt(int index) {
    final list = widget.descriptions;
    if (list == null || index >= list.length) return null;
    return list[index];
  }

  /// Rakit Tab dari judul dan keterangannya.
  ///
  /// Keterangan diwarnai mengikuti keadaan tab: ikut warna aktif saat
  /// terpilih, redup saat tidak. TabBar hanya mewarnai label utama, jadi
  /// warnanya dihitung di sini dari indeks yang sedang aktif.
  List<Widget> _buildTabs(
    ThemeData theme,
    Color selectedColor,
    Color mutedColor,
  ) {
    final descriptionStyle = theme.textTheme.bodySmall?.copyWith(
      fontSize: widget.size.fontSize - 3,
      height: 1.2,
    );

    return [
      for (var i = 0; i < widget.tabs.length; i++)
        Tab(
          key: _tabKey(i),
          height: _descriptionAt(i) == null ? null : 56,
          // Isi dilebarkan ke seluruh tab agar rata kirinya terlihat.
          // Pada mode scrollable lebar tab tidak terbatas, jadi dibiarkan
          // menciut selebar teks.
          child: SizedBox(
            width: widget.isScrollable ? null : double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.tabs[i],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (_descriptionAt(i) case final description?) ...[
                  const SizedBox(height: 2),
                  Text(
                    description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: descriptionStyle?.copyWith(
                      color: _controller.index == i
                          ? selectedColor
                          : mutedColor,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
    ];
  }
}

/// Menggambar garis pemisah di bawah baris tab, diputus di bawah tab aktif.
class _TabSeamPainter extends CustomPainter {
  _TabSeamPainter({
    required this.animation,
    required this.tabCount,
    required this.color,
    required this.enabled,
  }) : super(repaint: animation);

  final Animation<double>? animation;
  final int tabCount;
  final Color color;
  final bool enabled;

  @override
  void paint(Canvas canvas, Size size) {
    if (!enabled || tabCount == 0) return;

    final pen = Paint()
      ..color = color
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    final y = size.height - 0.5;
    final tabWidth = size.width / tabCount;

    // Posisi pecahan mengikuti animasi geser, jadi celah ikut bergerak
    // mulus saat berpindah tab.
    final position = animation?.value ?? 0;
    final gapStart = position * tabWidth;
    final gapEnd = gapStart + tabWidth;

    // Ruas kiri celah.
    if (gapStart > 0) {
      canvas.drawLine(Offset(0, y), Offset(gapStart, y), pen);
    }

    // Ruas kanan celah.
    if (gapEnd < size.width) {
      canvas.drawLine(Offset(gapEnd, y), Offset(size.width, y), pen);
    }
  }

  @override
  bool shouldRepaint(_TabSeamPainter oldDelegate) =>
      oldDelegate.tabCount != tabCount ||
      oldDelegate.color != color ||
      oldDelegate.enabled != enabled ||
      oldDelegate.animation != animation;
}
