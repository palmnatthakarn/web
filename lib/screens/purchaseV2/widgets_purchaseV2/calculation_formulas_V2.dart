/// ไฟล์รวมสูตรคำนวณทั้งหมดสำหรับระบบขาย
/// แยกออกมาจาก purchasetotalpage.dart เพื่อให้ใช้งานร่วมกันได้
///
/// สูตรหลัก:
/// - VAT = ราคาสินค้า/บริการ × (อัตราภาษี ÷ 100)
/// - โหมด A (รวม VAT): สกัดฐานภาษีจากราคารวม VAT แล้วคำนวณ VAT
/// - โหมด B (ไม่รวม VAT): คำนวณ VAT จากราคาไม่รวม VAT
library;

import 'package:flutter_web_app/blocs/purchase/purchase_state.dart';
import 'package:intl/intl.dart';

class CalculationFormulas_V2 {
  /// คำนวณยอดรวมสินค้าทั้งหมด
  /// สูตร: ∑(ราคาสินค้า × จำนวน)
  static double calculateSubTotal(List<CartItem> cartItems) {
    return cartItems.fold(0.0,
        (sum, item) => sum + ((item.product.price ?? 0.0) * item.quantity));
  }

  /// คำนวณภาษีจากยอดรวม
  /// สูตร: ยอดรวม × (อัตราภาษี ÷ 100)
  static double calculateTax(double subTotal, String taxRateStr) {
    final taxRate = double.tryParse(taxRateStr) ?? 0.0;
    return subTotal * (taxRate / 100);
  }

  /// คำนวณส่วนลดรวมทั้งหมด
  /// สูตร: ∑(ส่วนลดแต่ละรายการ)
  static double calculateTotalDiscount(List<CartItem> cartItems) {
    return cartItems.fold(0.0, (sum, item) => sum + item.totalDiscountAmount);
  }

  /// คำนวณ VAT ตามสูตรมาตรฐาน
  /// สูตร: ราคาสินค้า/บริการ × (อัตราภาษี ÷ 100) = VAT
  static double calculateVAT(double baseAmount, double taxRate) {
    return baseAmount * (taxRate / 100.0);
  }

  /// คำนวณฐานภาษีจากราคารวม VAT (สำหรับโหมด A)
  /// สูตร: ราคารวม VAT ÷ (1 + อัตราภาษี/100)
  static double calculateTaxBaseFromInclusivePrice(
      double inclusivePrice, double taxRate) {
    final rate = taxRate / 100.0;
    return inclusivePrice / (1 + rate);
  }

  /// คำนวณเงินทอน
  /// สูตร: เงินที่รับ - ยอดรวมสุทธิ
  static double calculateChange(double receivedAmount, double grandTotal) {
    return receivedAmount - grandTotal;
  }

  /// คำนวณยอดรวมสุทธิสำหรับโหมด A (ราคารวม VAT)
  /// ขั้นตอน:
  /// 1. หักส่วนลดสินค้าจากยอดรวม
  /// 2. สกัดฐานภาษีและ VAT
  /// 3. หักส่วนลดก่อนชำระ
  /// 4. บวกปัดเศษและปิดยอด
  static Map<String, double> calculateInclusiveVATMode({
    required double grossAmount,
    required double taxableDiscount,
    required double nonTaxableDiscount,
    required double beforePaymentDiscount,
    required double roundingAmount,
    required double closeAmount,
    required double taxRatePercent,
  }) {
    final rate = taxRatePercent / 100.0;
    final hasVat = rate > 0.0;

    // ส่วนลดสินค้าหักออกจากยอดรวมที่รวมภาษีอยู่แล้ว
    final afterItemStage = (grossAmount - taxableDiscount - nonTaxableDiscount)
        .clamp(0.0, double.infinity);

    double beforeVat;
    double vatAmount;

    // สกัดฐานภาษี / ภาษี (จากราคาที่รวม VAT แล้ว)
    if (hasVat) {
      beforeVat =
          calculateTaxBaseFromInclusivePrice(afterItemStage, taxRatePercent);
      // สูตร VAT: ราคาสินค้า/บริการ × (7 ÷ 100) = VAT
      // ในโหมดนี้ ราคาสินค้า = ฐานภาษี (beforeVat)
      vatAmount = calculateVAT(beforeVat, taxRatePercent);
    } else {
      beforeVat = afterItemStage;
      vatAmount = 0.0;
    }

    // หักส่วนลดก่อนชำระ
    final netAfterPrepay =
        (afterItemStage - beforePaymentDiscount).clamp(0.0, double.infinity);

    // รวมสุดท้าย (อย่าเอา VAT มาบวกซ้ำ เพราะ afterItemStage รวมภาษีแล้ว)
    final grandTotal = netAfterPrepay + roundingAmount + closeAmount;

    return {
      'beforeVat': beforeVat,
      'vatAmount': vatAmount,
      'afterItemStage': afterItemStage,
      'netAfterPrepay': netAfterPrepay,
      'grandTotal': grandTotal,
    };
  }

