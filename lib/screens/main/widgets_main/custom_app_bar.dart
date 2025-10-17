import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

/// CustomAppBar คือวิดเจ็ต AppBar แบบกำหนดเอง
/// ประกอบด้วยชื่อเรื่อง ไอคอนค้นหา ไอคอนแจ้งเตือน และไอคอนโปรไฟล์ผู้ใช้
/// ชื่อเรื่องถูกตั้งค่าเป็น "ข้อมูลหลัก" (Main Information)
/// AppBar มีพื้นหลังสีน้ำเงินเข้มและตัวอักษรสีขาว
/// กำหนดขนาดที่ต้องการผ่าน PreferredSizeWidget
/// AppBar นี้ถูกใช้งานในวิดเจ็ต MainScreen

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kToolbarHeight,
      decoration: AppTheme.gradientDecoration,
      child: SafeArea(
        top: false, // ไม่ต้องเว้นพื้นที่ด้านบน เพราะไม่ใช่ AppBar แบบเต็มจอ
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: <Widget>[
              /*IconButton(
                  icon: const Icon(Icons.arrow_back,
                      color: Colors.black), // Menu icon
                  onPressed: () {}),*/
              //const SizedBox(width: 8),
              const Text(
                'ข้อมูลหลัก',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
              const Spacer(),
              _buildActionButton(
                icon: Icons.search,
                tooltip: 'ค้นหา',
                onPressed: () {},
              ),
              _buildActionButton(
                icon: Icons.notifications_none_outlined,
                tooltip: 'แจ้งเตือน',
                onPressed: () {},
              ),
              const SizedBox(width: 8),
              Container(
                margin: const EdgeInsets.only(left: 8),
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 22),
        onPressed: onPressed,
        tooltip: tooltip,
        padding: const EdgeInsets.all(12),
      ),
    );
  }
}
