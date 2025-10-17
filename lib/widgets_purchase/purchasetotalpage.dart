import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_app/blocs/purchase/purchase_bloc.dart';
import 'package:flutter_web_app/blocs/purchase/purchase_event.dart';
import 'package:flutter_web_app/blocs/purchase/purchase_state.dart';

import '../component/all/buildSection.dart';
import '../component/all/tf.dart';


class SummaryAndPaymentSection extends StatefulWidget {
  const SummaryAndPaymentSection({super.key});

  @override
  State<SummaryAndPaymentSection> createState() =>
      _SummaryAndPaymentSectionState();
}

class _SummaryAndPaymentSectionState extends State<SummaryAndPaymentSection> {
  // Controllers for calculation fields
  final ctrlSumValue = TextEditingController();
  final ctrlBeforeVat = TextEditingController();
  final ctrlVatBase = TextEditingController();
  final ctrlDiscountItem = TextEditingController();
  final ctrlDiscountBill = TextEditingController();
  final ctrlBeforeVatAfterDiscount = TextEditingController();
  final ctrlVatExtra = TextEditingController(); // ภาษีมูลค่าเพิ่ม
  final ctrlCloseAmount = TextEditingController();
  final ctrlGrandTotalField =
      TextEditingController(text: "0.00"); // ยอดรวมสุทธิ
  final ctrlNetTotal =
      TextEditingController(); // ยอดรวมทั้งสิ้น (ก่อนปัด/ปิดยอด)

  // Controllers for additional discount fields
  final ctrlBeforePaymentDiscount =
      TextEditingController(); // ส่วนลดก่อนชำระเงิน
  final ctrlTaxableDiscount = TextEditingController(); // ส่วนลดสินค้ามีภาษี
  final ctrlNonTaxableDiscount =
      TextEditingController(); // ส่วนลดสินค้ายกเว้นภาษี
  final ctrlRounding = TextEditingController(); // ปัดเศษ

  // New controllers for detailed calculation
  final ctrlBeforeDiscountAmount = TextEditingController(); // ยอดก่อนส่วนลด
  final ctrlDiscountAmount = TextEditingController(); // ยอดส่วนลด
  final ctrlAfterDiscountAmount = TextEditingController(); // ยอดหลังหักส่วนลด
  final ctrlTaxableItemDiscount =
      TextEditingController(); // ส่วนลดสินค้าที่มีภาษี
  final ctrlNonTaxableItemDiscount =
      TextEditingController(); // ส่วนลดสินค้าที่ไม่มีภาษี
  final ctrlNetAfterDiscount = TextEditingController(); // ยอดสุทธิหลังหักส่วนลด

  // Payment fields
  PaymentType _paymentType = PaymentType.cash;
  bool _saveMyChange = false;
  bool _autoPrint = false;
  final ctrlReceive = TextEditingController(); // รับเงินทอน/รับเงินสด
  final ctrlSelectBank = TextEditingController();
  double _changeAmount = 0.0;

  // Prevent infinite loop
  bool _isUpdatingFromBloc = false;

  double calculateSubTotal(List<CartItem> cartItems) {
    return cartItems.fold(0.0,
        (sum, item) => sum + ((item.product.price ?? 0.0) * item.quantity));
  }

  double calculateTax(double subTotal, String taxRateStr) {
    final taxRate = double.tryParse(taxRateStr) ?? 0.0;
    return subTotal * (taxRate / 100);
  }

  double calculateTotalDiscount(List<CartItem> cartItems) {
    return cartItems.fold(0.0, (sum, item) => sum + item.totalDiscountAmount);
  }

  String formatCurrency(double amount) {
    return amount.toStringAsFixed(2);
  }

