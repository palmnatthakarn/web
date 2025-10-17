import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_app/component/all/enhanced_dropdown_group.dart';
import '../../../blocs/creditor/creditor_bloc.dart';
import '../../../blocs/creditor/creditor_event.dart';
import '../../../blocs/creditor/creditor_state.dart';
import '../../../component/all/tf.dart';
import '../../../component/all/buildSection.dart';

class AddCreditorDialog extends StatefulWidget {
  const AddCreditorDialog({super.key});

  @override
  State<AddCreditorDialog> createState() => _AddCreditorDialogState();
}

class _AddCreditorDialogState extends State<AddCreditorDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _codeController;
  late final TextEditingController _nameController;
  late final TextEditingController _addressController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _taxIdController;
  late final TextEditingController _contactPersonController;
  late final TextEditingController _creditLimitController;
  late final TextEditingController _branchController;
  int _selectedBranchType = 0;
  int _selectedPersonType = 0;
  final _selectedGroup = TextEditingController();
  bool _isLoading = false;
  final List<TextEditingController> _addressControllers = [
    TextEditingController()
  ];
  final List<String> _selectedImages = [];
  StreamSubscription<CreditorState>? _blocSubscription;

  @override
  void initState() {
    super.initState();
    final state = context.read<CreditorBloc>().state;

    // Initialize controllers with current state values
    _codeController = TextEditingController(text: state.creditorCode);
    _nameController = TextEditingController(text: state.creditorName);
    _addressController = TextEditingController(text: state.address);
    _phoneController = TextEditingController(text: state.phone);
    _emailController = TextEditingController(text: state.email);
    _taxIdController = TextEditingController(text: state.taxId);
    _contactPersonController = TextEditingController(text: state.contactPerson);
    _creditLimitController = TextEditingController();
    _branchController = TextEditingController();

    // Add listeners to sync with bloc state
    _setupListeners();
    _subscribeToBloc();
  }

  void _setupListeners() {
    // Add listeners for text changes
    _codeController
        .addListener(() => _onFieldChanged('code', _codeController.text));
    _nameController
        .addListener(() => _onFieldChanged('name', _nameController.text));
    _phoneController
        .addListener(() => _onFieldChanged('phone', _phoneController.text));
    _emailController
        .addListener(() => _onFieldChanged('email', _emailController.text));
    _taxIdController
        .addListener(() => _onFieldChanged('taxId', _taxIdController.text));
    _contactPersonController.addListener(
        () => _onFieldChanged('contactPerson', _contactPersonController.text));
  }

  void _onFieldChanged(String field, String value) {
    if (!mounted) return;

    final event = CreditorFormUpdated(
      creditorCode: field == 'code' ? value : null,
      creditorName: field == 'name' ? value : null,
      phone: field == 'phone' ? value : null,
      email: field == 'email' ? value : null,
      taxId: field == 'taxId' ? value : null,
      contactPerson: field == 'contactPerson' ? value : null,
    );

    context.read<CreditorBloc>().add(event);
  }

  void _subscribeToBloc() {
    _blocSubscription = context.read<CreditorBloc>().stream.listen((state) {
      if (!mounted) return;

      // Only update if values are different to avoid loops
      if (_codeController.text != state.creditorCode) {
        _codeController.text = state.creditorCode;
      }
      if (_nameController.text != state.creditorName) {
        _nameController.text = state.creditorName;
      }
      if (_phoneController.text != state.phone) {
        _phoneController.text = state.phone;
      }
      if (_emailController.text != state.email) {
        _emailController.text = state.email;
      }
      if (_taxIdController.text != state.taxId) {
        _taxIdController.text = state.taxId;
      }
      if (_contactPersonController.text != state.contactPerson) {
        _contactPersonController.text = state.contactPerson;
      }
    });
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _taxIdController.dispose();
    _contactPersonController.dispose();
    _creditLimitController.dispose();
    _branchController.dispose();
    _selectedGroup.dispose();
    _blocSubscription?.cancel();

    for (var controller in _addressControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addAddressField() {
    setState(() {
      _addressControllers.add(TextEditingController());
    });
  }

  void _removeAddressField(int index) {
    if (_addressControllers.length > 1) {
      setState(() {
        _addressControllers[index].dispose();
        _addressControllers.removeAt(index);
      });
    }
  }

  Future<void> _saveCreditor() async {
    if (_codeController.text.isEmpty || _nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('กรุณากรอกรหัสและชื่อเจ้าหนี้'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final addresses = _addressControllers
          .map((controller) => controller.text)
          .where((text) => text.isNotEmpty)
          .toList();

      final newItem = CreditorItem(
        code: _codeController.text.trim(),
        name: _nameController.text.trim(),
        address: addresses.isNotEmpty ? addresses.join('; ') : '',
        phone: _phoneController.text.trim(),
        email: _emailController.text.trim(),
        taxId: _taxIdController.text.trim(),
        contactPerson: _contactPersonController.text.trim(),
        creditLimit: double.tryParse(_creditLimitController.text) ?? 0.0,
        currentBalance: 0.0,
        createdDate: DateTime.now(),
        personType: _selectedPersonType,
        branch: _selectedBranchType == 0 ? 'สาขา' : 'สาขาใหญ่',
        branchNumber: _branchController.text.trim().isEmpty
            ? '00000'
            : _branchController.text.trim(),
      );

      if (mounted) {
        context.read<CreditorBloc>().add(CreditorItemAdded(newItem));
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('เพิ่มเจ้าหนี้สำเร็จ'),
            backgroundColor: Color(0xFF10B981),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('เกิดข้อผิดพลาด: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('เพิ่มเจ้าหนี้ใหม่'),
      content: SizedBox(
        width: 500,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ...existing code...
                SectionBuilder.buildExpandableSection(
                  title: 'ข้อมูลเจ้าหนี้',
                  icon: Icons.info_outlined,
                  child: Column(
                    children: [
                      TextFieldBuilder.simpleTf(
                        labelText: 'รหัสเจ้าหนี้',
                        controller: _codeController,
                        required: true,
                      ),
                      const SizedBox(height: 16),
                      TextFieldBuilder.simpleTf(
                        labelText: 'ชื่อเจ้าหนี้',
                        controller: _nameController,
                        required: true,
                      ),
                      const SizedBox(height: 16),
                      EnhancedDropdownGroup(
                        title: 'ประเภท',
                        icon: Icons.person,
                        color: Colors.blue,
                        options: const ['บุคคลธรรมดา', 'นิติบุคคล'],
                        selectedValue: _selectedPersonType + 1,
                        onChanged: (value) {
                          setState(() {
                            _selectedPersonType = value - 1;
                            if (value == 2) {
                              _selectedBranchType = 1;
                              _branchController.text = '00000';
                            }
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFieldBuilder.simpleTfonlyNum(
                        labelText: _selectedPersonType == 1
                            ? 'เลขที่ผู้เสียภาษี'
                            : 'เลขที่บัตรประจำตัวประชาชน',
                        controller: _taxIdController,
                      ),
                      const SizedBox(height: 16),
                      EnhancedDropdownGroup(
                        title: 'สาขา',
                        icon: Icons.business,
                        color: Colors.green,
                        options: const ['สาขา', 'สาขาใหญ่'],
                        selectedValue: _selectedBranchType + 1,
                        onChanged: (value) {
                          setState(() {
                            _selectedBranchType = value - 1;
                            if (value == 2) {
                              _branchController.text = '00000';
                            }
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFieldBuilder.simpleTfonlyNum(
                        labelText: 'เลขสาขา',
                        controller: _branchController,
                        maxLength: 5,
                      ),
                      const SizedBox(height: 16),
                      TextFieldBuilder.simpleTfonlyNum(
                        labelText: 'วงเงินเครดิต',
                        controller: _creditLimitController,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SectionBuilder.buildExpandableSection(
                  title: 'ข้อมูลติดต่อ',
                  icon: Icons.contact_phone,
                  child: Column(
                    children: [
                      TextFieldBuilder.simpleTf(
                        labelText: 'ชื่อผู้ติดต่อ',
                        controller: _contactPersonController,
                      ),
                      const SizedBox(height: 16),
                      TextFieldBuilder.simpleTf(
                        labelText: 'เบอร์โทรศัพท์หลัก',
                        controller: _phoneController,
                      ),
                      const SizedBox(height: 16),
                      TextFieldBuilder.simpleTf(
                        labelText: 'อีเมล',
                        controller: _emailController,
                      ),
                      const SizedBox(height: 16),
                      ..._addressControllers.asMap().entries.map((entry) {
                        final index = entry.key;
                        final controller = entry.value;
                        return Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: TextFieldBuilder.simpleTf(
                                    labelText: 'ที่อยู่ ${index + 1}',
                                    controller: controller,
                                  ),
                                ),
                                if (_addressControllers.length > 1)
                                  IconButton(
                                    icon:
                                        const Icon(Icons.remove_circle_outline),
                                    onPressed: () => _removeAddressField(index),
                                    color: Colors.red,
                                  ),
                              ],
                            ),
                            const SizedBox(height: 16),
                          ],
                        );
                      }),
                      ElevatedButton.icon(
                        onPressed: _addAddressField,
                        icon: const Icon(Icons.add),
                        label: const Text('เพิ่มที่อยู่'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: const Text('ยกเลิก'),
        ),
        ElevatedButton.icon(
          onPressed: _isLoading ? null : _saveCreditor,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF10B981),
            foregroundColor: Colors.white,
          ),
          icon: _isLoading
              ? const SizedBox(height: 20, width: 20)
              : const Icon(Icons.save),
          label:
              _isLoading ? const Text('กำลังบันทึก...') : const Text('บันทึก'),
        ),
      ],
    );
  }
}
