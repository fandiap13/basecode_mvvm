import 'dart:async';

import 'package:basecode/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

// variant
enum AppCarouselVariant { primary, secondary, danger, warning, info, dark }

class AppCarousel extends StatefulWidget {
  const AppCarousel({
    super.key,
    required this.items,
    this.height,
    this.viewportFraction = 1,
    this.initialPage = 0,
    this.autoPlay = false,
    this.autoPlayDuration = const Duration(seconds: 3),
    this.onPageChanged,
    this.showIndicator = true,
    this.indicatorSpacing = 8,
    this.variant = AppCarouselVariant.primary,
  });

  final List<Widget> items;
  final double? height;
  final double viewportFraction;
  final int initialPage;

  final bool autoPlay;
  final Duration autoPlayDuration;

  final ValueChanged<int>? onPageChanged;

  final bool showIndicator;
  final double indicatorSpacing;

  final AppCarouselVariant variant;

  @override
  State<AppCarousel> createState() => _AppCarouselState();
}

class _AppCarouselState extends State<AppCarousel> {
  late final PageController _controller;
  late int _currentPage;

  // Disimpan agar bisa dibatalkan saat widget dibuang; tanpa ini timer
  // tetap berjalan setelah layar ditutup.
  Timer? _autoPlayTimer;

  @override
  void initState() {
    super.initState();

    _currentPage = widget.initialPage;

    _controller = PageController(
      initialPage: widget.initialPage,
      viewportFraction: widget.viewportFraction,
    );

    if (widget.autoPlay) {
      _startAutoPlay();
    }
  }

  void _startAutoPlay() {
    _autoPlayTimer?.cancel();

    _autoPlayTimer = Timer.periodic(widget.autoPlayDuration, (_) {
      if (!mounted || !_controller.hasClients) return;

      final nextPage = (_currentPage + 1) % widget.items.length;

      _controller.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });

    widget.onPageChanged?.call(index);
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final c = theme.appColors;
    final carouselColor = switch (widget.variant) {
      AppCarouselVariant.primary => c.primary,
      AppCarouselVariant.secondary => c.secondary,
      AppCarouselVariant.danger => c.danger,
      AppCarouselVariant.warning => c.warning,
      AppCarouselVariant.info => c.info,
      AppCarouselVariant.dark => c.ink,
    };

    return Column(
      children: [
        SizedBox(
          height: widget.height,
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.items.length,
            onPageChanged: _onPageChanged,
            itemBuilder: (context, index) {
              return widget.items[index];
            },
          ),
        ),
        if (widget.showIndicator && widget.items.length > 1) ...[
          SizedBox(height: widget.indicatorSpacing),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.items.length, (index) {
              final isActive = index == _currentPage;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: isActive ? 20 : 6,
                height: 6,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: isActive
                      ? carouselColor
                      : c.surface.withValues(alpha: 0.2),
                ),
              );
            }),
          ),
        ],
      ],
    );
  }
}
