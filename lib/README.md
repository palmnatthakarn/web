# Flutter Web App - BLoC & Components Documentation

> 📚 เอกสารการใช้งาน BLoC และ Components แบบครบถ้วน

---

## 🚀 เริ่มต้นใช้งาน

### การ Import แบบใหม่ (แนะนำ)

```dart
// แค่ 3 บรรทัด ใช้ได้ทุกอย่าง!
import 'package:flutter_web_app/blocs/blocs.dart';
import 'package:flutter_web_app/component/components.dart';
import 'package:flutter_web_app/widgets/widgets.dart';
```

### หรือ Import ทุกอย่างจากจุดเดียว

```dart
import 'package:flutter_web_app/app_exports.dart';
```

---

## 📖 เอกสารทั้งหมด

| เอกสาร | คำอธิบาย | เหมาะสำหรับ |
|--------|----------|-------------|
| **[README_ORGANIZATION.md](./README_ORGANIZATION.md)** | ภาพรวมการจัดระเบียบ | เริ่มต้นที่นี่ 👈 |
| **[QUICK_REFERENCE.md](./QUICK_REFERENCE.md)** | คู่มืออ้างอิงด่วน | ใช้งานประจำวัน |
| **[ARCHITECTURE.md](./ARCHITECTURE.md)** | สถาปัตยกรรมฉบับเต็ม | เข้าใจระบบลึก |
| **[COMPONENTS_LIST.md](./COMPONENTS_LIST.md)** | รายการ Component ทั้งหมด | ดูว่ามีอะไรบ้าง |
| **[MIGRATION_GUIDE.md](./MIGRATION_GUIDE.md)** | คู่มืออัพเกรดโค้ด | สำหรับโค้ดเดิม |

---

## 📦 โครงสร้างโปรเจค

```
lib/
├── 📄 app_exports.dart              # Central export (ใช้ไฟล์เดียวได้ทุกอย่าง)
├── 📄 README.md                     # เอกสารหลัก (ไฟล์นี้)
├── 📄 QUICK_REFERENCE.md            # คู่มืออ้างอิงด่วน
├── 📄 ARCHITECTURE.md               # สถาปัตยกรรม
├── 📄 COMPONENTS_LIST.md            # รายการ Components
├── 📄 MIGRATION_GUIDE.md            # คู่มือ Migrate
├── 📄 README_ORGANIZATION.md        # ภาพรวมการจัดระเบียบ
│
├── 📁 blocs/
│   ├── 📄 blocs.dart                # ⭐ Export BLoC ทั้งหมด
│   ├── main/                        # AppBloc
│   ├── creditor/                    # CreditorBloc
│   ├── purchase/                    # PurchaseBloc
│   ├── barcode/                     # BarcodeBloc
│   ├── image/                       # ImageBloc
│   └── report/                      # ReportBloc
│
├── 📁 component/
│   ├── 📄 components.dart           # ⭐ Export Component ทั้งหมด
│   ├── all/                         # Form, Dialog, UI Components
│   ├── barcode/
│   ├── report_screen/
│   └── utils/
│
├── 📁 widgets/
│   ├── 📄 widgets.dart              # ⭐ Export Widget ทั้งหมด
│   ├── creditor_image_picker.dart
│   └── image_upload_box.dart
│
├── 📁 screens/
│   └── main/
│       └── widgets_main/
│           ├── 📄 widgets_main.dart # ⭐ Export Main Screen Widgets
│           ├── custom_app_bar.dart
│           ├── dashboard_cards_section.dart
│           └── ... (6 widgets)
│
├── 📁 examples/
│   └── bloc_component_usage_examples.dart
│
└── 📁 scripts/
    └── check_components.dart        # ตรวจสอบ Components
```

---

## 🎯 รายการทรัพยากร

### BLoCs (6 ตัว)
- `AppBloc` - จัดการ App State, Navigation, Dashboard
- `CreditorBloc` - จัดการข้อมูลเจ้าหนี้
- `PurchaseBloc` - จัดการการซื้อขาย
- `BarcodeBloc` - จัดการ Barcode Scanner
- `ImageBloc` - จัดการรูปภาพ
- `ReportBloc` - จัดการรายงาน

### Components (14+ ตัว)
- **Form:** TextFieldBuilder, DatePickerField, TimePickerField, Dropdown, Radio
- **Dialog:** AddItemDialog, EditItemDialog
- **UI:** CardButton, CollapsiblePanel, CustomCollapseButton

### Widgets (2 ตัว)
- `CreditorImagePicker` - เลือกรูปภาพ
- `ImageUploadBox` - อัพโหลดรูปภาพ

### Main Screen Widgets (6 ตัว)
- CustomAppBar, DashboardCardsSection, LeftNavigationPanel
- MainContentPanel, PingridSection, PlaceholderCardSection

**รวมทั้งหมด: 28+ Components พร้อมใช้งาน**

---

## 💡 ตัวอย่างการใช้งาน

