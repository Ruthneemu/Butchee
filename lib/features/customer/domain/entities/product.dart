// lib/features/customer/domain/entities/product.dart
class Product {
  final String id;
  final String name;
  final double price;
  final String? imageUrl;
  final String category;
  final String description;
  final double rating;
  final int reviews;
  final String? weight;
  final bool inStock;
  // New fields
  final Map<String, dynamic>? options;
  final bool allowHalf;
  final String unit;

  Product({
    required this.id,
    required this.name,
    required this.price,
    this.imageUrl,
    required this.category,
    required this.description,
    required this.rating,
    required this.reviews,
    this.weight,
    required this.inStock,
    this.options,
    required this.allowHalf,
    required this.unit,
  });

  String get displayPrice {
    return 'KSH ${price.toStringAsFixed(0)}/${unit}';
  }

  String get displayWeight {
    return weight ?? '1 $unit';
  }
}
