// ตัวอย่าง Event
// File: lib/blocs/counter_event.dart

// ใช้สำหรับจัดการเหตุการณ์ที่เกิดขึ้นในแอปพลิเคชัน

abstract class AppEvent {}
class SelectLeftNavItem extends AppEvent {
  final int index;
  SelectLeftNavItem(this.index);
}
class ToggleLeftNavExpand extends AppEvent {}