### ตัวอย่างที่ 1: Dashboard Page

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_app/blocs/blocs.dart';
import 'package:flutter_web_app/screens/main/widgets_main/widgets_main.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          LeftNavigationPanel(),
          Expanded(
            child: Column(
              children: [
                CustomAppBar(),
                Expanded(child: MainContentPanel()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

### ตัวอย่างที่ 2: Form Page

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_app/blocs/blocs.dart';
import 'package:flutter_web_app/component/components.dart';

class MyFormPage extends StatelessWidget {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFieldBuilder(
          label: 'ชื่อ',
          controller: _controller,
        ),
        DatePickerField(
          label: 'วันที่',
          onDateSelected: (date) {},
        ),
        ElevatedButton(
          onPressed: () {
            context.read<CreditorBloc>().add(
              CreditorItemAdded(/* ... */),
            );
          },
          child: Text('บันทึก'),
        ),
      ],
    );
  }
}
```

### ตัวอย่างที่ 3: ใช้ BLoC

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_app/blocs/blocs.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        return Text('Screen: ${state.selectedScreenIndex}');
      },
    );
  }
}
```

---

## 🛠️ เครื่องมือ

### ตรวจสอบ Components

```bash
# รันคำสั่งนี้เพื่อดูรายการ Components ทั้งหมด
dart lib/scripts/check_components.dart
```

### Analyze โค้ด

```bash
# ตรวจสอบ errors และ warnings
flutter analyze

# แก้ไข formatting
dart format lib/
```

---

## 📚 แนะนำให้อ่านตามลำดับ

1. **เริ่มต้น**: [README_ORGANIZATION.md](./README_ORGANIZATION.md)
   - ภาพรวมการจัดระเบียบ
   - ประโยชน์ที่ได้รับ

2. **ใช้งาน**: [QUICK_REFERENCE.md](./QUICK_REFERENCE.md)
   - วิธีใช้งาน BLoC แต่ละตัว
   - วิธีใช้งาน Component แต่ละตัว
   - Templates สำเร็จรูป

3. **เข้าใจลึก**: [ARCHITECTURE.md](./ARCHITECTURE.md)
   - สถาปัตยกรรมโดยรวม
   - Best Practices
   - ตัวอย่างโค้ดละเอียด

4. **ดูรายการ**: [COMPONENTS_LIST.md](./COMPONENTS_LIST.md)
   - รายการ BLoC ทั้งหมด
   - รายการ Component ทั้งหมด
   - Signature และ Parameters

5. **อัพเกรด**: [MIGRATION_GUIDE.md](./MIGRATION_GUIDE.md)
   - วิธี Migrate จากโค้ดเดิม
   - Find & Replace patterns
   - Troubleshooting

---

## ✨ ข้อดีของระบบใหม่

### ก่อนหน้า (ยุ่งยาก ❌)
```dart
import 'package:flutter_web_app/blocs/main/app_bloc.dart';
import 'package:flutter_web_app/blocs/main/bloc_event.dart';
import 'package:flutter_web_app/blocs/main/bloc_state.dart';
import 'package:flutter_web_app/blocs/creditor/creditor_bloc.dart';
import 'package:flutter_web_app/blocs/creditor/creditor_event.dart';
import 'package:flutter_web_app/blocs/creditor/creditor_state.dart';
import 'package:flutter_web_app/component/all/form_components.dart';
import 'package:flutter_web_app/component/all/card_boutton.dart';
import 'package:flutter_web_app/component/all/date_picker_field.dart';
// ... 10+ บรรทัด
```

### ตอนนี้ (ง่ายมาก ✅)
```dart
import 'package:flutter_web_app/blocs/blocs.dart';
import 'package:flutter_web_app/component/components.dart';
```

**ประโยชน์:**
- ✅ ลด import 70-80%
- ✅ Code สะอาด อ่านง่าย
- ✅ Refactor ง่าย
- ✅ ทีมทำงานร่วมกันสะดวก
- ✅ Maintainability ดีขึ้น

---

## 🎓 Tips & Best Practices

### 1. จัดกลุ่ม Import
```dart
// 1. Flutter/Dart packages
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// 2. Barrel files (App packages)
import 'package:flutter_web_app/blocs/blocs.dart';
import 'package:flutter_web_app/component/components.dart';

// 3. Specific imports (หลีกเลี่ยงถ้าทำได้)
import 'package:flutter_web_app/models/model.dart';
```

### 2. ใช้ BlocBuilder สำหรับ UI
```dart
BlocBuilder<AppBloc, AppState>(
  builder: (context, state) {
    return YourWidget();
  },
)
```

### 3. ใช้ BlocListener สำหรับ Side Effects
```dart
BlocListener<CreditorBloc, CreditorState>(
  listener: (context, state) {
    if (state.status == CreditorStatus.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('บันทึกสำเร็จ')),
      );
    }
  },
  child: YourWidget(),
)
```

### 4. ใช้ BlocConsumer เมื่อต้องการทั้งสองอย่าง
```dart
BlocConsumer<CreditorBloc, CreditorState>(
  listener: (context, state) {
    // Handle side effects
  },
  builder: (context, state) {
    // Build UI
    return YourWidget();
  },
)
```

---

## 🆘 การขอความช่วยเหลือ

### ปัญหาที่พบบ่อย

1. **Import หาไม่เจอ**
   - ตรวจสอบว่ามีไฟล์ barrel file
   - รัน `flutter clean && flutter pub get`

2. **Unused imports**
   - ลบ import เก่าออก
   - ใช้ barrel file แทน

3. **Duplicate symbols**
   - ลบ import ซ้ำ
   - เหลือแค่ barrel file

ดูรายละเอียดเพิ่มใน [MIGRATION_GUIDE.md](./MIGRATION_GUIDE.md)

---

## 📝 License

Copyright © 2025 Flutter Web App Team

---

## 📞 Contact

หากมีคำถามหรือข้อเสนอแนะ กรุณาติดต่อทีมพัฒนา

---

**เวอร์ชัน:** 1.0.0  
**อัพเดทล่าสุด:** October 17, 2025  
**สถานะ:** ✅ พร้อมใช้งาน

---

**🎉 ขอบคุณที่ใช้งาน Flutter Web App!**
