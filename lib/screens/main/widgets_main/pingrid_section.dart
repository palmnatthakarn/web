import 'package:flutter/material.dart';
import 'package:flutter_web_app/screens/barcode/barcode.dart';
import 'package:flutter_web_app/screens/creditor/creditor_screen.dart';
import 'package:flutter_web_app/screens/debtor/debtor_screen.dart';
import 'package:flutter_web_app/screens/purchaseV2/purchaseV2.dart';
import 'package:flutter_web_app/screens/report_screen/report_screen.dart';
import 'package:flutter_web_app/screens/saleV2/sale_screen_V2.dart';
import '../../../component/all/card_boutton.dart';

/// PingridSection - Improved UX with better responsive design
class PingridSection extends StatelessWidget {
  const PingridSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Wrap(
          spacing: 16,
          runSpacing: 16,
          alignment: WrapAlignment.start, // จัดชิดซ้าย
          children: [
            CardButton.buildCategoryCard(
              title: 'การซื้อ',
              color: const Color(0xFF26A69A),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ProductManagementScreen_V2()),
              ),
            ),
            CardButton.buildCategoryCard(
              title: 'ขายสินค้า',
              color: const Color(0xFF26A69A),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SaleScreenV2()),
              ),
            ),
          
            CardButton.buildCategoryCard(
              title: 'บาร์โค้ด',
              color: const Color(0xFFFF9800),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BarcodeScreen()),
              ),
            ),
            CardButton.buildCategoryCard(
              title: 'รายงานยอดขาย',
              color: const Color(0xFFFF9800), // Orange
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ReportScreen()),
              ),
            ),
            CardButton.buildCategoryCard(
              title: 'เจ้าหนี้',
              color: const Color(0xFF29B6F6),
              // onTap: () => debugPrint('เจ้าหนี้ tapped'), // Light Blue
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CreditorScreen()),
              ),
            ),
            CardButton.buildCategoryCard(
              title: 'ลูกหนี้',
              color: const Color(0xFF29B6F6), // Light Blue
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DebtorScreen()),
              ),
            ),
           
            CardButton.buildCategoryCard(
              title: 'ตั้งค่า',
              color: const Color(0xFF29B6F6),
              onTap: () => debugPrint('ตั้งค่า tapped'),
            ),
            CardButton.buildCategoryCard(
              title: 'พนักงาน',
              color: const Color(0xFF29B6F6),
              onTap: () => debugPrint('พนักงาน tapped'),
            ),
            CardButton.buildCategoryCard(
              title: 'สำรองข้อมูล',
              color: const Color(0xFF9C27B0),
              onTap: () => debugPrint('สำรองข้อมูล tapped'),
            ),
            CardButton.buildCategoryCard(
              title: 'ช่วยเหลือ',
              color: const Color(0xFF607D8B),
              onTap: () => debugPrint('ช่วยเหลือ tapped'),
            ),
          ],
        ),
      ),
    );
  }
}
