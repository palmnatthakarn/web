// ================================================================================
// ⚠️ หมายเหตุ: ไฟล์นี้เป็นตัวอย่าง Reference เท่านั้น ไม่ได้ออกแบบให้ compile ได้
// สำหรับตัวอย่างที่ใช้งานได้จริง กรุณาดูที่เอกสาร:
// - lib/QUICK_REFERENCE.md
// - lib/ARCHITECTURE.md
// - lib/COMPONENTS_LIST.md
// ================================================================================

/*

===============================================================================
ตัวอย่างการใช้งาน BLoC และ Components
Example usage of BLoC and Components
===============================================================================

## วิธี Import แบบใหม่ (Barrel Files)

✅ แนะนำ:
```dart
import 'package:flutter_web_app/blocs/blocs.dart';
import 'package:flutter_web_app/component/components.dart';
import 'package:flutter_web_app/widgets/widgets.dart';
import 'package:flutter_web_app/screens/main/widgets_main/widgets_main.dart';
```

❌ อย่าทำแบบนี้อีกต่อไป:
```dart
import 'package:flutter_web_app/blocs/main/app_bloc.dart';
import 'package:flutter_web_app/blocs/main/bloc_event.dart';
import 'package:flutter_web_app/blocs/main/bloc_state.dart';
import 'package:flutter_web_app/blocs/creditor/creditor_bloc.dart';
// ...และอื่นๆ อีกหลายบรรทัด
```

===============================================================================
ตัวอย่างที่ 1: การใช้งาน AppBloc
===============================================================================

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_app/blocs/blocs.dart';

class ExampleAppBlocUsage extends StatelessWidget {
  const ExampleAppBlocUsage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        return Column(
          children: [
            // แสดงข้อมูลจาก state
            Text('Selected Screen: \${state.selectedScreenIndex}'),
            
            // Dispatch event เมื่อกดปุ่ม
            ElevatedButton(
              onPressed: () {
                context.read<AppBloc>().add(
                  LeftNavItemPressed(index: 1),
                );
              },
              child: const Text('Go to Daily Data'),
            ),
          ],
        );
      },
    );
  }
}
```

===============================================================================
ตัวอย่างที่ 2: การใช้งาน CreditorBloc พร้อม Form
===============================================================================

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_app/blocs/blocs.dart';
import 'package:flutter_web_app/component/components.dart';

class ExampleCreditorForm extends StatefulWidget {
  const ExampleCreditorForm({super.key});

  @override
  State<ExampleCreditorForm> createState() => _ExampleCreditorFormState();
}

class _ExampleCreditorFormState extends State<ExampleCreditorForm> {
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreditorBloc, CreditorState>(
      listener: (context, state) {
        if (state.status == CreditorStatus.loaded) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('บันทึกสำเร็จ!')),
          );
        }
      },
      child: Column(
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'ชื่อเจ้าหนี้'),
          ),
          ElevatedButton(
            onPressed: () {
              // บันทึกข้อมูล
            },
            child: const Text('บันทึก'),
          ),
        ],
      ),
    );
  }
}
```

===============================================================================
ตัวอย่างที่ 3: การใช้งาน Components พื้นฐาน
===============================================================================

```dart
import 'package:flutter/material.dart';

class ExampleBasicComponents extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // TextField พื้นฐาน
        TextField(
          decoration: InputDecoration(
            labelText: 'ชื่อ',
            border: OutlineInputBorder(),
          ),
        ),
        
        SizedBox(height: 16),
        
        // Date Picker
        ElevatedButton(
          onPressed: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
          },
          child: Text('เลือกวันที่'),
        ),
      ],
    );
  }
}
```

===============================================================================
ตัวอย่างที่ 4: การใช้งาน Main Screen Widgets
===============================================================================

```dart
import 'package:flutter/material.dart';
import 'package:flutter_web_app/screens/main/widgets_main/widgets_main.dart';

class ExampleDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Left Navigation
          LeftNavigationPanel(),
          
          // Main Content
          Expanded(
            child: Column(
              children: [
                CustomAppBar(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        DashboardCardsSection(),
                        SizedBox(height: 24),
                        PingridSection(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

===============================================================================
ตัวอย่างที่ 5: การใช้งาน BlocConsumer (Builder + Listener)
===============================================================================

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_app/blocs/blocs.dart';

class ExampleBlocConsumer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreditorBloc, CreditorState>(
      // Listener: สำหรับ side effects
      listener: (context, state) {
        if (state.status == CreditorStatus.loaded) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('สำเร็จ!')),
          );
        } else if (state.status == CreditorStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('เกิดข้อผิดพลาด')),
          );
        }
      },
      // Builder: สำหรับ build UI
      builder: (context, state) {
        if (state.status == CreditorStatus.loading) {
          return Center(child: CircularProgressIndicator());
        }
        
        return ListView.builder(
          itemCount: state.items.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(state.items[index].name),
            );
          },
        );
      },
    );
  }
}
```

===============================================================================
สรุป Best Practices
===============================================================================

✅ ทำ:
1. ใช้ Barrel files (blocs.dart, components.dart)
2. ใช้ BlocBuilder สำหรับ UI
3. ใช้ BlocListener สำหรับ side effects
4. ใช้ BlocConsumer เมื่อต้องการทั้งสอง
5. Dispose controllers เสมอ

❌ อย่าทำ:
1. Import แต่ละไฟล์ทีละตัว
2. ใช้ setState ใน BLoC pattern
3. ทำ business logic ใน Widget
4. ลืม dispose controllers
5. สร้าง Bloc ใหม่ทุกครั้งที่ build

===============================================================================
เอกสารเพิ่มเติม
===============================================================================

- QUICK_REFERENCE.md - คู่มืออ้างอิงด่วน
- ARCHITECTURE.md - สถาปัตยกรรมฉบับเต็ม
- COMPONENTS_LIST.md - รายการ Components ทั้งหมด
- MIGRATION_GUIDE.md - คู่มืออัพเกรดโค้ด

===============================================================================

*/

// This file serves as a reference guide only.
// For working examples, please refer to the documentation files listed above.
