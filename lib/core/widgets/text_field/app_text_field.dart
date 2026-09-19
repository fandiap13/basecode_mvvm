import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.onPrefixTap,
    this.onSuffixTap,
    this.obscureText = false,
    this.keyboardType,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.onChanged,
    this.onSubmitted,
    this.decoration,
  });

  final TextEditingController? controller;

  final String? label;
  final String? hint;
  final String? helperText;
  final String? errorText;

  final IconData? prefixIcon;
  final IconData? suffixIcon;

  final VoidCallback? onPrefixTap;
  final VoidCallback? onSuffixTap;

  final bool obscureText;
  final TextInputType? keyboardType;
  final bool enabled;
  final bool readOnly;
  final int maxLines;

  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  final InputDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      enabled: enabled,
      readOnly: readOnly,
      maxLines: obscureText ? 1 : maxLines,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      decoration: (decoration ?? const InputDecoration()).copyWith(
        labelText: label,
        hintText: hint,
        helperText: helperText,
        errorText: errorText,
        prefixIcon: prefixIcon != null
            ? IconButton(onPressed: onPrefixTap, icon: Icon(prefixIcon))
            : null,
        suffixIcon: suffixIcon != null
            ? IconButton(onPressed: onSuffixTap, icon: Icon(suffixIcon))
            : null,
      ),
    );
  }
}
