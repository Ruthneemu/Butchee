// TODO Implement this library.
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductSeeder {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> seedProducts() async {
    final products = [
      // Beef Products
      {
        'id': 'beef_1',
        'name': 'Premium Ribeye Steak',
        'price': 24.99,
        'imageUrl': '',
        'categoryId': 'Beef',
        'description': 'Prime cut ribeye with excellent marbling. Perfect for grilling or pan-searing.',
        'weightDisplay': '1 lb',
        'isAvailable': true,
        'options': ['whole', 'half'],
        'allowHalf': true,
        'unit': 'lb',
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'id': 'beef_2',
        'name': 'Ground Beef',
        'price': 8.99,
        'imageUrl': '',
        'categoryId': 'Beef',
        'description': 'Fresh lean ground beef, 85/15. Great for burgers, meatballs, and tacos.',
        'weightDisplay': '1 lb',
        'isAvailable': true,
        'options': ['whole'],
        'allowHalf': false,
        'unit': 'lb',
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'id': 'beef_3',
        'name': 'T-Bone Steak',
        'price': 19.99,
        'imageUrl': '',
        'categoryId': 'Beef',
        'description': 'Classic T-bone with strip and tenderloin. A steak lover\'s favorite.',
        'weightDisplay': '1 lb',
        'isAvailable': true,
        'options': ['whole', 'half'],
        'allowHalf': true,
        'unit': 'lb',
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'id': 'beef_4',
        'name': 'Beef Short Ribs',
        'price': 16.99,
        'imageUrl': '',
        'categoryId': 'Beef',
        'description': 'Tender beef short ribs perfect for braising or grilling.',
        'weightDisplay': '2 lbs',
        'isAvailable': false,
        'options': ['whole'],
        'allowHalf': false,
        'unit': 'lb',
        'createdAt': FieldValue.serverTimestamp(),
      },

      // Chicken Products
      {
        'id': 'chicken_1',
        'name': 'Whole Chicken',
        'price': 12.99,
        'imageUrl': '',
        'categoryId': 'Chicken',
        'description': 'Farm-fresh whole chicken. Perfect for roasting.',
        'weightDisplay': '3-4 lbs',
        'isAvailable': true,
        'options': ['whole'],
        'allowHalf': false,
        'unit': 'lb',
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'id': 'chicken_2',
        'name': 'Chicken Breast',
        'price': 9.99,
        'imageUrl': '',
        'categoryId': 'Chicken',
        'description': 'Boneless, skinless chicken breast. Lean and versatile.',
        'weightDisplay': '1 lb',
        'isAvailable': true,
        'options': ['whole', 'half'],
        'allowHalf': true,
        'unit': 'lb',
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'id': 'chicken_3',
        'name': 'Chicken Wings',
        'price': 7.99,
        'imageUrl': '',
        'categoryId': 'Chicken',
        'description': 'Fresh chicken wings. Great for BBQ or buffalo wings.',
        'weightDisplay': '2 lbs',
        'isAvailable': true,
        'options': ['whole'],
        'allowHalf': false,
        'unit': 'lb',
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'id': 'chicken_4',
        'name': 'Chicken Thighs',
        'price': 6.99,
        'imageUrl': '',
        'categoryId': 'Chicken',
        'description': 'Juicy chicken thighs with skin. Full of flavor.',
        'weightDisplay': '1.5 lbs',
        'isAvailable': true,
        'options': ['whole', 'half'],
        'allowHalf': true,
        'unit': 'lb',
        'createdAt': FieldValue.serverTimestamp(),
      },

      // Goat Products
      {
        'id': 'goat_1',
        'name': 'Goat Leg',
        'price': 18.99,
        'imageUrl': '',
        'categoryId': 'Goat',
        'description': 'Fresh goat leg, perfect for slow roasting or curry.',
        'weightDisplay': '2 lbs',
        'isAvailable': true,
        'options': ['whole', 'half'],
        'allowHalf': true,
        'unit': 'lb',
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'id': 'goat_2',
        'name': 'Goat Chops',
        'price': 15.99,
        'imageUrl': '',
        'categoryId': 'Goat',
        'description': 'Tender goat chops, great for grilling.',
        'weightDisplay': '1 lb',
        'isAvailable': true,
        'options': ['whole'],
        'allowHalf': false,
        'unit': 'lb',
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'id': 'goat_3',
        'name': 'Goat Shoulder',
        'price': 14.99,
        'imageUrl': '',
        'categoryId': 'Goat',
        'description': 'Goat shoulder cut, ideal for stews and braises.',
        'weightDisplay': '3 lbs',
        'isAvailable': false,
        'options': ['whole'],
        'allowHalf': false,
        'unit': 'lb',
        'createdAt': FieldValue.serverTimestamp(),
      },

      // Seafood Products
      {
        'id': 'seafood_1',
        'name': 'Atlantic Salmon',
        'price': 22.99,
        'imageUrl': '',
        'categoryId': 'Seafood',
        'description': 'Fresh Atlantic salmon fillet. Rich in omega-3.',
        'weightDisplay': '1 lb',
        'isAvailable': true,
        'options': ['whole', 'half'],
        'allowHalf': true,
        'unit': 'lb',
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'id': 'seafood_2',
        'name': 'Jumbo Shrimp',
        'price': 19.99,
        'imageUrl': '',
        'categoryId': 'Seafood',
        'description': 'Large, fresh shrimp. Perfect for grilling or pasta.',
        'weightDisplay': '1 lb',
        'isAvailable': true,
        'options': ['whole'],
        'allowHalf': false,
        'unit': 'lb',
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'id': 'seafood_3',
        'name': 'Tilapia Fillet',
        'price': 11.99,
        'imageUrl': '',
        'categoryId': 'Seafood',
        'description': 'Mild, flaky white fish. Great for pan-frying.',
        'weightDisplay': '1 lb',
        'isAvailable': true,
        'options': ['whole', 'half'],
        'allowHalf': true,
        'unit': 'lb',
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'id': 'seafood_4',
        'name': 'Sea Bass',
        'price': 26.99,
        'imageUrl': '',
        'categoryId': 'Seafood',
        'description': 'Premium sea bass. Delicate and flavorful.',
        'weightDisplay': '1.5 lbs',
        'isAvailable': true,
        'options': ['whole'],
        'allowHalf': false,
        'unit': 'lb',
        'createdAt': FieldValue.serverTimestamp(),
      },
    ];

    try {
      print('🌱 Starting product seeding...');
      
      final batch = _firestore.batch();
      
      for (var product in products) {
        final docRef = _firestore.collection('products').doc(product['id'] as String);
        batch.set(docRef, product);
      }
      
      await batch.commit();
      
      print('✅ Successfully seeded ${products.length} products!');
    } catch (e) {
      print('❌ Error seeding products: $e');
      rethrow;
    }
  }

  static Future<void> clearProducts() async {
    try {
      print('🗑️ Clearing all products...');
      
      final snapshot = await _firestore.collection('products').get();
      final batch = _firestore.batch();
      
      for (var doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      
      await batch.commit();
      
      print('✅ Cleared ${snapshot.docs.length} products');
    } catch (e) {
      print('❌ Error clearing products: $e');
      rethrow;
    }
  }
}