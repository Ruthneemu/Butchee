// lib/features/customer/presentation/bloc/cart/cart_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/features/customer/domain/entities/cart_item.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState()) {
    on<LoadCart>(_onLoadCart);
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<UpdateCartItemQuantity>(_onUpdateCartItemQuantity);
    on<ClearCart>(_onClearCart);
    on<ApplyCoupon>(_onApplyCoupon);
    on<RemoveCoupon>(_onRemoveCoupon);
  }

  void _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    emit(state.copyWith(status: CartStatus.loading));
    
    try {
      // In a real app, load cart from storage or API
      await Future.delayed(const Duration(milliseconds: 500));
      emit(state.copyWith(status: CartStatus.loaded));
    } catch (e) {
      emit(state.copyWith(
        status: CartStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onAddToCart(AddToCart event, Emitter<CartState> emit) {
    final items = List<CartItem>.from(state.items);
    
    final existingIndex = items.indexWhere(
      (item) => item.product.id == event.product.id,
    );

    if (existingIndex >= 0) {
      items[existingIndex] = items[existingIndex].copyWith(
        quantity: items[existingIndex].quantity + event.quantity,
      );
    } else {
      items.add(CartItem(
        product: event.product,
        quantity: event.quantity,
      ));
    }

    _recalculateCart(emit, items);
  }

  void _onRemoveFromCart(RemoveFromCart event, Emitter<CartState> emit) {
    final items = state.items
        .where((item) => item.product.id != event.productId)
        .toList();
    
    _recalculateCart(emit, items);
  }

  void _onUpdateCartItemQuantity(
    UpdateCartItemQuantity event,
    Emitter<CartState> emit,
  ) {
    final items = state.items.map((item) {
      if (item.product.id == event.productId) {
        return item.copyWith(quantity: event.quantity);
      }
      return item;
    }).toList();

    _recalculateCart(emit, items);
  }

  void _onClearCart(ClearCart event, Emitter<CartState> emit) {
    emit(const CartState(status: CartStatus.loaded));
  }

  void _onApplyCoupon(ApplyCoupon event, Emitter<CartState> emit) {
    // Simulate coupon validation
    final couponCode = event.couponCode.toUpperCase();
    double discount = 0.0;

    if (couponCode == 'SAVE10') {
      discount = state.subtotal * 0.10;
    } else if (couponCode == 'SAVE20') {
      discount = state.subtotal * 0.20;
    } else if (couponCode == 'FREESHIP') {
      discount = state.deliveryFee;
    } else {
      emit(state.copyWith(
        status: CartStatus.error,
        errorMessage: 'Invalid coupon code',
      ));
      return;
    }

    final total = state.subtotal - discount + state.deliveryFee;

    emit(state.copyWith(
      appliedCoupon: couponCode,
      discount: discount,
      total: total,
      status: CartStatus.loaded,
      clearErrorMessage: true,
    ));
  }

  void _onRemoveCoupon(RemoveCoupon event, Emitter<CartState> emit) {
    final total = state.subtotal + state.deliveryFee;
    
    emit(state.copyWith(
      clearAppliedCoupon: true,
      discount: 0.0,
      total: total,
    ));
  }

  void _recalculateCart(Emitter<CartState> emit, List<CartItem> items) {
    final subtotal = items.fold<double>(
      0.0,
      (sum, item) => sum + (item.product.price * item.quantity),
    );

    double discount = 0.0;
    if (state.appliedCoupon != null) {
      // Recalculate discount based on new subtotal
      if (state.appliedCoupon == 'SAVE10') {
        discount = subtotal * 0.10;
      } else if (state.appliedCoupon == 'SAVE20') {
        discount = subtotal * 0.20;
      } else if (state.appliedCoupon == 'FREESHIP') {
        discount = state.deliveryFee;
      }
    }

    final total = subtotal - discount + state.deliveryFee;

    emit(state.copyWith(
      items: items,
      subtotal: subtotal,
      discount: discount,
      total: total,
      status: CartStatus.loaded,
      clearErrorMessage: true,
    ));
  }
}


