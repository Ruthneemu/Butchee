import 'package:myapp/core/services/firebase_service.dart';
import 'package:myapp/data/models/product_model.dart';

class ProductRepository {
  final FirebaseService _firebaseService = FirebaseService();

  Future<List<ProductModel>> getAllProducts() async {
    try {
      return await _firebaseService.getProducts();
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }

  Future<ProductModel?> getProductById(String productId) async {
    try {
      return await _firebaseService.getProductById(productId);
    } catch (e) {
      throw Exception('Failed to load product: $e');
    }
  }

  Future<List<ProductModel>> getProductsByCategory(String categoryId) async {
    try {
      final allProducts = await _firebaseService.getProducts();
      return allProducts
          .where((product) => product.categoryId == categoryId)
          .toList();
    } catch (e) {
      throw Exception('Failed to load products by category: $e');
    }
  }
}