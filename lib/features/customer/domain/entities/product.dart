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
  final String weight;
  final bool inStock;
  // Changed from Map to List<String>
  final List<String> options;
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
    required this.weight,
    required this.inStock,
    this.options = const [],  // Changed to List with default empty list
    required this.allowHalf,
    required this.unit,
  });

  String get displayPrice {
    return 'KSH ${price.toStringAsFixed(0)}/$unit';
  }

  String get displayWeight {
    return weight;
  }

  Product copyWith({
    String? id,
    String? name,
    double? price,
    String? imageUrl,
    String? category,
    String? description,
    double? rating,
    int? reviews,
    String? weight,
    bool? inStock,
    List<String>? options,
    bool? allowHalf,
    String? unit,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      description: description ?? this.description,
      rating: rating ?? this.rating,
      reviews: reviews ?? this.reviews,
      weight: weight ?? this.weight,
      inStock: inStock ?? this.inStock,
      options: options ?? this.options,
      allowHalf: allowHalf ?? this.allowHalf,
      unit: unit ?? this.unit,
    );
  }

  @override
  String toString() {
    return 'Product(id: $id, name: $name, price: $price, category: $category, inStock: $inStock)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Product && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}