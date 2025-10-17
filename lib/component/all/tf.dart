import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldBuilder {
  static Widget tf(
    TextEditingController controller,
    String label,
    String hint,
    IconData icon, {
    bool required = false,
    int maxLines = 1,
    Color? fillColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Colors.black87,
            ),
            children: required
                ? [
                    const TextSpan(
                      text: ' *',
                      style: TextStyle(color: Colors.red),
                    )
                  ]
                : [],
          ),
        ),
        const SizedBox(height: 6),
        SizedBox(
          height: 40,
          child: TextFormField(
            controller: controller,
            maxLines: maxLines,
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: Icon(icon, color: Colors.grey[500], size: 18),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Colors.grey.shade500,
                  width: 1,
                ),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              filled: true,
              fillColor: fillColor ?? Colors.grey.shade50,
            ),
            validator: required
                ? (value) => value?.isEmpty == true ? 'กรุณากรอก$label' : null
                : null,
          ),
        ),
      ],
    );
  }

  // Keep the simple version for backward compatibility
  static Widget simpleTf({
    String? label,
    required TextEditingController controller,
    String? labelText,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int? maxLines,
    Color? fillColor,
    bool required = false,
  }) {
    final displayLabel = labelText ?? label ?? '';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (required)
          RichText(
            text: TextSpan(
              text: displayLabel,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.black87,
              ),
              children: [
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red),
                )
              ],
            ),
          ),
        SizedBox(height: required ? 6 : 0),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType ??
              (displayLabel == 'ราคาต่อหน่วย'
                  ? TextInputType.numberWithOptions(decimal: true)
                  : null),
          maxLines: maxLines ?? 1,
          decoration: InputDecoration(
            labelText: required ? null : displayLabel,
            isDense: true,
            filled: true,
            fillColor: fillColor ?? const Color(0xFFF9FAFB),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFF3B82F6)),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          validator: validator ??
              (required
                  ? (value) {
                      if (value?.trim().isEmpty == true) {
                        return 'กรุณากรอก$displayLabel';
                      }
                      // ตรวจสอบราคาต่อหน่วยต้องเป็นตัวเลขและมากกว่า 0
                      if (displayLabel == 'ราคาต่อหน่วย') {
                        final price = double.tryParse(value!);
                        if (price == null || price <= 0) {
                          return 'ราคาต้องเป็นตัวเลขและมากกว่า 0';
                        }
                      }
                      return null;
                    }
                  : null),
        ),
      ],
    );
  }

  static Widget simpleTfonlyNum({
    String? label,
    required TextEditingController controller,
    String? labelText,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int? maxLines,
    Color? fillColor,
    bool required = false,
    int? maxLength, // ✅ จำกัดความยาวได้
    bool? allowDecimal, // ✅ อนุญาตทศนิยม
  }) {
    final displayLabel = labelText ?? label ?? '';

    // กำหนดว่าจะให้มีทศนิยมหรือไม่ (ดีฟอลต์: ถ้าเป็น "ราคาต่อหน่วย" ให้มีทศนิยม)
    final _allowDecimal = allowDecimal ?? (displayLabel == 'ราคาต่อหน่วย');

    // สร้าง inputFormatters
    final List<TextInputFormatter> formatters = [];
    if (_allowDecimal) {
      // ตัวเลข + จุดทศนิยม และจำกัดทศนิยมไม่เกิน 2 ตำแหน่ง (ปรับได้ตามต้องการ)
      formatters.add(FilteringTextInputFormatter.allow(
        RegExp(r'^\d*\.?\d{0,2}$'),
      ));
    } else {
      // เฉพาะตัวเลขเท่านั้น
      formatters.add(FilteringTextInputFormatter.digitsOnly);
    }
    if (maxLength != null) {
      formatters.add(LengthLimitingTextInputFormatter(maxLength));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (required)
          RichText(
            text: TextSpan(
              text: displayLabel,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.black87,
              ),
              children: const [
                TextSpan(text: ' *', style: TextStyle(color: Colors.red)),
              ],
            ),
          ),
        SizedBox(height: required ? 6 : 0),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType ??
              (_allowDecimal
                  ? const TextInputType.numberWithOptions(decimal: true)
                  : TextInputType.number),
          maxLines: maxLines ?? 1,
          inputFormatters: formatters, // ✅ ใส่ตัวจำกัดการกรอก
          decoration: InputDecoration(
            labelText: required ? null : displayLabel,
            isDense: true,
            filled: true,
            fillColor: fillColor ?? const Color(0xFFF9FAFB),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFF3B82F6)),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          validator: validator ??
              (required
                  ? (value) {
                      final v = value?.trim() ?? '';
                      if (v.isEmpty) return 'กรุณากรอก$displayLabel';
                      if (_allowDecimal) {
                        final n = double.tryParse(v);
                        if (n == null) return '$displayLabel ต้องเป็นตัวเลข';
                        if (displayLabel == 'ราคาต่อหน่วย' && n <= 0) {
                          return 'ราคาต้องมากกว่า 0';
                        }
                      } else {
                        if (!RegExp(r'^\d+$').hasMatch(v)) {
                          return '$displayLabel ต้องเป็นตัวเลข';
                        }
                      }
                      return null;
                    }
                  : null),
        ),
      ],
    );
  }

  static Widget readOnlyTextField({
    required String labelText,
    required String value,
    Color? fillColor,
  }) {
    return TextFormField(
      initialValue: value,
      enabled: false,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
        filled: true,
        fillColor: fillColor ?? Colors.grey[100],
      ),
    );
  }
}
