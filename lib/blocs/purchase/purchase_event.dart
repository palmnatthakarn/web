import 'package:flutter/material.dart';
import '../../models/barcode_item.dart';
import 'purchase_state.dart';

abstract class PurchaseEvent {
  const PurchaseEvent();
}

class PurchaseInitialized extends PurchaseEvent {
  const PurchaseInitialized();
}

class PurchaseSearchChanged extends PurchaseEvent {
  final String query;
  const PurchaseSearchChanged(this.query);
}

class PurchaseLeftPanelDragged extends PurchaseEvent {
  final double dx;
  const PurchaseLeftPanelDragged(this.dx);
}

class PurchaseItemSelected extends PurchaseEvent {
  final ProductItem item;
  const PurchaseItemSelected(this.item);
}

class PurchaseProductTypeChanged extends PurchaseEvent {
  final int value; // 1 ปกติ, 2 ส่วนผสม, 3 บริการ
  const PurchaseProductTypeChanged(this.value);
}

class PurchaseProduceTypeChanged extends PurchaseEvent {
  final int value; // 1 มีการผลิต, 2 ไม่มีการผลิต
  const PurchaseProduceTypeChanged(this.value);
}

class PurchaseItemAdded extends PurchaseEvent {
  final ProductItem item;
  final int quantity;
  const PurchaseItemAdded(this.item, this.quantity);
}

class PurchaseItemRemoved extends PurchaseEvent {
  final int index;
  const PurchaseItemRemoved(this.index);
}

class PurchaseQuantityChanged extends PurchaseEvent {
  final int index;
  final int quantity;
  const PurchaseQuantityChanged(this.index, this.quantity);
}

class PurchaseBarcodeScanned extends PurchaseEvent {
  final String barcode;
  const PurchaseBarcodeScanned(this.barcode);
}

class PurchaseItemUpdated extends PurchaseEvent {
  final int index;
  final ProductItem item;
  const PurchaseItemUpdated(this.index, this.item);
}

class PurchaseClearAll extends PurchaseEvent {
  const PurchaseClearAll();
}

// Events for Form Updates
class PurchaseFormUpdated extends PurchaseEvent {
  final String? creditorName;
  final String? creditorCode;
  final String? employeeCode;
  final String? employeeName;
  final String? branch;
  final String? referenceDoc;
  final String? taxInvoice;
  final String? remarks;
  final String? taxRate;
  final int? taxType;
  final int? paymentType;
  final DateTime? documentDate;
  final TimeOfDay? documentTime;
  final DateTime? referenceDate;
  final DateTime? taxinvoiceDate;

  const PurchaseFormUpdated({
    this.creditorName,
    this.creditorCode,
    this.employeeCode,
    this.employeeName,
    this.branch,
    this.referenceDoc,
    this.taxInvoice,
    this.remarks,
    this.taxRate,
    this.taxType,
    this.paymentType,
    this.documentDate,
    this.documentTime,
    this.referenceDate,
    this.taxinvoiceDate,
  });
}

// Events for Total Updates
class PurchaseTotalUpdated extends PurchaseEvent {
  final double subTotal;
  final double taxAmount;
  final double totalAmount;
  final double discount;

  const PurchaseTotalUpdated(
      {required this.subTotal,
      required this.taxAmount,
      required this.totalAmount,
      required this.discount});
}

// Event for Discount Updates
class PurchaseDiscountChanged extends PurchaseEvent {
  final int index;
  final double discount;
  final bool isPercentageDiscount;

  const PurchaseDiscountChanged({
    required this.index,
    required this.discount,
    required this.isPercentageDiscount,
  });
}

// เพิ่ม Events ใหม่สำหรับการคำนวณรายละเอียด
class PurchaseCalculationDetailsUpdated extends PurchaseEvent {
  final double? beforePaymentDiscount;
  final double? taxableDiscount;
  final double? nonTaxableDiscount;
  final double? taxableAmount;
  final double? nonTaxableAmount;
  final double? taxAmount;
  final double? roundingAmount;

  const PurchaseCalculationDetailsUpdated({
    this.beforePaymentDiscount,
    this.taxableDiscount,
    this.nonTaxableDiscount,
    this.taxableAmount,
    this.nonTaxableAmount,
    this.taxAmount,
    this.roundingAmount,
  });
}

// Event สำหรับการชำระเงิน
class PurchasePaymentUpdated extends PurchaseEvent {
  final double? receivedAmount;
  final double? changeAmount;

  const PurchasePaymentUpdated({
    this.receivedAmount,
    this.changeAmount,
  });
}

// Event สำหรับการเปลี่ยนโหมด VAT
class PurchaseVatModeChanged extends PurchaseEvent {
  final VatMode vatMode;

  const PurchaseVatModeChanged(this.vatMode);
}
