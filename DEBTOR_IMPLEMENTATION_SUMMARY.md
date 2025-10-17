# หน้าลูกหนี้ (Debtor) - สรุปการสร้าง

## 📋 ภาพรวม
สร้างหน้าจัดการลูกหนี้ที่มีโครงสร้างคล้ายกับหน้าเจ้าหนี้ โดยใช้ Bloc pattern และใช้ component ที่มีอยู่แล้ว

## 🗂️ ไฟล์ที่สร้าง

### 1. Bloc Layer
- **`lib/blocs/debtor/debtor_state.dart`**
  - `DebtorStatus` enum: initial, loading, loaded, failure
  - `DebtorItem` class: โมเดลข้อมูลลูกหนี้
    - code, name, address, phone, email, taxId
    - contactPerson, createdDate, creditLimit, currentBalance
    - personType, branch, branchNumber, images
  - `DebtorState` class: state management
    - Form fields สำหรับเพิ่ม/แก้ไขลูกหนี้
    - `filtered` getter สำหรับค้นหา

- **`lib/blocs/debtor/debtor_event.dart`**
  - `DebtorInitialized` - โหลดข้อมูลลูกหนี้
  - `DebtorSearchChanged` - ค้นหาลูกหนี้
  - `DebtorLeftPanelDragged` - ปรับขนาด panel
  - `DebtorItemSelected` - เลือกลูกหนี้
  - `DebtorFormUpdated` - อัพเดทฟอร์ม
  - `DebtorItemAdded/Removed/Updated` - จัดการข้อมูล
  - `DebtorCalculatePressed/InventoryPressed/AddPressed/DeletePressed/UserPressed` - ปุ่มต่างๆ
  - `DebtorImageAdded/Removed/ImagesCleared` - จัดการรูปภาพ

- **`lib/blocs/debtor/debtor_bloc.dart`**
  - Event handlers ทั้งหมด
  - เชื่อมต่อกับ DebtorRepository

### 2. Repository Layer
- **`lib/repository/debtor_repository.dart`**
  - `fetchDebtors()` - โหลดข้อมูลลูกหนี้ (mock data 5 รายการ)
  - `addDebtor()` - เพิ่มลูกหนี้
  - `updateDebtor()` - อัพเดทลูกหนี้
  - `deleteDebtor()` - ลบลูกหนี้

### 3. Screen Layer
- **`lib/screens/debtor/debtor_screen.dart`**
  - หน้าหลักจัดการลูกหนี้
  - AppBar พร้อม gradient decoration
  - ปุ่ม Action: คำนวณ, คลังสินค้า, เพิ่ม, ลบ, ผู้ใช้
  - Layout: Left Panel + Right Panel

### 4. Widgets Layer

#### Left Panel
- **`lib/screens/debtor/widgets_debtor/debtor_left_panel.dart`**
  - แสดงรายการลูกหนี้แบบตาราง
  - ค้นหาและกรอง
  - Collapsible panel (ปรับขนาดได้)
  - Header columns: รหัส, ชื่อลูกหนี้, โทรศัพท์, วงเงิน, ยอดคงเหลือ
  - Highlight แถวที่เลือก

#### Right Panel
- **`lib/screens/debtor/widgets_debtor/debtor_right_panel.dart`**
  - แสดงตารางลูกหนี้แบบเต็ม (DataTable2)
  - Empty state เมื่อยังไม่มีข้อมูล
  - คลิกแถวเพื่อดูรายละเอียด
  - ปุ่มลบในแต่ละแถว

#### Header
- **`lib/screens/debtor/widgets_debtor/debtor_header.dart`**
  - ช่องค้นหาพร้อม clear button
  - ปุ่มเพิ่มลูกหนี้
  - สรุปข้อมูล:
    - ลูกหนี้ทั้งหมด (จำนวนราย)
    - ยอดรวม (ยอดคงเหลือรวม)

#### Dialogs
- **`lib/screens/debtor/widgets_debtor/debtor_detail_dialog.dart`**
  - แสดงรายละเอียดลูกหนี้แบบเต็ม
  - Sections: ข้อมูลทั่วไป, ข้อมูลการติดต่อ, ข้อมูลทางการเงิน
  - ปุ่มแก้ไข

- **`lib/screens/debtor/widgets_debtor/add_debtor_dialog.dart`**
  - Dialog เพิ่มลูกหนี้ใหม่
  - ใช้ AddItemDialog component
  - ฟิลด์: รหัส, ชื่อ, ที่อยู่, โทรศัพท์, อีเมล, เลขภาษี, ผู้ติดต่อ, วงเงิน, ยอดคงเหลือ, ประเภท, สาขา

