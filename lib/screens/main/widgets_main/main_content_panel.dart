import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_app/screens/daliry_menu_screen.dart';
import 'package:flutter_web_app/screens/report_menu_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_web_app/blocs/main/app_bloc.dart';
import 'package:flutter_web_app/blocs/main/bloc_state.dart';
import 'dashboard_cards_section.dart';
import 'pingrid_section.dart';
import 'placeholder_card_section.dart';

//MainContentPanel
// ใช้สำหรับแสดงเนื้อหาหลักของแอปพลิเคชัน
// ประกอบด้วยส่วนต่าง ๆ ของแดชบอร์ด เช่น การ์ดบนแดชบอร์ด
// การ์ดที่สามารถเลื่อนดูได้ การ์ดที่แสดงในรูปแบบวงกลมและรายการในกริดด้านล่าง
// แต่ละส่วนจะถูกสร้างขึ้นเป็นวิดเจ็ตย่อย
// และใช้ BlocBuilder เพื่อฟังการเปลี่ยนแปลงของสถานะและอัปเดต UI ตามสถานะที่เปลี่ยนแปลง
// สามารถใช้สำหรับการจัดการเนื้อหาหลักของแอปพลิเคชัน
// โดยใช้ BLoC หรือ Provider เพื่อให้สามารถเข้าถึงและปรับปรุง
// ข้อมูลได้อย่างมีประสิทธิภาพ และสามารถใช้ในการแสดงผล UI ได้อย่างเหมาะสม
class MainContentPanel extends StatelessWidget {
  const MainContentPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        return _buildScreenContent(context, state.selectedScreenIndex);
      },
    );
  }

  Widget _buildScreenContent(BuildContext context, int selectedIndex) {
    switch (selectedIndex) {
      case 0: // ข้อมูลหลัก
        return _buildDashboardScreen(context);
      case 1: // ข้อมูลประจำวัน
        return DaliryDataScreen();
      case 2: // รายงาน
        return ReportMenuScreen();
      case 3: // การตั้งค่า
        return _buildSettingsScreen(context);
      case 4: // ผู้ใช้งาน
        return _buildUserScreen(context);
      default:
        return _buildDashboardScreen(context);
    }
  }

  Widget _buildDashboardScreen(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 1200;
        final isMedium = constraints.maxWidth > 800;
        final isSmall = constraints.maxWidth < 600;

        return Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          height: constraints.maxHeight,
          child: Column(
            children: [
              // Header with improved responsive styling
              Container(
                padding: EdgeInsets.all(isSmall ? 12.0 : 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'ยอดขาย',
                          style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                              color: Colors.black87,
                              fontSize: isWide ? 28 : (isMedium ? 24 : 20),
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Date selector with responsive sizing
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isSmall ? 8 : 12,
                        vertical: isSmall ? 4 : 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: isSmall ? 14 : 16,
                            color: Colors.grey[600],
                          ),
                          SizedBox(width: isSmall ? 4 : 8),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'วันนี้',
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: isSmall ? 12 : 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Main content layout - Use Expanded to fill remaining space
              Expanded(
                child: SingleChildScrollView(
                  padding:
                      EdgeInsets.symmetric(horizontal: isSmall ? 12.0 : 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isWide)
                        // Wide screen: side-by-side layout
                        _buildWideLayout(constraints)
                      else if (isMedium)
                        // Medium screen: mixed layout
                        _buildMediumLayout(constraints)
                      else
                        // Small screen: stacked layout
                        _buildSmallLayout(constraints),

                      // Add bottom padding for scroll
                      SizedBox(height: isSmall ? 30 : 50),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWideLayout(BoxConstraints constraints) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left panel: Dashboard + Pin Grid
        Expanded(
          flex: 7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dashboard cards
              const DashboardCardsSection(),
              const SizedBox(height: 32),
              // Pin section header
              _buildSectionHeader('ปักหมุด', 20),
              const SizedBox(height: 16),
              // Pin grid
              const PingridSection(),
            ],
          ),
        ),

        const SizedBox(width: 24),

        // Right panel: Analytics
        Container(
          constraints: BoxConstraints(
            maxWidth: constraints.maxWidth * 0.28,
            minWidth: 280,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            //  _buildSectionHeader('สรุปภาพรวม', 18),
              const SizedBox(height: 16),
              SizedBox(
                height: 700,
                child: const PlaceholderCardSection(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMediumLayout(BoxConstraints constraints) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Dashboard cards
        const DashboardCardsSection(),
        const SizedBox(height: 32),

        // Pin and Analytics side by side
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader('ปักหมุด', 20),
                  const SizedBox(height: 16),
                  const PingridSection(),
                ],
              ),
            ),
            const SizedBox(width: 24),
            Flexible(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: constraints.maxWidth * 0.35,
                  minWidth: 250,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader('สรุปภาพรวม', 18),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 400,
                      child: const PlaceholderCardSection(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSmallLayout(BoxConstraints constraints) {
    final isVerySmall = constraints.maxWidth < 400;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Dashboard cards
        const DashboardCardsSection(),
        SizedBox(height: isVerySmall ? 24 : 32),

        // Pin section
        _buildSectionHeader('ปักหมุด', isVerySmall ? 18 : 20),
        SizedBox(height: isVerySmall ? 12 : 16),
        const PingridSection(),
        SizedBox(height: isVerySmall ? 24 : 32),

        // Analytics section
        _buildSectionHeader('สรุปภาพรวม', isVerySmall ? 16 : 18),
        SizedBox(height: isVerySmall ? 12 : 16),
        SizedBox(
          height: isVerySmall ? 400 : 500,
          child: const PlaceholderCardSection(),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, double fontSize) {
    return Text(
      title,
      style: GoogleFonts.roboto(
        textStyle: TextStyle(
          color: Colors.black87,
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildSettingsScreen(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'การตั้งค่า',
            style: GoogleFonts.roboto(
              textStyle: const TextStyle(
                color: Colors.black,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Expanded(
            child: Center(
              child: Text(
                'หน้าการตั้งค่า - กำลังพัฒนา',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserScreen(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ผู้ใช้งาน',
            style: GoogleFonts.roboto(
              textStyle: const TextStyle(
                color: Colors.black,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Expanded(
            child: Center(
              child: Text(
                'หน้าผู้ใช้งาน - กำลังพัฒนา',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
