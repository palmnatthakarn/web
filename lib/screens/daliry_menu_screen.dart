import 'package:flutter/material.dart';
import 'package:flutter_web_app/screens/barcode/barcode.dart';
import 'package:flutter_web_app/screens/creditor/creditor_screen.dart';
import 'package:flutter_web_app/screens/debtor/debtor_screen.dart';
//import 'package:flutter_web_app/screens/creditor/creditor_screen.dart';
import 'package:flutter_web_app/screens/purchaseV2/purchaseV2.dart';
import 'package:flutter_web_app/screens/saleV2/sale_screen_V2.dart';
import '../theme/app_theme.dart';
import '../component/all/card_boutton.dart';

/// DaliryDataScreen - หน้าจอข้อมูลรายวัน
/// ใช้สำหรับแสดงข้อมูลรายวันของระบบ
class DaliryDataScreen extends StatelessWidget {
  const DaliryDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.backgroundColor,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // จัดการสินค้า Section (First)
            CardButton.buildSectionTitle('จัดการสินค้า'),
            const SizedBox(height: 16),
            Row(
              children: [
                CardButton.buildCategoryCard(
                  title: 'การซื้อ',
                  color: const Color(0xFF26A69A), // Teal
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const ProductManagementScreen_V2()),
                  ),
                ),
                const SizedBox(width: 16),
                CardButton.buildCategoryCard(
                  title: 'ขายสินค้า',
                  color: const Color(0xFF26A69A), // Teal
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SaleScreenV2()),
                  ),
                ),
                const SizedBox(width: 16),
                CardButton.buildCategoryCard(
                  title: 'เจ้าหนี้',
                  color: const Color(0xFF29B6F6),
                  // onTap: () => debugPrint('เจ้าหนี้ tapped'), // Light Blue
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CreditorScreen()),
                  ),
                ),
                const SizedBox(width: 16),
                CardButton.buildCategoryCard(
                  title: 'ลูกหนี้',
                  color: const Color(0xFF29B6F6), // Light Blue
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DebtorScreen()),
                  ),
                ),
                const SizedBox(width: 16),
                CardButton.buildCategoryCard(
                  title: 'บาร์โค้ด',
                  color: const Color(0xFFFF9800), // Orange
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const BarcodeScreen()),
                  ),
                ),
            
              ],
            ),
          ],
        ),
      ),
    );
  }
}
