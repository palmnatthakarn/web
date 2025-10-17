import 'package:flutter/material.dart';
import 'package:flutter_web_app/screens/purchase/widgets_purchase/purchaseformpage.dart';
import 'package:flutter_web_app/screens/purchase/widgets_purchase/purchasetotalpage.dart';
import 'package:flutter_web_app/screens/purchase/widgets_purchase/purchase_product_list.dart';

class PurchaseRightPanel extends StatelessWidget {
  const PurchaseRightPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // แถบแท็บสไตล์แคปซูล
          Container(
            margin: const EdgeInsets.fromLTRB(10, 10, 10, 8),
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: const Color(0xFFEDEDED),
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: SizedBox(
              height: 30,
              child: TabBar(
                // ให้ indicator เป็นแคปซูลสีขาว
                indicator: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                // ขยับขอบ indicator ไม่ให้ชนขอบ container
                indicatorPadding:
                    const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                // สีตัวอักษร
                labelColor: Colors.black87,
                unselectedLabelColor: Colors.grey[600],
                // ตัดเส้นใต้ TabBar (เวอร์ชันใหม่มี dividerColor)
                dividerColor: Colors.transparent,
                overlayColor: WidgetStateProperty.all(Colors.transparent),
                labelStyle:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                unselectedLabelStyle: const TextStyle(fontSize: 12),
                tabs: const [
                  Tab(text: 'เอกสาร'),
                  Tab(text: 'รายการสินค้า'),
                  Tab(text: 'รวม'),
                ],
              ),
            ),
          ),
          // เนื้อหาแท็บ
          const Expanded(
            child: TabBarView(
              children: [
                Center(child: PurchaseFormPage()),
                PurchaseProductList(),
                Center(child: SummaryAndPaymentSection()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
