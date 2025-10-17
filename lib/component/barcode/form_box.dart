import 'package:flutter/material.dart';

class FormBox extends StatelessWidget {
  final String? hintText;
  final double? height;
  final bool filled;
  final int? maxLines;
  final bool expands;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  const FormBox({
    super.key,
    this.hintText,
    this.height,
    this.filled = false,
    this.maxLines = 1,
    this.expands = false,
    this.prefixIcon,
    this.suffixIcon,
    this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final field = TextField(
      controller: controller,
      maxLines: expands ? null : maxLines,
      expands: expands,
      onChanged: onChanged,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: hintText,
        prefixIcon: prefixIcon == null ? null : Icon(prefixIcon, size: 18),
        suffixIcon: suffixIcon == null ? null : Icon(suffixIcon, size: 18),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );

    final box = Container(
      height: expands ? null : (height ?? 36),
      decoration: BoxDecoration(
        color: filled ? Colors.grey[200] : null,
        border: filled ? null : Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(4),
      ),
      child: field,
    );

    if (expands && height != null) return SizedBox(height: height, child: box);
    return box;
  }
}
