import 'package:flutter/material.dart';
import 'package:flutter_web_app/screens/report_screen/report_screen.dart';
import 'package:flutter_web_app/screens/saleV2/sale_screen_V2.dart';
import '../theme/app_theme.dart';
import '../component/all/card_boutton.dart';

/// DaliryDataScreen - หน้าจอข้อมูลรายวัน
/// ใช้สำหรับแสดงข้อมูลรายวันของระบบ
class ReportMenuScreen extends StatelessWidget {
  const ReportMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.backgroundColor,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           
            // จัดการสินค้า Section (Second)
           /* CardButton.buildSectionTitle('รายงานสินค้าคงเหลือ'),
            const SizedBox(height: 16),
            Row(
              children: [
                CardButton.buildCategoryCard(
                  title: 'การซื้อ',
                  color: const Color(0xFF26A69A), // Teal
                  onTap: () => debugPrint('การซื้อ tapped'),
                ),
                const SizedBox(width: 16),
                CardButton.buildCategoryCard(
                  title: 'ขายสินค้า',
                  color: const Color(0xFF26A69A), // Teal
                  onTap: () => debugPrint('ขายสินค้า tapped'),
                ),
                const SizedBox(width: 16),
                CardButton.buildCategoryCard(
                  title: 'เจ้าหนี้',
                  color: const Color(0xFF29B6F6), // Light Blue
                  onTap: () => debugPrint('เจ้าหนี้ tapped'),
                ),
                const SizedBox(width: 16),
                CardButton.buildCategoryCard(
                  title: 'ลูกหนี้',
                  color: const Color(0xFF29B6F6), // Light Blue
                  onTap: () => debugPrint('ลูกหนี้ tapped'),
                ),
              ],
            ),
            const SizedBox(height: 32),*/

            // ระบบขาย Section
            CardButton.buildSectionTitle('ระบบขาย'),
            const SizedBox(height: 16),
            Row(
              children: [
                CardButton.buildCategoryCard(
                  title: 'ขายสินค้า',
                 color: const Color(0xFF26A69A), // Green
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SaleScreenV2()),
                  ),
                ),
                const SizedBox(width: 16),
              ],
            ),
            const SizedBox(height: 32),
            
            // จัดการสินค้า Section (Third)
            CardButton.buildSectionTitle('รายงานอื่น ๆ'),
            const SizedBox(height: 16),
            Row(
              children: [
                CardButton.buildCategoryCard(
                  title: 'รายงานยอดขาย',
                  color: const Color(0xFFFF9800), // Orange
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ReportScreen()),
                  ),
                ),
                const SizedBox(width: 16),

              ],
            ),
          ],
        ),
      ),
    );
  }
}
