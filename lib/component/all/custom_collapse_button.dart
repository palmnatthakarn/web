import 'package:flutter/material.dart';

import 'collapsible_panel_widget.dart';

class CustomCollapseButton extends StatelessWidget {
  final bool isCollapsed;
  final VoidCallback onTap;
  final Gradient gradient;
  final String? tooltip;

  const CustomCollapseButton({
    super.key,
    required this.isCollapsed,
    required this.onTap,
    required this.gradient,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft, // ชิดซ้ายตรงกลางแนวตั้ง
      child: GestureDetector(
        onTap: onTap,
        child: CollapseButtonBuilder.gradient(
          gradient: gradient,
          tooltip: tooltip,
          isCollapsed: isCollapsed,
        ),
      ),
    );
  }
}
