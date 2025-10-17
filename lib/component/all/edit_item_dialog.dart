import 'package:flutter/material.dart';
import 'tf.dart';

class EditItemDialog extends StatefulWidget {
  final String title;
  final List<EditItemField> fields;
  final Function(Map<String, String>) onSave;
  final Widget? customContent;

  const EditItemDialog({
    super.key,
    required this.title,
    required this.fields,
    required this.onSave,
    this.customContent,
  });

  @override
  State<EditItemDialog> createState() => _EditItemDialogState();
}

class _EditItemDialogState extends State<EditItemDialog> {
  final _formKey = GlobalKey<FormState>();
  late Map<String, TextEditingController> _controllers;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controllers = {};
    for (var field in widget.fields) {
      _controllers[field.key] = TextEditingController(text: field.initialValue ?? '');
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
    if (!_formKey.currentState!.validate()) return;

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
      title: Row(
        children: [
          const SizedBox(width: 8),
          Text(widget.title),
          const SizedBox(width: 5),
          const Icon(Icons.edit, color: Colors.black),
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

  Widget _buildField(EditItemField field) {
    final controller = _controllers[field.key]!;
    
    if (field.isReadOnly) {
      return Column(
        children: [
          _buildReadOnlyTextField(field.label, controller),
          const SizedBox(height: 16),
        ],
      );
    }

    if (field.isRow && field.rowFields != null) {
      return Column(
        children: [
          Row(
            children: field.rowFields!.map((rowField) {
              final rowController = _controllers[rowField.key]!;
              return Expanded(
                flex: rowField.flex ?? 1,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: rowField.isReadOnly
                      ? _buildReadOnlyTextField(rowField.label, rowController)
                      : TextFieldBuilder.simpleTf(
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

  Widget _buildReadOnlyTextField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      enabled: false,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF10B981)),
        ),
        filled: true,
        fillColor: Colors.grey.shade100,
      ),
    );
  }
}

class EditItemField {
  final String key;
  final String label;
  final String? initialValue;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final int? maxLines;
  final bool isRow;
  final bool isReadOnly;
  final List<EditItemField>? rowFields;
  final int? flex;

  const EditItemField({
    required this.key,
    required this.label,
    this.initialValue,
    this.validator,
    this.keyboardType,
    this.maxLines,
    this.isRow = false,
    this.isReadOnly = false,
    this.rowFields,
    this.flex,
  });

  static EditItemField row({
    required String key,
    required List<EditItemField> fields,
  }) {
    return EditItemField(
      key: key,
      label: '',
      isRow: true,
      rowFields: fields,
    );
  }

  static EditItemField readOnly({
    required String key,
    required String label,
    String? initialValue,
  }) {
    return EditItemField(
      key: key,
      label: label,
      initialValue: initialValue,
      isReadOnly: true,
    );
  }
}