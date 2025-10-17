import '../../models/barcode_item.dart';
import 'package:flutter/material.dart';

enum PurchaseStatus { initial, loading, loaded, failure }

enum VatMode {
  inclusive, // โหมด A: ราคาสินค้ารวม VAT
  exclusive // โหมด B: ราคาสินค้าไม่รวม VAT
}

class CartItem {
  final ProductItem product;
  final int quantity;
  final double? discount;
  final bool? isPercentageDiscount;

  const CartItem(
      {required this.product,
      required this.quantity,
      this.discount,
      this.isPercentageDiscount});

  double get finalPrice {
    final basePrice = product.price ?? 0.0;
    if (discount == null || discount == 0) {
      return basePrice;
    }

    if (isPercentageDiscount == true) {
      // ส่วนลดเปอร์เซ็นต์ - คำนวณจากราคาต่อชิ้น
      return basePrice * (1 - (discount! / 100));
    } else {
      // ส่วนลดเป็นเงิน - เป็นส่วนลดของทั้งบรรทัด แบ่งด้วยจำนวน
      final discountPerUnit = discount! / quantity;
      return basePrice - discountPerUnit;
    }
  }

  double get discountAmount {
    if (discount == null || discount == 0) return 0.0;
    if (isPercentageDiscount == true) {
      // ส่วนลดเปอร์เซ็นต์ - คำนวณจากราคาต่อชิ้น
      return (product.price ?? 0.0) * (discount! / 100);
    }
    // ส่วนลดเป็นเงิน - เป็นส่วนลดของทั้งบรรทัด แบ่งด้วยจำนวน
    return discount! / quantity;
  }

  // เพิ่ม method สำหรับคำนวณส่วนลดทั้งบรรทัด
  double get totalDiscountAmount {
    if (discount == null || discount == 0) return 0.0;
    if (isPercentageDiscount == true) {
      // ส่วนลดเปอร์เซ็นต์ - คำนวณจากราคารวมทั้งบรรทัด
      final totalPrice = (product.price ?? 0.0) * quantity;
      return totalPrice * (discount! / 100);
    }
    // ส่วนลดเป็นเงิน - เป็นจำนวนเงินคงที่ของทั้งบรรทัด
    return discount!;
  }

  CartItem copyWith(
      {ProductItem? product,
      int? quantity,
      double? discount,
      bool? isPercentageDiscount}) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      discount: discount ?? this.discount,
      isPercentageDiscount: isPercentageDiscount ?? this.isPercentageDiscount,
    );
  }
}

class PurchaseState {
  final PurchaseStatus status;
  final List<ProductItem> items;
  final List<CartItem> cartItems;
  final String query;
  final double leftPanelWidth;
  final double minPanelWidth;
  final double maxPanelWidth;
  final ProductItem? selected;
  final int productTypeGroup; // 1,2,3
  final int produceGroup; // 1,2
  final String? error;

  // Form fields
  final String creditorName;
  final String creditorCode;
  final String employeeCode;
  final String employeeName;
  final String branch;
  final String referenceDoc;
  final String taxInvoice;
  final String remarks;
  final String taxRate;
  final int taxType;
  final int paymentType;
  final DateTime documentDate;
  final TimeOfDay documentTime;
  final DateTime referenceDate;
  final DateTime taxinvoiceDate;

  // Totals
  final double subTotal;
  final double taxAmount;
  final double totalAmount;
  final double discount;

  // เพิ่มรายละเอียดการคำนวณใหม่
  final double beforePaymentDiscount;
  final double taxableDiscount;
  final double nonTaxableDiscount;
  final double taxableAmount;
  final double nonTaxableAmount;
  final double roundingAmount;
  final double netTaxAmount;
  final double grandTotal;

  // เพิ่มข้อมูลการชำระเงิน
  final double receivedAmount;
  final double changeAmount;

  // เพิ่มโหมด VAT
  final VatMode vatMode;

  const PurchaseState({
    this.status = PurchaseStatus.initial,
    this.items = const [],
    this.cartItems = const [],
    this.query = '',
    this.leftPanelWidth = 400,
    this.minPanelWidth = 300,
    this.maxPanelWidth = 600,
    this.selected,
    this.productTypeGroup = 1,
    this.produceGroup = 1,
    this.error,
    this.creditorName = '',
    this.creditorCode = '',
    this.employeeCode = '',
    this.employeeName = '',
    this.branch = '',
    this.referenceDoc = '',
    this.taxInvoice = '',
    this.remarks = '',
    this.taxRate = '',
    this.taxType = 0,
    this.paymentType = 0,
    required this.documentDate,
    required this.documentTime,
    required this.referenceDate,
    required this.taxinvoiceDate,
    this.subTotal = 0.0,
    this.taxAmount = 0.0,
    this.totalAmount = 0.0,
    this.discount = 0.0,
    // เพิ่มค่าใหม่
    this.beforePaymentDiscount = 0.0,
    this.taxableDiscount = 0.0,
    this.nonTaxableDiscount = 0.0,
    this.taxableAmount = 0.0,
    this.nonTaxableAmount = 0.0,
    this.roundingAmount = 0.0,
    this.netTaxAmount = 0.0,
    this.grandTotal = 0.0,
    this.receivedAmount = 0.0,
    this.changeAmount = 0.0,
    this.vatMode = VatMode.inclusive,
  });

