import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String name;
  final double price;
  final String image;
  final String category;
  final String description;
  final double rating;
  final int reviews;
  final String weight;
  final bool inStock;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.category,
    required this.description,
    required this.rating,
    required this.reviews,
    required this.weight,
    required this.inStock,
  });

  Product copyWith({
    String? id,
    String? name,
    double? price,
    String? image,
    String? category,
    String? description,
    double? rating,
    int? reviews,
    String? weight,
    bool? inStock,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      image: image ?? this.image,
      category: category ?? this.category,
      description: description ?? this.description,
      rating: rating ?? this.rating,
      reviews: reviews ?? this.reviews,
      weight: weight ?? this.weight,
      inStock: inStock ?? this.inStock,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        price,
        image,
        category,
        description,
        rating,
        reviews,
        weight,
        inStock,
      ];
}