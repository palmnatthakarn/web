import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_app/blocs/purchase/purchase_bloc.dart';
import 'package:flutter_web_app/blocs/purchase/purchase_event.dart';
import 'package:flutter_web_app/blocs/purchase/purchase_state.dart';
import 'package:flutter_web_app/component/all/buildSection.dart';
import 'package:flutter_web_app/screens/purchase/widgets_purchase/calculation_formulas.dart';
import '../../../component/all/tf.dart';

class SummaryAndPaymentSection extends StatefulWidget {
  const SummaryAndPaymentSection({super.key});

  @override
  State<SummaryAndPaymentSection> createState() =>
      _SummaryAndPaymentSectionState();
}

// Controller groups for better organization
class CalculationControllers {
  final sumValue = TextEditingController();
  final beforeVat = TextEditingController();
  final vatBase = TextEditingController();
  final beforeVatAfterDiscount = TextEditingController();
  final vatExtra = TextEditingController();
  final netTotal = TextEditingController();
  final grandTotal = TextEditingController(text: "0.00");
  final closeAmount = TextEditingController();

  void dispose() {
    sumValue.dispose();
    beforeVat.dispose();
    vatBase.dispose();
    beforeVatAfterDiscount.dispose();
    vatExtra.dispose();
    netTotal.dispose();
    grandTotal.dispose();
    closeAmount.dispose();
  }

  void clear() {
    sumValue.clear();
    beforeVat.clear();
    vatBase.clear();
    beforeVatAfterDiscount.clear();
    vatExtra.clear();
    netTotal.clear();
    closeAmount.clear();
  }

  // Helper methods for getting numeric values (รองรับรูปแบบไทย)
  double get sumValueAmount =>
      CalculationFormulas.parseThaiNumber(sumValue.text);
  double get beforeVatAmount =>
      CalculationFormulas.parseThaiNumber(beforeVat.text);
  double get vatExtraAmount =>
      CalculationFormulas.parseThaiNumber(vatExtra.text);
  double get grandTotalAmount =>
      CalculationFormulas.parseThaiNumber(grandTotal.text);
  double get closeAmountValue =>
      CalculationFormulas.parseThaiNumber(closeAmount.text);

  // Update methods with Thai formatting
  void updateSumValue(double value) {
    sumValue.text = CalculationFormulas.formatThaiDecimal(value);
  }

  void updateGrandTotal(double value) {
    grandTotal.text = CalculationFormulas.formatThaiDecimal(value);
  }

  void updateVatExtra(double value) {
    vatExtra.text = CalculationFormulas.formatThaiDecimal(value);
  }

  void updateBeforeVat(double value) {
    beforeVat.text = CalculationFormulas.formatThaiDecimal(value);
  }

  void updateVatBase(double value) {
    vatBase.text = CalculationFormulas.formatThaiDecimal(value);
  }

  void updateBeforeVatAfterDiscount(double value) {
    beforeVatAfterDiscount.text = CalculationFormulas.formatThaiDecimal(value);
  }

  // อัปเดตมูลค่าสุทธิ (netAfterPrepay)
  void updateNetAfterPrepay(double value) {
    beforeVatAfterDiscount.text = CalculationFormulas.formatThaiDecimal(value);
  }

  void updateNetTotal(double value) {
    netTotal.text = CalculationFormulas.formatThaiDecimal(value);
  }

  void updateCloseAmount(double value) {
    closeAmount.text = CalculationFormulas.formatThaiDecimal(value);
  }

  // Validation methods
  bool get isValid {
    return sumValueAmount >= 0 && grandTotalAmount >= 0;
  }

  String? validateCalculation() {
    if (sumValueAmount < 0) return 'รวมมูลค่าต้องไม่เป็นลบ';
    if (grandTotalAmount < 0) return 'ยอดรวมสุทธิต้องไม่เป็นลบ';
    return null;
  }
}

class DiscountControllers {
  final beforePayment = TextEditingController();
  final taxable = TextEditingController();
  final nonTaxable = TextEditingController();
  final rounding = TextEditingController();

  void dispose() {
    beforePayment.dispose();
    taxable.dispose();
    nonTaxable.dispose();
    rounding.dispose();
  }

  void clear() {
    beforePayment.clear();
    taxable.clear();
    nonTaxable.clear();
    rounding.clear();
  }

  // Helper methods for getting numeric values (รองรับรูปแบบไทย)
  double get beforePaymentAmount =>
      CalculationFormulas.parseThaiNumber(beforePayment.text);
  double get taxableAmount => CalculationFormulas.parseThaiNumber(taxable.text);
  double get nonTaxableAmount =>
      CalculationFormulas.parseThaiNumber(nonTaxable.text);
  double get roundingAmount =>
      CalculationFormulas.parseThaiNumber(rounding.text);

  // Get total discount amount
  double get totalDiscountAmount =>
      beforePaymentAmount + taxableAmount + nonTaxableAmount;

  // Update methods with Thai formatting
  void updateBeforePayment(double value) {
    beforePayment.text = CalculationFormulas.formatThaiDecimal(value);
  }

  void updateTaxable(double value) {
    taxable.text = CalculationFormulas.formatThaiDecimal(value);
  }

  void updateNonTaxable(double value) {
    nonTaxable.text = CalculationFormulas.formatThaiDecimal(value);
  }

  void updateRounding(double value) {
    rounding.text = CalculationFormulas.formatThaiDecimal(value);
  }

  // Validation methods
  bool get isValid {
    return beforePaymentAmount >= 0 &&
        taxableAmount >= 0 &&
        nonTaxableAmount >= 0;
  }

