import 'package:flutter/material.dart';

/// Date Picker Field Component
/// A customizable date picker widget with Thai Buddhist calendar support
class DatePickerField extends StatelessWidget {
  final String label;
  final DateTime selectedDate;
  final Function(DateTime) onChanged;
  final bool isRequired;

  const DatePickerField({
    super.key,
    required this.label,
    required this.selectedDate,
    required this.onChanged,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
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
            children: isRequired
                ? [
                    const TextSpan(
                      text: ' *',
                      style: TextStyle(color: Colors.red),
                    )
                  ]
                : [],
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: selectedDate,
              firstDate: DateTime(2000),
              lastDate: DateTime(2030),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: const ColorScheme.light(
                      primary: Color(0xFF3B82F6),
                      onPrimary: Colors.white,
                      surface: Colors.white,
                      onSurface: Colors.black,
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (date != null) onChanged(date);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 7),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(10),
              color: const Color(0xFFF9FAFB),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today,
                    color: Color(0xFF3B82F6), size: 20),
                const SizedBox(width: 12),
                Text(
                  '${selectedDate.day.toString().padLeft(2, '0')}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.year + 543}',
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
