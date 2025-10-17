# CalculationFormulas - สูตรคำนวณระบบขาย

## ภาพรวม

`CalculationFormulas` เป็น utility class ที่รวบรวมสูตรคำนวณทั้งหมดสำหรับระบบขาย โดยแยกออกมาจาก UI เพื่อให้:
- ทดสอบได้ง่าย (Unit Testing)
- ใช้งานร่วมกันได้หลายที่
- บำรุงรักษาง่าย
- มีความแม่นยำในการคำนวณ

## สูตรหลัก

### 1. สูตร VAT มาตรฐาน
```
VAT = ราคาสินค้า/บริการ × (อัตราภาษี ÷ 100)
```

### 2. โหมด VAT

#### โหมด A (Inclusive VAT) - ราคารวม VAT
- ราคาที่แสดงรวม VAT แล้ว
- ต้องสกัดฐานภาษีออกมาก่อน
- สูตร: `ฐานภาษี = ราคารวม VAT ÷ (1 + อัตราภาษี/100)`

#### โหมด B (Exclusive VAT) - ราคาไม่รวม VAT  
- ราคาที่แสดงยังไม่รวม VAT
- คำนวณ VAT จากฐานภาษีโดยตรง
- สูตร: `VAT = ฐานภาษี × (อัตราภาษี/100)`

## การใช้งาน

### 1. คำนวณ VAT พื้นฐาน
```dart
// คำนวณ VAT จาก 100 บาท อัตรา 7%
double vat = CalculationFormulas.calculateVAT(100.0, 7.0);
// ผลลัพธ์: 7.0 บาท
```

### 1.1. การจัดรูปแบบแบบไทย (Thai Formatting)
```dart
// จัดรูปแบบสกุลเงินแบบไทย (มีคอมม่าคั่นหลักพัน)
String formatted = CalculationFormulas.formatThaiCurrency(1234567.89);
// ผลลัพธ์: "1,234,567.89 บาท"

// จัดรูปแบบตัวเลขแบบไทย (ไม่มีสัญลักษณ์สกุลเงิน)
String number = CalculationFormulas.formatThaiDecimal(1234567.89);
// ผลลัพธ์: "1,234,567.89"

// แปลงจากสตริงที่มีคอมม่าเป็นตัวเลข
double parsed = CalculationFormulas.parseThaiNumber("1,234,567.89 บาท");
// ผลลัพธ์: 1234567.89

// ตรวจสอบความถูกต้องของตัวเลขไทย
bool isValid = CalculationFormulas.isValidThaiNumber("1,234.56");
// ผลลัพธ์: true
```

### 2. คำนวณตามโหมด VAT
```dart
// โหมด Inclusive (รวม VAT)
final result = CalculationFormulas.calculateTotalByVATMode(
  vatMode: VatMode.inclusive,
  grossAmount: 107.0,        // ยอดรวม (รวม VAT แล้ว)
  taxableDiscount: 7.0,      // ส่วนลดสินค้า (คิด VAT)
  nonTaxableDiscount: 0.0,   // ส่วนลดสินค้า (ไม่คิด VAT)
  beforePaymentDiscount: 0.0, // ส่วนลดก่อนชำระ
  roundingAmount: 0.0,       // ปัดเศษ
  closeAmount: 0.0,          // ปิดยอด
  taxRatePercent: 7.0,       // อัตรา VAT
);

// ผลลัพธ์
print('ฐานภาษี: ${result['beforeVat']}');      // 93.46
print('VAT: ${result['vatAmount']}');          // 6.54
print('ยอดรวม: ${result['grandTotal']}');      // 100.0
```

### 3. คำนวณส่วนลด
```dart
// คำนวณเปอร์เซ็นต์ส่วนลด
double percentage = CalculationFormulas.calculateDiscountPercentage(100.0, 20.0);
// ผลลัพธ์: 20.0%

// คำนวณจำนวนเงินส่วนลด
double amount = CalculationFormulas.calculateDiscountAmount(100.0, 20.0);
// ผลลัพธ์: 20.0 บาท

// คำนวณราคาหลังหักส่วนลด
double finalPrice = CalculationFormulas.calculatePriceAfterDiscount(100.0, 20.0);
// ผลลัพธ์: 80.0 บาท
```

