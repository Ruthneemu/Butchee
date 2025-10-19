import 'package:myapp/core/services/firebase_service.dart';
import 'package:myapp/data/models/order_model.dart';

class OrderRepository {
  final FirebaseService _firebaseService = FirebaseService();

  Future<String> createOrder(OrderModel order) async {
    try {
      return await _firebaseService.createOrder(order);
    } catch (e) {
      throw Exception('Failed to create order: $e');
    }
  }

  Future<List<OrderModel>> getUserOrders(String userId) async {
    try {
      return await _firebaseService.getUserOrders(userId);
    } catch (e) {
      throw Exception('Failed to load orders: $e');
    }
  }

  Future<OrderModel?> getOrderById(String orderId) async {
    try {
      return await _firebaseService.getOrderById(orderId);
    } catch (e) {
      throw Exception('Failed to load order: $e');
    }
  }
}