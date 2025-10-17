import '../constants/app_constants.dart';
import '../blocs/purchase/purchase_state.dart';
import '../screens/purchase/widgets_purchase/calculation_formulas.dart';

class CalculationService {
  static CalculationService? _instance;

  CalculationService._internal();

  factory CalculationService() {
    _instance ??= CalculationService._internal();
    return _instance!;
  }

  /// Calculate totals based on VAT mode and input values
  Map<String, double> calculateTotals({
    required VatMode vatMode,
    required double grossAmount,
    required double taxableDiscount,
    required double nonTaxableDiscount,
    required double beforePaymentDiscount,
    required double roundingAmount,
    required double closeAmount,
    double taxRatePercent = CalculationConstants.defaultVatRate,
  }) {
    return CalculationFormulas.calculateTotalByVATMode(
      vatMode: vatMode,
      grossAmount: grossAmount,
      taxableDiscount: taxableDiscount,
      nonTaxableDiscount: nonTaxableDiscount,
      beforePaymentDiscount: beforePaymentDiscount,
      roundingAmount: roundingAmount,
      closeAmount: closeAmount,
      taxRatePercent: taxRatePercent,
    );
  }

  /// Calculate change amount
  double calculateChange(double receivedAmount, double grandTotal) {
    return CalculationFormulas.calculateChange(receivedAmount, grandTotal);
  }

  /// Format currency for display
  String formatCurrency(double amount) {
    return CalculationFormulas.formatCurrency(amount);
  }

  /// Validate numeric input
  ValidationResult validateNumericInput(
    String? value, {
    required String fieldName,
    bool allowNegative = false,
    bool required = false,
    double? minValue,
    double? maxValue,
  }) {
    if (required && (value?.trim().isEmpty == true)) {
      return ValidationResult.error('กรุณากรอก$fieldName');
    }

    if (value == null || value.trim().isEmpty) {
      return ValidationResult.success();
    }

    final double? parsedValue = double.tryParse(value);
    if (parsedValue == null) {
      return ValidationResult.error('กรุณากรอกตัวเลขที่ถูกต้อง');
    }

    if (!allowNegative && parsedValue < 0) {
      return ValidationResult.error('ค่าต้องไม่เป็นลบ');
    }

    if (minValue != null && parsedValue < minValue) {
      return ValidationResult.error(
          'ค่าต้องไม่น้อยกว่า ${formatCurrency(minValue)}');
    }

    if (maxValue != null && parsedValue > maxValue) {
      return ValidationResult.error(
          'ค่าต้องไม่เกิน ${formatCurrency(maxValue)}');
    }

    if (parsedValue.abs() > AppConstants.maxCurrencyValue) {
      return ValidationResult.error(
          'ค่าต้องไม่เกิน ${formatCurrency(AppConstants.maxCurrencyValue)}');
    }

    return ValidationResult.success();
  }

  /// Parse double from string with default value
  double parseDouble(String? value, {double defaultValue = 0.0}) {
    if (value == null || value.trim().isEmpty) {
      return defaultValue;
    }
    return double.tryParse(value) ?? defaultValue;
  }

  /// Check if value has changed significantly (for optimization)
  bool hasSignificantChange(double oldValue, double newValue,
      {double threshold = 0.01}) {
    return (oldValue - newValue).abs() > threshold;
  }

  /// Round to currency precision
  double roundToCurrency(double value) {
    return double.parse(value.toStringAsFixed(AppConstants.maxDecimalPlaces));
  }
}

class ValidationResult {
  final bool isValid;
  final String? errorMessage;

  ValidationResult._(this.isValid, this.errorMessage);

  factory ValidationResult.success() => ValidationResult._(true, null);
  factory ValidationResult.error(String message) =>
      ValidationResult._(false, message);
}
