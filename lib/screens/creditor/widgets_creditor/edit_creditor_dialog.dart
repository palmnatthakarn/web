import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/creditor/creditor_bloc.dart';
import '../../../blocs/creditor/creditor_event.dart';
import '../../../blocs/creditor/creditor_state.dart';
import '../../../component/all/tf.dart';
import '../../../component/all/buildSection.dart';

class EditCreditorDialog extends StatefulWidget {
  final CreditorItem item;

  const EditCreditorDialog({super.key, required this.item});

  @override
  State<EditCreditorDialog> createState() => _EditCreditorDialogState();
}

class _EditCreditorDialogState extends State<EditCreditorDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _codeController;
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _taxIdController;
  late final TextEditingController _contactPersonController;
  late final TextEditingController _creditLimitController;
  late final TextEditingController _branchController;
  late int _selectedBranchType;
  late int _selectedPersonType;
  final _selectedGroup = TextEditingController();
  bool _isLoading = false;
  late List<TextEditingController> _addressControllers;
  List<String> _selectedImages = [];
  StreamSubscription<CreditorState>? _blocSubscription;

  @override
  void initState() {
    super.initState();

    // Initialize controllers with item values
    _codeController = TextEditingController(text: widget.item.code);
    _nameController = TextEditingController(text: widget.item.name ?? '');
    _phoneController = TextEditingController(text: widget.item.phone ?? '');
    _emailController = TextEditingController(text: widget.item.email ?? '');
    _taxIdController = TextEditingController(text: widget.item.taxId ?? '');
    _contactPersonController =
        TextEditingController(text: widget.item.contactPerson ?? '');
    _creditLimitController =
        TextEditingController(text: widget.item.creditLimit?.toString() ?? '0');
    _branchController = TextEditingController(text: widget.item.branchNumber);
    _selectedBranchType = (widget.item.branch == 'สาขาใหญ่') ? 1 : 0;
    _selectedPersonType = widget.item.personType ?? 0;

    // แยกที่อยู่ออกเป็น controllers แยกกัน
    final addresses = widget.item.address?.split('; ') ?? [''];
    _addressControllers =
        addresses.map((addr) => TextEditingController(text: addr)).toList();
    if (_addressControllers.isEmpty) {
      _addressControllers.add(TextEditingController());
    }

    // Setup listeners and subscriptions
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

  void _pickImages() async {
    setState(() {
      _selectedImages.add('image_${_selectedImages.length + 1}.jpg');
    });
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
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

  Future<void> _updateCreditor() async {
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

      final updatedItem = widget.item.copyWith(
        code: _codeController.text.trim(),
        name: _nameController.text.trim(),
        address: addresses.isNotEmpty ? addresses.join('; ') : '',
        phone: _phoneController.text.trim(),
        email: _emailController.text.trim(),
        taxId: _taxIdController.text.trim(),
        contactPerson: _contactPersonController.text.trim(),
        creditLimit: double.tryParse(_creditLimitController.text) ?? 0.0,
        personType: _selectedPersonType,
        branch: _selectedBranchType == 0 ? 'สาขา' : 'สาขาใหญ่',
        branchNumber: _branchController.text.trim().isEmpty
            ? '00000'
            : _branchController.text.trim(),
      );

      if (mounted) {
        final state = context.read<CreditorBloc>().state;
        final index = state.items.indexOf(widget.item);
        if (index >= 0) {
          context
              .read<CreditorBloc>()
              .add(CreditorItemUpdated(index, updatedItem));
        }
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('อัปเดตเจ้าหนี้สำเร็จ'),
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
      title: Row(
        children: const [
          Text('แก้ไขข้อมูลเจ้าหนี้'),
          SizedBox(width: 8),
          Icon(Icons.edit, color: Colors.black),
        ],
      ),
      content: SizedBox(
        width: 500,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SectionBuilder.buildExpandableSection(
                  title: 'ข้อมูลเจ้าหนี้',
                  icon: Icons.info_outlined,
                  child: Column(
                    children: [
                      // Creditor info form fields
                      // Add your form fields here
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SectionBuilder.buildExpandableSection(
                  title: 'ข้อมูลติดต่อ',
                  icon: Icons.contact_phone,
                  child: Column(
                    children: [
                      // Contact info form fields
                      // Add your form fields here
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
          onPressed: _isLoading ? null : _updateCreditor,
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
