class AppStrings {
  // Section Titles
  static const String calculationDetailsTitle = 'รายละเอียดการคำนวณ';
  static const String vatSectionTitle = 'ภาษีมูลค่าเพิ่ม';
  static const String discountSectionTitle = 'ส่วนลดและการปรับปรุง';
  static const String paymentSectionTitle = 'วิธีชำระเงิน';
  static const String summaryTitle = 'สรุปยอดและชำระเงิน';
  static const String netTotalTitle = 'ยอดรวมสุทธิ';

  // Field Labels
  static const String totalValueLabel = 'รวมมูลค่า';
  static const String afterDiscountLabel = 'ยอดหลังหักส่วนลดสินค้า';
  static const String beforeVatLabel = 'ยอดก่อนภาษี (ฐานภาษี)';
  static const String vatAmountLabel = 'ภาษีมูลค่าเพิ่ม';
  static const String taxableDiscountLabel = 'ส่วนลดสินค้ามีภาษี';
  static const String nonTaxableDiscountLabel = 'ส่วนลดสินค้ายกเว้นภาษี';
  static const String beforePaymentDiscountLabel = 'ส่วนลดก่อนชำระเงิน';
  static const String roundingLabel = 'ปัดเศษ';
  static const String receiveAmountLabel = 'รับเงิน/เงินโอน';
  static const String changeAmountLabel = 'เงินทอน';
  static const String insufficientAmountLabel = 'เงินไม่พอ';

  // Currency
  static const String currencySymbol = 'บาท';
  static const String currencyUnit = ' บาท';

  // VAT Mode
  static const String vatInclusiveLabel = 'รวม VAT';
  static const String vatExclusiveLabel = 'ก่อน VAT';

  // Validation Messages
  static const String requiredFieldMessage = 'กรุณากรอก';
  static const String invalidNumberMessage = 'กรุณากรอกตัวเลขที่ถูกต้อง';
  static const String negativeValueMessage = 'ค่าต้องไม่เป็นลบ';
  static const String maxValueExceededMessage = 'ค่าต้องไม่เกิน 999,999,999.99';
  static const String priceGreaterThanZeroMessage = 'ราคาต้องมากกว่า 0';
  static const String amountMustBePositiveMessage = 'จำนวนเงินต้องไม่เป็นลบ';

  // Actions
  static const String resetLabel = 'รีเซ็ต';
  static const String calculateLabel = 'คำนวณ';
  static const String clearDataTooltip = 'ล้างข้อมูล';

  // Payment Types
  static const String cashPaymentLabel = 'เงินสด';
  static const String transferPaymentLabel = 'โอนเงิน';
  static const String cardPaymentLabel = 'บัตรเครดิต';

  // Settings
  static const String saveMyChangeLabel = 'บันทึกการเปลี่ยนแปลง';
  static const String autoPrintLabel = 'พิมพ์อัตโนมัติ';

  // Status Messages
  static const String calculatingMessage = 'กำลังคำนวณ...';
  static const String processingMessage = 'กำลังประมวลผล...';
  static const String completedMessage = 'เสร็จสิ้น';
}
