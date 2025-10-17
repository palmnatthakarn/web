import 'package:flutter/material.dart';

class ResizableDivider extends StatefulWidget {
  final void Function(double dx) onDrag;
  const ResizableDivider({super.key, required this.onDrag});

  @override
  State<ResizableDivider> createState() => _ResizableDividerState();
}

class _ResizableDividerState extends State<ResizableDivider> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.resizeColumn,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onPanUpdate: (d) => widget.onDrag(d.delta.dx),
        child: Container(
          width: 4,
          color:
              _hover ? Colors.blue.withOpacity(0.15) : Colors.grey[300],
          child: Center(
            child: Container(
              width: 2,
              height: 120,
              color: Colors.grey[400],
            ),
          ),
        ),
      ),
    );
  }
}
