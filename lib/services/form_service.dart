import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_constants.dart';
import '../constants/app_strings.dart';
import 'calculation_service.dart';

class FormService {
  static FormService? _instance;

  FormService._internal();

  factory FormService() {
    _instance ??= FormService._internal();
    return _instance!;
  }

  final CalculationService _calculationService = CalculationService();

  /// Create input formatters for numeric fields
  List<TextInputFormatter> getNumericInputFormatters(
      {bool allowNegative = false}) {
    return [
      FilteringTextInputFormatter.allow(
          RegExp(allowNegative ? r'[0-9.-]' : r'[0-9.]')),
      TextInputFormatter.withFunction((oldValue, newValue) {
        return _validateNumericFormat(oldValue, newValue, allowNegative);
      }),
    ];
  }

  /// Validate numeric format during input
  TextEditingValue _validateNumericFormat(TextEditingValue oldValue,
      TextEditingValue newValue, bool allowNegative) {
    if (newValue.text.isEmpty) return newValue;

    // Check negative sign position
    if (allowNegative &&
        newValue.text.contains('-') &&
        !newValue.text.startsWith('-')) {
      return oldValue;
    }

    // Check decimal points
    if (newValue.text.split('.').length > 2) {
      return oldValue;
    }

    // Limit decimal places
    if (newValue.text.contains('.')) {
      final parts = newValue.text.split('.');
      if (parts.length == 2 &&
          parts[1].length > AppConstants.maxDecimalPlaces) {
        return oldValue;
      }
    }

    // Validate as number
    final double? value = double.tryParse(newValue.text);
    if (value == null && newValue.text != '-' && newValue.text != '.') {
      return oldValue;
    }

    return newValue;
  }

  /// Create input decoration for form fields
  InputDecoration createInputDecoration({
    required String label,
    required Color fillColor,
    String? hintText,
    String? suffixText,
    Widget? suffixIcon,
    bool showCurrency = true,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hintText,
      filled: true,
      fillColor: fillColor,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.inputBorderRadius),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.inputBorderRadius),
        borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.inputBorderRadius),
        borderSide: BorderSide(color: Colors.blue[600]!, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.inputBorderRadius),
        borderSide: BorderSide(color: Colors.red[400]!, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.inputBorderRadius),
        borderSide: BorderSide(color: Colors.red[600]!, width: 2),
      ),
      suffixText:
          showCurrency ? (suffixText ?? AppStrings.currencySymbol) : suffixText,
      suffixStyle: TextStyle(
        color: Colors.grey[600],
        fontSize: 12,
      ),
      suffixIcon: suffixIcon,
    );
  }

  /// Create validator for form fields
  String? Function(String?) createValidator({
    required String fieldName,
    bool required = false,
    bool allowNegative = false,
    double? minValue,
    double? maxValue,
  }) {
    return (String? value) {
      final result = _calculationService.validateNumericInput(
        value,
        fieldName: fieldName,
        required: required,
        allowNegative: allowNegative,
        minValue: minValue,
        maxValue: maxValue,
      );

      return result.isValid ? null : result.errorMessage;
    };
  }

  /// Handle tap to select all text
  void handleTapToSelectAll(TextEditingController controller) {
    if (controller.text.isNotEmpty) {
      controller.selection = TextSelection(
        baseOffset: 0,
        extentOffset: controller.text.length,
      );
    }
  }

  /// Create text style for form fields
  TextStyle getFormFieldTextStyle({bool isNumeric = false}) {
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
    );
  }

  /// Get text alignment for form fields
  TextAlign getTextAlignment({bool isNumeric = false}) {
    return isNumeric ? TextAlign.right : TextAlign.start;
  }

  /// Create keyboard type for form fields
  TextInputType getKeyboardType({bool isNumeric = false}) {
    return isNumeric
        ? const TextInputType.numberWithOptions(decimal: true, signed: true)
        : TextInputType.text;
  }
}
