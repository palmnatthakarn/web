import 'package:flutter/material.dart';

/// Time Picker Field Component
/// A customizable time picker widget with consistent styling
class TimePickerField extends StatelessWidget {
  final String label;
  final TimeOfDay selectedTime;
  final Function(TimeOfDay) onChanged;

  const TimePickerField({
    super.key,
    required this.label,
    required this.selectedTime,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final time = await showTimePicker(
              context: context,
              initialTime: selectedTime,
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
            if (time != null) onChanged(time);
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
                const Icon(Icons.access_time,
                    color: Color(0xFF3B82F6), size: 20),
                const SizedBox(width: 12),
                Text(
                  selectedTime.format(context),
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
