import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
export 'package:flutter_web_app/component/barcode/ui.dart';


class HeaderWithIcon extends StatelessWidget {
  final String text;
  final IconData icon;
  const HeaderWithIcon(this.text, this.icon);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.blueGrey.shade600),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class SoftDivider extends StatelessWidget {
  const SoftDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Divider(
        height: 20,
        color: Colors.grey.shade300,
      ),
    );
  }
}

class TagChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  const TagChip({required this.label, this.icon});

  @override
  Widget build(BuildContext context) {
    final fg = Colors.grey.shade800;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: fg),
            const SizedBox(width: 6),
          ],
          Text(label, style: TextStyle(fontSize: 13, color: fg)),
        ],
      ),
    );
  }
}



class ImagePreviewBox extends StatelessWidget {
  const ImagePreviewBox();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 210,
      height: 140,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          // โทนพื้นหลังนวล ๆ
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: const [0.1, 1.0],
                  colors: [Colors.grey.shade50, Colors.grey.shade100],
                ),
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
          // ไอคอน placeholder แบบมินิมอล
          Center(
            child: Icon(Icons.image_outlined,
                size: 44, color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }
}

class Capsule extends StatelessWidget {
  final String text;
  const Capsule({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('vat'),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0), // soft amber
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFCC80)),
      ),
      child: Text(
        text,
        style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF8D6E63),
            fontWeight: FontWeight.w600),
      ),
    );
  }
}

class UnderlineValue extends StatelessWidget {
  final String text;
  final double? minWidth;
  final double? maxWidth;
  const UnderlineValue({required this.text, this.minWidth, this.maxWidth});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: minWidth ?? 120,
        maxWidth: maxWidth ?? 420,
      ),
      child: Container(
        padding: const EdgeInsets.only(bottom: 2),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.shade400,
              width: 1.1,
            ),
          ),
        ),
        child: Text(
          text,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 14,
            height: 1.2,
            decoration: TextDecoration.none,
          ),
        ),
      ),
    );
  }
}

class FormLabel extends StatelessWidget {
  final String text;
  const FormLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontSize: 14,
          color: Colors.grey.shade900,
          fontWeight: FontWeight.w500),
    );
  }
}

class RadioRow extends StatelessWidget {
  final String title;
  final int value;
  final int group;
  final ValueChanged<int> onChanged;
  const RadioRow({
    super.key,
    required this.title,
    required this.value,
    required this.group,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final selected = value == group;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 140),
      curve: Curves.easeOut,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: selected ? Colors.blue.withOpacity(0.04) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Radio<int>(
            value: value,
            groupValue: group,
            onChanged: (v) => onChanged(v ?? group),
            visualDensity: VisualDensity.compact,
          ),
          Text(title, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}

class RadioInline extends StatelessWidget {
  final String label;
  final int value;
  final int group;
  final ValueChanged<int> onChanged;
  const RadioInline({
    super.key,
    required this.label,
    required this.value,
    required this.group,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<int>(
          value: value,
          groupValue: group,
          onChanged: (v) => onChanged(v ?? group),
          visualDensity: VisualDensity.compact,
        ),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}



class RowBaseline extends StatelessWidget {
  final List<Widget> children;
  const RowBaseline({required this.children});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: children,
    );
  }
}
