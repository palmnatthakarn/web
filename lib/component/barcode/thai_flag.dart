import 'package:flutter/material.dart';

class ThaiFlag extends StatelessWidget {
  final double width;
  final double height;
  final String? assetPath; // หากอยากใช้ asset จริง

  const ThaiFlag({
    super.key,
    required this.width,
    required this.height,
    this.assetPath,
  });

  @override
  Widget build(BuildContext context) {
    if (assetPath != null) {
      return Image.asset(
        assetPath!,
        width: width,
        height: height,
        errorBuilder: (_, __, ___) => _fallback(),
      );
    }
    return _fallback();
  }

  Widget _fallback() {
    return SizedBox(
      width: width,
      height: height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          _Stripe(color: Color(0xffDA1212)),
          _Stripe(color: Colors.white),
          _Stripe(color: Color(0xff241D4F), flex: 2),
          _Stripe(color: Colors.white),
          _Stripe(color: Color(0xffDA1212)),
        ],
      ),
    );
  }
}

class _Stripe extends StatelessWidget {
  final Color color;
  final int flex;
  const _Stripe({required this.color, this.flex = 1, super.key});
  @override
  Widget build(BuildContext context) {
    return Expanded(child: Container(color: color));
  }
}
