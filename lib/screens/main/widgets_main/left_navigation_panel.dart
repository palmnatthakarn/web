import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_app/blocs/main/app_bloc.dart';
import 'package:flutter_web_app/blocs/main/bloc_event.dart';
import 'package:flutter_web_app/blocs/main/bloc_state.dart';

import '../../../models/model.dart';

//LeftNavigationPanel
// ใช้สำหรับแสดงแถบเมนูด้านซ้ายของแอปพลิเคชัน
// ประกอบด้วยรายการเมนูที่สามารถเลือกได้
// แต่ละรายการมีไอคอนและตัวนับจำนวนรายการที่ยังไม่ได้อ่าน
// เมื่อผู้ใช้คลิกที่รายการเมนู จะมีการเปลี่ยนแปลงสถานะของรายการนั้น
// และแสดงผลการเปลี่ยนแปลงใน UI
// โดยใช้ BlocBuilder เพื่อฟังการเปลี่ยนแปลงของสถานะ
// และอัปเดต UI ตามสถานะที่เปลี่ยนแปลง
// สามารถใช้สำหรับการจัดการเมนูด้านซ้ายของแอปพลิเคชัน
// โดยใช้ BLoC หรือ Provider เพื่อให้สามารถเข้าถึงและปรับปรุง
class LeftNavigationPanel extends StatelessWidget {
  const LeftNavigationPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        final bool isExpanded = state.isLeftNavExpanded;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: isExpanded ? 220.0 : 70.0,
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 10.0),
          child: Column(
            crossAxisAlignment: isExpanded
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.center,
            children: [
              // ปุ่ม toggle + เมนู
              Row(
                mainAxisAlignment: isExpanded
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      isExpanded ? Icons.arrow_back_ios : Icons.menu,
                      color: Colors.grey[700],
                    ),
                    onPressed: () {
                      context.read<AppBloc>().add(ToggleLeftNavExpand());
                    },
                  ),
                  if (isExpanded)
                    const Text(
                      'เมนู',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(170, 0, 0, 0),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              ...state.leftNavItems.asMap().entries.map((entry) {
                final int index = entry.key;
                final LeftNavItem item = entry.value;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(100.0),
                    onTap: () {
                      context.read<AppBloc>().add(SelectLeftNavItem(index));
                    },
                    child: Row(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: item.isSelected
                                    ? const Color(0xFFD6E4FF)
                                    : Colors.transparent,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: item.isSelected
                                      ? const Color(0xFF4C7FFF)
                                      : Colors.transparent,
                                  width: 2.0,
                                ),
                              ),
                              child: Icon(
                                item.icon,
                                color: item.isSelected
                                    ? const Color(0xFF4C7FFF)
                                    : Colors.grey[600],
                                size: item.isSelected ? 26 : 24,
                              ),
                            ),
                          ],
                        ),
                        if (isExpanded) ...[
                          const SizedBox(width: 12),
                          Text(
                            item.label,
                            style: TextStyle(
                              fontSize: 14,
                              color: item.isSelected
                                  ? const Color(0xFF4C7FFF)
                                  : Colors.grey[700],
                            ),
                          ),
                        ]
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
