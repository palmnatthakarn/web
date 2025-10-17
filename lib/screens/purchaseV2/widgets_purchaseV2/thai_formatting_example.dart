/// ตัวอย่างการใช้งาน NumberFormat สำหรับ locale ไทย
///
/// ไฟล์นี้แสดงตัวอย่างการใช้งานฟังก์ชันการจัดรูปแบบแบบไทย
/// ที่เพิ่มเข้ามาใน CalculationFormulas

import 'package:flutter/material.dart';
import 'package:flutter_web_app/blocs/purchase/purchase_state.dart';
import 'package:flutter_web_app/screens/purchase/widgets_purchase/calculation_formulas.dart';

class ThaiFormattingExample extends StatelessWidget {
  const ThaiFormattingExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ตัวอย่างการจัดรูปแบบแบบไทย'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection('การจัดรูปแบบสกุลเงิน', _buildCurrencyExamples()),
            const SizedBox(height: 20),
            _buildSection('การจัดรูปแบบตัวเลข', _buildNumberExamples()),
            const SizedBox(height: 20),
            _buildSection('การแปลงจากสตริง', _buildParsingExamples()),
            const SizedBox(height: 20),
            _buildSection('รายงานการคำนวณ', _buildReportExample()),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, Widget content) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            content,
          ],
        ),
      ),
    );
  }

  Widget _buildCurrencyExamples() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildExample(
            '1234.56', CalculationFormulas.formatThaiCurrency(1234.56)),
        _buildExample(
            '1000000.00', CalculationFormulas.formatThaiCurrency(1000000.00)),
        _buildExample('123.45 (ไม่มีสัญลักษณ์)',
            CalculationFormulas.formatThaiCurrency(123.45, showSymbol: false)),
      ],
    );
  }

  Widget _buildNumberExamples() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildExample(
            '1234.56 (ทศนิยม)', CalculationFormulas.formatThaiDecimal(1234.56)),
        _buildExample('1234.56 (จำนวนเต็ม)',
            CalculationFormulas.formatThaiNumber(1234.56)),
        _buildExample(
            '7.5 (เปอร์เซ็นต์)', CalculationFormulas.formatThaiPercentage(7.5)),
      ],
    );
  }

  Widget _buildParsingExamples() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildExample('แปลง "1,234.56"',
            CalculationFormulas.parseThaiNumber('1,234.56').toString()),
        _buildExample('แปลง "1,000,000.00 บาท"',
            CalculationFormulas.parseThaiNumber('1,000,000.00 บาท').toString()),
        _buildExample('แปลง "7.5%"',
            CalculationFormulas.parseThaiNumber('7.5%').toString()),
        _buildExample('ตรวจสอบ "1,234.56"',
            CalculationFormulas.isValidThaiNumber('1,234.56').toString()),
        _buildExample('ตรวจสอบ "invalid"',
            CalculationFormulas.isValidThaiNumber('invalid').toString()),
      ],
    );
  }

  Widget _buildReportExample() {
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('โหมด VAT: ${report['vatMode']}'),
        Text('ยอดรวมสินค้า: ${report['grossAmount']}'),
        Text('ส่วนลดสินค้า: ${report['taxableDiscount']}'),
        Text('อัตราภาษี: ${report['taxRate']}'),
        Text('ฐานภาษี: ${report['beforeVat']}'),
        Text('VAT: ${report['vatAmount']}'),
        Text('ยอดรวมสุดท้าย: ${report['grandTotal']}'),
      ],
    );
  }

  Widget _buildExample(String input, String output) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(input),
          ),
          const Text(' → '),
          Expanded(
            flex: 3,
            child: Text(
              output,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

/// ตัวอย่างการใช้งานในการคำนวณจริง
class CalculationExample {
  static void demonstrateVATCalculation() {
    print('=== ตัวอย่างการคำนวณ VAT แบบไทย ===');

    // ตัวอย่างที่ 1: โหมด Inclusive (รวม VAT)
    print('\n1. โหมด A (รวม VAT):');
    final inclusiveResult = CalculationFormulas.calculateTotalByVATMode(
      vatMode: VatMode.inclusive,
      grossAmount: 1070.0,
      taxableDiscount: 70.0,
      nonTaxableDiscount: 0.0,
      beforePaymentDiscount: 0.0,
      roundingAmount: 0.0,
      closeAmount: 0.0,
      taxRatePercent: 7.0,
    );

    print('ยอดรวมสินค้า: ${CalculationFormulas.formatThaiCurrency(1070.0)}');
    print('ส่วนลดสินค้า: ${CalculationFormulas.formatThaiCurrency(70.0)}');
    print(
        'ฐานภาษี: ${CalculationFormulas.formatThaiCurrency(inclusiveResult['beforeVat']!)}');
    print(
        'VAT: ${CalculationFormulas.formatThaiCurrency(inclusiveResult['vatAmount']!)}');
    print(
        'ยอดรวมสุดท้าย: ${CalculationFormulas.formatThaiCurrency(inclusiveResult['grandTotal']!)}');

    // ตัวอย่างที่ 2: โหมด Exclusive (ไม่รวม VAT)
    print('\n2. โหมด B (ก่อน VAT):');
    final exclusiveResult = CalculationFormulas.calculateTotalByVATMode(
      vatMode: VatMode.exclusive,
      grossAmount: 1000.0,
      taxableDiscount: 0.0,
      nonTaxableDiscount: 0.0,
      beforePaymentDiscount: 0.0,
      roundingAmount: 0.0,
      closeAmount: 0.0,
      taxRatePercent: 7.0,
    );

    print(
        'ยอดรวมสินค้า: ${CalculationFormulas.formatThaiCurrency(1000.0)} (ก่อน VAT)');
    print(
        'ฐานภาษี: ${CalculationFormulas.formatThaiCurrency(exclusiveResult['beforeVat']!)}');
    print(
        'VAT: ${CalculationFormulas.formatThaiCurrency(exclusiveResult['vatAmount']!)}');
    print(
        'ยอดรวมสุดท้าย: ${CalculationFormulas.formatThaiCurrency(exclusiveResult['grandTotal']!)}');

    // ตัวอย่างการแปลงจากสตริง
    print('\n3. การแปลงจากสตริงที่มีคอมม่า:');
    final inputs = ['1,234.56', '1,000,000.00 บาท', '7.5%'];
    for (final input in inputs) {
      final parsed = CalculationFormulas.parseThaiNumber(input);
      print('$input → $parsed');
    }

    // ตัวอย่างการสร้างรายงาน
    print('\n4. รายงานการคำนวณแบบไทย:');
    final explanation = CalculationFormulas.generateThaiCalculationExplanation(
      vatMode: VatMode.inclusive,
      grossAmount: 1070.0,
      taxableDiscount: 70.0,
      nonTaxableDiscount: 0.0,
      taxRatePercent: 7.0,
    );
    print(explanation);
  }
}
