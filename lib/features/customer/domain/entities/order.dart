import 'package:equatable/equatable.dart';
import 'package:myapp/features/customer/domain/entities/cart_item.dart';

class Order extends Equatable {
  final String id;
  final List<CartItem> items;
  final double totalAmount;
  final String status; // pending, confirmed, preparing, in_transit, delivered, cancelled
  final DateTime orderDate;
  final String deliveryAddress;
  final DateTime? estimatedDelivery;
  final String? trackingNumber;
  final String? cancelReason;

  const Order({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.orderDate,
    required this.deliveryAddress,
    this.estimatedDelivery,
    this.trackingNumber,
    this.cancelReason,
  });

  String get statusDisplay {
    switch (status) {
      case 'pending':
        return 'Pending';
      case 'confirmed':
        return 'Confirmed';
      case 'preparing':
        return 'Preparing';
      case 'in_transit':
        return 'In Transit';
      case 'delivered':
        return 'Delivered';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status;
    }
  }

  Order copyWith({
    String? id,
    List<CartItem>? items,
    double? totalAmount,
    String? status,
    DateTime? orderDate,
    String? deliveryAddress,
    DateTime? estimatedDelivery,
    String? trackingNumber,
    String? cancelReason,
  }) {
    return Order(
      id: id ?? this.id,
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      orderDate: orderDate ?? this.orderDate,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      estimatedDelivery: estimatedDelivery ?? this.estimatedDelivery,
      trackingNumber: trackingNumber ?? this.trackingNumber,
      cancelReason: cancelReason ?? this.cancelReason,
    );
  }

  @override
  List<Object?> get props => [
        id,
        items,
        totalAmount,
        status,
        orderDate,
        deliveryAddress,
        estimatedDelivery,
        trackingNumber,
        cancelReason,
      ];
}