  String? validateDiscounts() {
    if (beforePaymentAmount < 0) return 'ส่วนลดก่อนชำระเงินต้องไม่เป็นลบ';
    if (taxableAmount < 0) return 'ส่วนลดสินค้ามีภาษีต้องไม่เป็นลบ';
    if (nonTaxableAmount < 0) return 'ส่วนลดสินค้ายกเว้นภาษีต้องไม่เป็นลบ';
    return null;
  }
}

class PaymentControllers {
  final receive = TextEditingController();
  final selectBank = TextEditingController();
  final accountNumber = TextEditingController();

  void dispose() {
    receive.dispose();
    selectBank.dispose();
    accountNumber.dispose();
  }

  void clear() {
    receive.clear();
    selectBank.clear();
    accountNumber.clear();
  }

  // Helper methods for getting numeric values (รองรับรูปแบบไทย)
  double get receiveAmount => CalculationFormulas.parseThaiNumber(receive.text);
  String get selectedBank => selectBank.text.trim();
  String get accountNumberValue => accountNumber.text.trim();

  // Update methods with Thai formatting
  void updateReceive(double value) {
    receive.text = CalculationFormulas.formatThaiDecimal(value);
  }

  void updateSelectedBank(String bank) {
    selectBank.text = bank;
  }

  void updateAccountNumber(String account) {
    accountNumber.text = account;
  }

  // Calculate change amount
  double calculateChange(double grandTotal) {
    final change = receiveAmount - grandTotal;
    return change;
  }

  // Validation methods
  bool get isValid {
    return receiveAmount >= 0;
  }

  String? validatePayment(double grandTotal, PaymentType paymentType) {
    if (receiveAmount < 0) return 'จำนวนเงินที่รับต้องไม่เป็นลบ';
    if (receiveAmount < grandTotal) return 'จำนวนเงินที่รับน้อยกว่ายอดรวม';

    // ตรวจสอบข้อมูลเพิ่มเติมสำหรับการโอนเงิน
    if (paymentType == PaymentType.transfer) {
      if (selectedBank.isEmpty) return 'กรุณาเลือกธนาคาร';
      if (accountNumberValue.isEmpty) return 'กรุณากรอกเลขบัญชี';
      if (accountNumberValue.length < 10)
        return 'เลขบัญชีต้องมีอย่างน้อย 10 หลัก';
    }

    return null;
  }

  bool get hasInsufficientPayment => receiveAmount < 0;
  bool hasInsufficientPaymentFor(double grandTotal) =>
      receiveAmount < grandTotal;
}

class _SummaryAndPaymentSectionState extends State<SummaryAndPaymentSection> {
  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Services (for future use)
  // final _calculationService = CalculationService();
  // final _formService = FormService();
  // final _uiService = UIService();

  // Grouped controllers
  late final CalculationControllers _calculationCtrls;
  late final DiscountControllers _discountCtrls;
  late final PaymentControllers _paymentCtrls;

  // Payment settings
  PaymentType _paymentType = PaymentType.cash;
  bool _saveMyChange = false;
  bool _autoPrint = false;

  // เพิ่มการคำนวณเงินทอน
  double _changeAmount = 0.0;

  // เพิ่มตัวแปรป้องกัน infinite loop
  bool _isUpdatingFromBloc = false; // ป้องกัน infinite loop
  VatMode? _lastVatMode; // ติดตาม VAT Mode ที่เปลี่ยน
  bool _isCalculating = false; // ป้องกันการคำนวณซ้อน

  // เพิ่มตัวแปรเพื่อติดตามว่า field ไหนกำลังถูกแก้ไข
  // TextEditingController? _currentlyEditingController; // ปิดการใช้งานชั่วคราว

  /// ฟอร์แมตตัวเลขให้แสดงผลสวยงาม
  String _formatNumberInput(String input) {
    if (input.isEmpty) return '';

    final double? value = double.tryParse(input);
    if (value == null) return input;

    // ถ้าเป็นจำนวนเต็ม ไม่แสดงทศนิยม
    if (value == value.toInt()) {
      return value.toInt().toString();
    }

    // แสดงทศนิยมสูงสุด 2 ตำแหน่ง
    return value.toStringAsFixed(2).replaceAll(RegExp(r'\.?0+$'), '');
  }

  /// ตรวจสอบว่าค่าที่กรอกถูกต้องหรือไม่ (รองรับรูปแบบไทย)
  bool _isValidNumberInput(String input) {
    if (input.isEmpty) return true;

    // ใช้ฟังก์ชันตรวจสอบจาก CalculationFormulas
    return CalculationFormulas.isValidThaiNumber(input);
  }

  // ===== VALIDATION METHODS =====

  /// Validate the entire form
  bool validateForm() {
    if (!_formKey.currentState!.validate()) {
      return false;
    }

    // Validate controller groups
    final calculationError = _calculationCtrls.validateCalculation();
    if (calculationError != null) {
      _showValidationError(calculationError);
      return false;
    }

    final discountError = _discountCtrls.validateDiscounts();
    if (discountError != null) {
      _showValidationError(discountError);
      return false;
    }

    final paymentError = _paymentCtrls.validatePayment(
        _calculationCtrls.grandTotalAmount, _paymentType);
    if (paymentError != null) {
      _showValidationError(paymentError);
      return false;
    }

    return true;
  }

  /// Show validation error message
  void _showValidationError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Check if form has any changes
  bool get hasFormChanges {
    return _discountCtrls.totalDiscountAmount > 0 ||
        _paymentCtrls.receiveAmount > 0 ||
        _calculationCtrls.closeAmountValue > 0;
  }

