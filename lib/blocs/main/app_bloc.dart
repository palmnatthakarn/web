import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_app/blocs/main/bloc_event.dart';
import 'package:flutter_web_app/blocs/main/bloc_state.dart';
import 'package:flutter_web_app/models/model.dart';
import 'package:flutter_material_symbols/flutter_material_symbols.dart';

// BLoC
// ใช้สำหรับจัดการสถานะของแอปพลิเคชัน
// โดยใช้ BLoC (Business Logic Component) เพื่อจัดการเหตุการณ์และสถานะ
// สามารถใช้สำหรับการจัดการสถานะของแอปพลิเคชัน
// เช่น การเลือกเมนูด้านซ้าย การอัปเดตการ์ดบนแดชบอร์ด
// การอัปเดตรายการที่สามารถเลื่อนดูได้ การอัปเดตราย
// การอัปเดตรายการที่แสดงในรูปแบบวงกลม และการอัปเดตรายการในกริดด้านล่าง
// โดยใช้ BLoC หรือ Provider เพื่อให้สามารถเข้าถึงและปรับปรุง
// ข้อมูลได้อย่างมีประสิทธิภาพ และสามารถใช้ในการแสดงผล UI ได้อย่างเหมาะสม

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc()
      : super(AppState(
          selectedScreenIndex: 0, // Default to "การตั้งค่า" which is selected
          leftNavItems: [
            LeftNavItem(
                label: 'ข้อมูลหลัก',
                icon: (MaterialSymbols.inventory_2_outlined),
                count: 5,
                isSelected: true),
            LeftNavItem(
                label: 'ข้อมูลประจำวัน',
                icon: (MaterialSymbols.spatial_tracking),
                count: 2),
            LeftNavItem(
              label: 'รายงาน',
              icon: (MaterialSymbols.bar_chart),
            ),
            LeftNavItem(
              label: 'การตั้งค่า',
              icon: (MaterialSymbols.settings),
            ),
            LeftNavItem(
              label: 'ผู้ใช้งาน',
              icon: (MaterialSymbols.person),
            ),
          ],
          dashboardCards: [
            DashboardCardData(
              title: 'รายได้วันนี้',
              subtitle: 'รายได้ทั้งหมด',
              progress: 0.25,
              icon: Icons.monetization_on,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFFe6f1ff), // ฟ้าอ่อน
                  const Color(0xFFb6fb08), // เขียวเหลือง
                  const Color(0xFFf9f871), // เหลืองอ่อน
                ],
              ),
              backgroundColor: const Color(0xFFe6f1ff),
              foregroundColor: const Color(0xFFb6fb08),
            ),
            /*DashboardCardData(
              title: 'ยอดขายวันนี้',
              subtitle: 'ยอดขายทั้งหมด',
              icon: Icons.favorite,
              gradient: LinearGradient(
                colors: [
                  const Color.fromARGB(255, 230, 241, 255),
                  const Color.fromARGB(255, 182, 251, 8),
                ],
              ),
              backgroundColor: const Color(0xFFFDE7FF),
              foregroundColor: const Color(0xFFF165A9),
            ),*/
          ],
    
          placeholderCard: [
            PlaceholderData(
              width: 300,
              height: 200,
              color: const Color(0xFFEEEEEE),
            ),
          ],
          pinGridItems: [
            PingridData(
              text: 'การซื้อ',
              color: const Color(0xFF000000),
              onPressed: () => debugPrint('การซื้อ pressed'),
            ),
            PingridData(
              text: 'ขายสินค้า',
              color: const Color(0xFF28A799),
              onPressed: () => debugPrint('ขายสินค้า pressed'),
            ),
            PingridData(
              text: 'บาร์โค้ด',
              color: const Color(0xFFFD8D04),
              onPressed: () => debugPrint('บาร์โค้ด pressed'),
            ),
            PingridData(
              text: 'เจ้าหนี้',
              color: const Color(0xFF28B7E2),
              onPressed: () => debugPrint('เจ้าหนี้ pressed'),
            ),
            PingridData(
              //imageUrl:'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg',
              text: 'ลูกหนี้',
              color: const Color(0xFF28B7E2),
              onPressed: () => debugPrint('ลูกหนี้ pressed'),
            ),
            PingridData(
              //imageUrl:'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg',
              text: 'สินค้า',
              color: const Color(0xFFFD8D04),
              onPressed: () => debugPrint('สินค้า pressed'),
            ),
          ],
          circularItems: [],
        )) {
    on<SelectLeftNavItem>((event, emit) {
      final updatedNav = List<LeftNavItem>.from(state.leftNavItems);
      for (int i = 0; i < updatedNav.length; i++) {
        updatedNav[i] = LeftNavItem(
          label: updatedNav[i].label,
          icon: updatedNav[i].icon,
          isSelected: i == event.index,
          count: updatedNav[i].count,
        );
      }
      emit(state.copyWith(
        leftNavItems: updatedNav,
        selectedScreenIndex: event.index,
      ));
    });

    on<ToggleLeftNavExpand>((event, emit) {
      emit(state.copyWith(isLeftNavExpanded: !state.isLeftNavExpanded));
    });
  }
}
