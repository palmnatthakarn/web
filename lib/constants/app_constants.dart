class AppConstants {
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double tabletPadding = 24.0;
  static const double tabletBreakpoint = 768.0;
  static const double maxContentWidth = 1200.0;
  static const double cardBorderRadius = 16.0;
  static const double inputBorderRadius = 8.0;
  static const double sectionSpacing = 16.0;

  // Form Constants
  static const int maxDecimalPlaces = 2;
  static const double maxCurrencyValue = 999999999.99;
  static const double defaultTaxRate = 7.0;
  static const String defaultCurrencyFormat = "0.00";

  // Animation Constants
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const Duration debounceDelay = Duration(milliseconds: 500);

  // Validation Constants
  static const int maxInputLength = 15;
  static const String numberPattern = r'[0-9.-]';

  // Color Constants
  static const double shadowOpacity = 0.08;
  static const double cardShadowBlur = 10.0;
  static const double cardShadowOffset = 4.0;
}

class PaymentConstants {
  static const String cashPayment = 'cash';
  static const String transferPayment = 'transfer';
  static const String cardPayment = 'card';

  static const double minReceiveAmount = 0.0;
  static const double maxReceiveAmount = 999999999.99;
}

class CalculationConstants {
  static const double defaultVatRate = 7.0;
  static const double minDiscountAmount = 0.0;
  static const double maxDiscountAmount = 999999999.99;
  static const double roundingPrecision = 0.01;
}