### 4. สร้างรายงานแบบไทย
```dart
// สร้างรายงานการคำนวณแบบไทย (มีคอมม่าและสัญลักษณ์)
Map<String, String> report = CalculationFormulas.generateThaiCalculationReport(
  vatMode: VatMode.inclusive,
  grossAmount: 1070.0,
  taxableDiscount: 70.0,
  nonTaxableDiscount: 0.0,
  beforePaymentDiscount: 0.0,
  roundingAmount: 0.0,
  closeAmount: 0.0,
  taxRatePercent: 7.0,
);

print(report['grossAmount']);    // "1,070.00 บาท"
print(report['vatAmount']);      // "65.42 บาท"
print(report['grandTotal']);     // "1,000.00 บาท"

// สร้างคำอธิบายการคำนวณแบบไทย
String explanation = CalculationFormulas.generateThaiCalculationExplanation(
  vatMode: VatMode.inclusive,
  grossAmount: 1070.0,
  taxableDiscount: 70.0,
  nonTaxableDiscount: 0.0,
  taxRatePercent: 7.0,
);
print(explanation);
// ผลลัพธ์: คำอธิบายขั้นตอนการคำนวณแบบละเอียด
```

## ตัวอย่างการคำนวณ

### ตัวอย่างที่ 1: ร้านอาหาร (โหมด A - รวม VAT)
```
ยอดรวมสินค้า: 1,070 บาท (รวม VAT แล้ว)
ส่วนลดสินค้า: 70 บาท
อัตรา VAT: 7%

ขั้นตอนการคำนวณ:
1. หลังหักส่วนลด = 1,070 - 70 = 1,000 บาท
2. ฐานภาษี = 1,000 ÷ 1.07 = 934.58 บาท
3. VAT = 934.58 × 0.07 = 65.42 บาท
4. ยอดสุดท้าย = 1,000 บาท
```

### ตัวอย่างที่ 2: ร้านค้าปลีก (โหมด B - ไม่รวม VAT)
```
ยอดรวมสินค้า: 1,000 บาท (ยังไม่รวม VAT)
ส่วนลดสินค้า: 100 บาท
อัตรา VAT: 7%

ขั้นตอนการคำนวณ:
1. หลังหักส่วนลด = 1,000 - 100 = 900 บาท
2. ฐานภาษี = 900 บาท
3. VAT = 900 × 0.07 = 63 บาท
4. ยอดสุดท้าย = 900 + 63 = 963 บาท
```

## การทดสอบ

รันคำสั่งนี้เพื่อทดสอบสูตรคำนวณ:
```bash
flutter test test/calculation_formulas_test.dart
```

### Test Coverage
- ✅ การคำนวณ VAT พื้นฐาน
- ✅ การสกัดฐานภาษีจากราคารวม VAT
- ✅ โหมด Inclusive VAT
- ✅ โหมด Exclusive VAT
- ✅ การคำนวณส่วนลด
- ✅ การจัดการกรณีพิเศษ (VAT 0%, ส่วนลดเกินราคา)
- ✅ การตรวจสอบความถูกต้อง
- ✅ Utility functions

## หมายเหตุสำคัญ

1. **ความแม่นยำ**: ใช้ `closeTo()` ในการทดสอบเพื่อจัดการ floating point precision
2. **การป้องกัน**: ใช้ `clamp(0.0, double.infinity)` เพื่อป้องกันค่าลบ
3. **มาตรฐาน**: ทุกสูตรเป็นไปตามมาตรฐานการคำนวณภาษีของไทย
4. **การใช้งาน**: สามารถใช้ร่วมกับ UI หรือ Business Logic ได้

## การบำรุงรักษา

เมื่อต้องการเพิ่มสูตรใหม่:
1. เพิ่มฟังก์ชันใน `CalculationFormulas`
2. เขียน unit test ใน `calculation_formulas_test.dart`
3. อัปเดต documentation นี้
4. รัน test เพื่อตรวจสอบความถูกต้อง

## การอ้างอิง

- [กฎหมายภาษีมูลค่าเพิ่ม](https://www.rd.go.th/)
- [มาตรฐานการคำนวณภาษี](https://www.dbd.g