  List<ProductItem> getFilteredProductItems(List<BarcodeItem> barcodeItems) {
    List<ProductItem> productItems = convertBarcodeItemsToProductItems(
        barcodeItems); // แปลงข้อมูลจาก BarcodeItem
    return productItems
        .where((e) =>
            e.code.toLowerCase().contains(query.toLowerCase()) ||
            (e.name?.toLowerCase() ?? '').contains(query.toLowerCase()))
        .toList();
  }

  List<ProductItem> convertBarcodeItemsToProductItems(
      List<BarcodeItem> barcodeItems) {
    return barcodeItems.map((barcodeItem) {
      return ProductItem(
        unit: barcodeItem.unit,
        price: barcodeItem.price,
        stock: barcodeItem.stock,
        name: barcodeItem.name,
        code: barcodeItem.code, // สมมุติว่า BarcodeItem มีฟิลด์ `code`
      );
    }).toList();
  }

  PurchaseState copyWith({
    PurchaseStatus? status,
    List<ProductItem>? items,
    List<CartItem>? cartItems,
    String? query,
    double? leftPanelWidth,
    double? minPanelWidth,
    double? maxPanelWidth,
    ProductItem? selected,
    int? productTypeGroup,
    int? produceGroup,
    String? error,
    bool clearSelected = false,
    String? creditorName,
    String? creditorCode,
    String? employeeCode,
    String? employeeName,
    String? branch,
    String? referenceDoc,
    String? taxInvoice,
    String? remarks,
    String? taxRate,
    int? taxType,
    int? paymentType,
    DateTime? documentDate,
    TimeOfDay? documentTime,
    DateTime? referenceDate,
    DateTime? taxinvoiceDate,
    double? subTotal,
    double? taxAmount,
    double? totalAmount,
    double? discount,
    // เพิ่มพารามิเตอร์ใหม่
    double? beforePaymentDiscount,
    double? taxableDiscount,
    double? nonTaxableDiscount,
    double? taxableAmount,
    double? nonTaxableAmount,
    double? roundingAmount,
    double? netTaxAmount,
    double? grandTotal,
    double? receivedAmount,
    double? changeAmount,
    VatMode? vatMode,
  }) {
    return PurchaseState(
      status: status ?? this.status,
      items: items ?? this.items,
      cartItems: cartItems ?? this.cartItems,
      query: query ?? this.query,
      leftPanelWidth: leftPanelWidth ?? this.leftPanelWidth,
      minPanelWidth: minPanelWidth ?? this.minPanelWidth,
      maxPanelWidth: maxPanelWidth ?? this.maxPanelWidth,
      selected: clearSelected ? null : (selected ?? this.selected),
      productTypeGroup: productTypeGroup ?? this.productTypeGroup,
      produceGroup: produceGroup ?? this.produceGroup,
      error: error,
      creditorName: creditorName ?? this.creditorName,
      creditorCode: creditorCode ?? this.creditorCode,
      employeeCode: employeeCode ?? this.employeeCode,
      employeeName: employeeName ?? this.employeeName,
      branch: branch ?? this.branch,
      referenceDoc: referenceDoc ?? this.referenceDoc,
      taxInvoice: taxInvoice ?? this.taxInvoice,
      remarks: remarks ?? this.remarks,
      taxRate: taxRate ?? this.taxRate,
      taxType: taxType ?? this.taxType,
      paymentType: paymentType ?? this.paymentType,
      documentDate: documentDate ?? this.documentDate,
      documentTime: documentTime ?? this.documentTime,
      referenceDate: referenceDate ?? this.referenceDate,
      taxinvoiceDate: taxinvoiceDate ?? this.taxinvoiceDate,
      subTotal: subTotal ?? this.subTotal,
      taxAmount: taxAmount ?? this.taxAmount,
      totalAmount: totalAmount ?? this.totalAmount,
      discount: discount ?? this.discount,
      // เพิ่มค่าใหม่
      beforePaymentDiscount:
          beforePaymentDiscount ?? this.beforePaymentDiscount,
      taxableDiscount: taxableDiscount ?? this.taxableDiscount,
      nonTaxableDiscount: nonTaxableDiscount ?? this.nonTaxableDiscount,
      taxableAmount: taxableAmount ?? this.taxableAmount,
      nonTaxableAmount: nonTaxableAmount ?? this.nonTaxableAmount,
      roundingAmount: roundingAmount ?? this.roundingAmount,
      netTaxAmount: netTaxAmount ?? this.netTaxAmount,
      grandTotal: grandTotal ?? this.grandTotal,
      receivedAmount: receivedAmount ?? this.receivedAmount,
      changeAmount: changeAmount ?? this.changeAmount,
      vatMode: vatMode ?? this.vatMode,
    );
  }
}
