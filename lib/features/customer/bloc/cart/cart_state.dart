import 'package:equatable/equatable.dart';
import 'package:myapp/features/customer/domain/entities/cart_item.dart';

enum CartStatus { initial, loading, loaded, error }

class CartState extends Equatable {
  final CartStatus status;
  final List<CartItem> items;
  final double subtotal;
  final double discount;
  final double deliveryFee;
  final double total;
  final String? appliedCoupon;
  final String? errorMessage;

  const CartState({
    this.status = CartStatus.initial,
    this.items = const [],
    this.subtotal = 0.0,
    this.discount = 0.0,
    this.deliveryFee = 5.99,
    this.total = 0.0,
    this.appliedCoupon,
    this.errorMessage,
  });

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity.round());  // Round to get whole number for display

  bool get isEmpty => items.isEmpty;

  CartState copyWith({
    CartStatus? status,
    List<CartItem>? items,
    double? subtotal,
    double? discount,
    double? deliveryFee,
    double? total,
    String? appliedCoupon,
    String? errorMessage,
    bool clearAppliedCoupon = false,
    bool clearErrorMessage = false,
  }) {
    return CartState(
      status: status ?? this.status,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      discount: discount ?? this.discount,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      total: total ?? this.total,
      appliedCoupon: clearAppliedCoupon ? null : appliedCoupon ?? this.appliedCoupon,
      errorMessage: clearErrorMessage ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        items,
        subtotal,
        discount,
        deliveryFee,
        total,
        appliedCoupon,
        errorMessage,
      ];
}