  /// คำนวณยอดรวมสุทธิสำหรับโหมด B (ราคาไม่รวม VAT)
  /// ขั้นตอน:
  /// 1. หักส่วนลดสินค้าจากยอดที่ยังไม่รวม VAT
  /// 2. คำนวณ VAT จากฐานภาษี
  /// 3. รวม VAT เข้ากับยอด
  /// 4. หักส่วนลดก่อนชำระ
  /// 5. บวกปัดเศษและปิดยอด
  static Map<String, double> calculateExclusiveVATMode({
    required double grossAmount,
    required double taxableDiscount,
    required double nonTaxableDiscount,
    required double beforePaymentDiscount,
    required double roundingAmount,
    required double closeAmount,
    required double taxRatePercent,
  }) {
    final hasVat = taxRatePercent > 0.0;

    // ส่วนลดสินค้าหักจากยอดที่ "ยังไม่รวม VAT"
    final beforeVat = (grossAmount - taxableDiscount - nonTaxableDiscount)
        .clamp(0.0, double.infinity);

    // สูตร VAT: ราคาสินค้า/บริการ × (7 ÷ 100) = VAT
    // ในโหมดนี้ ราคาสินค้า = beforeVat (ยังไม่รวม VAT)
    final vatAmount = hasVat ? calculateVAT(beforeVat, taxRatePercent) : 0.0;

    final amountAfterTax = beforeVat + vatAmount; // ตอนนี้รวม VAT แล้ว

    // หักส่วนลดก่อนชำระจากยอดที่รวม VAT แล้ว
    final netAfterPrepay =
        (amountAfterTax - beforePaymentDiscount).clamp(0.0, double.infinity);

    // รวมสุดท้าย
    final grandTotal = netAfterPrepay + roundingAmount + closeAmount;

    // เพื่อให้ UI ใช้ช่องเดิม: afterItemStage (ในโหมด B) จะสื่อ "ยอดก่อนภาษีหลังส่วนลดสินค้า"
    final afterItemStage = beforeVat;

    return {
      'beforeVat': beforeVat,
      'vatAmount': vatAmount,
      'afterItemStage': afterItemStage,
      'netAfterPrepay': netAfterPrepay,
      'grandTotal': grandTotal,
    };
  }

  /// คำนวณยอดรวมตามโหมด VAT ที่เลือก
  static Map<String, double> calculateTotalByVATMode({
    required VatMode vatMode,
    required double grossAmount,
    required double taxableDiscount,
    required double nonTaxableDiscount,
    required double beforePaymentDiscount,
    required double roundingAmount,
    required double closeAmount,
    required double taxRatePercent,
  }) {
    if (vatMode == VatMode.inclusive) {
      return calculateInclusiveVATMode(
        grossAmount: grossAmount,
        taxableDiscount: taxableDiscount,
        nonTaxableDiscount: nonTaxableDiscount,
        beforePaymentDiscount: beforePaymentDiscount,
        roundingAmount: roundingAmount,
        closeAmount: closeAmount,
        taxRatePercent: taxRatePercent,
      );
    } else {
      return calculateExclusiveVATMode(
        grossAmount: grossAmount,
        taxableDiscount: taxableDiscount,
        nonTaxableDiscount: nonTaxableDiscount,
        beforePaymentDiscount: beforePaymentDiscount,
        roundingAmount: roundingAmount,
        closeAmount: closeAmount,
        taxRatePercent: taxRatePercent,
      );
    }
  }

  /// จัดรูปแบบตัวเลขเป็นสกุลเงิน (รองรับ locale ไทย)
  static String formatCurrency(double amount, {String? locale}) {
    final formatter = NumberFormat('#,##0.00');
    return formatter.format(amount);
  }

  /// จัดรูปแบบตัวเลขแบบไทย (คอมม่าคั่นหลักพัน)
  static String formatThaiCurrency(double amount, {bool showSymbol = true}) {
    final formatter = NumberFormat('#,##0.00', 'th_TH');
    final formatted = formatter.format(amount);
    return showSymbol ? '$formatted บาท' : formatted;
  }

