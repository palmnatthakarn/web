import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_app/blocs/purchase/purchase_state.dart';
import 'package:flutter_web_app/models/barcode_item.dart';
import 'sale_event.dart';
import 'sale_state.dart';

class SaleBloc extends Bloc<SaleEvent, SaleState> {
  SaleBloc() : super(const SaleState()) {
    on<SaleItemAdded>(_onItemAdded);
    on<SaleItemRemoved>(_onItemRemoved);
    on<SaleItemUpdated>(_onItemUpdated);
    on<SaleQuantityChanged>(_onQuantityChanged);
    on<SaleDiscountChanged>(_onDiscountChanged);
    on<SaleSearchChanged>(_onSearchChanged);
    on<SaleBarcodeScanned>(_onBarcodeScanned);
    on<SaleVatModeChanged>(_onVatModeChanged);
    on<SaleCalculationDetailsUpdated>(_onCalculationDetailsUpdated);
    on<SalePaymentUpdated>(_onPaymentUpdated);
    on<SaleReset>(_onReset);
  }

  void _onItemAdded(SaleItemAdded event, Emitter<SaleState> emit) {
    final newCartItem = CartItem(
      product: event.product,
      quantity: event.quantity,
      discount: 0.0,
      isPercentageDiscount: false,
      //finalPrice: event.product.price ?? 0.0,
      //totalDiscountAmount: 0.0,
    );

    final updatedCartItems = List<CartItem>.from(state.cartItems)..add(newCartItem);
    final newSubTotal = _calculateSubTotal(updatedCartItems);

    emit(state.copyWith(
      cartItems: updatedCartItems,
      subTotal: newSubTotal,
      grandTotal: newSubTotal,
    ));
  }

  void _onItemRemoved(SaleItemRemoved event, Emitter<SaleState> emit) {
    if (event.index >= 0 && event.index < state.cartItems.length) {
      final updatedCartItems = List<CartItem>.from(state.cartItems)..removeAt(event.index);
      final newSubTotal = _calculateSubTotal(updatedCartItems);

      emit(state.copyWith(
        cartItems: updatedCartItems,
        subTotal: newSubTotal,
        grandTotal: newSubTotal,
      ));
    }
  }

  void _onItemUpdated(SaleItemUpdated event, Emitter<SaleState> emit) {
    if (event.index >= 0 && event.index < state.cartItems.length) {
      final updatedCartItems = List<CartItem>.from(state.cartItems);
      final currentItem = updatedCartItems[event.index];
      
      updatedCartItems[event.index] = CartItem(
        product: event.product,
        quantity: currentItem.quantity,
        discount: currentItem.discount,
        isPercentageDiscount: currentItem.isPercentageDiscount,
       // finalPrice: event.product.price ?? 0.0,
       // totalDiscountAmount: currentItem.totalDiscountAmount,
      );

      final newSubTotal = _calculateSubTotal(updatedCartItems);

      emit(state.copyWith(
        cartItems: updatedCartItems,
        subTotal: newSubTotal,
        grandTotal: newSubTotal,
      ));
    }
  }

  void _onQuantityChanged(SaleQuantityChanged event, Emitter<SaleState> emit) {
    if (event.index >= 0 && event.index < state.cartItems.length) {
      final updatedCartItems = List<CartItem>.from(state.cartItems);
      final currentItem = updatedCartItems[event.index];
      
      updatedCartItems[event.index] = CartItem(
        product: currentItem.product,
        quantity: event.quantity,
        discount: currentItem.discount,
        isPercentageDiscount: currentItem.isPercentageDiscount,
       // finalPrice: currentItem.finalPrice,
       // totalDiscountAmount: currentItem.totalDiscountAmount,
      );

      final newSubTotal = _calculateSubTotal(updatedCartItems);

      emit(state.copyWith(
        cartItems: updatedCartItems,
        subTotal: newSubTotal,
        grandTotal: newSubTotal,
      ));
    }
  }

  void _onDiscountChanged(SaleDiscountChanged event, Emitter<SaleState> emit) {
    if (event.index >= 0 && event.index < state.cartItems.length) {
      final updatedCartItems = List<CartItem>.from(state.cartItems);
      final currentItem = updatedCartItems[event.index];
      final originalPrice = currentItem.product?.price ?? 0.0;
      
      double finalPrice = originalPrice;
      double totalDiscountAmount = 0.0;

      if (event.discount > 0) {
        if (event.isPercentageDiscount) {
          totalDiscountAmount = originalPrice * (event.discount / 100);
          finalPrice = originalPrice - totalDiscountAmount;
        } else {
          totalDiscountAmount = event.discount;
          finalPrice = originalPrice - event.discount;
        }
      }

      updatedCartItems[event.index] = CartItem(
        product: currentItem.product,
        quantity: currentItem.quantity,
        discount: event.discount,
        isPercentageDiscount: event.isPercentageDiscount,
       // finalPrice: finalPrice.clamp(0.0, double.infinity),
        //totalDiscountAmount: totalDiscountAmount,
      );

      final newSubTotal = _calculateSubTotal(updatedCartItems);

      emit(state.copyWith(
        cartItems: updatedCartItems,
        subTotal: newSubTotal,
        grandTotal: newSubTotal,
      ));
    }
  }

  void _onSearchChanged(SaleSearchChanged event, Emitter<SaleState> emit) {
    emit(state.copyWith(searchTerm: event.searchTerm));
  }

  void _onBarcodeScanned(SaleBarcodeScanned event, Emitter<SaleState> emit) {
    // Mock product for barcode
    final mockProduct = ProductItem(
      code: 'SCAN${DateTime.now().millisecondsSinceEpoch}',
      barcode: event.barcode,
      name: 'สินค้าจากบาร์โค้ด ${event.barcode}',
      price: 100.0,
      unit: 'ชิ้น',
      stock: 999,
    );

    add(SaleItemAdded(mockProduct, 1));
  }

  void _onVatModeChanged(SaleVatModeChanged event, Emitter<SaleState> emit) {
    emit(state.copyWith(vatMode: event.vatMode));
  }

  void _onCalculationDetailsUpdated(SaleCalculationDetailsUpdated event, Emitter<SaleState> emit) {
    emit(state.copyWith(
      beforePaymentDiscount: event.beforePaymentDiscount,
      taxableDiscount: event.taxableDiscount,
      nonTaxableDiscount: event.nonTaxableDiscount,
      netTaxAmount: event.taxAmount,
      roundingAmount: event.roundingAmount,
    ));
  }

  void _onPaymentUpdated(SalePaymentUpdated event, Emitter<SaleState> emit) {
    emit(state.copyWith(
      receivedAmount: event.receivedAmount,
      changeAmount: event.changeAmount,
    ));
  }

  void _onReset(SaleReset event, Emitter<SaleState> emit) {
    emit(const SaleState());
  }

  double _calculateSubTotal(List<CartItem> cartItems) {
    return cartItems.fold(0.0, (sum, item) {
      if (item.product != null) {
        return sum + ((item.finalPrice ?? 0.0) * (item.quantity ?? 0));
      }
      return sum;
    });
  }
}