import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/data/models/user_model.dart';
import 'package:myapp/data/models/product_model.dart';
import 'package:myapp/data/models/order_model.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // User Collection Reference
  CollectionReference get _usersCollection => _firestore.collection('users');

  // Product Collection Reference
  CollectionReference get _productsCollection => _firestore.collection('products');

  // Order Collection Reference
  CollectionReference get _ordersCollection => _firestore.collection('orders');


  // Get user profile
// In your FirebaseService class
Future<UserModel?> getUserProfile(String userId) async {
  try {
    final doc = await FirebaseFirestore.instance
        .collection('users')  // Make sure this matches your security rules
        .doc(userId)
        .get();
    
    if (doc.exists) {
      return UserModel.fromMap(doc.data() as Map<String, dynamic>);
    }
    return null;
  } catch (e) {
    print('Error getting user profile: $e');
    rethrow;
  }
}

Future<void> saveUserProfile(UserModel userModel) async {
  try {
    await FirebaseFirestore.instance
        .collection('users')  // Make sure this matches your security rules
        .doc(userModel.id)
        .set(userModel.toMap());
  } catch (e) {
    print('Error saving user profile: $e');
    rethrow;
  }
}

  // Get all products
  Future<List<ProductModel>> getProducts() async {
    try {
      QuerySnapshot querySnapshot = await _productsCollection.get();
      return querySnapshot.docs.map((doc) {
        return ProductModel.fromJson({
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>
        });
      }).toList();
    } catch (e) {
      throw Exception('Failed to get products: $e');
    }
  }

  // Get product by ID
  Future<ProductModel?> getProductById(String productId) async {
    try {
      DocumentSnapshot doc = await _productsCollection.doc(productId).get();
      if (doc.exists) {
        return ProductModel.fromJson({
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>
        });
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get product: $e');
    }
  }

  // Create a new order
  Future<String> createOrder(OrderModel order) async {
    try {
      DocumentReference docRef = await _ordersCollection.add(order.toJson());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create order: $e');
    }
  }

  // Get user orders
  Future<List<OrderModel>> getUserOrders(String userId) async {
    try {
      QuerySnapshot querySnapshot = await _ordersCollection
          .where('userId', isEqualTo: userId)
          .orderBy('orderDate', descending: true)
          .get();
      
      return querySnapshot.docs.map((doc) {
        return OrderModel.fromJson({
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>
        });
      }).toList();
    } catch (e) {
      throw Exception('Failed to get user orders: $e');
    }
  }

  // Get order by ID
  Future<OrderModel?> getOrderById(String orderId) async {
    try {
      DocumentSnapshot doc = await _ordersCollection.doc(orderId).get();
      if (doc.exists) {
        return OrderModel.fromJson({
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>
        });
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get order: $e');
    }
  }
}