  /// จัดรูปแบบตัวเลขแบบไทย (ไม่มีทศนิยม)
  static String formatThaiNumber(double amount) {
    final formatter = NumberFormat('#,##0', 'th_TH');
    return formatter.format(amount);
  }

  /// จัดรูปแบบตัวเลขแบบไทย (ทศนิยม 2 ตำแหน่ง)
  static String formatThaiDecimal(double amount) {
    final formatter = NumberFormat('#,##0.00', 'th_TH');
    return formatter.format(amount);
  }

  /// จัดรูปแบบเปอร์เซ็นต์แบบไทย
  static String formatThaiPercentage(double percentage) {
    final formatter = NumberFormat('#,##0.0', 'th_TH');
    return '${formatter.format(percentage)}%';
  }

  /// แปลงจากสตริงที่มีคอมม่าเป็นตัวเลข
  static double parseThaiNumber(String input) {
    if (input.isEmpty) return 0.0;

    // ลบคอมม่าและสัญลักษณ์อื่นๆ ออก
    final cleanInput = input
        .replaceAll(',', '')
        .replaceAll(' บาท', '')
        .replaceAll('%', '')
        .trim();

    return double.tryParse(cleanInput) ?? 0.0;
  }

  /// ตรวจสอบว่าสตริงเป็นตัวเลขไทยที่ถูกต้องหรือไม่
  static bool isValidThaiNumber(String input) {
    if (input.isEmpty) return true;

    final cleanInput = input
        .replaceAll(',', '')
        .replaceAll(' บาท', '')
        .replaceAll('%', '')
        .trim();

    return double.tryParse(cleanInput) != null;
  }

  /// อธิบายสูตรการคำนวณตามโหมด
  static String getVATFormulaExplanation(VatMode mode, double taxRate) {
    final formatter = NumberFormat('#,##0');
    final rateStr = formatter.format(taxRate);
    if (mode == VatMode.inclusive) {
      return 'โหมด A: สกัดฐานภาษีจากราคารวม VAT แล้วคำนวณ VAT = ฐานภาษี × ($rateStr ÷ 100)';
    } else {
      return 'โหมด B: คำนวณ VAT จากราคาก่อน VAT = ราคาสินค้า × ($rateStr ÷ 100)';
    }
  }

  /// แสดงตัวอย่างการคำนวณ VAT
  static String getVATCalculationExample(double baseAmount, double taxRate) {
    final vatAmount = calculateVAT(baseAmount, taxRate);
    final formatter = NumberFormat('#,##0.00');
    final rateFormatter = NumberFormat('#,##0');
    return '${formatter.format(baseAmount)} × (${rateFormatter.format(taxRate)} ÷ 100) = ${formatter.format(vatAmount)} บาท';
  }

  /// แสดงตัวอย่างการคำนวณ VAT แบบไทย (มีคอมม่า)
  static String getVATCalculationExampleThai(
      double baseAmount, double taxRate) {
    final vatAmount = calculateVAT(baseAmount, taxRate);
    final rateFormatter = NumberFormat('#,##0');
    return '${formatThaiDecimal(baseAmount)} × (${rateFormatter.format(taxRate)} ÷ 100) = ${formatThaiCurrency(vatAmount)}';
  }

  /// สร้างรายงานการคำนวณแบบไทย
  static Map<String, String> generateThaiCalculationReport({
    required VatMode vatMode,
    required double grossAmount,
    required double taxableDiscount,
    required double nonTaxableDiscount,
    required double beforePaymentDiscount,
    required double roundingAmount,
    required double closeAmount,
    required double taxRatePercent,
  }) {
    final result = calculateTotalByVATMode(
      vatMode: vatMode,
      grossAmount: grossAmount,
      taxableDiscount: taxableDiscount,
      nonTaxableDiscount: nonTaxableDiscount,
      beforePaymentDiscount: beforePaymentDiscount,
      roundingAmount: roundingAmount,
      closeAmount: closeAmount,
      taxRatePercent: taxRatePercent,
    );

    return {
      'vatMode': vatMode == VatMode.inclusive
          ? 'โหมด A (รวม VAT)'
          : 'โหมด B (ก่อน VAT)',
      'grossAmount': formatThaiCurrency(grossAmount),
      'taxableDiscount': formatThaiCurrency(taxableDiscount),
      'nonTaxableDiscount': formatThaiCurrency(nonTaxableDiscount),
      'beforePaymentDiscount': formatThaiCurrency(beforePaymentDiscount),
      'roundingAmount': formatThaiCurrency(roundingAmount),
      'closeAmount': formatThaiCurrency(closeAmount),
      'taxRate': formatThaiPercentage(taxRatePercent),
      'beforeVat': formatThaiCurrency(result['beforeVat']!),
      'vatAmount': formatThaiCurrency(result['vatAmount']!),
      'afterItemStage': formatThaiCurrency(result['afterItemStage']!),
      'netAfterPrepay': formatThaiCurrency(result['netAfterPrepay']!),
      'grandTotal': formatThaiCurrency(result['grandTotal']!),
    };
  }

