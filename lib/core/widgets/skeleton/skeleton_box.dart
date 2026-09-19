import 'package:basecode/core/theme/app_radius.dart';
import 'package:basecode/core/widgets/skeleton/skeleton_base.dart';
import 'package:flutter/material.dart';

/// Blok skeleton persegi dengan sudut membulat.
/// Animasi dipegang SkeletonBase, di sini hanya bentuknya.
class SkeletonBox extends StatelessWidget {
  const SkeletonBox({
    super.key,
    this.width,
    this.height,
    this.radius = AppRadius.sm,
    this.duration = const Duration(milliseconds: 1200),
  });

  final double? width;
  final double? height;
  final double radius;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return SkeletonBase(
      width: width,
      height: height,
      duration: duration,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
