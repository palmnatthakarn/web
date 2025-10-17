import 'package:flutter/material.dart';

class SectionBuilder {
  static Widget buildSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      decoration: _boxDecoration(),
      child: Column(
        children: [
          _header(title, icon),
          Padding(
            padding: const EdgeInsets.all(10),
            child: child,
          ),
        ],
      ),
    );
  }

  /// 🔽 ตัวใหม่: buildSectionWithTrailing
  static Widget buildSectionWithTrailing({
    required String title,
    required IconData icon,
    required Widget child,
    required Widget headerTrailing,
  }) {
    return Container(
      decoration: _boxDecoration(),
      child: Column(
        children: [
          _headerWithTrailing(title, icon, headerTrailing),
          Padding(
            padding: const EdgeInsets.all(10),
            child: child,
          ),
        ],
      ),
    );
  }

  /// 🔽 ตัวเดิมที่ย่อ/ขยายได้
  static Widget buildExpandableSection({
    required String title,
    required IconData icon,
    required Widget child,
    bool initiallyExpanded = true,
  }) {
    return _ExpandableSection(
      title: title,
      icon: icon,
      child: child,
      initiallyExpanded: initiallyExpanded,
    );
  }

  // --- ส่วนตกแต่งที่ใช้ซ้ำ ---
  static BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.08),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
        BoxShadow(
          color: Colors.grey.withOpacity(0.04),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  static Widget _header(String title, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: _headerDecoration(),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            child: Icon(icon, color: Colors.grey[700], size: 20),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color.fromARGB(255, 43, 43, 43),
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _headerWithTrailing(
      String title, IconData icon, Widget trailing) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: _headerDecoration(),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            child: Icon(icon, color: Colors.grey[700], size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color.fromARGB(255, 43, 43, 43),
                letterSpacing: -0.5,
              ),
            ),
          ),
          trailing,
        ],
      ),
    );
  }

  static BoxDecoration _headerDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Colors.grey.shade50,
          Colors.grey.shade100,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      ),
      border: Border(
        bottom: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
    );
  }
}

/// Stateful สำหรับ expandable
class _ExpandableSection extends StatefulWidget {
  final String title;
  final IconData icon;
  final Widget child;
  final bool initiallyExpanded;

  const _ExpandableSection({
    required this.title,
    required this.icon,
    required this.child,
    this.initiallyExpanded = true,
  });

  @override
  State<_ExpandableSection> createState() => _ExpandableSectionState();
}

class _ExpandableSectionState extends State<_ExpandableSection> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: SectionBuilder._boxDecoration(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () {
              if (mounted) {
                setState(() => _isExpanded = !_isExpanded);
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: SectionBuilder._headerDecoration(),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: Icon(widget.icon, color: Colors.grey[700], size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color.fromARGB(255, 43, 43, 43),
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.grey[700],
                  )
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 250),
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.all(10),
              child: widget.child,
            ),
          ),
        ],
      ),
    );
  }
}
