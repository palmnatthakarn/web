import 'package:equatable/equatable.dart';
import 'package:flutter_web_app/models/barcode_item.dart';
import 'package:flutter_web_app/blocs/purchase/purchase_state.dart';

class SaleState extends Equatable {
  final List<CartItem> cartItems;
  final List<ProductItem> items;
  final String searchTerm;
  final double subTotal;
  final double grandTotal;
  final double netTaxAmount;
  final String taxRate;
  final VatMode vatMode;
  final double beforePaymentDiscount;
  final double taxableDiscount;
  final double nonTaxableDiscount;
  final double roundingAmount;
  final double receivedAmount;
  final double changeAmount;
  final bool isLoading;
  final String? errorMessage;

  const SaleState({
    this.cartItems = const [],
    this.items = const [],
    this.searchTerm = '',
    this.subTotal = 0.0,
    this.grandTotal = 0.0,
    this.netTaxAmount = 0.0,
    this.taxRate = '7.0',
    this.vatMode = VatMode.inclusive,
    this.beforePaymentDiscount = 0.0,
    this.taxableDiscount = 0.0,
    this.nonTaxableDiscount = 0.0,
    this.roundingAmount = 0.0,
    this.receivedAmount = 0.0,
    this.changeAmount = 0.0,
    this.isLoading = false,
    this.errorMessage,
  });

  SaleState copyWith({
    List<CartItem>? cartItems,
    List<ProductItem>? items,
    String? searchTerm,
    double? subTotal,
    double? grandTotal,
    double? netTaxAmount,
    String? taxRate,
    VatMode? vatMode,
    double? beforePaymentDiscount,
    double? taxableDiscount,
    double? nonTaxableDiscount,
    double? roundingAmount,
    double? receivedAmount,
    double? changeAmount,
    bool? isLoading,
    String? errorMessage,
  }) {
    return SaleState(
      cartItems: cartItems ?? this.cartItems,
      items: items ?? this.items,
      searchTerm: searchTerm ?? this.searchTerm,
      subTotal: subTotal ?? this.subTotal,
      grandTotal: grandTotal ?? this.grandTotal,
      netTaxAmount: netTaxAmount ?? this.netTaxAmount,
      taxRate: taxRate ?? this.taxRate,
      vatMode: vatMode ?? this.vatMode,
      beforePaymentDiscount:
          beforePaymentDiscount ?? this.beforePaymentDiscount,
      taxableDiscount: taxableDiscount ?? this.taxableDiscount,
      nonTaxableDiscount: nonTaxableDiscount ?? this.nonTaxableDiscount,
      roundingAmount: roundingAmount ?? this.roundingAmount,
      receivedAmount: receivedAmount ?? this.receivedAmount,
      changeAmount: changeAmount ?? this.changeAmount,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        cartItems,
        items,
        searchTerm,
        subTotal,
        grandTotal,
        netTaxAmount,
        taxRate,
        vatMode,
        beforePaymentDiscount,
        taxableDiscount,
        nonTaxableDiscount,
        roundingAmount,
        receivedAmount,
        changeAmount,
        isLoading,
        errorMessage,
      ];
}
