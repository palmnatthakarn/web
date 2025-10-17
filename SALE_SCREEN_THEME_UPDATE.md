# การปรับปรุงธีมหน้าขายสินค้า (Sale Screen)

## 📋 สรุปการเปลี่ยนแปลง

ปรับปรุงหน้าขายสินค้า (SaleScreenV2) ให้มีธีมและรูปแบบสอดคล้องกับหน้าอื่นๆ ในระบบ เช่น หน้าเจ้าหนี้, ลูกหนี้, และหน้าซื้อสินค้า

## 🎨 การเปลี่ยนแปลงหลัก

### 1. AppBar Gradient
**เดิม:**
```dart
backgroundColor: Colors.green[600]
```

**ใหม่:**
```dart
decoration: AppTheme.gradientDecoration
backgroundColor: Colors.transparent
```

- ใช้ gradient แบบเดียวกับหน้าอื่นๆ
- เพิ่มความสวยงามและความสอดคล้อง

### 2. ปุ่ม Back
**เพิ่ม:**
```dart
leading: Container(
  margin: const EdgeInsets.all(8),
  decoration: BoxDecoration(
    color: Colors.white.withOpacity(0.2),
    borderRadius: BorderRadius.circular(12),
  ),
  child: IconButton(
    icon: const Icon(Icons.arrow_back, color: Colors.white),
    onPressed: () => Navigator.pop(context),
    padding: EdgeInsets.zero,
  ),
)
```

- ปุ่ม Back แบบกลมพร้อมพื้นหลังโปร่งแสง
- สอดคล้องกับหน้าอื่นๆ

### 3. Thai Flag
**เพิ่ม:**
```dart
const Padding(
  padding: EdgeInsets.only(right: 16),
  child: ThaiFlag(width: 24, height: 16),
)
```

- เพิ่มธงชาติไทยในมุมบนขวา
- แสดงความเป็นไทยของระบบ

### 4. Action Buttons
**เพิ่มปุ่มต่างๆ:**
- 🧮 **คำนวณ** - สำหรับคำนวณต่างๆ
- 📦 **คลังสินค้า** - ดูข้อมูลคลังสินค้า
- 🖨️ **พิมพ์** - พิมพ์ใบเสร็จ
- 🗑️ **ล้างรายการ** - ล้างรายการในตะกร้า
- 👤 **ผู้ใช้** - ข้อมูลผู้ใช้

```dart
ActionIconButton(
  icon: Icons.calculate,
  tooltip: 'คำนวณ',
  onPressed: () { /* TODO */ },
)
```

### 5. Background Color
**เดิม:**
```dart
backgroundColor: Colors.grey[50]
```

**ใหม่:**
```dart
backgroundColor: Colors.grey[100]
```

- สอดคล้องกับหน้าอื่นๆ
- ดูสบายตามากขึ้น

### 6. Floating Action Button Color
**เดิม:**
```dart
backgroundColor: Colors.green[600]
```

**ใหม่:**
```dart
backgroundColor: const Color(0xFF10B981)
```

- ใช้สีเขียวมาตรฐานของระบบ
- สอดคล้องกับปุ่มอื่นๆ

### 7. AppBar Size
**เพิ่ม:**
```dart
preferredSize: const Size.fromHeight(kToolbarHeight + 48)
```

- เพิ่มความสูงเพื่อรองรับ TabBar และ Action buttons

## 📦 Dependencies เพิ่มเติม

```dart
import '../../blocs/sale/sale_event.dart';
import '../../component/barcode/action_icon_button.dart';
import '../../component/barcode/thai_flag.dart';
import '../../theme/app_theme.dart';
```

## 🎯 ผลลัพธ์

### ก่อนปรับปรุง
- AppBar สีเขียวธรรมดา
- ไม่มีปุ่ม Action
- ไม่มีธงชาติไทย
- ธีมไม่สอดคล้องกับหน้าอื่น

### หลังปรับปรุง
- ✅ AppBar แบบ Gradient สวยงาม
- ✅ ปุ่ม Back แบบกลม
- ✅ ธงชาติไทย
- ✅ Action Buttons 5 ปุ่ม
- ✅ ธีมสอดคล้องกับทุกหน้า
- ✅ UX ดีขึ้น

## 🔧 TODO (สำหรับการพัฒนาต่อ)

1. **ปุ่มคำนวณ** - เพิ่มฟังก์ชันคำนวณส่วนลด/ภาษี
2. **ปุ่มคลังสินค้า** - เชื่อมต่อกับหน้าคลังสินค้า
3. **ปุ่มพิมพ์** - พิมพ์ใบเสร็จรับเงิน
4. **ปุ่มผู้ใช้** - แสดงข้อมูลผู้ใช้/พนักงาน

## 📊 การเปรียบเทียบ

| คุณสมบัติ | เดิม | ใหม่ |
|-----------|------|------|
| AppBar Background | สีเขียวเดียว | Gradient |
| ปุ่ม Back | ธรรมดา | กลม + โปร่งแสง |
| Action Buttons | ไม่มี | 5 ปุ่ม |
| Thai Flag | ไม่มี | มี |
| Background Color | grey[50] | grey[100] |
| FAB Color | green[600] | #10B981 |
| ความสอดคล้อง | ❌ | ✅ |

## ✅ สถานะ

- ✅ ไม่มี compile errors
- ✅ ใช้ component ที่มีอยู่แล้ว
- ✅ ธีมสอดคล้องกับหน้าอื่นๆ
- ✅ พร้อมใช้งาน

## 🚀 การใช้งาน

ไม่มีการเปลี่ยนแปลงใน API - ใช้งานเหมือนเดิม:

```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const SaleScreenV2(),
  ),
);
```

---

**วันที่อัพเดท:** 17 ตุลาคม 2025  
**ไฟล์ที่แก้ไข:** `lib/screens/saleV2/sale_screen_V2.dart`