  /// Get form summary for validation
  Map<String, dynamic> getFormSummary() {
    return {
      'calculation': {
        'sumValue': _calculationCtrls.sumValueAmount,
        'grandTotal': _calculationCtrls.grandTotalAmount,
        'vatAmount': _calculationCtrls.vatExtraAmount,
      },
      'discounts': {
        'beforePayment': _discountCtrls.beforePaymentAmount,
        'taxable': _discountCtrls.taxableAmount,
        'nonTaxable': _discountCtrls.nonTaxableAmount,
        'rounding': _discountCtrls.roundingAmount,
        'total': _discountCtrls.totalDiscountAmount,
      },
      'payment': {
        'receive': _paymentCtrls.receiveAmount,
        'change': _changeAmount,
        'type': _paymentType,
        'selectedBank': _paymentCtrls.selectedBank,
      },
      'validation': {
        'isValid': validateForm(),
        'hasChanges': hasFormChanges,
      }
    };
  }

  /// Reset form to initial state
  void resetForm() {
    _formKey.currentState?.reset();
    _discountCtrls.clear();
    _paymentCtrls.clear();
    _changeAmount = 0.0;
    _paymentType = PaymentType.cash;
    setState(() {});
    _calculate();
  }

  /// Save form data (placeholder for future implementation)
  Future<bool> saveForm() async {
    if (!validateForm()) {
      return false;
    }

    try {
      // TODO: Implement actual save logic
      // final formData = getFormSummary();

      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 500));

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('บันทึกข้อมูลเรียบร้อยแล้ว'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }

      return true;
    } catch (e) {
      _showValidationError('เกิดข้อผิดพลาดในการบันทึกข้อมูล: $e');
      return false;
    }
  }

  // ===== LIFECYCLE METHODS =====

  @override
  void initState() {
    super.initState();

    // Initialize controller groups
    _calculationCtrls = CalculationControllers();
    _discountCtrls = DiscountControllers();
    _paymentCtrls = PaymentControllers();

    _addListeners();

    // อัปเดตค่าเริ่มต้นจาก bloc state (ไม่ทำการคำนวณใหม่)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final state = context.read<PurchaseBloc>().state;
        _lastVatMode = state.vatMode; // Initialize last VAT mode
        _updateControllersFromState(state);
      }
    });
  }

  void _updateControllersFromState(PurchaseState state) {
    if (_isUpdatingFromBloc) return;
    _isUpdatingFromBloc = true;

    // รวมมูลค่าตามตะกร้า (ให้ bloc เป็นคน sync) - ใช้รูปแบบไทย
    final formattedSubTotal =
        CalculationFormulas.formatThaiDecimal(state.subTotal);
    if (_calculationCtrls.sumValue.text != formattedSubTotal) {
      _calculationCtrls.sumValue.text = formattedSubTotal;
    }

    // ช่องอินพุตที่ bloc จำไว้ (ให้สะท้อนกลับมา)
    if (_discountCtrls.beforePayment.text !=
        state.beforePaymentDiscount.toStringAsFixed(2)) {
      _discountCtrls.beforePayment.text =
          state.beforePaymentDiscount.toStringAsFixed(2);
    }
    final formattedTaxableDiscount =
        CalculationFormulas.formatThaiDecimal(state.taxableDiscount);
    if (_discountCtrls.taxable.text != formattedTaxableDiscount) {
      _discountCtrls.taxable.text = formattedTaxableDiscount;
    }
    final formattedNonTaxableDiscount =
        CalculationFormulas.formatThaiDecimal(state.nonTaxableDiscount);
    if (_discountCtrls.nonTaxable.text != formattedNonTaxableDiscount) {
      _discountCtrls.nonTaxable.text = formattedNonTaxableDiscount;
    }
    final formattedRounding =
        CalculationFormulas.formatThaiDecimal(state.roundingAmount);
    if (_discountCtrls.rounding.text != formattedRounding) {
      _discountCtrls.rounding.text = formattedRounding;
    }

    // ค่าคำนวณจาก bloc (ถ้า bloc มีเก็บไว้)
    // ถ้าไม่มีใน state ก็ปล่อยให้ _calculate เป็นคนเติมเอง
    if (state.netTaxAmount >= 0) {
      final formattedVatAmount =
          CalculationFormulas.formatThaiDecimal(state.netTaxAmount);
      if (_calculationCtrls.vatExtra.text != formattedVatAmount) {
        _calculationCtrls.vatExtra.text = formattedVatAmount;
      }
    }
    if (state.grandTotal >= 0 &&
        _calculationCtrls.grandTotal.text !=
            state.grandTotal.toStringAsFixed(2)) {
      _calculationCtrls.grandTotal.text = state.grandTotal.toStringAsFixed(2);
    }
    if (state.receivedAmount >= 0 &&
        _paymentCtrls.receive.text != state.receivedAmount.toStringAsFixed(2)) {
      _paymentCtrls.receive.text = state.receivedAmount.toStringAsFixed(2);
    }
    if (_changeAmount != state.changeAmount) {
      _changeAmount = state.changeAmount;
    }

    _isUpdatingFromBloc = false;
  }

  @override
  void dispose() {
    _calculationCtrls.dispose();
    _discountCtrls.dispose();
    _paymentCtrls.dispose();
    super.dispose();
  }

  void _addListeners() {
    // เพิ่ม wrapper function เพื่อป้องกัน loop
    void safeCalculate() {
      if (!_isUpdatingFromBloc && mounted) {
        _calculate();
      }
    }

    void safeCalculateChange() {
      if (!_isUpdatingFromBloc && mounted) {
        _calculateChange();
      }
    }

    // Calculation listeners
    _calculationCtrls.closeAmount.addListener(safeCalculate);

    // Discount listeners
    _discountCtrls.beforePayment.addListener(safeCalculate);
    _discountCtrls.taxable.addListener(safeCalculate);
    _discountCtrls.nonTaxable.addListener(safeCalculate);
    _discountCtrls.rounding.addListener(safeCalculate);

    // Payment listeners
    _paymentCtrls.receive.addListener(safeCalculateChange);
  }

