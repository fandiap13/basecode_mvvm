import 'package:basecode/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class SectionCard extends StatefulWidget {
  const SectionCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;

  @override
  State<SectionCard> createState() => _SectionCardState();
}

class _SectionCardState extends State<SectionCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1,
        duration: const Duration(milliseconds: 100),
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: _isPressed ? AppColors.green : AppColors.line,
              width: 1,
            ),
          ),
          margin: widget.margin,
          color: AppColors.surface,
          child: Padding(
            padding: widget.padding ?? EdgeInsets.all(12),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