  /// สร้างข้อความอธิบายการคำนวณแบบไทย
  static String generateThaiCalculationExplanation({
    required VatMode vatMode,
    required double grossAmount,
    required double taxableDiscount,
    required double nonTaxableDiscount,
    required double taxRatePercent,
  }) {
    final afterDiscount = grossAmount - taxableDiscount - nonTaxableDiscount;

    if (vatMode == VatMode.inclusive) {
      final beforeVat =
          calculateTaxBaseFromInclusivePrice(afterDiscount, taxRatePercent);
      final vatAmount = calculateVAT(beforeVat, taxRatePercent);

      return '''
โหมด A (ราคารวม VAT):
1. ยอดรวมสินค้า: ${formatThaiCurrency(grossAmount)}
2. หักส่วนลดสินค้า: ${formatThaiCurrency(taxableDiscount + nonTaxableDiscount)}
3. ยอดหลังส่วนลด: ${formatThaiCurrency(afterDiscount)} (รวม VAT แล้ว)
4. สกัดฐานภาษี: ${formatThaiCurrency(afterDiscount)} ÷ ${formatThaiDecimal(1 + taxRatePercent / 100)} = ${formatThaiCurrency(beforeVat)}
5. คำนวณ VAT: ${formatThaiCurrency(beforeVat)} × ${formatThaiNumber(taxRatePercent)}% = ${formatThaiCurrency(vatAmount)}
''';
    } else {
      final beforeVat = afterDiscount;
      final vatAmount = calculateVAT(beforeVat, taxRatePercent);

      return '''
โหมด B (ราคาก่อน VAT):
1. ยอดรวมสินค้า: ${formatThaiCurrency(grossAmount)} (ก่อน VAT)
2. หักส่วนลดสินค้า: ${formatThaiCurrency(taxableDiscount + nonTaxableDiscount)}
3. ฐานภาษี: ${formatThaiCurrency(beforeVat)}
4. คำนวณ VAT: ${formatThaiCurrency(beforeVat)} × ${formatThaiNumber(taxRatePercent)}% = ${formatThaiCurrency(vatAmount)}
5. ยอดรวม VAT: ${formatThaiCurrency(beforeVat + vatAmount)}
''';
    }
  }

  /// ตรวจสอบความถูกต้องของการคำนวณ
  static bool validateCalculation({
    required double grossAmount,
    required double discountAmount,
    required double taxAmount,
    required double grandTotal,
  }) {
    // ตรวจสอบว่าค่าต่างๆ ไม่เป็นลบ
    if (grossAmount < 0 ||
        discountAmount < 0 ||
        taxAmount < 0 ||
        grandTotal < 0) {
      return false;
    }

    // ตรวจสอบว่าส่วนลดไม่เกินยอดรวม
    if (discountAmount > grossAmount) {
      return false;
    }

    return true;
  }

  /// คำนวณเปอร์เซ็นต์ส่วนลด
  static double calculateDiscountPercentage(
      double originalAmount, double discountAmount) {
    if (originalAmount <= 0) return 0.0;
    return (discountAmount / originalAmount) * 100;
  }

  /// คำนวณจำนวนเงินจากเปอร์เซ็นต์ส่วนลด
  static double calculateDiscountAmount(
      double originalAmount, double discountPercentage) {
    return originalAmount * (discountPercentage / 100);
  }

  /// คำนวณราคาหลังหักส่วนลด
  static double calculatePriceAfterDiscount(
      double originalPrice, double discountAmount) {
    return (originalPrice - discountAmount).clamp(0.0, double.infinity);
  }

  /// คำนวณราคาหลังหักส่วนลดเปอร์เซ็นต์
  static double calculatePriceAfterDiscountPercentage(
      double originalPrice, double discountPercentage) {
    final discountAmount =
        calculateDiscountAmount(originalPrice, discountPercentage);
    return calculatePriceAfterDiscount(originalPrice, discountAmount);
  }
}