//หัวใจของการคำนวณ
  void _calculate() {
    // ป้องกันการคำนวณซ้ำซ้อน
    if (_isUpdatingFromBloc || _isCalculating) return;

    _isCalculating = true;
    final blocState = context.read<PurchaseBloc>().state;

    // 1) รวมมูลค่า (Gross) อ่านจากกล่องหรือ state ที่ sync ไว้แล้ว
    final gross = _calculationCtrls.sumValueAmount;

    // 2) ส่วนลดระดับ "สินค้า" แยกตามหมวดภาษี
    final discTaxable = _discountCtrls.taxableAmount;
    final discNonTaxable = _discountCtrls.nonTaxableAmount;

    // 3) ส่วนลดก่อนชำระเงิน (ท้ายบิล) + ปิดยอด/ปัดเศษ
    final discBeforePay = _discountCtrls.beforePaymentAmount;
    final rounding = _discountCtrls.roundingAmount;
    final closeAmount = _calculationCtrls.closeAmountValue;

    // 4) อัตราภาษี - ใช้สูตร VAT: ราคาสินค้า/บริการ × (7 ÷ 100) = VAT
    final double taxRatePercent = double.tryParse(blocState.taxRate) ?? 7.0;

    // ---------- คำนวณตามโหมด VAT ใช้ CalculationFormulas ----------
    final calculationResult = CalculationFormulas.calculateTotalByVATMode(
      vatMode: blocState.vatMode,
      grossAmount: gross,
      taxableDiscount: discTaxable,
      nonTaxableDiscount: discNonTaxable,
      beforePaymentDiscount: discBeforePay,
      roundingAmount: rounding,
      closeAmount: closeAmount,
      taxRatePercent: taxRatePercent,
    );

    final beforeVat = calculationResult['beforeVat']!;
    final vatAmount = calculationResult['vatAmount']!;
    final afterItemStage = calculationResult['afterItemStage']!;
    final netAfterPrepay = calculationResult['netAfterPrepay']!;
    final grandTotal = calculationResult['grandTotal']!;

    // --- อัปเดตช่องแสดงผล ---
    _isUpdatingFromBloc = true;

    // ใช้การจัดรูปแบบแบบไทย (มีคอมม่าคั่นหลักพัน)
    // TODO: สามารถเปลี่ยนเป็น user setting ได้ในอนาคต
    _calculationCtrls.beforeVat.text =
        CalculationFormulas.formatThaiDecimal(beforeVat);
    _calculationCtrls.vatBase.text =
        CalculationFormulas.formatThaiDecimal(beforeVat);
    _calculationCtrls.vatExtra.text =
        CalculationFormulas.formatThaiDecimal(vatAmount);
    // แสดงมูลค่าสุทธิ (netAfterPrepay) = ยอดหลังหักส่วนลดสินค้าและส่วนลดก่อนชำระ
    _calculationCtrls.beforeVatAfterDiscount.text =
        CalculationFormulas.formatThaiDecimal(netAfterPrepay);
    _calculationCtrls.netTotal.text =
        CalculationFormulas.formatThaiDecimal(netAfterPrepay);
    _calculationCtrls.grandTotal.text =
        CalculationFormulas.formatThaiDecimal(grandTotal);

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

    _isUpdatingFromBloc = false;
    _isCalculating = false;

    setState(() {});
    _calculateChange();
  }

  // เพิ่มฟังก์ชันคำนวณเงินทอน
  void _calculateChange() {
    if (_isUpdatingFromBloc) return; // ป้องกัน infinite loop

    final receive = _paymentCtrls.receiveAmount;
    final grandTotal = _calculationCtrls.grandTotalAmount;
    final changeAmount =
        CalculationFormulas.calculateChange(receive, grandTotal);

    // อัปเดต local state เฉพาะเมื่อค่าเปลี่ยน
    if (_changeAmount != changeAmount) {
      setState(() {
        _changeAmount = changeAmount;
      });

      // อัปเดต bloc state เฉพาะเมื่อไม่ได้อัปเดตจาก bloc
      if (!_isUpdatingFromBloc) {
        context.read<PurchaseBloc>().add(
              PurchasePaymentUpdated(
                receivedAmount: receive,
                changeAmount: changeAmount,
              ),
            );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 768;

    return BlocListener<PurchaseBloc, PurchaseState>(
      listener: (context, state) {
        _updateControllersFromState(state);

        // Trigger recalculation only when VAT mode actually changes
        if (_lastVatMode != null && _lastVatMode != state.vatMode) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && !_isUpdatingFromBloc) {
              _calculate();
            }
          });
        }
        _lastVatMode = state.vatMode;
      },
      child: Form(
        key: _formKey,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.grey[50]!,
                Colors.white,
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // Header with Quick Actions
                //_buildHeader(context),

                // Main Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 24 : 16,
                      vertical: 16,
                    ),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        minWidth: double.infinity, // ยืดเต็ม
                        maxWidth: double.infinity, // ล็อกให้เต็ม
                      ),
                      child: isTablet
                          ? _buildTabletLayout()
                          : _buildMobileLayout(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.receipt_long, color: Colors.blue[600], size: 28),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'สรุปยอดและชำระเงิน',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'ตรวจสอบยอดรวมและเลือกวิธีชำระเงิน',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          _buildQuickActionButtons(),
        ],
      ),
    );
  }

  Widget _buildQuickActionButtons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildQuickButton(
          icon: Icons.refresh,
          label: 'รีเซ็ต',
          onTap: _resetCalculation,
          color: Colors.orange,
        ),
        const SizedBox(width: 8),
        _buildQuickButton(
          icon: Icons.calculate,
          label: 'คำนวณ',
          onTap: _calculate,
          color: Colors.blue,
        ),
      ],
    );
  }

  Widget _buildQuickButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabletLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Column - Calculations
        Expanded(
          flex: 2,
          child: Column(
            children: [
              _buildCalculationSection(),
              const SizedBox(height: 16),
              _buildTaxSection(),
              const SizedBox(height: 16),
              _buildDiscountSection(),
            ],
          ),
        ),
        const SizedBox(width: 24),

        // Right Column - Summary & Payment
        Expanded(
          flex: 1,
          child: Column(
            children: [
              _buildTotalSummaryCard(),
              const SizedBox(height: 16),
              _buildPaymentSection(),
              const SizedBox(height: 16),
              _buildActionButtonsSection(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        _buildTotalSummaryCard(),
        const SizedBox(height: 16),
        _buildCalculationSection(),
        const SizedBox(height: 16),
        _buildTaxSection(),
        const SizedBox(height: 16),
        _buildDiscountSection(),
        const SizedBox(height: 16),
        _buildPaymentSection(),
        const SizedBox(height: 16),
        _buildActionButtonsSection(),
        const SizedBox(height: 100), // Space for sticky bottom
      ],
    );
  }

//แสดงยอดรวมสุทธิด้วย Gradient
  Widget _buildTotalSummaryCard() {
    return BlocBuilder<PurchaseBloc, PurchaseState>(
      builder: (context, state) {
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue[600]!, Colors.blue[700]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ยอดรวมสุทธิ',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildPricingModeToggle(), // ปุ่มสลับโหมด
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            state.vatMode == VatMode.inclusive
                                ? 'รวม VAT'
                                : 'ก่อน VAT',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  '${CalculationFormulas.formatCurrency(state.grandTotal)} บาท',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (state.receivedAmount > 0) ...[
                  const SizedBox(height: 16),
                  _buildChangeIndicator(state.changeAmount),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

//แสดง เงินทอน (พื้นฟ้า) หรือ เงินไม่พอ (พื้นแดง) ตามค่า _changeAmount
  Widget _buildChangeIndicator(double changeAmount) {
    final isPositive = changeAmount >= 0;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isPositive
            ? Colors.green.withOpacity(0.2)
            : Colors.red.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPositive ? Icons.keyboard_return : Icons.warning_outlined,
            color: isPositive ? Colors.green[100] : Colors.red[100],
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(
            '${isPositive ? 'เงินทอน' : 'เงินไม่พอ'} ${CalculationFormulas.formatCurrency(changeAmount.abs())} บาท',
            style: TextStyle(
              color: isPositive ? Colors.green[100] : Colors.red[100],
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

//ช่องแสดงการคำนวณ
  Widget _buildCalculationSection() {
    return Column(
      children: [
        SectionBuilder.buildSection(
          title: 'รายละเอียดการคำนวณ',
          icon: Icons.calculate_outlined,
          child: Column(
            children: [
              _responsiveGrid(children: [
                _roTf('รวมมูลค่า', _calculationCtrls.sumValue),
                _roTf('มูลค่าสุทธิ (หลังหักส่วนลด)',
                    _calculationCtrls.beforeVatAfterDiscount),
              ]),
            ],
          ),
        ),
      ],
    );
  }

// ส่วนภาษีมูลค่าเพิ่ม
  Widget _buildTaxSection() {
    return BlocBuilder<PurchaseBloc, PurchaseState>(
      builder: (context, state) {
        return SectionBuilder.buildSection(
          title: 'ภาษีมูลค่าเพิ่ม',
          icon: Icons.percent,
          child: Column(
            children: [
              const SizedBox(height: 12),
              _responsiveGrid(children: [
                _roTf('ยอดก่อนภาษี (ฐานภาษี)', _calculationCtrls.beforeVat),
                _roTf('ภาษีมูลค่าเพิ่ม', _calculationCtrls.vatExtra),
              ]),
            ],
          ),
        );
      },
    );
  }

//ส่วนลดต่างประเภท
  Widget _buildDiscountSection() {
    return SectionBuilder.buildSection(
      title: 'ส่วนลดและการปรับปรุง',
      icon: Icons.discount_outlined,
      child: Column(
        children: [
          _responsiveGrid(children: [
            TextFieldBuilder.simpleTf(
               labelText:  'ส่วนลดสินค้ามีภาษี',
              controller: _discountCtrls.taxable,
              fillColor: Colors.blue[50]!,
            ),
            TextFieldBuilder.simpleTf(
               labelText:  'ส่วนลดสินค้ายกเว้นภาษี',
              controller: _discountCtrls.nonTaxable,
              fillColor: Colors.green[50]!,
            ),
          ]),
          const SizedBox(height: 12),
          _responsiveGrid(children: [
            TextFieldBuilder.simpleTf(
              labelText:   'ส่วนลดก่อนชำระเงิน',
              controller: _discountCtrls.beforePayment,
              fillColor: Colors.orange[50]!,
            ),
            TextFieldBuilder.simpleTf(
               labelText:  'ปัดเศษ',
              controller: _discountCtrls.rounding,
              fillColor: Colors.purple[50]!,
            ),
          ]),
        ],
      ),
    );
  }

// วิธีชำระเงิน
  Widget _buildPaymentSection() {
    return SectionBuilder.buildSection(
      title: 'วิธีชำระเงิน',
      icon: Icons.payment_outlined,
      child: Column(
        children: [
          _buildInputField(
            'รับเงิน/เงินโอน',
            _paymentCtrls.receive,
            color: Colors.yellow[50]!,
            icon: Icons.attach_money,
          ),
          const SizedBox(height: 16),
          _buildPaymentTypeSelector(),
          const SizedBox(height: 16),
          // แสดงฟิลด์ธนาคารและเลขบัญชีเมื่อเลือกเงินโอน
          if (_paymentType == PaymentType.transfer) ...[
            _buildBankSelector(),
            const SizedBox(height: 16),
            _buildAccountNumberField(),
            const SizedBox(height: 16),
          ],
          _buildPaymentOptions(),
        ],
      ),
    );
  }

  // Action buttons section
  Widget _buildActionButtonsSection() {
    return SectionBuilder.buildSection(
      title: 'การดำเนินการ',
      icon: Icons.settings_outlined,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => resetForm(),
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text('รีเซ็ตฟอร์ม'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange[100],
                    foregroundColor: Colors.orange[800],
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (validateForm()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('ฟอร์มถูกต้อง ✓'),
                          backgroundColor: Colors.green,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.check_circle, size: 18),
                  label: const Text('ตรวจสอบ'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[100],
                    foregroundColor: Colors.blue[800],
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () async {
                await saveForm();
              },
              icon: const Icon(Icons.save, size: 18),
              label: const Text('บันทึกข้อมูล'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[600],
                foregroundColor: Colors.white,
                elevation: 2,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Form summary info
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'สรุปข้อมูล',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 8),
                _buildSummaryRow(
                    'ส่วนลดรวม', _discountCtrls.totalDiscountAmount),
                _buildSummaryRow('เงินทอน', _changeAmount),
                _buildSummaryRow('สถานะ',
                    hasFormChanges ? 'มีการเปลี่ยนแปลง' : 'ไม่มีการเปลี่ยนแปลง',
                    isText: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, dynamic value, {bool isText = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          Text(
            isText ? value.toString() : '${value.toStringAsFixed(2)} บาท',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }

//ฟิลด์อินพุตตัวเลข
  Widget _buildInputField(
    String label,
    TextEditingController controller, {
    required Color color,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: Colors.grey[600]),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(
            decimal: true,
            signed: true,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: color,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.blue[600]!, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.red[400]!, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.red[600]!, width: 2),
            ),
            suffixText: 'บาท',
            suffixStyle: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
            hintText: '',
            hintStyle: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
            ),
          ),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.right,
          onChanged: (value) {
            // ตรวจสอบและแปลงค่าให้เป็นตัวเลขที่ถูกต้อง
            if (value.isNotEmpty) {
              final double? parsedValue = double.tryParse(value);
              if (parsedValue != null) {
                // สามารถเพิ่ม callback ที่นี่เพื่อแจ้ง parent widget
              }
            }
          },
          onTap: () {
            // เลือกข้อความทั้งหมดเมื่อแตะ (เพื่อความสะดวกในการแก้ไข)
            if (controller.text.isNotEmpty) {
              controller.selection = TextSelection(
                baseOffset: 0,
                extentOffset: controller.text.length,
              );
            }
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return null; // อนุญาตให้เว้นว่างได้
            }

            final double? parsedValue = double.tryParse(value);
            if (parsedValue == null) {
              return 'กรุณากรอกตัวเลขที่ถูกต้อง';
            }

            // อนุญาตให้ใส่ค่าลบได้สำหรับบางฟิลด์ (เช่น ปัดเศษ)
            if (parsedValue < 0 && !label.contains('ปัดเศษ')) {
              return 'ค่าต้องไม่เป็นลบ';
            }

            // ตรวจสอบค่าสูงสุด
            if (parsedValue.abs() > 999999999.99) {
              return 'ค่าต้องไม่เกิน 999,999,999.99';
            }

            return null;
          },
        ),
      ],
    );
  }

  // กล่องเลือกธนาคาร
  Widget _buildBankSelector() {
    final banks = [
      'ธนาคารกรุงเทพ',
      'ธนาคารกสิกรไทย',
      'ธนาคารไทยพาณิชย์',
      'ธนาคารกรุงไทย',
      'ธนาคารทหารไทยธนชาต',
      'ธนาคารกรุงศรีอยุธยา',
      'ธนาคารเกียรตินาคินภัทร',
      'ธนาคารซีไอเอ็มบี ไทย',
      'ธนาคารยูโอบี',
      'ธนาคารแลนด์ แอนด์ เฮ้าส์',
      'ธนาคารลิเบอร์ตี้',
      'ธนาคารไอซีบีซี (ไทย)',
      'ธนาคารเมกะ สากลพาณิชย์',
      'ธนาคารซูมิโตโม มิตซุย แบงกิ้ง คอร์ปอเรชั่น',
      'ธนาคารมิซูโฮ คอร์ปอเรต',
      'ธนาคารสแตนดาร์ดชาร์เตอร์ด (ไทย)',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.account_balance, size: 16, color: Colors.grey[600]),
            const SizedBox(width: 6),
            const Text(
              'เลือกธนาคาร',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _paymentCtrls.selectedBank.isEmpty
              ? null
              : _paymentCtrls.selectedBank,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.blue[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.blue[600]!, width: 2),
            ),
            hintText: 'เลือกธนาคาร',
            hintStyle: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
            ),
          ),
          items: banks.map((bank) {
            return DropdownMenuItem<String>(
              value: bank,
              child: Text(
                bank,
                style: const TextStyle(fontSize: 14),
              ),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              _paymentCtrls.updateSelectedBank(value);
            }
          },
          validator: (value) {
            if (_paymentType == PaymentType.transfer &&
                (value == null || value.isEmpty)) {
              return 'กรุณาเลือกธนาคาร';
            }
            return null;
          },
        ),
      ],
    );
  }

  // กล่องกรอกเลขบัญชี
  Widget _buildAccountNumberField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.credit_card, size: 16, color: Colors.grey[600]),
            const SizedBox(width: 6),
            const Text(
              'เลขบัญชี',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _paymentCtrls.accountNumber,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.blue[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.blue[600]!, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.red[400]!, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.red[600]!, width: 2),
            ),
            hintText: 'กรอกเลขบัญชี 10-15 หลัก',
            hintStyle: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
            ),
          ),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          validator: (value) {
            if (_paymentType == PaymentType.transfer) {
              if (value == null || value.isEmpty) {
                return 'กรุณากรอกเลขบัญชี';
              }
              if (value.length < 10) {
                return 'เลขบัญชีต้องมีอย่างน้อย 10 หลัก';
              }
              if (value.length > 15) {
                return 'เลขบัญชีต้องไม่เกิน 15 หลัก';
              }
              // ตรวจสอบว่าเป็นตัวเลขเท่านั้น
              if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                return 'เลขบัญชีต้องเป็นตัวเลขเท่านั้น';
              }
            }
            return null;
          },
          onChanged: (value) {
            // จำกัดให้กรอกได้เฉพาะตัวเลข
            final filteredValue = value.replaceAll(RegExp(r'[^0-9]'), '');
            if (filteredValue != value) {
              _paymentCtrls.accountNumber.text = filteredValue;
              _paymentCtrls.accountNumber.selection =
                  TextSelection.fromPosition(
                TextPosition(offset: filteredValue.length),
              );
            }
          },
        ),
      ],
    );
  }

  void _resetCalculation() {
    _discountCtrls.clear();
    _paymentCtrls.clear();
    _calculate();
  }

  /*Widget _buildSummaryRow(
    String label, {
    double? amount, // สำหรับโหมดแสดงผล
    bool isDiscount = false,
    bool isBold = false,

    // ===== สำหรับโหมดกรอกค่า =====
    bool editable = false,
    TextEditingController? controller,
    ValueChanged<String>? onChanged,
  }) {
    // วิดเจ็ตค่าด้านขวา: ถ้า editable ให้เป็น TextFormField
    Widget valueWidget;
    if (editable) {
      final c = controller ??
          TextEditingController(
            text: amount != null
                ? CalculationFormulas.formatCurrency(amount)
                : '',
          );

      valueWidget = ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 140, maxWidth: 260),
        child: TextFormField(
          controller: c,
          onChanged: onChanged,
          textAlign: TextAlign.right,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            // พิมพ์ได้หลายหลัก รองรับทศนิยม 2 ตำแหน่ง (ปรับ regex ได้)
            FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
            // จำกัดรูปแบบให้ถูกต้อง
            TextInputFormatter.withFunction((oldValue, newValue) {
              if (newValue.text.isEmpty) return newValue;
              
              // อนุญาตให้มีจุดทศนิยมได้เพียงจุดเดียว
              if (newValue.text.split('.').length > 2) {
                return oldValue;
              }
              
              // จำกัดทศนิยมไม่เกิน 2 ตำแหน่ง
              if (newValue.text.contains('.')) {
                final parts = newValue.text.split('.');
                if (parts.length == 2 && parts[1].length > 2) {
                  return oldValue;
                }
              }
              
              // ตรวจสอบว่าเป็นตัวเลขที่ถูกต้อง
              final double? value = double.tryParse(newValue.text);
              if (value == null && newValue.text != '.') {
                return oldValue;
              }
              
              return newValue;
            }),
          ],
          decoration: const InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            border: OutlineInputBorder(),
            counterText: '',
          ),
        ),
      );
    } else {
      final v = amount ?? 0;
      valueWidget = Text(
        '${isDiscount && v > 0 ? '-' : ''}${CalculationFormulas.formatCurrency(v.abs())} บาท',
        textAlign: TextAlign.right,
        style: TextStyle(
          color: isDiscount
              ? Colors.red
              : (isBold ? Colors.green[700] : Colors.black),
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          fontSize: isBold ? 16 : 14,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(
            // ให้ป้ายกินที่เหลือ
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                fontSize: isBold ? 16 : 14,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            // ให้ช่องตัวเลขยืดได้มากกว่าหนึ่งหลัก
            child: valueWidget,
          ),
        ],
      ),
    );
  }*/

  // ===================================================================
  // ==================== Small UI helpers / components =================
  // ===================================================================
