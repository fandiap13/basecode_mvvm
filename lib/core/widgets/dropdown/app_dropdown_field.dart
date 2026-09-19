import 'package:basecode/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

enum AppDropdownFieldLabelPosition { outside, floating }

// variant
enum AppDropdownFieldVariant { primary, secondary, danger, warning, info, dark }

// size
enum AppDropdownFieldSize {
  small(vPadding: 8, hPadding: 12, fontSize: 13),
  medium(vPadding: 12, hPadding: 16, fontSize: 14),
  large(vPadding: 16, hPadding: 20, fontSize: 16);

  const AppDropdownFieldSize({
    required this.vPadding,
    required this.hPadding,
    required this.fontSize,
  });

  final double vPadding;
  final double hPadding;
  final double fontSize;
}

class AppDropdownField<T> extends StatelessWidget {
  const AppDropdownField({
    super.key,
    required this.items,
    this.value, // gak pake controller
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.onPrefixTap,
    this.suffixIcon,
    this.onSuffixTap,
    this.onChanged,
    this.enabled = true,
    this.decoration,
    this.focusNode,
    this.labelPosition = AppDropdownFieldLabelPosition.outside,
    this.variant = AppDropdownFieldVariant.primary,
    this.size = AppDropdownFieldSize.medium,
    this.radius,
  });

  final List<DropdownMenuItem<T>> items;
  final T? value;

  final String? label;
  final String? hint;
  final String? helperText;
  final String? errorText;

  final IconData? prefixIcon;
  final VoidCallback? onPrefixTap;

  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;

  final ValueChanged<T?>? onChanged;

  final bool enabled;

  final InputDecoration? decoration;

  final AppDropdownFieldSize size;
  final double? radius;

  final FocusNode? focusNode;
  final AppDropdownFieldLabelPosition labelPosition;
  final AppDropdownFieldVariant variant;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = theme.appColors;
    final isFloating = labelPosition == AppDropdownFieldLabelPosition.floating;

    final dropdownColor = switch (variant) {
      AppDropdownFieldVariant.primary => c.primary,
      AppDropdownFieldVariant.secondary => c.secondary,
      AppDropdownFieldVariant.danger => c.danger,
      AppDropdownFieldVariant.warning => c.warning,
      AppDropdownFieldVariant.info => c.info,
      AppDropdownFieldVariant.dark => c.ink,
    };

    final borderRadius = radius != null
        ? BorderRadius.circular(radius!)
        : (theme.inputDecorationTheme.enabledBorder as OutlineInputBorder?)
                  ?.borderRadius ??
              BorderRadius.zero;

    OutlineInputBorder border(Color color, {double width = 1}) =>
        OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(color: color, width: width),
        );

    final dropdownField = AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: focusNode?.hasFocus == true
            ? [
                BoxShadow(
                  color: dropdownColor.withValues(alpha: 0.12),
                  offset: Offset.zero,
                  blurRadius: 6,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: DropdownButtonFormField<T>(
        focusNode: focusNode,
        initialValue: value,
        items: items,
        onChanged: enabled ? onChanged : null,
        // height dibiarkan bawaan font; menaikkannya justru menumpuk
        // ruang di atas glyph sehingga huruf terdorong ke bawah.
        style: theme.textTheme.labelMedium?.copyWith(
          fontSize: size.fontSize,
          height: 1,
        ),
        alignment: Alignment.centerLeft,
        isExpanded: true,
        decoration: (decoration ?? const InputDecoration()).copyWith(
          isDense: true,
          contentPadding:
              decoration?.contentPadding ??
              EdgeInsets.symmetric(
                horizontal: size.hPadding,
                vertical: size.vPadding,
              ),
          filled: true,
          fillColor: dropdownColor.withValues(alpha: 0.05),
          labelText: isFloating ? label : null,
          hintText: hint,
          helperText: helperText,
          errorText: errorText,

          prefixIcon: prefixIcon != null
              ? IconButton(onPressed: onPrefixTap, icon: Icon(prefixIcon))
              : null,
          suffixIcon: suffixIcon != null
              ? IconButton(onPressed: onSuffixTap, icon: Icon(suffixIcon))
              : null,
          // border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          enabledBorder: border(dropdownColor),
          focusedBorder: border(dropdownColor, width: 2),
          errorBorder: border(c.danger),
          focusedErrorBorder: border(c.danger, width: 2),
          disabledBorder: border(c.line.withValues(alpha: 0.5)),
        ),
      ),
    );

    if (isFloating || label == null) return dropdownField;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label!, style: theme.textTheme.labelMedium),
        const SizedBox(height: 6),
        dropdownField,
      ],
    );
  }
}