- **`lib/screens/debtor/widgets_debtor/edit_debtor_dialog.dart`**
  - Dialog แก้ไขลูกหนี้
  - ใช้ AddItemDialog component
  - ไม่สามารถแก้ไขรหัสได้

## 🎨 คุณสมบัติ

### การจัดการข้อมูล
- ✅ เพิ่มลูกหนี้ใหม่
- ✅ แก้ไขข้อมูลลูกหนี้
- ✅ ลบลูกหนี้
- ✅ ดูรายละเอียดลูกหนี้

### การค้นหา & กรอง
- ✅ ค้นหาด้วย: รหัส, ชื่อ, โทรศัพท์, อีเมล, เลขภาษี
- ✅ Real-time search
- ✅ Clear search button

### UI/UX
- ✅ Responsive design
- ✅ Collapsible left panel
- ✅ Empty state
- ✅ Loading state
- ✅ Error handling
- ✅ Success/Error messages (SnackBar)
- ✅ Highlight แถวที่เลือก
- ✅ Gradient AppBar พร้อม ThaiFlag

### ข้อมูลที่รองรับ
- ✅ ประเภทบุคคล: นิติบุคคล (1), บุคคลธรรมดา (2)
- ✅ ข้อมูลสาขา (สำหรับนิติบุคคล)
- ✅ วงเงินเครดิต
- ✅ ยอดคงเหลือ
- ✅ วันที่สร้าง

## 🔗 Component ที่ใช้งานซ้ำ

จากหน้าเจ้าหนี้:
- `ActionIconButton` - ปุ่มใน AppBar
- `ThaiFlag` - ธงชาติไทย
- `FormBox` - ช่องค้นหา
- `CollapsiblePanelWidget` - Panel ซ้ายที่ปรับขนาดได้
- `CustomCollapseButton` - ปุ่มยุบ/ขยาย panel
- `AddItemDialog` - Dialog เพิ่ม/แก้ไขข้อมูล

จาก Theme:
- `AppTheme.gradientDecoration` - สีพื้นหลัง AppBar
- `dashboard_gradient_2` - สี collapse button

## 📊 Mock Data
Repository มีข้อมูล mock 5 รายการ:
1. D001 - บริษัท ABC จำกัด (วงเงิน 500,000, คงเหลือ 150,000)
2. D002 - ร้านค้าปลีก XYZ (วงเงิน 300,000, คงเหลือ 85,000)
3. D003 - นายสมปอง รุ่งเรือง (วงเงิน 100,000, คงเหลือ 25,000)
4. D004 - ห้างหุ้นส่วน DEF (วงเงิน 750,000, คงเหลือ 320,000)
5. D005 - บริษัท GHI จำกัด (มหาชน) (วงเงิน 1,000,000, คงเหลือ 450,000)

## 🚀 การใช้งาน

```dart
// นำเข้าหน้าลูกหนี้
import 'package:flutter_web_app/screens/debtor/debtor_screen.dart';

// เปิดหน้า
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const DebtorScreen()),
);
```

## 🎯 ความแตกต่างจากหน้าเจ้าหนี้

1. **ชื่อเรียก**: เจ้าหนี้ → ลูกหนี้
2. **ไอคอน/สี**: ใช้สีเดียวกันแต่ข้อความต่างกัน
3. **ข้อมูล**: ใช้ DebtorItem แทน CreditorItem
4. **Repository**: แยก repository ต่างหาก
5. **Bloc**: แยก bloc ต่างหาก

## ✅ สถานะการพัฒนา

- ✅ Bloc Layer - สำเร็จ
- ✅ Repository - สำเร็จ (mock data)
- ✅ Screen - สำเร็จ
- ✅ Left Panel - สำเร็จ
- ✅ Right Panel - สำเร็จ
- ✅ Header - สำเร็จ
- ✅ Detail Dialog - สำเร็จ
- ✅ Add Dialog - สำเร็จ
- ✅ Edit Dialog - สำเร็จ
- ✅ ไม่มี compile errors

## 📝 หมายเหตุ

- ใช้ `AddItemField` จาก `component/all/add_item_dialog.dart`
- `AddItemField` ไม่รองรับ `enabled` parameter และ `dropdown` constructor
- แก้ไขโดยใช้ TextField ธรรมดาพร้อมคำอธิบาย
- ประเภทบุคคลใช้ตัวเลข: 1=นิติบุคคล, 2=บุคคลธรรมดา

## 🔜 การพัฒนาต่อ
- เชื่อมต่อกับ Database จริง
- เพิ่มการอัพโหลดรูปภาพ
- เพิ่มการ Export ข้อมูล
- เพิ่มรายงานลูกหนี้
- เพิ่มการแจ้งเตือนเมื่อเกินวงเงิน
