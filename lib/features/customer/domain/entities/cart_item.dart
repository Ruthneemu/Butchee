import 'package:equatable/equatable.dart';
import 'package:myapp/features/customer/domain/entities/product.dart';

class CartItem extends Equatable {
  final Product product;
  final double quantity;  // Changed from int to double to support fractional quantities
  final Map<String, dynamic> selectedOptions;  // Added to store product options

  const CartItem({
    required this.product,
    required this.quantity,
    this.selectedOptions = const {},  // Default empty map
  });

  double get totalPrice => product.price * quantity;

  CartItem copyWith({
    Product? product,
    double? quantity,
    Map<String, dynamic>? selectedOptions,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      selectedOptions: selectedOptions ?? this.selectedOptions,
    );
  }

  @override
  List<Object?> get props => [product, quantity, selectedOptions];
}