//จัดเป็น Row (ขยายเท่า ๆ กัน)ไม่งั้นเป็น Column
  Widget _responsiveGrid({required List<Widget> children}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 400;
        if (isWide) {
          return Row(
            children: children
                .map((child) => Expanded(child: child))
                .expand((widget) => [widget, const SizedBox(width: 12)])
                .take(children.length * 2 - 1)
                .toList(),
          );
        } else {
          return Column(
            children: children
                .expand((widget) => [widget, const SizedBox(height: 12)])
                .take(children.length * 2 - 1)
                .toList(),
          );
        }
      },
    );
  }

//อ่านอย่างเดียว + พื้นหลังเทาอ่อน
  Widget _roTf(String label, TextEditingController c) {
    return AbsorbPointer(
      child: TextFieldBuilder.simpleTf(
         labelText:  label,
        controller: c,
        fillColor: const Color(0xFFF3F4F6),
      ),
    );
  }

  //สลับโหมด ปุ่มสลับ VAT Inclusive/Exclusiveส่ง PurchaseVatModeChanged(newMode) เข้า BLoC
  Widget _buildPricingModeToggle() {
    return BlocBuilder<PurchaseBloc, PurchaseState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(0),
          child: Row(
            children: [
              // Icon เป็นปุ่มที่กดได้
              InkWell(
                onTap: () {
                  // สลับโหมดเมื่อกด icon
                  final newMode = state.vatMode == VatMode.inclusive
                      ? VatMode.exclusive
                      : VatMode.inclusive;

                  if (newMode != state.vatMode &&
                      !_isUpdatingFromBloc &&
                      !_isCalculating) {
                    context
                        .read<PurchaseBloc>()
                        .add(PurchaseVatModeChanged(newMode));
                  }
                },
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Icon(Icons.swap_horiz, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ===================================================================
  // ==================== Updated Payment Section ===================
  // ===================================================================
//ปุ่มแบบการ์ด 2 แบบ: เงินสด, โอน
  Widget _buildPaymentTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.payment, size: 16, color: Colors.grey[600]),
            const SizedBox(width: 6),
            const Text(
              'วิธีชำระ',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Row(
            children: PaymentType.values.map((type) {
              final isSelected = _paymentType == type;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _paymentType = type),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue[600] : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.3),
                                blurRadius: 8,
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
                          size: 20,
                          color: isSelected ? Colors.white : Colors.grey[600],
                        ),
                        const SizedBox(width: 8),
                        Text(
                          type.displayName,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.grey[700],
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
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

//แสดง เงินทอน (พื้นฟ้า)
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

//checkbox แบบกดได้ทั้งบรรทัด
  Widget _buildPaymentOptions() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ตัวเลือกเพิ่มเติม',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 5,
            runSpacing: 0,
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
          ),
        ],
      ),
    );
  }

  Widget _buildCheckboxTile(
      String label, bool value, IconData icon, ValueChanged<bool?> onChanged) {
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: value ? Colors.blue[600] : Colors.transparent,
                border: Border.all(
                  color: value ? Colors.blue[600]! : Colors.grey[400]!,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: value
                  ? const Icon(
                      Icons.check,
                      size: 14,
                      color: Colors.white,
                    )
                  : null,
            ),
            const SizedBox(width: 8),
            Icon(icon, size: 16, color: Colors.grey[600]),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

//ปุ่ม “บันทึก” และ “พิมพ์ใบเสร็จ”
/*  Widget _buildActionButtons() {
    final grandTotal =
        double.tryParse(_calculationCtrls.grandTotal.text) ?? 0.0;
    final isEnabled = grandTotal > 0;

    return Column(
      children: [
        // Primary Actions
        Row(
          children: [
            Expanded(
              flex: 2,
              child: ElevatedButton.icon(
                onPressed: isEnabled ? _handleSave : null,
                icon: const Icon(Icons.save_outlined, size: 20),
                label: const Text(
                  'บันทึกรายการ',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[600],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: isEnabled ? 4 : 0,
                  shadowColor: Colors.green.withOpacity(0.3),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: isEnabled ? _handlePrint : null,
                icon: const Icon(Icons.print_outlined, size: 20),
                label: const Text(
                  'พิมพ์',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: BorderSide(
                    color: isEnabled ? Colors.blue[600]! : Colors.grey[300]!,
                    width: 2,
                  ),
                  foregroundColor:
                      isEnabled ? Colors.blue[600] : Colors.grey[400],
                ),
              ),
            ),
          ],
        ),

        // Secondary Actions
        const SizedBox(height: 8),
        /*  Row(
          children: [
            Expanded(
              child: TextButton.icon(
                onPressed: _showCalculationDetails,
                icon: const Icon(Icons.info_outline, size: 18),
                label: const Text('รายละเอียด'),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  foregroundColor: Colors.grey[600],
                ),
              ),
            ),
          ],
        ),*/
      ],
    );
  }*/

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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PurchaseBloc, PurchaseState>(
      builder: (context, state) {
        double subTotal =
            CalculationFormulas.calculateSubTotal(state.cartItems);
        double discount =
            CalculationFormulas.calculateTotalDiscount(state.cartItems);
        double netAmount = subTotal - discount;
        double taxAmount =
            CalculationFormulas.calculateTax(netAmount, state.taxRate);
        double totalAmount = netAmount + taxAmount;
        // ไม่ส่ง event ใน build method เพื่อป้องกัน infinite loop
        // ใช้ค่าจาก state แทน
        return Column(
          children: [
            Text('ยอดรวม: ${CalculationFormulas.formatCurrency(subTotal)}'),
            if (discount > 0)
              Text('ส่วนลด: ${CalculationFormulas.formatCurrency(discount)}',
                  style: const TextStyle(color: Colors.red)),
            Text(
                'มูลค่าสุทธิ: ${CalculationFormulas.formatCurrency(netAmount)}'),
            Text('ภาษี: ${CalculationFormulas.formatCurrency(taxAmount)}'),
            Text(
                'ยอดรวมสุทธิ: ${CalculationFormulas.formatCurrency(totalAmount)}',
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        );
      },
    );
  }
}
