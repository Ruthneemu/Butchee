import 'package:equatable/equatable.dart';
import 'package:myapp/features/customer/bloc/product/product.dart';
enum ProductStatus { initial, loading, loaded, error }

class ProductState extends Equatable {
  final ProductStatus status;
  final List<Product> allProducts;
  final List<Product> filteredProducts;
  final List<String> favorites;
  final String selectedCategory;
  final String searchQuery;
  final String sortBy;
  final String? errorMessage;

  const ProductState({
    this.status = ProductStatus.initial,
    this.allProducts = const [],
    this.filteredProducts = const [],
    this.favorites = const [],
    this.selectedCategory = 'All',
    this.searchQuery = '',
    this.sortBy = 'featured',
    this.errorMessage,
  });

  ProductState copyWith({
    ProductStatus? status,
    List<Product>? allProducts,
    List<Product>? filteredProducts,
    List<String>? favorites,
    String? selectedCategory,
    String? searchQuery,
    String? sortBy,
    String? errorMessage,
  }) {
    return ProductState(
      status: status ?? this.status,
      allProducts: allProducts ?? this.allProducts,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      favorites: favorites ?? this.favorites,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      sortBy: sortBy ?? this.sortBy,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        allProducts,
        filteredProducts,
        favorites,
        selectedCategory,
        searchQuery,
        sortBy,
        errorMessage,
      ];
}
