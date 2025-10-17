import 'package:flutter/material.dart';

/// Enhanced Radio Group Component
/// A customizable radio group widget with icons and enhanced styling
class EnhancedRadioGroup extends StatelessWidget {
  final String title;
  final IconData icon;
  final MaterialColor color;
  final List<String> options;
  final int selectedValue;
  final Function(int) onChanged;

  const EnhancedRadioGroup({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.options,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: color[600]),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Column(
          children: options.asMap().entries.map((entry) {
            final index = entry.key + 1;
            final option = entry.value;
            final isSelected = selectedValue == index;
            final isLast = index == options.length;

            return InkWell(
              onTap: () => onChanged(index),
              borderRadius: BorderRadius.vertical(
                top: index == 1 ? const Radius.circular(12) : Radius.zero,
                bottom: isLast ? const Radius.circular(12) : Radius.zero,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                decoration: BoxDecoration(
                  color: isSelected ? color[50] : Colors.transparent,
                ),
                child: Row(
                  children: [
                    Radio<int>(
                      value: index,
                      groupValue: selectedValue,
                      onChanged: (v) => onChanged(v!),
                      activeColor: color[500],
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        option,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.normal,
                          color: isSelected ? color[700] : Colors.grey[700],
                        ),
                      ),
                    ),
                    if (isSelected)
                      Icon(Icons.check_circle, color: color[600], size: 18),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  /// Simple Radio Group without title and icon, radios in a single row
  static Widget RowRadioGroup({
    required List<String> options,
    required int selectedValue,
    required Function(int) onChanged,
    MaterialColor color = Colors.blue,
  }) {
    return Row(
      children: options.asMap().entries.map((entry) {
        final index = entry.key + 1;
        final option = entry.value;
        final isSelected = selectedValue == index;

        return Expanded(
          child: InkWell(
            onTap: () => onChanged(index),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              decoration: BoxDecoration(
                color: isSelected ? color[50] : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Radio<int>(
                    value: index,
                    groupValue: selectedValue,
                    onChanged: (v) => onChanged(v!),
                    activeColor: color[500],
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  Expanded(
                    child: Text(
                      option,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        color: isSelected ? color[700] : Colors.grey[700],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
