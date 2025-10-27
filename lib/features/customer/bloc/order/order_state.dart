import 'package:equatable/equatable.dart';
import 'package:myapp/features/customer/domain/entities/order.dart';

enum OrderStatus { initial, loading, loaded, placing, placed, error }

class OrderState extends Equatable {
  final OrderStatus status;
  final List<Order> orders;
  final Order? selectedOrder;
  final String? errorMessage;
  final String? successMessage;

  const OrderState({
    this.status = OrderStatus.initial,
    this.orders = const [],
    this.selectedOrder,
    this.errorMessage,
    this.successMessage,
  });

  List<Order> get activeOrders => orders
      .where((order) =>
          order.status != 'delivered' &&
          order.status != 'cancelled')
      .toList();

  List<Order> get completedOrders => orders
      .where((order) =>
          order.status == 'delivered' || order.status == 'cancelled')
      .toList();

  OrderState copyWith({
    OrderStatus? status,
    List<Order>? orders,
    Order? selectedOrder,
    String? errorMessage,
    String? successMessage,
  }) {
    return OrderState(
      status: status ?? this.status,
      orders: orders ?? this.orders,
      selectedOrder: selectedOrder ?? this.selectedOrder,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        orders,
        selectedOrder,
        errorMessage,
        successMessage,
      ];
}