import 'package:flutter/material.dart';

//LeftNavItem
// ใช้สำหรับรายการในแถบเมนูด้านซ้าย
class LeftNavItem {
  final String label;
  final IconData icon;
  bool isSelected;
  final int? count;

  LeftNavItem({
    required this.label,
    required this.icon,
    this.isSelected = false,
    this.count,
  });
}
// DashboardCardData
// ใช้สำหรับการ์ดบนแดชบอร์ดที่มีข้อมูลแบบวงกล
class DashboardCardData {
  final String title;
  final String subtitle;
  final double? progress; // Nullable for circular progress
  final IconData? icon; // Nullable for icon
  final Color backgroundColor;
  final Color foregroundColor;

  DashboardCardData({
    required this.title,
    required this.subtitle,
    this.progress,
    this.icon,
    required this.backgroundColor,
    required this.foregroundColor, 
    required LinearGradient gradient,
  });

  get gradient => null;
}

// GridButtonData 
// ใช้สำหรับรายการที่สามารถเลื่อนดูได้ในแดชบอร์ด
class GridButtonData  {
  final String text;
  final Color color;
  final VoidCallback? onPressed;



  GridButtonData ({
    required this.text,
    required this.color,
    required this.onPressed,
  });
}

// CircularItemData
// ใช้สำหรับรายการที่แสดงในรูปแบบวงกลมบนแดชบอร์ด
class CircularItemData {
  final String title;
  final String imageUrl;

  CircularItemData({
    required this.title,
    required this.imageUrl,
  });
}

// BottomGridItemData
// ใช้สำหรับรายการในกริดด้านล่างของแดชบอร์ด
class BottomGridItemData {
  final String title;
  final String imageUrl;

  BottomGridItemData({
    required this.title,
    required this.imageUrl,
  });
}

class PlaceholderData  {
  final double? width;
  final double? height;
  final Color color;
  final Widget? child;

  const PlaceholderData({
    this.width,
    this.height,
    this.color = Colors.white,
    this.child,
  });
} 
class PingridData {
 final String text;
 final Color color;
 final VoidCallback? onPressed;

  PingridData({
    required this.text,
    required this.color,
    this.onPressed,
  });
}