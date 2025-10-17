import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_web_app/blocs/purchase/purchase_state.dart';
import 'package:flutter_web_app/screens/purchase/widgets_purchase/calculation_formulas.dart';

void main() {
  group('CalculationFormulas Tests', () {
    group('VAT Calculation Tests', () {
      test('calculateVAT should calculate VAT correctly', () {
        // Test case: 100 บาท × 7% = 7 บาท
        expect(
            CalculationFormulas.calculateVAT(100.0, 7.0), closeTo(7.0, 0.01));

        // Test case: 1000 บาท × 10% = 100 บาท
        expect(CalculationFormulas.calculateVAT(1000.0, 10.0),
            closeTo(100.0, 0.01));

        // Test case: 0% VAT
        expect(CalculationFormulas.calculateVAT(100.0, 0.0), equals(0.0));
      });

      test(
          'calculateTaxBaseFromInclusivePrice should extract tax base correctly',
          () {
        // Test case: ราคารวม VAT 107 บาท, อัตรา 7% → ฐานภาษี 100 บาท
        final result =
            CalculationFormulas.calculateTaxBaseFromInclusivePrice(107.0, 7.0);
        expect(result, closeTo(100.0, 0.01));

        // Test case: ราคารวม VAT 1100 บาท, อัตรา 10% → ฐานภาษี 1000 บาท
        final result2 = CalculationFormulas.calculateTaxBaseFromInclusivePrice(
            1100.0, 10.0);
        expect(result2, closeTo(1000.0, 0.01));
      });
    });

    group('VAT Mode Calculation Tests', () {
      test('calculateInclusiveVATMode should calculate correctly', () {
        // Test case: โหมด A (รวม VAT)
        // ยอดรวม 107 บาท, ส่วนลดสินค้า 7 บาท, อัตรา VAT 7%
        final result = CalculationFormulas.calculateInclusiveVATMode(
          grossAmount: 107.0,
          taxableDiscount: 7.0,
          nonTaxableDiscount: 0.0,
          beforePaymentDiscount: 0.0,
          roundingAmount: 0.0,
          closeAmount: 0.0,
          taxRatePercent: 7.0,
        );

        // หลังหักส่วนลด = 107 - 7 = 100 บาท (รวม VAT)
        // ฐานภาษี = 100 ÷ 1.07 ≈ 93.46 บาท
        // VAT = 93.46 × 0.07 ≈ 6.54 บาท
        expect(result['afterItemStage'], equals(100.0));
        expect(result['beforeVat']!, closeTo(93.46, 0.01));
        expect(result['vatAmount']!, closeTo(6.54, 0.01));
        expect(result['grandTotal'], equals(100.0));
      });

      test('calculateExclusiveVATMode should calculate correctly', () {
        // Test case: โหมด B (ไม่รวม VAT)
        // ยอดรวม 100 บาท (ยังไม่รวม VAT), ส่วนลดสินค้า 0 บาท, อัตรา VAT 7%
        final result = CalculationFormulas.calculateExclusiveVATMode(
          grossAmount: 100.0,
          taxableDiscount: 0.0,
          nonTaxableDiscount: 0.0,
          beforePaymentDiscount: 0.0,
          roundingAmount: 0.0,
          closeAmount: 0.0,
          taxRatePercent: 7.0,
        );

        // ฐานภาษี = 100 บาท
        // VAT = 100 × 0.07 = 7 บาท
        // ยอดรวม = 100 + 7 = 107 บาท
        expect(result['beforeVat'], equals(100.0));
        expect(result['vatAmount'], closeTo(7.0, 0.01));
        expect(result['grandTotal'], closeTo(107.0, 0.01));
      });

      test('calculateTotalByVATMode should route to correct calculation method',
          () {
        // Test inclusive mode
        final inclusiveResult = CalculationFormulas.calculateTotalByVATMode(
          vatMode: VatMode.inclusive,
          grossAmount: 107.0,
          taxableDiscount: 0.0,
          nonTaxableDiscount: 0.0,
          beforePaymentDiscount: 0.0,
          roundingAmount: 0.0,
          closeAmount: 0.0,
          taxRatePercent: 7.0,
        );

        // Test exclusive mode
        final exclusiveResult = CalculationFormulas.calculateTotalByVATMode(
          vatMode: VatMode.exclusive,
          grossAmount: 100.0,
          taxableDiscount: 0.0,
          nonTaxableDiscount: 0.0,
          beforePaymentDiscount: 0.0,
          roundingAmount: 0.0,
          closeAmount: 0.0,
          taxRatePercent: 7.0,
        );

        // Both should result in similar grand totals (around 107)
        expect(inclusiveResult['grandTotal'], closeTo(107.0, 0.01));
        expect(exclusiveResult['grandTotal'], closeTo(107.0, 0.01));
      });
    });

    group('Discount Calculation Tests', () {
      test('calculateDiscountPercentage should calculate percentage correctly',
          () {
        // 20 บาทส่วนลดจาก 100 บาท = 20%
        expect(CalculationFormulas.calculateDiscountPercentage(100.0, 20.0),
            equals(20.0));

        // 50 บาทส่วนลดจาก 200 บาท = 25%
        expect(CalculationFormulas.calculateDiscountPercentage(200.0, 50.0),
            equals(25.0));

        // Edge case: 0 amount
        expect(CalculationFormulas.calculateDiscountPercentage(0.0, 10.0),
            equals(0.0));
      });

      test('calculateDiscountAmount should calculate amount correctly', () {
        // 20% ส่วนลดจาก 100 บาท = 20 บาท
        expect(CalculationFormulas.calculateDiscountAmount(100.0, 20.0),
            equals(20.0));

        // 15% ส่วนลดจาก 200 บาท = 30 บาท
        expect(CalculationFormulas.calculateDiscountAmount(200.0, 15.0),
            equals(30.0));
      });

      test('calculatePriceAfterDiscount should calculate correctly', () {
        // 100 บาท หัก 20 บาท = 80 บาท
        expect(CalculationFormulas.calculatePriceAfterDiscount(100.0, 20.0),
            equals(80.0));

        // Edge case: ส่วนลดมากกว่าราคา (ควรได้ 0)
        expect(CalculationFormulas.calculatePriceAfterDiscount(100.0, 150.0),
            equals(0.0));
      });
    });

    group('Complex Scenario Tests', () {
      test(
          'should handle complex calculation with all discounts and adjustments',
          () {
        // Scenario: ร้านอาหาร
        // - ยอดรวมสินค้า: 1000 บาท (รวม VAT แล้ว)
        // - ส่วนลดสินค้า (taxable): 100 บาท
        // - ส่วนลดก่อนชำระ: 50 บาท
        // - ปัดเศษ: -0.50 บาท
        // - อัตรา VAT: 7%

        final result = CalculationFormulas.calculateInclusiveVATMode(
          grossAmount: 1000.0,
          taxableDiscount: 100.0,
          nonTaxableDiscount: 0.0,
          beforePaymentDiscount: 50.0,
          roundingAmount: -0.50,
          closeAmount: 0.0,
          taxRatePercent: 7.0,
        );

        // หลังหักส่วนลดสินค้า = 1000 - 100 = 900 บาท (รวม VAT)
        // ฐานภาษี = 900 ÷ 1.07 ≈ 841.12 บาท
        // VAT = 841.12 × 0.07 ≈ 58.88 บาท
        // หลังหักส่วนลดก่อนชำระ = 900 - 50 = 850 บาท
        // ยอดสุดท้าย = 850 - 0.50 = 849.50 บาท

        expect(result['afterItemStage'], equals(900.0));
        expect(result['beforeVat']!, closeTo(841.12, 0.01));
        expect(result['vatAmount']!, closeTo(58.88, 0.01));
        expect(result['netAfterPrepay'], equals(850.0));
        expect(result['grandTotal'], equals(849.50));
      });

      test('should handle zero VAT rate correctly', () {
        final result = CalculationFormulas.calculateTotalByVATMode(
          vatMode: VatMode.exclusive,
          grossAmount: 100.0,
          taxableDiscount: 10.0,
          nonTaxableDiscount: 0.0,
          beforePaymentDiscount: 0.0,
          roundingAmount: 0.0,
          closeAmount: 0.0,
          taxRatePercent: 0.0, // ไม่มี VAT
        );

        expect(result['beforeVat'], equals(90.0));
        expect(result['vatAmount'], equals(0.0));
        expect(result['grandTotal'], equals(90.0));
      });
    });

    group('Validation Tests', () {
      test('validateCalculation should validate correctly', () {
        // Valid calculation
        expect(
            CalculationFormulas.validateCalculation(
              grossAmount: 100.0,
              discountAmount: 20.0,
              taxAmount: 7.0,
              grandTotal: 87.0,
            ),
            isTrue);

        // Invalid: negative values
        expect(
            CalculationFormulas.validateCalculation(
              grossAmount: -100.0,
              discountAmount: 20.0,
              taxAmount: 7.0,
              grandTotal: 87.0,
            ),
            isFalse);

        // Invalid: discount > gross
        expect(
            CalculationFormulas.validateCalculation(
              grossAmount: 100.0,
              discountAmount: 150.0,
              taxAmount: 7.0,
              grandTotal: 87.0,
            ),
            isFalse);
      });
    });

    group('Utility Tests', () {
      test('formatCurrency should format correctly', () {
        expect(CalculationFormulas.formatCurrency(123.456), equals('123.46'));
        expect(CalculationFormulas.formatCurrency(100.0), equals('100.00'));
        expect(CalculationFormulas.formatCurrency(0.1), equals('0.10'));
      });

      test('formatThaiCurrency should format with Thai locale', () {
        expect(CalculationFormulas.formatThaiCurrency(1234.56),
            equals('1,234.56 บาท'));
        expect(CalculationFormulas.formatThaiCurrency(1000000.0),
            equals('1,000,000.00 บาท'));
        expect(
            CalculationFormulas.formatThaiCurrency(123.45, showSymbol: false),
            equals('123.45'));
      });

      test('formatThaiNumber should format without decimals', () {
        expect(CalculationFormulas.formatThaiNumber(1234.56), equals('1,235'));
        expect(CalculationFormulas.formatThaiNumber(1000000.0),
            equals('1,000,000'));
      });

      test('formatThaiDecimal should format with decimals', () {
        expect(
            CalculationFormulas.formatThaiDecimal(1234.56), equals('1,234.56'));
        expect(CalculationFormulas.formatThaiDecimal(1000000.0),
            equals('1,000,000.00'));
      });

      test('formatThaiPercentage should format percentage', () {
        expect(CalculationFormulas.formatThaiPercentage(7.5), equals('7.5%'));
        expect(
            CalculationFormulas.formatThaiPercentage(100.0), equals('100.0%'));
      });

      test('parseThaiNumber should parse Thai formatted numbers', () {
        expect(
            CalculationFormulas.parseThaiNumber('1,234.56'), equals(1234.56));
        expect(CalculationFormulas.parseThaiNumber('1,000,000.00 บาท'),
            equals(1000000.0));
        expect(CalculationFormulas.parseThaiNumber('7.5%'), equals(7.5));
        expect(CalculationFormulas.parseThaiNumber(''), equals(0.0));
        expect(CalculationFormulas.parseThaiNumber('invalid'), equals(0.0));
      });

      test('isValidThaiNumber should validate Thai numbers', () {
        expect(CalculationFormulas.isValidThaiNumber('1,234.56'), isTrue);
        expect(
            CalculationFormulas.isValidThaiNumber('1,000,000.00 บาท'), isTrue);
        expect(CalculationFormulas.isValidThaiNumber('7.5%'), isTrue);
        expect(CalculationFormulas.isValidThaiNumber(''), isTrue);
        expect(CalculationFormulas.isValidThaiNumber('invalid'), isFalse);
        expect(CalculationFormulas.isValidThaiNumber('abc123'), isFalse);
      });

      test('calculateChange should calculate correctly', () {
        expect(
            CalculationFormulas.calculateChange(1000.0, 850.0), equals(150.0));
        expect(CalculationFormulas.calculateChange(100.0, 100.0), equals(0.0));
        expect(CalculationFormulas.calculateChange(50.0, 100.0), equals(-50.0));
      });

      test('getVATFormulaExplanation should return correct explanation', () {
        final inclusiveExplanation =
            CalculationFormulas.getVATFormulaExplanation(
                VatMode.inclusive, 7.0);
        final exclusiveExplanation =
            CalculationFormulas.getVATFormulaExplanation(
                VatMode.exclusive, 7.0);

        expect(inclusiveExplanation, contains('โหมด A'));
        expect(inclusiveExplanation, contains('7'));
        expect(exclusiveExplanation, contains('โหมด B'));
        expect(exclusiveExplanation, contains('7'));
      });

      test('getVATCalculationExample should return correct example', () {
        final example =
            CalculationFormulas.getVATCalculationExample(100.0, 7.0);
        expect(example, contains('100.00'));
        expect(example, contains('7'));
        expect(example, contains('7.00'));
      });

      test('getVATCalculationExampleThai should return Thai formatted example',
          () {
        final example =
            CalculationFormulas.getVATCalculationExampleThai(1000.0, 7.0);
        expect(example, contains('1,000.00'));
        expect(example, contains('7'));
        expect(example, contains('70.00 บาท'));
      });
    });

    group('Thai Formatting Integration Tests', () {
      test('generateThaiCalculationReport should create complete Thai report',
          () {
        final report = CalculationFormulas.generateThaiCalculationReport(
          vatMode: VatMode.inclusive,
          grossAmount: 1070.0,
          taxableDiscount: 70.0,
          nonTaxableDiscount: 0.0,
          beforePaymentDiscount: 0.0,
          roundingAmount: 0.0,
          closeAmount: 0.0,
          taxRatePercent: 7.0,
        );

        expect(report['vatMode'], equals('โหมด A (รวม VAT)'));
        expect(report['grossAmount'], contains('1,070.00 บาท'));
        expect(report['taxableDiscount'], contains('70.00 บาท'));
        expect(report['taxRate'], contains('7.0%'));
        expect(report['grandTotal'], contains('1,000.00 บาท'));
      });

      test(
          'generateThaiCalculationExplanation should create detailed explanation',
          () {
        final explanation =
            CalculationFormulas.generateThaiCalculationExplanation(
          vatMode: VatMode.inclusive,
          grossAmount: 1070.0,
          taxableDiscount: 70.0,
          nonTaxableDiscount: 0.0,
          taxRatePercent: 7.0,
        );

        expect(explanation, contains('โหมด A'));
        expect(explanation, contains('1,070.00 บาท'));
        expect(explanation, contains('70.00 บาท'));
        expect(explanation, contains('สกัดฐานภาษี'));
        expect(explanation, contains('คำนวณ VAT'));
      });

      test('should handle large numbers with Thai formatting', () {
        final formatted = CalculationFormulas.formatThaiCurrency(1234567.89);
        expect(formatted, equals('1,234,567.89 บาท'));

        final parsed = CalculationFormulas.parseThaiNumber('1,234,567.89 บาท');
        expect(parsed, equals(1234567.89));
      });

      test('should handle edge cases in Thai formatting', () {
        // Zero amount
        expect(CalculationFormulas.formatThaiCurrency(0.0), equals('0.00 บาท'));

        // Very small amount
        expect(
            CalculationFormulas.formatThaiCurrency(0.01), equals('0.01 บาท'));

        // Very large amount
        expect(CalculationFormulas.formatThaiCurrency(999999999.99),
            equals('999,999,999.99 บาท'));
      });
    });
  });
}
