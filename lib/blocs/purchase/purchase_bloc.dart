import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_app/blocs/purchase/purchase_event.dart';
import 'package:flutter_web_app/repository/purchase_repository.dart';
import 'purchase_state.dart';

class PurchaseBloc extends Bloc<PurchaseEvent, PurchaseState> {
  final ProductRepository repo;

  PurchaseBloc(this.repo)
      : super(PurchaseState(
          documentDate: DateTime.now(),
          documentTime: TimeOfDay.now(),
          referenceDate: DateTime.now(),
          taxinvoiceDate: DateTime.now(),
        )) {
    on<PurchaseInitialized>(_onInit);
    on<PurchaseSearchChanged>(_onSearchChanged);
    on<PurchaseLeftPanelDragged>(_onDragged);
    on<PurchaseItemSelected>(_onSelected);
    on<PurchaseProductTypeChanged>(_onProductTypeChanged);
    on<PurchaseProduceTypeChanged>(_onProduceTypeChanged);
    on<PurchaseItemAdded>(_onItemAdded);
    on<PurchaseItemRemoved>(_onItemRemoved);
    on<PurchaseQuantityChanged>(_onQuantityChanged);
    on<PurchaseBarcodeScanned>(_onBarcodeScanned);
    on<PurchaseItemUpdated>(_onItemUpdated);
    on<PurchaseClearAll>(_onClearAll);
    on<PurchaseFormUpdated>(_onFormUpdated);
    on<PurchaseTotalUpdated>(_onTotalUpdated);
    on<PurchaseDiscountChanged>(_onDiscountChanged);
    on<PurchaseCalculationDetailsUpdated>(_onCalculationDetailsUpdated);
    on<PurchasePaymentUpdated>(_onPaymentUpdated);
    on<PurchaseVatModeChanged>(_onVatModeChanged);
  }
  Future<void> _onInit(
    PurchaseInitialized event,
    Emitter<PurchaseState> emit,
  ) async {
    emit(state.copyWith(status: PurchaseStatus.loading));
    try {
      final items = await repo.fetchItems();
      emit(state.copyWith(status: PurchaseStatus.loaded, items: items));
    } catch (e) {
      emit(state.copyWith(status: PurchaseStatus.failure, error: e.toString()));
    }
  }

  void _onSearchChanged(
    PurchaseSearchChanged event,
    Emitter<PurchaseState> emit,
  ) {
    emit(state.copyWith(query: event.query, clearSelected: true));
  }

  void _onDragged(
    PurchaseLeftPanelDragged event,
    Emitter<PurchaseState> emit,
  ) {
    final w = (state.leftPanelWidth + event.dx)
        .clamp(state.minPanelWidth, state.maxPanelWidth);
    emit(state.copyWith(leftPanelWidth: w));
  }

  void _onSelected(
    PurchaseItemSelected event,
    Emitter<PurchaseState> emit,
  ) {
    emit(state.copyWith(selected: event.item));
  }

  void _onProductTypeChanged(
    PurchaseProductTypeChanged event,
    Emitter<PurchaseState> emit,
  ) {
    emit(state.copyWith(productTypeGroup: event.value));
  }

  void _onProduceTypeChanged(
    PurchaseProduceTypeChanged event,
    Emitter<PurchaseState> emit,
  ) {
    emit(state.copyWith(produceGroup: event.value));
  }

  void _onItemAdded(
    PurchaseItemAdded event,
    Emitter<PurchaseState> emit,
  ) {
    final existingIndex = state.cartItems.indexWhere(
      (item) => item.product.code == event.item.code,
    );

    List<CartItem> updatedCart;
    if (existingIndex >= 0) {
      updatedCart = List.from(state.cartItems);
      updatedCart[existingIndex] = updatedCart[existingIndex].copyWith(
        quantity: updatedCart[existingIndex].quantity + event.quantity,
      );
    } else {
      updatedCart = [
        ...state.cartItems,
        CartItem(product: event.item, quantity: event.quantity)
      ];
    }

    final totals = _calculateTotals(updatedCart);
    emit(state.copyWith(
      cartItems: updatedCart,
      subTotal: totals['subTotal']!,
      discount: totals['discount']!,
      totalAmount: totals['totalAmount']!,
    ));
  }

  void _onItemRemoved(
    PurchaseItemRemoved event,
    Emitter<PurchaseState> emit,
  ) {
    final updatedCart = List<CartItem>.from(state.cartItems);
    updatedCart.removeAt(event.index);
    final totals = _calculateTotals(updatedCart);
    emit(state.copyWith(
      cartItems: updatedCart,
      subTotal: totals['subTotal']!,
      discount: totals['discount']!,
      totalAmount: totals['totalAmount']!,
    ));
  }

  void _onQuantityChanged(
    PurchaseQuantityChanged event,
    Emitter<PurchaseState> emit,
  ) {
    final updatedCart = List<CartItem>.from(state.cartItems);
    if (event.quantity <= 0) {
      updatedCart.removeAt(event.index);
    } else {
      updatedCart[event.index] =
          updatedCart[event.index].copyWith(quantity: event.quantity);
    }
    final totals = _calculateTotals(updatedCart);
    emit(state.copyWith(
      cartItems: updatedCart,
      subTotal: totals['subTotal']!,
      discount: totals['discount']!,
      totalAmount: totals['totalAmount']!,
    ));
  }

