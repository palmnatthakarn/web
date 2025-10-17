import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_app/blocs/purchase/purchase_bloc.dart';
import 'package:flutter_web_app/blocs/purchase/purchase_state.dart';
import 'package:flutter_web_app/blocs/purchase/purchase_event.dart';
import '../../../component/all/form_components.dart';
import '../../../component/all/tf.dart';
import '../../../component/all/enhanced_dropdown_group.dart';

class PurchaseFormPage_V2 extends StatefulWidget {
  const PurchaseFormPage_V2({super.key});

  @override
  State<PurchaseFormPage_V2> createState() => _PurchaseFormPageState();
}

class _PurchaseFormPageState extends State<PurchaseFormPage_V2>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Form controllers with focus nodes for better navigation
  final _creditorNameController = TextEditingController();
  final _creditorCodeController = TextEditingController();
  final _employeeCodeController = TextEditingController();
  final _employeeNameController = TextEditingController();
  final _branchController = TextEditingController();
  final _referenceDocController = TextEditingController();
  final _taxInvoiceController = TextEditingController();
  final _remarksController = TextEditingController();
  final _taxRateController = TextEditingController();

  // Focus nodes for keyboard navigation (keeping only tax rate focus)
  final _taxRateFocus = FocusNode();

  // Form state
  int _selectedTaxType = 1;
  int _selectedPaymentType = 1;
  String? _selectedBranch;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  DateTime _selectedReferenceDate = DateTime.now();
  DateTime _selectedTaxInvoiceDate = DateTime.now();

  // UI state
  bool _isLoading = false;
  bool _autoValidate = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();

    _addListeners();
    _setupFocusNavigation();
    _updateForm(); // ส่งข้อมูลเริ่มต้น
  }

  void _addListeners() {
    _creditorNameController.addListener(_updateForm);
    _creditorCodeController.addListener(_updateForm);
    _employeeCodeController.addListener(_updateForm);
    _employeeNameController.addListener(_updateForm);
    _branchController.addListener(_updateForm);
    _referenceDocController.addListener(_updateForm);
    _taxInvoiceController.addListener(_updateForm);
    _remarksController.addListener(_updateForm);
    _taxRateController.addListener(_updateForm);
  }

  void _setupFocusNavigation() {
    // Setup focus navigation for tax rate input
  }

  void _updateForm() {
    if (mounted) {
      context.read<PurchaseBloc>().add(PurchaseFormUpdated(
            creditorName: _creditorNameController.text,
            creditorCode: _creditorCodeController.text,
            employeeCode: _employeeCodeController.text,
            employeeName: _employeeNameController.text,
            branch: _branchController.text,
            referenceDoc: _referenceDocController.text,
            taxInvoice: _taxInvoiceController.text,
            remarks: _remarksController.text,
            taxRate: _taxRateController.text,
            taxType: _selectedTaxType,
            paymentType: _selectedPaymentType,
            documentDate: _selectedDate,
            documentTime: _selectedTime,
            referenceDate: _selectedReferenceDate,
            taxinvoiceDate: _selectedTaxInvoiceDate,
          ));
    }
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();

    // Dispose controllers
    _creditorNameController.dispose();
    _creditorCodeController.dispose();
    _employeeCodeController.dispose();
    _employeeNameController.dispose();
    _branchController.dispose();
    _referenceDocController.dispose();
    _taxInvoiceController.dispose();
    _remarksController.dispose();
    _taxRateController.dispose();

    // Dispose focus nodes
    _taxRateFocus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      floatingActionButton: _buildNextButton(),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            // Progress indicator
            if (_isLoading)
              const LinearProgressIndicator(
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3B82F6)),
              ),

            Expanded(
              child: BlocBuilder<PurchaseBloc, PurchaseState>(
                builder: (context, state) {
                  return Form(
                    key: _formKey,
                    autovalidateMode: _autoValidate
                        ? AutovalidateMode.onUserInteraction
                        : AutovalidateMode.disabled,
                    child: Scrollbar(
                      controller: _scrollController,
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            minWidth: double.infinity, // ยืดเต็ม
                            maxWidth: double.infinity, // ล็อกให้เต็ม
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildDocumentInfoSection(),
                              const SizedBox(height: 20),
                              _buildTypeSection(),
                              const SizedBox(height: 20),
                              _buildReferenceDocSection(),
                              const SizedBox(height: 32),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentInfoSection() {
    return SectionBuilder.buildSectionWithTrailing(
      title: 'ข้อมูลเอกสาร',
      icon: Icons.description_outlined,
      headerTrailing: DropdownButton<String>(
        value: _selectedBranch,
        underline: const SizedBox(), // 👈 เอาเส้นใต้ออก

        hint: const Text('เลือกสาขา'),
        items: ['สาขาหลัก', 'สาขา 1', 'สาขา 2', 'สาขา 3']
            .map((branch) => DropdownMenuItem(
                  value: branch,
                  child: Text(branch),
                ))
            .toList(),
        onChanged: (value) => setState(() {
          _selectedBranch = value;
          _branchController.text = value ?? '';
          _updateForm();
        }),
      ),
      child: Column(
        children: [
          // Date and Time Row
          Row(
            children: [
              Expanded(
                flex: 2,
                child: DatePickerField(
                  label: 'วันที่เอกสาร',
                  selectedDate: _selectedDate,
                  onChanged: (date) => setState(() {
                    _selectedDate = date;
                    _updateForm();
                  }),
                  isRequired: true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: TimePickerField(
                  label: 'เวลา',
                  selectedTime: _selectedTime,
                  onChanged: (time) => setState(() {
                    _selectedTime = time;
                    _updateForm();
                  }),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Creditor Information Row
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextFieldBuilder.simpleTf(
                  labelText: 'รหัสเจ้าหนี้',
                  controller: _creditorCodeController,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: TextFieldBuilder.simpleTf(
                  labelText: 'ชื่อเจ้าหนี้',
                  controller: _creditorNameController,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Employee Information Row
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextFieldBuilder.simpleTf(
                  labelText: 'รหัสพนักงาน',
                  controller: _employeeCodeController,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: TextFieldBuilder.simpleTf(
                  labelText: 'ชื่อพนักงาน',
                  controller: _employeeNameController,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTypeSection() {
    return SectionBuilder.buildSection(
      title: 'ประเภทและข้อมูลภาษี',
      icon: Icons.category_outlined,
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Responsive layout - stack on smaller screens
          if (constraints.maxWidth < 300) {
            return Column(
              children: [
                EnhancedDropdownGroup(
                  title: 'ประเภทภาษี',
                  icon: Icons.receipt_outlined,
                  color: Colors.blue,
                  options: [
                    'ราคาไม่รวมภาษี',
                    'ราคารวมภาษี',
                    'ภาษีอัตราศูนย์',
                    'ไม่กระทบภาษี'
                  ],
                  selectedValue: _selectedTaxType,
                  onChanged: (value) => setState(() {
                    _selectedTaxType = value;
                    _updateForm();
                  }),
                  hint: 'เลือกประเภทภาษี',
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    EnhancedDropdownGroup(
                      title: 'ประเภทการชำระ',
                      icon: Icons.payment_outlined,
                      color: Colors.green,
                      options: ['เครดิต', 'เงินสด'],
                      selectedValue: _selectedPaymentType,
                      onChanged: (value) => setState(() {
                        _selectedPaymentType = value;
                        _updateForm();
                      }),
                      hint: 'เลือกประเภทการชำระ',
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildEnhancedTaxRateInput(),
                    ),
                  ],
                ),
              ],
            );
          }
          // Desktop layout
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: EnhancedDropdownGroup(
                  title: 'ประเภทภาษี',
                  icon: Icons.receipt_outlined,
                  color: Colors.blue,
                  options: [
                    'ราคาไม่รวมภาษี',
                    'ราคารวมภาษี',
                    'ภาษีอัตราศูนย์',
                    'ไม่กระทบภาษี'
                  ],
                  selectedValue: _selectedTaxType,
                  onChanged: (value) => setState(() {
                    _selectedTaxType = value;
                    _updateForm();
                  }),
                  hint: 'เลือกประเภทภาษี',
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                flex: 2,
                child: EnhancedDropdownGroup(
                  title: 'ประเภทการชำระ',
                  icon: Icons.payment_outlined,
                  color: Colors.green,
                  options: ['เครดิต', 'เงินสด'],
                  selectedValue: _selectedPaymentType,
                  onChanged: (value) => setState(() {
                    _selectedPaymentType = value;
                    _updateForm();
                  }),
                  hint: 'เลือกประเภทการชำระ',
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                flex: 2,
                child: _buildEnhancedTaxRateInput(),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildReferenceDocSection() {
    return SectionBuilder.buildSection(
      title: 'เอกสารอ้างอิงและข้อมูลเพิ่มเติม',
      icon: Icons.folder_outlined,
      child: Column(
        children: [
          // Branch field
          /*  TextFieldBuilder.simpleTf(
            'สาขา',
            _branchController,
          ),
          const SizedBox(height: 16),*/
          // Reference document row
          Row(
            crossAxisAlignment:
                CrossAxisAlignment.end, // ⬅️ ดันลูกทุกตัวให้ชิดล่างเท่ากัน
            children: [
              Expanded(
                child: DatePickerField(
                  label: 'วันที่เอกสารอ้างอิง',
                  selectedDate: _selectedReferenceDate,
                  onChanged: (date) => setState(() {
                    _selectedReferenceDate = date;
                    _updateForm();
                  }),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DatePickerField(
                  label: 'วันที่ใบกำกับภาษี',
                  selectedDate: _selectedTaxInvoiceDate,
                  onChanged: (date) => setState(() {
                    _selectedTaxInvoiceDate = date;
                    _updateForm();
                  }),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Tax invoice row
          Row(
            crossAxisAlignment:
                CrossAxisAlignment.end, // ⬅️ ดันลูกทุกตัวให้ชิดล่างเท่ากัน
            children: [
              Expanded(
                child: TextFieldBuilder.simpleTf(
                  labelText: 'เลขที่ใบกำกับภาษี',
                  controller: _taxInvoiceController,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFieldBuilder.simpleTf(
                  labelText: 'เลขที่เอกสารอ้างอิง',
                  controller: _referenceDocController,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Remarks field
          TextFieldBuilder.simpleTf(
            labelText: 'หมายเหตุ',
            controller: _remarksController,
          ),
        ],
      ),
    );
  }

  Widget _buildNextButton() {
    return Container(
      width: 45,
      height: 45,
      child: FloatingActionButton(
        onPressed: () {
          // Navigate to next tab or page
          DefaultTabController.of(context)?.animateTo(1);
        },
        backgroundColor: Colors.blue[600],
        child: const Icon(Icons.arrow_forward_ios, color: Colors.white),
      ),
    );
  }

  Widget _buildEnhancedTaxRateInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.percent_outlined, size: 18, color: Colors.orange[600]),
            const SizedBox(width: 8),
            const Text(
              'อัตราภาษี',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          height: 40,
          child: TextFormField(
            controller: _taxRateController,
            focusNode: _taxRateFocus,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: const TextStyle(fontSize: 14),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
            ],
            decoration: InputDecoration(
              hintText: 'กรอกอัตราภาษี',
              suffixIcon: Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 7),
                child: Text(
                  '%',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.orange[600],
                  ),
                ),
              ),
              prefixIcon:
                  Icon(Icons.percent, color: Colors.orange[600], size: 20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.orange[600]!,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              filled: true,
              fillColor: _taxRateFocus.hasFocus
                  ? Colors.orange[50]
                  : const Color(0xFFF9FAFB),
            ),
            validator: (value) {
              if (value?.isNotEmpty == true) {
                final rate = double.tryParse(value!);
                if (rate == null || rate < 0 || rate > 100) {
                  return 'กรุณากรอกอัตราภาษี 0-100%';
                }
              }
              return null;
            },
            onChanged: (value) => _updateForm(),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Clear all button
          TextButton.icon(
            onPressed: _isLoading ? null : () => _showClearAllConfirmation(),
            icon: const Icon(Icons.clear_all, color: Colors.red),
            label: const Text(
              'ล้างทั้งหมด',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
            ),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),

          // Action buttons
          Row(
            children: [
              // Save draft button
              OutlinedButton.icon(
                onPressed: _isLoading ? null : () => _saveDraft(),
                icon: _isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save_outlined),
                label: const Text('บันทึกร่าง'),
                style: OutlinedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  side: const BorderSide(color: Color(0xFF3B82F6)),
                  foregroundColor: const Color(0xFF3B82F6),
                ),
              ),
              const SizedBox(width: 12),

              // Submit button
              ElevatedButton.icon(
                onPressed: _isLoading ? null : () => _submitForm(),
                icon: _isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Icon(Icons.shopping_cart_checkout),
                label: Text(_isLoading ? 'กำลังดำเนินการ...' : 'ดำเนินการซื้อ'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  elevation: 2,
                  shadowColor: const Color(0xFF10B981).withOpacity(0.3),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showClearAllConfirmation() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28),
            SizedBox(width: 12),
            Text('ยืนยันการล้างทั้งหมด'),
          ],
        ),
        content: const Text(
          'ต้องการลบรายการทั้งหมดหรือไม่? การดำเนินการนี้ไม่สามารถย้อนกลับได้',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('ยกเลิก'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              _clearAllFields();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('ล้างทั้งหมด'),
          ),
        ],
      ),
    );
  }

  void _clearAllFields() {
    setState(() {
      _creditorNameController.clear();
      _creditorCodeController.clear();
      _employeeCodeController.clear();
      _employeeNameController.clear();
      _branchController.clear();
      _referenceDocController.clear();
      _taxInvoiceController.clear();
      _remarksController.clear();
      _taxRateController.clear();
      _selectedTaxType = 1;
      _selectedPaymentType = 1;
      _selectedDate = DateTime.now();
      _selectedTime = TimeOfDay.now();
      _selectedReferenceDate = DateTime.now();
      _selectedTaxInvoiceDate = DateTime.now();
    });
    _updateForm();
    _showSuccessMessage('ล้างรายการทั้งหมดสำเร็จ');
  }

  void _saveDraft() async {
    setState(() => _isLoading = true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    setState(() => _isLoading = false);
    _showSuccessMessage('บันทึกแบบร่างเรียบร้อยแล้ว');
  }

  void _submitForm() async {
    setState(() {
      _autoValidate = true;
      _isLoading = true;
    });

    if (_formKey.currentState?.validate() ?? false) {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      setState(() => _isLoading = false);
      _showSuccessMessage('ส่งข้อมูลเรียบร้อยแล้ว');
    } else {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 8),
              Text('กรุณากรอกข้อมูลให้ครบถ้วน'),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }
}