  @override
  void initState() {
    super.initState();
    _addListeners();

    // Initialize values from bloc state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final state = context.read<PurchaseBloc>().state;
        _updateControllersFromState(state);
      }
    });
  }

  void _updateControllersFromState(PurchaseState state) {
    if (_isUpdatingFromBloc) return;
    _isUpdatingFromBloc = true;

    // Update basic totals
    if (ctrlSumValue.text != state.subTotal.toStringAsFixed(2)) {
      ctrlSumValue.text = state.subTotal.toStringAsFixed(2);
    }

    // Update discount fields
    if (ctrlBeforePaymentDiscount.text !=
        state.beforePaymentDiscount.toStringAsFixed(2)) {
      ctrlBeforePaymentDiscount.text =
          state.beforePaymentDiscount.toStringAsFixed(2);
    }
    if (ctrlTaxableDiscount.text != state.taxableDiscount.toStringAsFixed(2)) {
      ctrlTaxableDiscount.text = state.taxableDiscount.toStringAsFixed(2);
    }
    if (ctrlNonTaxableDiscount.text !=
        state.nonTaxableDiscount.toStringAsFixed(2)) {
      ctrlNonTaxableDiscount.text = state.nonTaxableDiscount.toStringAsFixed(2);
    }
    if (ctrlRounding.text != state.roundingAmount.toStringAsFixed(2)) {
      ctrlRounding.text = state.roundingAmount.toStringAsFixed(2);
    }

    // Update calculated values
    if (state.netTaxAmount >= 0 &&
        ctrlVatExtra.text != state.netTaxAmount.toStringAsFixed(2)) {
      ctrlVatExtra.text = state.netTaxAmount.toStringAsFixed(2);
    }
    if (state.grandTotal >= 0 &&
        ctrlGrandTotalField.text != state.grandTotal.toStringAsFixed(2)) {
      ctrlGrandTotalField.text = state.grandTotal.toStringAsFixed(2);
    }
    if (state.receivedAmount >= 0 &&
        ctrlReceive.text != state.receivedAmount.toStringAsFixed(2)) {
      ctrlReceive.text = state.receivedAmount.toStringAsFixed(2);
    }
    if (_changeAmount != state.changeAmount) {
      _changeAmount = state.changeAmount;
    }

    _isUpdatingFromBloc = false;
  }

  @override
  void dispose() {
    // Dispose all controllers
    ctrlSumValue.dispose();
    ctrlBeforeVat.dispose();
    ctrlVatBase.dispose();
    ctrlDiscountItem.dispose();
    ctrlDiscountBill.dispose();
    ctrlBeforeVatAfterDiscount.dispose();
    ctrlVatExtra.dispose();
    ctrlCloseAmount.dispose();
    ctrlGrandTotalField.dispose();
    ctrlReceive.dispose();
    ctrlSelectBank.dispose();
    ctrlBeforePaymentDiscount.dispose();
    ctrlTaxableDiscount.dispose();
    ctrlNonTaxableDiscount.dispose();
    ctrlRounding.dispose();
    ctrlNetTotal.dispose();
    ctrlBeforeDiscountAmount.dispose();
    ctrlDiscountAmount.dispose();
    ctrlAfterDiscountAmount.dispose();
    ctrlTaxableItemDiscount.dispose();
    ctrlNonTaxableItemDiscount.dispose();
    ctrlNetAfterDiscount.dispose();

    super.dispose();
  }

  void _addListeners() {
    ctrlCloseAmount.addListener(_calculate);
    ctrlBeforePaymentDiscount.addListener(_calculate);
    ctrlTaxableDiscount.addListener(_calculate);
    ctrlNonTaxableDiscount.addListener(_calculate);
    ctrlRounding.addListener(_calculate);
    ctrlReceive.addListener(_calculateChange);
  }

  void _calculate() {
    if (_isUpdatingFromBloc) return;

    final blocState = context.read<PurchaseBloc>().state;

    // 1) รวมมูลค่ารวม VAT (Gross) อ่านจากกล่องหรือ state ที่ sync ไว้แล้ว
    final gross = double.tryParse(ctrlSumValue.text) ?? 0.0;

    // 2) ส่วนลดระดับ "สินค้า" แยกตามหมวดภาษี
    final discTaxable = double.tryParse(ctrlTaxableDiscount.text) ?? 0.0;
    final discNonTaxable = double.tryParse(ctrlNonTaxableDiscount.text) ?? 0.0;

    // 3) ยอดรวมหลังหักส่วนลดสินค้า (ยังเป็นยอดที่รวม VAT อยู่)
    final double afterItemDiscount = (gross - discTaxable - discNonTaxable)
        .clamp(0.0, double.infinity)
        .toDouble();

    // 4) สกัดการภาษี/ภาษี (โหมด รวม VAT)
    final rate = (double.tryParse(blocState.taxRate) ?? 0.0) / 100.0;
    final hasVat = rate > 0.0;

    final double beforeVat =
        hasVat ? (afterItemDiscount / (1 + rate)) : afterItemDiscount;
    final double vatAmount = hasVat ? (afterItemDiscount - beforeVat) : 0.0;

    // 5) ส่วนลดก่อนชำระเงิน (ท้ายบิล) + ปิดยอด/ปัดเศษ
    final discBeforePay =
        double.tryParse(ctrlBeforePaymentDiscount.text) ?? 0.0;
    final rounding = double.tryParse(ctrlRounding.text) ?? 0.0;
    final closeAmount = double.tryParse(ctrlCloseAmount.text) ?? 0.0;

    // ยอดสุทธิก่อนปัด/ปิดยอด (ยังรวม VAT อยู่แล้ว)
    final double netAfterPrepay = (afterItemDiscount - discBeforePay)
        .clamp(0.0, double.infinity)
        .toDouble();

    // 6) รวมสุดท้าย
    final double grandTotal = netAfterPrepay + rounding + closeAmount;

    // --- อัปเดตช่องแสดงผล ---
    _isUpdatingFromBloc = true;
    ctrlBeforeVat.text = beforeVat.toStringAsFixed(2);
    ctrlVatBase.text = beforeVat.toStringAsFixed(2);
    ctrlVatExtra.text = vatAmount.toStringAsFixed(2);
    // แสดงมูลค่าสุทธิ (netAfterPrepay) = ยอดหลังหักส่วนลดสินค้าและส่วนลดก่อนชำระ
    ctrlBeforeVatAfterDiscount.text = netAfterPrepay.toStringAsFixed(2);
    ctrlNetTotal.text = netAfterPrepay.toStringAsFixed(2);
    ctrlGrandTotalField.text = grandTotal.toStringAsFixed(2);

    // Update additional calculation fields
    ctrlBeforeDiscountAmount.text = gross.toStringAsFixed(2);
    ctrlDiscountAmount.text = (discTaxable + discNonTaxable).toStringAsFixed(2);
    ctrlAfterDiscountAmount.text = afterItemDiscount.toStringAsFixed(2);
    ctrlTaxableItemDiscount.text = discTaxable.toStringAsFixed(2);
    ctrlNonTaxableItemDiscount.text = discNonTaxable.toStringAsFixed(2);
    ctrlNetAfterDiscount.text = netAfterPrepay.toStringAsFixed(2);

    _isUpdatingFromBloc = false;

    // --- แจ้ง Bloc ---
    context.read<PurchaseBloc>().add(
          PurchaseCalculationDetailsUpdated(
            beforePaymentDiscount: discBeforePay,
            taxableDiscount: discTaxable,
            nonTaxableDiscount: discNonTaxable,
            taxableAmount: beforeVat,
            nonTaxableAmount: 0.0,
            taxAmount: vatAmount,
            roundingAmount: rounding,
          ),
        );

    setState(() {});
    _calculateChange();
  }

  void _calculateChange() {
    if (_isUpdatingFromBloc) return;

    final receive = double.tryParse(ctrlReceive.text) ?? 0.0;
    final grandTotal = double.tryParse(ctrlGrandTotalField.text) ?? 0.0;
    final changeAmount = receive - grandTotal;

    setState(() {
      _changeAmount = changeAmount;
    });

    context.read<PurchaseBloc>().add(
          PurchasePaymentUpdated(
            receivedAmount: receive,
            changeAmount: changeAmount,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final bg = const Color.fromARGB(255, 255, 255, 255);

    return BlocListener<PurchaseBloc, PurchaseState>(
      listener: (context, state) {
        _updateControllersFromState(state);
      },
      child: Scaffold(
        backgroundColor: bg,
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1500),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: Column(
                children: [
                  // ------- รายละเอียดการคำนวณ (รวม VAT) -------
                  SectionBuilder.buildSection(
                    title: 'รายละเอียดการคำนวณ (รวม VAT)',
                    icon: Icons.calculate_outlined,
                    child: Column(
                      children: [
                        // Basic totals
                        _twoColGrid(children: [
                          _roTf('รวมมูลค่า', ctrlSumValue),
                          _roTf('ส่วนลดสินค้า', ctrlDiscountAmount),
                        ]),
                        const SizedBox(height: 12),

                        // Detailed discount fields
                        _twoColGrid(children: [
                          TextFieldBuilder.simpleTf(
                               labelText:  'ส่วนลดสินค้ามีภาษี',  controller:ctrlTaxableDiscount,
                              fillColor: const Color(0xFFE7F3FF)),
                          TextFieldBuilder.simpleTf(
                               labelText:  'ส่วนลดสินค้ายกเว้นภาษี',  controller:ctrlNonTaxableDiscount,
                              fillColor: const Color(0xFFE7F3FF)),
                        ]),
                        const SizedBox(height: 12),

                        // After discount amounts
                        _twoColGrid(children: [
                          _roTf('ยอดก่อนภาษี', ctrlBeforeVat),
                          _roTf('มูลค่าสุทธิ (หลังหักส่วนลด)',
                              ctrlBeforeVatAfterDiscount),
                        ]),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ------- ภาษีมูลค่าเพิ่ม -------
                  SectionBuilder.buildSection(
                    title: 'ภาษีมูลค่าเพิ่ม',
                    icon: Icons.percent,
                    child: _twoColGrid(children: [
                      _roTf('ยอดก่อนภาษี (ฐานภาษี)', ctrlVatBase),
                      _roTf('ภาษีมูลค่าเพิ่ม', ctrlVatExtra),
                    ]),
                  ),
                  const SizedBox(height: 16),

                  // ------- ส่วนลดท้ายบิล / การชำระ -------
                  SectionBuilder.buildSection(
                    title: 'ส่วนลดท้ายบิล / การชำระ',
                    icon: Icons.discount_outlined,
                    child: Column(
                      children: [
                        _twoColGrid(children: [
                          TextFieldBuilder.simpleTf(
                               labelText:  'ส่วนลดก่อนชำระเงิน', controller: ctrlBeforePaymentDiscount,
                              fillColor: const Color(0xFFFFF3CD)),
                          TextFieldBuilder.simpleTf(  labelText: 'ปัดเศษ', controller: ctrlRounding,
                              fillColor: const Color(0xFFF0F9FF)),
                        ]),
                        const SizedBox(height: 12),
                        _twoColGrid(children: [
                          TextFieldBuilder.simpleTf(  labelText: 'ปิดยอด',  controller:ctrlCloseAmount),
                          _roTf('—', TextEditingController(text: '')),
                        ]),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ------- ยอดรวมสุดท้าย -------
                  SectionBuilder.buildSection(
                    title: 'ยอดรวมสุดท้าย',
                    icon: Icons.receipt_long_outlined,
                    child: Column(
                      children: [
                        _twoColGrid(children: [
                          _roTf(
                              'ยอดรวมทั้งสิ้น', ctrlNetTotal), // ก่อนปัด/ปิดยอด
                          _roTf('รวมเงินทั้งสิ้น',
                              ctrlGrandTotalField), // หลังปัด/ปิดยอด
                        ]),
                        const SizedBox(height: 12),
                        _disabledBar(
                          label: 'ยอดรวมสุทธิ',
                          controller: ctrlGrandTotalField,
                        ),
                        const SizedBox(height: 12),
                        _finalTotalBox(
                            amountText: ctrlGrandTotalField.text, unit: 'บาท'),
                      ],
                    ),
                  ),

                  // ------- วิธีชำระเงิน -------
                  SectionBuilder.buildSection(
                    title: 'วิธีชำระเงิน',
                    icon: Icons.payment_outlined,
                    child: Column(
                      children: [
                        _twoColGrid(children: [
                          TextFieldBuilder.simpleTf(
                              labelText: 'รับเงิน/เงินโอน',
                            controller: ctrlReceive,
                            fillColor: const Color(0xFFFFF9DB),
                          ),
                          _buildPaymentTypeSelector(),
                        ]),
                        if (_changeAmount != 0) ...[
                          const SizedBox(height: 16),
                          _buildChangeCard(),
                        ],
                        const SizedBox(height: 16),
                        _buildPaymentOptions(),
                        const SizedBox(height: 16),
                        _buildActionButtons(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ------- สรุปยอดจาก Bloc -------
                  BlocBuilder<PurchaseBloc, PurchaseState>(
                    builder: (context, state) {
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('สรุปยอดจาก Bloc',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              const Divider(),
                              _buildSummaryRow('ยอดรวมสินค้า', state.subTotal),
                              if (state.discount > 0)
                                _buildSummaryRow('ส่วนลดรายการ', state.discount,
                                    isDiscount: true),
                              if (state.beforePaymentDiscount > 0)
                                _buildSummaryRow('ส่วนลดก่อนชำระ',
                                    state.beforePaymentDiscount,
                                    isDiscount: true),
                              if (state.taxableDiscount > 0)
                                _buildSummaryRow(
                                    'ส่วนลดสินค้ามีภาษี', state.taxableDiscount,
                                    isDiscount: true),
                              if (state.nonTaxableDiscount > 0)
                                _buildSummaryRow('ส่วนลดสินค้ายกเว้นภาษี',
                                    state.nonTaxableDiscount,
                                    isDiscount: true),
                              _buildSummaryRow(
                                  'ภาษีมูลค่าเพิ่ม', state.netTaxAmount),
                              if (state.roundingAmount != 0)
                                _buildSummaryRow(
                                    'ปัดเศษ', state.roundingAmount),
                              const Divider(),
                              _buildSummaryRow('ยอดรวมสุทธิ', state.grandTotal,
                                  isBold: true),
                              if (state.receivedAmount > 0) ...[
                                const SizedBox(height: 8),
                                _buildSummaryRow(
                                    'รับเงิน', state.receivedAmount),
                                _buildSummaryRow('เงินทอน', state.changeAmount,
                                    isDiscount: state.changeAmount < 0),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, double amount,
      {bool isDiscount = false, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: isBold ? 16 : 14,
            ),
          ),
          Text(
            '${isDiscount && amount > 0 ? '-' : ''}${formatCurrency(amount.abs())} บาท',
            style: TextStyle(
              color: isDiscount
                  ? Colors.red
                  : (isBold ? Colors.green[700] : Colors.black),
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: isBold ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }

  // ===================================================================
  // ==================== UI Helper Methods =========================
  // ===================================================================

  Widget _twoColGrid({required List<Widget> children}) {
    return LayoutBuilder(
      builder: (context, c) {
        final isWide = c.maxWidth >= 500;
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: children
              .map(
                (child) => SizedBox(
                  width: isWide ? (c.maxWidth - 12) / 2 : c.maxWidth,
                  child: child,
                ),
              )
              .toList(),
        );
      },
    );
  }

  Widget _roTf(String label, TextEditingController c) {
    return AbsorbPointer(
      child: TextFieldBuilder.simpleTf(
          labelText: label,
        controller: c,
        fillColor: const Color(0xFFF3F4F6),
      ),
    );
  }

  Widget _disabledBar(
      {required String label, required TextEditingController controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Text(controller.text, style: const TextStyle(fontSize: 16)),
        ),
      ],
    );
  }

  Widget _finalTotalBox({required String amountText, required String unit}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF10B981),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('ยอดรวมสุดท้าย',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('$amountText $unit',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('วิธีชำระ',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: PaymentType.values.map((type) {
              final isSelected = _paymentType == type;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _paymentType = type),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          type.icon,
                          size: 18,
                          color: isSelected ? Colors.blue : Colors.grey[600],
                        ),
                        const SizedBox(width: 6),
                        Text(
                          type.displayName,
                          style: TextStyle(
                            color: isSelected ? Colors.black : Colors.grey[600],
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildChangeCard() {
    final isPositive = _changeAmount >= 0;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isPositive ? Colors.blue[50] : Colors.red[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isPositive ? Colors.blue[200]! : Colors.red[200]!,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isPositive ? Icons.keyboard_return : Icons.warning_outlined,
            color: isPositive ? Colors.blue : Colors.red,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              isPositive ? 'เงินทอน' : 'เงินไม่พอ',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isPositive ? Colors.blue[800] : Colors.red[800],
              ),
            ),
          ),
          Text(
            '${_changeAmount.abs().toStringAsFixed(2)} บาท',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isPositive ? Colors.blue[800] : Colors.red[800],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOptions() {
    return Wrap(
      spacing: 20,
      runSpacing: 12,
      children: [
        _buildCheckboxTile(
          'บันทึกยอดเงินทอน',
          _saveMyChange,
          Icons.save_outlined,
          (value) => setState(() => _saveMyChange = value ?? false),
        ),
        _buildCheckboxTile(
          'พิมพ์ใบเสร็จอัตโนมัติ',
          _autoPrint,
          Icons.print_outlined,
          (value) => setState(() => _autoPrint = value ?? false),
        ),
      ],
    );
  }

  Widget _buildCheckboxTile(
      String label, bool value, IconData icon, ValueChanged<bool?> onChanged) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        Icon(icon, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(label),
      ],
    );
  }

  Widget _buildActionButtons() {
    final grandTotal = double.tryParse(ctrlGrandTotalField.text) ?? 0.0;

    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: grandTotal > 0 ? _handleSave : null,
            icon: const Icon(Icons.save_outlined),
            label: const Text('บันทึก'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3B82F6),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: grandTotal > 0 ? _handlePrint : null,
            icon: const Icon(Icons.print_outlined),
            label: const Text('พิมพ์ใบเสร็จ'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              side: const BorderSide(color: Colors.blue),
            ),
          ),
        ),
      ],
    );
  }

  void _handleSave() {
    // Implement save logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('บันทึกข้อมูลเรียบร้อยแล้ว'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _handlePrint() {
    // Implement print logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('กำลังพิมพ์ใบเสร็จ...'),
        backgroundColor: Colors.blue,
      ),
    );
  }
}

// Payment Type Enum
enum PaymentType {
  cash(Icons.money, 'เงินสด'),
  transfer(Icons.account_balance, 'โอน');

  const PaymentType(this.icon, this.displayName);
  final IconData icon;
  final String displayName;
}

// Purchase Total Page
class PurchaseTotalPage extends StatelessWidget {
  const PurchaseTotalPage({super.key});

  double calculateSubTotal(List<CartItem> cartItems) {
    return cartItems.fold(0.0,
        (sum, item) => sum + ((item.product.price ?? 0.0) * item.quantity));
  }

  double calculateTax(double subTotal, String taxRateStr) {
    final taxRate = double.tryParse(taxRateStr) ?? 0.0;
    return subTotal * (taxRate / 100);
  }

  double calculateTotalDiscount(List<CartItem> cartItems) {
    return cartItems.fold(0.0, (sum, item) => sum + item.totalDiscountAmount);
  }

  String formatCurrency(double amount) {
    return amount.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PurchaseBloc, PurchaseState>(
      builder: (context, state) {
        double subTotal = calculateSubTotal(state.cartItems);
        double discount = calculateTotalDiscount(state.cartItems);
        double netAmount = subTotal - discount;
        double taxAmount = calculateTax(netAmount, state.taxRate);
        double totalAmount = netAmount + taxAmount;

        return Column(
          children: [
            Text('ยอดรวม: ${formatCurrency(subTotal)}'),
            if (discount > 0)
              Text('ส่วนลด: ${formatCurrency(discount)}',
                  style: const TextStyle(color: Colors.red)),
            Text('มูลค่าสุทธิ: ${formatCurrency(netAmount)}'),
            Text('ภาษี: ${formatCurrency(taxAmount)}'),
            Text('ยอดรวมสุทธิ: ${formatCurrency(totalAmount)}',
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        );
      },
    );
  }
}
