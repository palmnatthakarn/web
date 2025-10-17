import 'package:flutter/material.dart';
import 'tf.dart';

class AddItemDialog extends StatefulWidget {
  final String title;
  final List<AddItemField> fields;
  final Function(Map<String, String>) onSave;
  final Widget? customContent;

  const AddItemDialog({
    super.key,
    required this.title,
    required this.fields,
    required this.onSave,
    this.customContent,
  });

  @override
  State<AddItemDialog> createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog> {
  final _formKey = GlobalKey<FormState>();
  late Map<String, TextEditingController> _controllers;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    print('🟢 [DEBUG] AddItemDialog initState called');
    _controllers = {};
    _createControllers(widget.fields);
    print('✅ [DEBUG] All controllers created: ${_controllers.keys.toList()}');
  }
  
  void _createControllers(List<AddItemField> fields) {
    for (var field in fields) {
      print('🔑 [DEBUG] Creating controller for field: ${field.key}');
      _controllers[field.key] = TextEditingController(text: field.defaultValue ?? '');
      
      // สร้าง controllers สำหรับ row fields
      if (field.isRow && field.rowFields != null) {
        print('🔄 [DEBUG] Creating controllers for row fields in: ${field.key}');
        _createControllers(field.rowFields!);
      }
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (_formKey.currentState?.validate() != true) return;

    setState(() => _isLoading = true);

    try {
      final values = <String, String>{};
      for (var entry in _controllers.entries) {
        values[entry.key] = entry.value.text;
      }
      
      await widget.onSave(values);
      
      if (mounted) {
        Navigator.pop(context);
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
      title: Text(widget.title),
      content: SizedBox(
        width: 500,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.customContent != null) ...[
                  widget.customContent!,
                  const SizedBox(height: 16),
                ],
                ...widget.fields.map((field) => _buildField(field)),
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
        ElevatedButton(
          onPressed: _isLoading ? null : _handleSave,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF10B981),
            foregroundColor: Colors.white,
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('บันทึก'),
        ),
      ],
    );
  }

  Widget _buildField(AddItemField field) {
    print('🔨 [DEBUG] Building field: ${field.key}, isRow: ${field.isRow}');
    final controller = _controllers[field.key];
    
    if (controller == null) {
      print('❌ [DEBUG] Controller not found for field: ${field.key}');
      print('📊 [DEBUG] Available controllers: ${_controllers.keys.toList()}');
      return const SizedBox.shrink();
    }
    
    if (field.isRow && field.rowFields != null) {
      print('🔄 [DEBUG] Building row with ${field.rowFields!.length} fields');
      return Column(
        children: [
          Row(
            children: field.rowFields!.map((rowField) {
              print('🔨 [DEBUG] Building row field: ${rowField.key}');
              final rowController = _controllers[rowField.key];
              if (rowController == null) {
                print('❌ [DEBUG] Row controller not found for field: ${rowField.key}');
                return const SizedBox.shrink();
              }
              return Expanded(
                flex: rowField.flex ?? 1,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: TextFieldBuilder.simpleTf(
                    controller: rowController,
                    labelText: rowField.label,
                    validator: rowField.validator,
                    keyboardType: rowField.keyboardType,
                    maxLines: rowField.maxLines,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
        ],
      );
    }

    return Column(
      children: [
        TextFieldBuilder.simpleTf(
          controller: controller,
          labelText: field.label,
          validator: field.validator,
          keyboardType: field.keyboardType,
          maxLines: field.maxLines,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class AddItemField {
  final String key;
  final String label;
  final String? defaultValue;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final int? maxLines;
  final bool isRow;
  final List<AddItemField>? rowFields;
  final int? flex;

  const AddItemField({
    required this.key,
    required this.label,
    this.defaultValue,
    this.validator,
    this.keyboardType,
    this.maxLines,
    this.isRow = false,
    this.rowFields,
    this.flex,
  });

  static AddItemField row({
    required String key,
    required List<AddItemField> fields,
  }) {
    return AddItemField(
      key: key,
      label: '',
      isRow: true,
      rowFields: fields,
    );
  }
}