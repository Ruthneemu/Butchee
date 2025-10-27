// lib/features/customer/presentation/bloc/order/order_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/features/customer/bloc/order/order_event.dart';
import 'package:myapp/features/customer/bloc/order/order_state.dart';
import 'package:myapp/features/customer/domain/entities/order.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc() : super(const OrderState()) {
    on<LoadOrders>(_onLoadOrders);
    on<PlaceOrder>(_onPlaceOrder);
    on<CancelOrder>(_onCancelOrder);
    on<TrackOrder>(_onTrackOrder);
    on<LoadOrderDetails>(_onLoadOrderDetails);
    on<RefreshOrders>(_onRefreshOrders);
  }

  void _onLoadOrders(LoadOrders event, Emitter<OrderState> emit) async {
    emit(state.copyWith(status: OrderStatus.loading));

    try {
      await Future.delayed(const Duration(milliseconds: 800));
      
      final orders = _getMockOrders();
      
      emit(state.copyWith(
        status: OrderStatus.loaded,
        orders: orders,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: OrderStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onPlaceOrder(PlaceOrder event, Emitter<OrderState> emit) async {
    emit(state.copyWith(status: OrderStatus.placing));

    try {
      await Future.delayed(const Duration(milliseconds: 1500));
      
      final orders = List<Order>.from(state.orders)..insert(0, event.order);
      
      emit(state.copyWith(
        status: OrderStatus.placed,
        orders: orders,
        successMessage: 'Order placed successfully!',
      ));
      
      // Reset to loaded after success message is shown
      await Future.delayed(const Duration(milliseconds: 100));
      emit(state.copyWith(status: OrderStatus.loaded, successMessage: null));
    } catch (e) {
      emit(state.copyWith(
        status: OrderStatus.error,
        errorMessage: 'Failed to place order: ${e.toString()}',
      ));
    }
  }

  void _onCancelOrder(CancelOrder event, Emitter<OrderState> emit) async {
    emit(state.copyWith(status: OrderStatus.loading));

    try {
      await Future.delayed(const Duration(milliseconds: 800));
      
      final orders = state.orders.map((order) {
        if (order.id == event.orderId) {
          return order.copyWith(status: 'cancelled');
        }
        return order;
      }).toList();
      
      emit(state.copyWith(
        status: OrderStatus.loaded,
        orders: orders,
        successMessage: 'Order cancelled successfully',
      ));
      
      await Future.delayed(const Duration(milliseconds: 100));
      emit(state.copyWith(successMessage: null));
    } catch (e) {
      emit(state.copyWith(
        status: OrderStatus.error,
        errorMessage: 'Failed to cancel order: ${e.toString()}',
      ));
    }
  }

  void _onTrackOrder(TrackOrder event, Emitter<OrderState> emit) async {
    try {
      final order = state.orders.firstWhere(
        (order) => order.id == event.orderId,
      );
      
      emit(state.copyWith(selectedOrder: order));
    } catch (e) {
      emit(state.copyWith(
        status: OrderStatus.error,
        errorMessage: 'Order not found',
      ));
    }
  }

  void _onLoadOrderDetails(
    LoadOrderDetails event,
    Emitter<OrderState> emit,
  ) async {
    emit(state.copyWith(status: OrderStatus.loading));

    try {
      await Future.delayed(const Duration(milliseconds: 500));
      
      final order = state.orders.firstWhere(
        (order) => order.id == event.orderId,
      );
      
      emit(state.copyWith(
        status: OrderStatus.loaded,
        selectedOrder: order,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: OrderStatus.error,
        errorMessage: 'Failed to load order details',
      ));
    }
  }

  void _onRefreshOrders(RefreshOrders event, Emitter<OrderState> emit) async {
    emit(state.copyWith(status: OrderStatus.loading));

    try {
      await Future.delayed(const Duration(milliseconds: 500));
      final orders = _getMockOrders();
      
      emit(state.copyWith(
        status: OrderStatus.loaded,
        orders: orders,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: OrderStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  List<Order> _getMockOrders() {
    return [
      Order(
        id: 'ORD001',
        items: [],
        totalAmount: 89.97,
        status: 'in_transit',
        orderDate: DateTime.now().subtract(const Duration(days: 1)),
        deliveryAddress: '123 Main St, New York, NY 10001',
        estimatedDelivery: DateTime.now().add(const Duration(hours: 4)),
      ),
      Order(
        id: 'ORD002',
        items: [],
        totalAmount: 145.50,
        status: 'preparing',
        orderDate: DateTime.now().subtract(const Duration(hours: 2)),
        deliveryAddress: '123 Main St, New York, NY 10001',
        estimatedDelivery: DateTime.now().add(const Duration(days: 1)),
      ),
      Order(
        id: 'ORD003',
        items: [],
        totalAmount: 67.48,
        status: 'delivered',
        orderDate: DateTime.now().subtract(const Duration(days: 7)),
        deliveryAddress: '123 Main St, New York, NY 10001',
        estimatedDelivery: DateTime.now().subtract(const Duration(days: 6)),
      ),
    ];
  }
}