  Future<void> _onBarcodeScanned(
    PurchaseBarcodeScanned event,
    Emitter<PurchaseState> emit,
  ) async {
    final product =
        state.items.where((item) => item.code == event.barcode).firstOrNull;
    if (product != null) {
      add(PurchaseItemAdded(product, 1));
    }
  }

  void _onItemUpdated(
    PurchaseItemUpdated event,
    Emitter<PurchaseState> emit,
  ) {
    final updatedCart = List<CartItem>.from(state.cartItems);
    updatedCart[event.index] =
        updatedCart[event.index].copyWith(product: event.item);
    emit(state.copyWith(cartItems: updatedCart));
  }

  void _onClearAll(
    PurchaseClearAll event,
    Emitter<PurchaseState> emit,
  ) {
    emit(state.copyWith(
      cartItems: [],
      subTotal: 0.0,
      discount: 0.0,
      totalAmount: 0.0,
    ));
  }

  void _onFormUpdated(
    PurchaseFormUpdated event,
    Emitter<PurchaseState> emit,
  ) {
    emit(state.copyWith(
      creditorName: event.creditorName,
      creditorCode: event.creditorCode,
      employeeCode: event.employeeCode,
      employeeName: event.employeeName,
      branch: event.branch,
      referenceDoc: event.referenceDoc,
      taxInvoice: event.taxInvoice,
      remarks: event.remarks,
      taxRate: event.taxRate,
      taxType: event.taxType,
      paymentType: event.paymentType,
      documentDate: event.documentDate,
      documentTime: event.documentTime,
      referenceDate: event.referenceDate,
      taxinvoiceDate: event.taxinvoiceDate,
    ));
  }

  void _onTotalUpdated(
    PurchaseTotalUpdated event,
    Emitter<PurchaseState> emit,
  ) {
    emit(state.copyWith(
      subTotal: event.subTotal,
      taxAmount: event.taxAmount,
      totalAmount: event.totalAmount,
      discount: event.discount,
    ));
  }

  void _onDiscountChanged(
    PurchaseDiscountChanged event,
    Emitter<PurchaseState> emit,
  ) {
    final updatedCart = List<CartItem>.from(state.cartItems);
    if (event.index < updatedCart.length) {
      updatedCart[event.index] = updatedCart[event.index].copyWith(
        discount: event.discount,
        isPercentageDiscount: event.isPercentageDiscount,
      );
      final totals = _calculateTotals(updatedCart);
      emit(state.copyWith(
        cartItems: updatedCart,
        subTotal: totals['subTotal']!,
        discount: totals['discount']!,
        totalAmount: totals['totalAmount']!,
      ));
    }
  }

  void _onCalculationDetailsUpdated(
    PurchaseCalculationDetailsUpdated event,
    Emitter<PurchaseState> emit,
  ) {
    // คำนวณ grandTotal ใหม่
    final baseAmount = state.subTotal - state.discount;
    final afterAllDiscounts = baseAmount -
        (event.beforePaymentDiscount ?? 0.0) -
        (event.taxableDiscount ?? 0.0) -
        (event.nonTaxableDiscount ?? 0.0);
    final grandTotal = afterAllDiscounts +
        (event.taxAmount ?? 0.0) +
        (event.roundingAmount ?? 0.0);

    emit(state.copyWith(
      beforePaymentDiscount: event.beforePaymentDiscount,
      taxableDiscount: event.taxableDiscount,
      nonTaxableDiscount: event.nonTaxableDiscount,
      taxableAmount: event.taxableAmount,
      nonTaxableAmount: event.nonTaxableAmount,
      netTaxAmount: event.taxAmount,
      roundingAmount: event.roundingAmount,
      grandTotal: grandTotal,
    ));
  }

  void _onPaymentUpdated(
    PurchasePaymentUpdated event,
    Emitter<PurchaseState> emit,
  ) {
    // คำนวณเงินทอนใหม่ถ้าจำเป็น
    final changeAmount = event.changeAmount ??
        ((event.receivedAmount ?? state.receivedAmount) - state.grandTotal);

    emit(state.copyWith(
      receivedAmount: event.receivedAmount,
      changeAmount: changeAmount,
    ));
  }

  void _onVatModeChanged(
    PurchaseVatModeChanged event,
    Emitter<PurchaseState> emit,
  ) {
    emit(state.copyWith(
      vatMode: event.vatMode,
    ));
  }

  // อัปเดตฟังก์ชัน _calculateTotals เพื่อให้คำนวณรายละเอียดมากขึ้น
  Map<String, double> _calculateTotals(List<CartItem> cartItems) {
    double subTotal = 0.0;
    double totalDiscount = 0.0;
    double taxableAmount = 0.0;
    double nonTaxableAmount = 0.0;

    for (final item in cartItems) {
      final basePrice = (item.product.price ?? 0.0) * item.quantity;
      subTotal += basePrice;
      totalDiscount += item.totalDiscountAmount;

      // สมมุติว่าสินค้าทั้งหมดมีภาษี (ในที่นี้)
      taxableAmount += basePrice - item.totalDiscountAmount;
    }

    // คำนวณภาษี
    final taxRate = double.tryParse(state.taxRate) ?? 0.0;
    final taxAmount = taxableAmount * (taxRate / 100);

    final netAmount = subTotal - totalDiscount;
    final totalAmount = netAmount + taxAmount;

    return {
      'subTotal': subTotal,
      'discount': totalDiscount,
      'taxableAmount': taxableAmount,
      'nonTaxableAmount': nonTaxableAmount,
      'taxAmount': taxAmount,
      'totalAmount': totalAmount,
    };
  }
}
