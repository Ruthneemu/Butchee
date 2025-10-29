// lib/features/customer/bloc/product/product_state.dart
import 'package:equatable/equatable.dart';
import 'package:myapp/features/customer/domain/entities/product.dart';

enum ProductStatus { initial, loading, loaded, error }

class ProductState extends Equatable {
  final ProductStatus status;
  final List<Product> allProducts;
  final List<Product> filteredProducts;
  final String searchQuery;
  final String selectedCategory;
  final String sortBy;
  final List<String> favorites;
  final Product? selectedProduct;
  final String? errorMessage;

  const ProductState({
    this.status = ProductStatus.initial,
    this.allProducts = const [],
    this.filteredProducts = const [],
    this.searchQuery = '',
    this.selectedCategory = 'All',
    this.sortBy = 'featured',
    this.favorites = const [],
    this.selectedProduct,
    this.errorMessage,
  });

  ProductState copyWith({
    ProductStatus? status,
    List<Product>? allProducts,
    List<Product>? filteredProducts,
    String? searchQuery,
    String? selectedCategory,
    String? sortBy,
    List<String>? favorites,
    Product? selectedProduct,
    String? errorMessage,
  }) {
    return ProductState(
      status: status ?? this.status,
      allProducts: allProducts ?? this.allProducts,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      sortBy: sortBy ?? this.sortBy,
      favorites: favorites ?? this.favorites,
      selectedProduct: selectedProduct ?? this.selectedProduct,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        allProducts,
        filteredProducts,
        searchQuery,
        selectedCategory,
        sortBy,
        favorites,
        selectedProduct,
        errorMessage,
      ];
}