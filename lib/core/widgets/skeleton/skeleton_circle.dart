import 'package:basecode/core/widgets/skeleton/skeleton_base.dart';
import 'package:flutter/material.dart';

/// Skeleton bulat untuk avatar atau ikon.
/// Animasi dipegang SkeletonBase, di sini hanya bentuknya.
class SkeletonCircle extends StatelessWidget {
  const SkeletonCircle({
    super.key,
    this.size = 40,
    this.duration = const Duration(milliseconds: 1200),
  });

  final double size;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return SkeletonBase(
      width: size,
      height: size,
      duration: duration,
      shape: const CircleBorder(),
    );
  }
}
