import 'package:flutter/material.dart';

/// Enhanced Dropdown Group Component
/// A customizable dropdown widget with icons and enhanced styling
class EnhancedDropdownGroup extends StatelessWidget {
  final String title;
  final IconData icon;
  final MaterialColor color;
  final List<String> options;
  final int selectedValue;
  final Function(int) onChanged;
  final String? hint;

  const EnhancedDropdownGroup({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.options,
    required this.selectedValue,
    required this.onChanged,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty)
          Row(
            children: [
              Icon(icon, size: 18, color: color[600]),
              const SizedBox(width: 8),
              Text(
                title,
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
            ],
          ),
        if (title.isNotEmpty) const SizedBox(height: 8),
        Container(
          width: double.infinity,
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: selectedValue > 0 && selectedValue <= options.length
                  ? selectedValue
                  : null,
              hint: Text(
                hint ?? 'เลือก${title.isNotEmpty ? title : 'รายการ'}',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              icon: Container(
                constraints: const BoxConstraints(maxWidth: 24),
                child: Icon(
                  Icons.arrow_drop_down,
                  color: color[600],
                ),
              ),
              isExpanded: true,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 14,
              ),
              items: options.asMap().entries.map((entry) {
                final index = entry.key + 1;
                final option = entry.value;

                return DropdownMenuItem<int>(
                  value: index,
                  child: Row(
                    children: [
                      Icon(
                        Icons.circle,
                        size: 8,
                        color: color[400],
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          option,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  onChanged(value);
                }
              },
              dropdownColor: Colors.white,
              borderRadius: BorderRadius.circular(8),
              elevation: 8,
            ),
          ),
        ),
      ],
    );
  }

  /// Simple Dropdown Group without title
  static Widget IconinDropdownGroup({
    required IconData icon,
    required MaterialColor color,
    required List<String> options,
    required int selectedValue,
    required Function(int) onChanged,
    String? hint,
  }) {
    return Container(
     height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 0.5, // ✅ ขอบบางลง
        ),
      ),
      child: DropdownButtonFormField<int>(
        isExpanded: true, // ✅ ป้องกัน overflow
        icon: const Icon(Icons.arrow_drop_down, size: 20), // ✅ คุมขนาด icon
        value: selectedValue > 0 && selectedValue <= options.length
            ? selectedValue
            : null,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: const Color(0xFF6B7280)),
          hintText: hint,
        //  isDense: true, // ✅ ลด padding แนวตั้ง
          contentPadding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 12, // ✅ กัน icon เบียดออกขวา
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: Colors.grey.shade300,
              width: 0.5,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: Colors.grey.shade300,
              width: 0.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: Color(0xFF10B981),
              width: 1.0,
            ),
          ),
        ),
        items: options.asMap().entries.map((entry) {
          final index = entry.key + 1;
          final option = entry.value;
          return DropdownMenuItem<int>(
            value: index,
            child: Text(option),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            onChanged(value);
          }
        },
      ),
    );
  }
}

/// Enhanced Payment Dropdown Component
/// A specialized dropdown for payment types with icons and enhanced styling
class EnhancedPaymentDropdown<T> extends StatelessWidget {
  final String title;
  final IconData titleIcon;
  final T value;
  final List<T> items;
  final String Function(T) getDisplayName;
  final IconData Function(T) getIcon;
  final ValueChanged<T?> onChanged;
  final Color? iconColor;
  final Color? backgroundColor;

  const EnhancedPaymentDropdown({
    super.key,
    required this.title,
    required this.titleIcon,
    required this.value,
    required this.items,
    required this.getDisplayName,
    required this.getIcon,
    required this.onChanged,
    this.iconColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return IntrinsicWidth(
      // ✅ ให้ขนาดพอดีกับข้อความ
      child: Container(
        height: 30,
        constraints: const BoxConstraints(minHeight: 30),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.white,
          borderRadius: BorderRadius.circular(60),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<T>(
            value: value,
            isExpanded: false, // ✅ สำคัญ: ไม่ขยายเต็ม จอ แต่พอดีกับเนื้อหา
            icon: Icon(Icons.keyboard_arrow_down,
                color: Colors.grey[600], size: 20),
            elevation: 8,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            dropdownColor: Colors.white,
            borderRadius: BorderRadius.circular(10),

            // แสดงผลเมื่อเลือกแล้ว
            selectedItemBuilder: (ctx) {
              return items.map((item) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(getIcon(item),
                        size: 18, color: iconColor ?? cs.primary),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        getDisplayName(item),
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                    ),
                  ],
                );
              }).toList();
            },

            // รายการใน dropdown
            items: items.map((item) {
              return DropdownMenuItem<T>(
                value: item,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(getIcon(item),
                        size: 18, color: iconColor ?? cs.primary),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        getDisplayName(item),
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),

            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}
