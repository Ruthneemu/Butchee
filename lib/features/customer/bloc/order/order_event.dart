import 'package:equatable/equatable.dart';
import 'package:myapp/features/customer/domain/entities/order.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object?> get props => [];
}

class LoadOrders extends OrderEvent {}

class PlaceOrder extends OrderEvent {
  final Order order;

  const PlaceOrder(this.order);

  @override
  List<Object?> get props => [order];
}

class CancelOrder extends OrderEvent {
  final String orderId;

  const CancelOrder(this.orderId);

  @override
  List<Object?> get props => [orderId];
}

class TrackOrder extends OrderEvent {
  final String orderId;

  const TrackOrder(this.orderId);

  @override
  List<Object?> get props => [orderId];
}

class LoadOrderDetails extends OrderEvent {
  final String orderId;

  const LoadOrderDetails(this.orderId);

  @override
  List<Object?> get props => [orderId];
}

class RefreshOrders extends OrderEvent {}
