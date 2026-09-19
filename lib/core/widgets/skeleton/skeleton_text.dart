import 'package:basecode/core/theme/app_radius.dart';
import 'package:basecode/core/widgets/skeleton/skeleton_box.dart';
import 'package:flutter/material.dart';

/// Baris teks tiruan. Hanya SkeletonBox dengan tinggi setara satu baris teks.
class SkeletonText extends StatelessWidget {
  const SkeletonText({
    super.key,
    this.width,
    this.height = 14,
    this.radius = AppRadius.xs,
    this.duration = const Duration(milliseconds: 1200),
  });

  final double? width;
  final double height;
  final double radius;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return SkeletonBox(
      width: width,
      height: height,
      radius: radius,
      duration: duration,
    );
  }
}
