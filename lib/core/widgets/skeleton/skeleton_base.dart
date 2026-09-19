import 'package:basecode/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Dasar bersama untuk semua skeleton.
///
/// Memegang satu animasi shimmer: gradient terang yang bergerak dari kiri ke
/// kanan di atas warna dasar. Bentuk (kotak / lingkaran) ditentukan pemanggil
/// lewat [shape], jadi SkeletonBox dan SkeletonCircle tidak perlu mengulang
/// kode animasi.
class SkeletonBase extends StatefulWidget {
  const SkeletonBase({
    super.key,
    required this.shape,
    this.width,
    this.height,
    this.duration = const Duration(milliseconds: 1200),
  });

  final ShapeBorder shape;
  final double? width;
  final double? height;
  final Duration duration;

  @override
  State<SkeletonBase> createState() => _SkeletonBaseState();
}

class _SkeletonBaseState extends State<SkeletonBase>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    // Warna dasar dan kilau diambil dari token supaya ikut light/dark mode.
    final base = colors.line;
    final highlight = Color.alphaBlend(
      colors.surface.withValues(alpha: 0.6),
      base,
    );
    // final highlight = colors.ink;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Geser gradient dari luar layar kiri ke luar layar kanan.
        final offset = (_controller.value * 2) - 1;

        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) => LinearGradient(
            begin: Alignment(offset - 1, 0),
            end: Alignment(offset + 1, 0),
            colors: [base, highlight, base],
            stops: const [0.40, 0.5, 0.60],
          ).createShader(bounds),
          child: child,
        );
      },
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: DecoratedBox(
          decoration: ShapeDecoration(color: base, shape: widget.shape),
        ),
      ),
    );
  }
}
