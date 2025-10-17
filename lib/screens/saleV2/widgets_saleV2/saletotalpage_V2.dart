import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_app/blocs/sale/sale_bloc.dart';
import 'package:flutter_web_app/blocs/sale/sale_event.dart';
import 'package:flutter_web_app/blocs/sale/sale_state.dart';
import 'package:flutter_web_app/component/all/buildSection.dart';
import 'package:flutter_web_app/component/all/enhanced_dropdown_group.dart';
import 'package:flutter_web_app/screens/purchase/widgets_purchase/calculation_formulas.dart';
import '../../../component/all/tf.dart';
import 'package:intl/intl.dart';

class SummaryAndPaymentSectionV2 extends StatefulWidget {
  const SummaryAndPaymentSectionV2({super.key});

  @override
  State<SummaryAndPaymentSectionV2> createState() =>
      _SummaryAndPaymentSectionState();
}

class _SummaryAndPaymentSectionState extends State<SummaryAndPaymentSectionV2> {
  final _formKey = GlobalKey<FormState>();
  
  // ฟังก์ชันจัดรูปแบบตัวเลขด้วยเครื่องหมายจุลภาค
  String formatNumber(double number) {
    final formatter = NumberFormat('#,##0.00');
    return formatter.format(number);
  }
  
  String formatInteger(int number) {
    final formatter = NumberFormat('#,##0');
    return formatter.format(number);
  }

  // Controllers
  final _receiveController = TextEditingController();
  final _discountController = TextEditingController();
  
  // Payment settings
  PaymentType _paymentType = PaymentType.cash;
  double _changeAmount = 0.0;

  @override
  void dispose() {
    _receiveController.dispose();
    _discountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 768;

    return BlocListener<SaleBloc, SaleState>(
      listener: (context, state) {
        _calculateChange(state);
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
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? 24 : 16,
                vertical: 16,
              ),
              child: Column(
                children: [
                  _buildTotalSummaryCard(),
                  const SizedBox(height: 16),
                  _buildPaymentSection(),
                  const SizedBox(height: 16),
                  _buildDiscountSection(),
                  const SizedBox(height: 16),
                  _buildActionButtonsSection(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTotalSummaryCard() {
    return BlocBuilder<SaleBloc, SaleState>(
      builder: (context, state) {
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green[600]!, Colors.green[700]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.green.withOpacity(0.3),
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
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'ขายสินค้า',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  '${formatNumber(state.grandTotal)} บาท',
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
            '${isPositive ? 'เงินทอน' : 'เงินไม่พอ'} ${formatNumber(changeAmount.abs())} บาท',
            style: TextStyle(
              color: isPositive ? Colors.green[100] : Colors.red[100],
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSection() {
    return SectionBuilder.buildSectionWithTrailing(
      title: 'วิธีชำระเงิน',
      icon: Icons.payment_outlined,
      headerTrailing: Container(
        constraints: const BoxConstraints(maxWidth: 200),
        child: EnhancedPaymentDropdown<PaymentType>(
          title: '',
          titleIcon: Icons.payment,
          value: _paymentType,
          items: PaymentType.values,
          getDisplayName: (type) => type.displayName,
          getIcon: (type) => type.icon,
          iconColor: Colors.green[600],
          backgroundColor: Colors.green[50],
          onChanged: (PaymentType? newValue) {
            if (newValue != null) {
              setState(() {
                _paymentType = newValue;
              });
            }
          },
        ),
      ),
      child: Column(
        children: [
          _buildInputField(
            'รับเงิน/เงินโอน',
            _receiveController,
            color: Colors.yellow[50]!,
            icon: Icons.attach_money,
          ),
        ],
      ),
    );
  }

  Widget _buildDiscountSection() {
    return SectionBuilder.buildExpandableSection(
      title: 'ส่วนลดและการปรับปรุง',
      icon: Icons.discount_outlined,
      initiallyExpanded: false,
      child: Column(
        children: [
          _buildInputField(
            'ส่วนลดรวม',
            _discountController,
            color: Colors.orange[50]!,
            icon: Icons.discount,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtonsSection() {
    return SectionBuilder.buildExpandableSection(
      title: 'การดำเนินการ',
      icon: Icons.settings_outlined,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _resetForm(),
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
                  onPressed: () => _completeSale(),
                  icon: const Icon(Icons.check_circle, size: 18),
                  label: const Text('ขายสำเร็จ'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[600],
                    foregroundColor: Colors.white,
                    elevation: 2,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

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
              borderSide: BorderSide(color: Colors.green[600]!, width: 2),
            ),
            suffixText: 'บาท',
            suffixStyle: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
            hintText: '0.00',
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
            if (controller == _receiveController) {
              final state = context.read<SaleBloc>().state;
              _calculateChange(state);
            }
          },
        ),
      ],
    );
  }

  void _calculateChange(SaleState state) {
    final receive = double.tryParse(_receiveController.text) ?? 0.0;
    final changeAmount = receive - state.grandTotal;
    
    if (_changeAmount != changeAmount) {
      setState(() {
        _changeAmount = changeAmount;
      });
      
      context.read<SaleBloc>().add(
        SalePaymentUpdated(
          receivedAmount: receive,
          changeAmount: changeAmount,
        ),
      );
    }
  }

  void _resetForm() {
    _receiveController.clear();
    _discountController.clear();
    _changeAmount = 0.0;
    context.read<SaleBloc>().add(const SaleReset());
    setState(() {});
  }

  void _completeSale() {
    if (_formKey.currentState?.validate() == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ขายสำเร็จ! 🎉'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
      _resetForm();
    }
  }
}

// Payment Type Enum
enum PaymentType {
  cash(Icons.money, 'เงินสด'),
  transfer(Icons.account_balance, 'เงินโอน'),
  qr(Icons.qr_code, 'QR'),
  creditCard(Icons.credit_card, 'บัตรเครดิต');

  const PaymentType(this.icon, this.displayName);
  final IconData icon;
  final String displayName;
}