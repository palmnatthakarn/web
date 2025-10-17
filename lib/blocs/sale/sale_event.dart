import 'package:equatable/equatable.dart';
import 'package:flutter_web_app/blocs/purchase/purchase_state.dart';
import 'package:flutter_web_app/models/barcode_item.dart';

abstract class SaleEvent extends Equatable {
  const SaleEvent();

  @override
  List<Object?> get props => [];
}

class SaleItemAdded extends SaleEvent {
  final ProductItem product;
  final int quantity;

  const SaleItemAdded(this.product, this.quantity);

  @override
  List<Object> get props => [product, quantity];
}

class SaleItemRemoved extends SaleEvent {
  final int index;

  const SaleItemRemoved(this.index);

  @override
  List<Object> get props => [index];
}

class SaleItemUpdated extends SaleEvent {
  final int index;
  final ProductItem product;

  const SaleItemUpdated(this.index, this.product);

  @override
  List<Object> get props => [index, product];
}

class SaleQuantityChanged extends SaleEvent {
  final int index;
  final int quantity;

  const SaleQuantityChanged(this.index, this.quantity);

  @override
  List<Object> get props => [index, quantity];
}

class SaleDiscountChanged extends SaleEvent {
  final int index;
  final double discount;
  final bool isPercentageDiscount;

  const SaleDiscountChanged({
    required this.index,
    required this.discount,
    required this.isPercentageDiscount,
  });

  @override
  List<Object> get props => [index, discount, isPercentageDiscount];
}

class SaleSearchChanged extends SaleEvent {
  final String searchTerm;

  const SaleSearchChanged(this.searchTerm);

  @override
  List<Object> get props => [searchTerm];
}

class SaleBarcodeScanned extends SaleEvent {
  final String barcode;

  const SaleBarcodeScanned(this.barcode);

  @override
  List<Object> get props => [barcode];
}

class SaleVatModeChanged extends SaleEvent {
  final VatMode vatMode;

  const SaleVatModeChanged(this.vatMode);

  @override
  List<Object> get props => [vatMode];
}

class SaleCalculationDetailsUpdated extends SaleEvent {
  final double beforePaymentDiscount;
  final double taxableDiscount;
  final double nonTaxableDiscount;
  final double taxableAmount;
  final double nonTaxableAmount;
  final double taxAmount;
  final double roundingAmount;

  const SaleCalculationDetailsUpdated({
    required this.beforePaymentDiscount,
    required this.taxableDiscount,
    required this.nonTaxableDiscount,
    required this.taxableAmount,
    required this.nonTaxableAmount,
    required this.taxAmount,
    required this.roundingAmount,
  });

  @override
  List<Object> get props => [
        beforePaymentDiscount,
        taxableDiscount,
        nonTaxableDiscount,
        taxableAmount,
        nonTaxableAmount,
        taxAmount,
        roundingAmount,
      ];
}

class SalePaymentUpdated extends SaleEvent {
  final double receivedAmount;
  final double changeAmount;

  const SalePaymentUpdated({
    required this.receivedAmount,
    required this.changeAmount,
  });

  @override
  List<Object> get props => [receivedAmount, changeAmount];
}

class SaleReset extends SaleEvent {
  const SaleReset();
}