import 'package:flutter/material.dart';
import 'package:flutter_web_app/screens/barcode/barcode.dart';
import 'package:google_fonts/google_fonts.dart';

/// MainDataScreen - หน้าจอข้อมูลหลัก
/// ใช้สำหรับแสดงข้อมูลหลักของระบบ
class MainDataScreen extends StatelessWidget {
  const MainDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ข้อมูลหลัก',
            style: GoogleFonts.roboto(
              textStyle: const TextStyle(
                color: Colors.black,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'จัดการข้อมูลหลักของระบบ',
            style: GoogleFonts.roboto(
              textStyle: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
                letterSpacing: 0.2,
              ),
            ),
          ),
          const SizedBox(height: 32),
          Container(
            // color: const Color.fromARGB(255, 238, 72, 72),
            child: Expanded(
              child: GridView.count(
                crossAxisCount: 5,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.5,
                children: [
                  _buildDataCard(
                    title: 'บาร์โค้ด',
                    //subtitle: 'จัดการข้อมูลสินค้าทั้งหมด',
                    icon: Icons.qr_code_2,
                    color: const Color(0xFF4C7FFF),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const BarcodeScreen()),
                    ),
                  ),
                  _buildDataCard(
                    title: 'เจ้าหนี้',
                    //subtitle: 'จัดการข้อมูลลูกค้า',
                    icon: Icons.attach_money,
                    color: const Color(0xFF28A799),
                    onTap: () => debugPrint('ข้อมูลลูกค้า tapped'),
                  ),
                  _buildDataCard(
                    title: 'ลูกหนี้',
                    //subtitle: 'จัดการข้อมูลผู้จำหน่าย',
                    icon: Icons.business,
                    color: const Color(0xFFFD8D04),
                    onTap: () => debugPrint('ข้อมูลผู้จำหน่าย tapped'),
                  ),
                  _buildDataCard(
                    title: 'หมวดหมู่สินค้า',
                    //subtitle: 'จัดการหมวดหมู่สินค้า',
                    icon: Icons.category,
                    color: const Color(0xFF28B7E2),
                    onTap: () => debugPrint('หมวดหมู่สินค้า tapped'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataCard({
    required String title,
    //required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.1),
                color.withOpacity(0.05),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: GoogleFonts.roboto(
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 4),
            ],
          ),
        ),
      ),
    );
  }
}
