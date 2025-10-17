// ตัวอย่าง State
// File: lib/blocs/counter_state.dart
import 'package:flutter_web_app/models/model.dart';

// ตัวอย่าง State สำหรับแอปพลิเคชัน
// ใช้สำหรับเก็บข้อมูลที่ใช้ในแอปพลิเคชัน
// เช่น รายการเมนูด้านซ้าย การ์ดบนแดชบอร์ด
// รายการที่สามารถเลื่อนดูได้ รายการที่แสดงในรูปแบบวงกลม และรายการในกริดด้านล่าง
// สามารถใช้สำหรับการจัดการสถานะของแอปพลิเคชัน
// โดยใช้ BLoC หรือ Provider
// เพื่อให้สามารถเข้าถึงและปรับปรุงข้อมูลได้อย่างมีประสิทธิภาพ
// และสามารถใช้ในการแสดงผล UI ได้อย่างเหมาะสม
class AppState {
  final List<LeftNavItem> leftNavItems;
  final List<DashboardCardData> dashboardCards;
  final List<CircularItemData> circularItems;
  final List<PlaceholderData> placeholderCard;
  final List<PingridData> pinGridItems;
  final bool isLeftNavExpanded;
  final int selectedScreenIndex;

  AppState({
    required this.leftNavItems,
    this.isLeftNavExpanded = false,
    required this.dashboardCards,
    required this.circularItems,
    required this.placeholderCard,
    required this.pinGridItems,
    this.selectedScreenIndex = 0,
  });

  AppState copyWith(
      {List<LeftNavItem>? leftNavItems,
      bool? isLeftNavExpanded,
      List<DashboardCardData>? dashboardCards,
      List<CircularItemData>? circularItems,
      List<BottomGridItemData>? bottomGridItems,
      List<PlaceholderData>? placeholderCard,
      List<PingridData>? pinGridItems,
      int? selectedScreenIndex}) {
    return AppState(
        leftNavItems: leftNavItems ?? this.leftNavItems,
        isLeftNavExpanded: isLeftNavExpanded ?? this.isLeftNavExpanded,
        dashboardCards: dashboardCards ?? this.dashboardCards,
        circularItems: circularItems ?? this.circularItems,
        placeholderCard: placeholderCard ?? this.placeholderCard,
        pinGridItems: pinGridItems ?? this.pinGridItems,
        selectedScreenIndex: selectedScreenIndex ?? this.selectedScreenIndex);
  }
}
