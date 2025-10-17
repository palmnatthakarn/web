import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter_web_app/blocs/purchase/purchase_bloc.dart';
import 'package:flutter_web_app/blocs/purchase/purchase_state.dart';
import 'package:flutter_web_app/component/all/collapsible_panel_widget.dart';
import 'package:flutter_web_app/component/all/custom_collapse_button.dart';
import 'package:flutter_web_app/theme/theme_web.dart';

class PurchaseLeftPanel extends StatelessWidget {
  const PurchaseLeftPanel({super.key});

  Widget _buildPanelContent() {
    return BlocBuilder<PurchaseBloc, PurchaseState>(
      builder: (context, state) {
        // Format date and time from state
        final dateStr = DateFormat('dd/MM/yyyy').format(state.documentDate);
        final weekdayNames = [
          'วันอาทิตย์',
          'วันจันทร์',
          'วันอังคาร',
          'วันพุธ',
          'วันพฤหัสบดี',
          'วันศุกร์',
          'วันเสาร์',
        ];
        final weekday = weekdayNames[state.documentDate.weekday % 7];
        final timeStr = state.documentTime.format(context);
        final docDateTime = 'วันที่ $dateStr ($weekday) $timeStr';
        final debtorCode = state.creditorCode.isEmpty ? '' : state.creditorCode;
        final debtorName = state.creditorName.isEmpty ? '' : state.creditorName;
        final empCode = state.employeeCode.isEmpty ? '' : state.employeeCode;
        final empName = state.employeeName.isEmpty ? '' : state.employeeName;
        final itemCount = state.cartItems.length;

        return Column(
          children: [
            // เนื้อหาหลัก
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // วันที่/เวลา + สาขา
                    Row(
                      children: [
                        Text(
                          docDateTime,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(), // ดันตัวถัดไปไปขวาสุด
                        Text(
                          'สาขา ',
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                        if (state.branch.isNotEmpty)
                          Text(
                            '${state.branch}',
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                      ],
                    ),
                    const SizedBox(height: 5),

                    // ข้อมูลเจ้าหนี้และพนักงาน
                    _twoColText(
                      leftTop: 'รหัสเจ้าหนี้: $debtorCode',
                      rightTop: 'ชื่อเจ้าหนี้: $debtorName',
                      leftBottom: 'รหัสพนักงาน: $empCode',
                      rightBottom: 'ชื่อพนักงาน: $empName',
                    ),

                    const SizedBox(height: 5),

                    // ประเภทภาษี / ประเภทการชำระ
                    _twoColRich(
                      left: TextSpan(
                        text: 'ประเภทภาษี  ',
                        style: const TextStyle(color: Colors.black87),
                        children: [
                          TextSpan(
                            text: _getTaxTypeText(state.taxType),
                            style: TextStyle(
                                color: Colors.black87.withOpacity(0.9),
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      right: TextSpan(
                        text: 'ประเภทการชำระ  ',
                        style: const TextStyle(color: Colors.black87),
                        children: [
                          TextSpan(
                            text: _getPaymentTypeText(state.paymentType),
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),

                    // อัตราภาษี
                    if (state.taxRate.isNotEmpty) ...[
                      Text(
                        'อัตราภาษี: ${state.taxRate}%',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 5),
                    ],
                    _twoColText(
                      leftTop:
                          'เอกสารอ้างอิง: ${state.referenceDoc.isNotEmpty ? state.referenceDoc : ""}',
                      rightTop:
                          'วันที่เอกสารอ้างอิง: ${DateFormat('dd/MM/yyyy').format(state.referenceDate)}',
                      leftBottom:
                          'เลขที่ใบกำกับภาษี: ${state.taxInvoice.isNotEmpty ? state.taxInvoice : ""} ',
                      rightBottom:
                          'วันที่ใบกำกับภาษี: ${DateFormat('dd/MM/yyyy').format(state.taxinvoiceDate)}',
                    ),

                    // เอกสารอ้างอิง
                    /*     Row(
                        children: [
                          const Text(
                            'เอกสารอ้างอิง: ',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                          if (state.referenceDoc.isNotEmpty)
                            Text(
                              state.referenceDoc,
                              style: const TextStyle(fontSize: 14),
                            ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      // เลขที่ใบกำกับภาษี
                      Row(
                        children: [
                          const Text(
                            'เลขที่ใบกำกับภาษี: ',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                          if (state.taxInvoice.isNotEmpty)
                            Text(
                              state.taxInvoice,
                              style: const TextStyle(fontSize: 14),
                            ),
                        ],
                      ),*/
                    const SizedBox(height: 5),
                    // หมายเหตุ
                    if (state.remarks.isNotEmpty) ...[
                      Row(
                        crossAxisAlignment:
                            CrossAxisAlignment.start, // กัน text ยาวแล้วชิดบน
                        children: [
                          const Text(
                            'หมายเหตุ: ',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Expanded(
                            // ป้องกันข้อความยาวเกินบรรทัด
                            child: Text(
                              state.remarks,
                              style: const TextStyle(fontSize: 14),
                              overflow: TextOverflow.visible,
                            ),
                          ),
                        ],
                      ),
                    ],

                    const SizedBox(height: 10),
                    // หัวข้อรายการสินค้า
                    Row(
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'รายการสินค้า',
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                        const Spacer(),
                        Text(
                          ' $itemCount รายการ',
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // ตรวจสอบว่ามีส่วนลดหรือไม่
                    Builder(
                      builder: (context) {
                        final hasDiscount = state.cartItems
                            .any((item) => (item.discount ?? 0.0) > 0);

                        return Column(
                          children: [
                            // หัวตาราง
                            _tableHeader(hasDiscount),

                            // รายการสินค้า
                            ...state.cartItems.asMap().entries.map((entry) {
                              final index = entry.key;
                              final item = entry.value;
                              return _buildProductRow(
                                  index + 1, item, hasDiscount);
                            }),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            // ===== สรุปยอดเงินติดล่างสุด (อยู่นอก Scroll) =====
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              child: _buildTotalSummary(state),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CollapsiblePanelWidget(
      minWidth: 300.0,
      maxWidth: 600.0,
      customCollapseButtonBuilder: (isCollapsed, onTap) {
        return CustomCollapseButton(
          isCollapsed: isCollapsed,
          onTap: onTap,
          gradient: dashboard_gradient_2,
          tooltip: 'รายการสินค้า',
        );
      },
      child: _buildPanelContent(),
    );
  }

  Widget _buildProductRow(int index, CartItem item, bool hasDiscount) {
    final product = item.product;
    final quantity = item.quantity;
    final price = product.price ?? 0.0;
    final discount = item.discount ?? 0.0;
    final isPercentageDiscount = item.isPercentageDiscount ?? false;
    final finalPrice = item.finalPrice;
    final total = finalPrice * quantity;

    // สร้างข้อความแสดงส่วนลด
    String discountText = '-';
    if (discount > 0) {
      if (isPercentageDiscount) {
        discountText = '${discount.toStringAsFixed(1)}%';
      } else {
        discountText = '${discount.toStringAsFixed(2)}฿';
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
              width: 28,
              child: Text('$index', style: const TextStyle(fontSize: 12))),
          Expanded(
            flex: 3,
            child: Text(
              product.name ?? '-',
              style: const TextStyle(fontSize: 12),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '$quantity ${product.unit ?? 'ชิ้น'}',
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '${price.toStringAsFixed(2)}฿',
              style: const TextStyle(fontSize: 12),
            ),
          ),
          if (hasDiscount)
            Expanded(
              flex: 2,
              child: Text(
                discountText,
                style: TextStyle(
                  fontSize: 12,
                  color: discount > 0 ? Colors.red : Colors.grey,
                  fontWeight:
                      discount > 0 ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          Expanded(
            flex: 2,
            child: Text(
              '${total.toStringAsFixed(2)}฿',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  String _getTaxTypeText(int type) {
    switch (type) {
      case 1:
        return 'ราคาไม่รวมภาษี';
      case 2:
        return 'ราคารวมภาษี';
      case 3:
        return 'ภาษีอัตราศูนย์';
      case 4:
        return 'ไม่กระทบภาษี';
      default:
        return 'ไม่ระบุ';
    }
  }

  String _getPaymentTypeText(int type) {
    switch (type) {
      case 1:
        return 'เครดิต';
      case 2:
        return 'เงินสด';
      default:
        return 'ไม่ระบุ';
    }
  }

  // แถว 2 คอลัมน์ธรรมดา
  Widget _twoColText({
    required String leftTop,
    required String rightTop,
    required String leftBottom,
    required String rightBottom,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _lineText(leftTop),
              const SizedBox(height: 5),
              _lineText(leftBottom),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _lineText(rightTop),
              const SizedBox(height: 5),
              _lineText(rightBottom),
            ],
          ),
        ),
      ],
    );
  }

  // แถว 2 คอลัมน์แบบ RichText
  Widget _twoColRich({required TextSpan left, required TextSpan right}) {
    return Row(
      children: [
        Expanded(child: RichText(text: left)),
        const SizedBox(width: 12),
        Expanded(child: RichText(text: right)),
      ],
    );
  }

  Widget _lineText(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 14, color: Colors.black.withOpacity(0.9)),
      overflow: TextOverflow.ellipsis,
    );
  }

  // หัวตาราง
  Widget _tableHeader(bool hasDiscount) {
    const headerStyle = TextStyle(
        fontSize: 14, color: Colors.black87, fontWeight: FontWeight.w600);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          const SizedBox(width: 28, child: Text('#', style: headerStyle)),
          const Expanded(flex: 3, child: Text('สินค้า', style: headerStyle)),
          const Expanded(flex: 2, child: Text('จำนวน', style: headerStyle)),
          const Expanded(flex: 2, child: Text('ราคา', style: headerStyle)),
          if (hasDiscount)
            const Expanded(flex: 2, child: Text('ส่วนลด', style: headerStyle)),
          const Expanded(flex: 2, child: Text('มูลค่า', style: headerStyle)),
        ],
      ),
    );
  }

  // สรุปยอดเงิน
  Widget _buildTotalSummary(PurchaseState state) {
    // คำนวณยอดรวมจากรายการสินค้าจริง
    double subTotal = 0.0;
    double totalDiscount = 0.0;

    for (final item in state.cartItems) {
      final basePrice = (item.product.price ?? 0.0) * item.quantity;
      subTotal += basePrice;
      totalDiscount += item.totalDiscountAmount;
    }

    final netAmount = subTotal - totalDiscount;
    final taxAmount = state.taxAmount;
    final finalTotal = netAmount + taxAmount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 16),
        Text(
          'มูลค่าก่อนส่วนลด: ${subTotal.toStringAsFixed(2)}฿',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        if (totalDiscount > 0) ...[
          const SizedBox(height: 6),
          Text(
            'ส่วนลดรวม: ${totalDiscount.toStringAsFixed(2)}฿',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.red,
            ),
          ),
        ],
        const SizedBox(height: 6),
        Text(
          'มูลค่าสุทธิ: ${netAmount.toStringAsFixed(2)}฿',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        if (taxAmount > 0) ...[
          const SizedBox(height: 6),
          Text(
            'ภาษี:${taxAmount.toStringAsFixed(2)}฿',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
        const SizedBox(height: 6),
        Text(
          'ยอดรวมสุทธิ:${finalTotal.toStringAsFixed(2)}฿',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.green,
          ),
        ),
      ],
    );
  }
}
