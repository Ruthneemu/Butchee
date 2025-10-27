// lib/features/customer/presentation/bloc/product/product_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/features/customer/bloc/product/product.dart';
import 'package:myapp/features/customer/bloc/product/product_event.dart';
import 'package:myapp/features/customer/bloc/product/product_state.dart';


class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(const ProductState()) {
    on<LoadProducts>(_onLoadProducts);
    on<SearchProducts>(_onSearchProducts);
    on<FilterProductsByCategory>(_onFilterProductsByCategory);
    on<SortProducts>(_onSortProducts);
    on<ToggleFavorite>(_onToggleFavorite);
    on<RefreshProducts>(_onRefreshProducts);
  }

  void _onLoadProducts(LoadProducts event, Emitter<ProductState> emit) async {
    emit(state.copyWith(status: ProductStatus.loading));

    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 800));
      
      final products = _getMockProducts();
      
      emit(state.copyWith(
        status: ProductStatus.loaded,
        allProducts: products,
        filteredProducts: products,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ProductStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onSearchProducts(SearchProducts event, Emitter<ProductState> emit) {
    final query = event.query.toLowerCase();
    final filtered = _filterAndSortProducts(
      state.allProducts,
      query: query,
      category: state.selectedCategory,
      sortBy: state.sortBy,
    );

    emit(state.copyWith(
      searchQuery: event.query,
      filteredProducts: filtered,
    ));
  }

  void _onFilterProductsByCategory(
    FilterProductsByCategory event,
    Emitter<ProductState> emit,
  ) {
    final filtered = _filterAndSortProducts(
      state.allProducts,
      query: state.searchQuery,
      category: event.category,
      sortBy: state.sortBy,
    );

    emit(state.copyWith(
      selectedCategory: event.category,
      filteredProducts: filtered,
    ));
  }

  void _onSortProducts(SortProducts event, Emitter<ProductState> emit) {
    final filtered = _filterAndSortProducts(
      state.allProducts,
      query: state.searchQuery,
      category: state.selectedCategory,
      sortBy: event.sortBy,
    );

    emit(state.copyWith(
      sortBy: event.sortBy,
      filteredProducts: filtered,
    ));
  }

  void _onToggleFavorite(ToggleFavorite event, Emitter<ProductState> emit) {
    final favorites = List<String>.from(state.favorites);
    
    if (favorites.contains(event.productId)) {
      favorites.remove(event.productId);
    } else {
      favorites.add(event.productId);
    }

    emit(state.copyWith(favorites: favorites));
  }

  void _onRefreshProducts(
    RefreshProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(state.copyWith(status: ProductStatus.loading));

    try {
      await Future.delayed(const Duration(milliseconds: 500));
      final products = _getMockProducts();
      
      final filtered = _filterAndSortProducts(
        products,
        query: state.searchQuery,
        category: state.selectedCategory,
        sortBy: state.sortBy,
      );

      emit(state.copyWith(
        status: ProductStatus.loaded,
        allProducts: products,
        filteredProducts: filtered,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ProductStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  List<Product> _filterAndSortProducts(
    List<Product> products, {
    required String query,
    required String category,
    required String sortBy,
  }) {
    var filtered = products.where((product) {
      final matchesSearch = query.isEmpty ||
          product.name.toLowerCase().contains(query.toLowerCase());
      final matchesCategory =
          category == 'All' || product.category == category;
      return matchesSearch && matchesCategory;
    }).toList();

    // Apply sorting
    switch (sortBy) {
      case 'price_low':
        filtered.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'price_high':
        filtered.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'name':
        filtered.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'rating':
        filtered.sort((a, b) => b.rating.compareTo(a.rating));
        break;
    }

    return filtered;
  }

  List<Product> _getMockProducts() {
    return [
      Product(
        id: '1',
        name: 'Prime Ribeye Steak',
        price: 28.99,
        image: 'ribeye',
        category: 'Beef',
        description: 'Premium quality ribeye steak with perfect marbling',
        rating: 4.8,
        reviews: 124,
        weight: '1 lb',
        inStock: true,
      ),
      Product(
        id: '2',
        name: 'Boneless Goat Leg',
        price: 18.90,
        image: 'goat',
        category: 'Goat',
        description: 'Fresh boneless goat leg, perfect for slow cooking',
        rating: 4.6,
        reviews: 89,
        weight: '2 lb',
        inStock: true,
      ),
      Product(
        id: '3',
        name: 'Free-Range Chicken',
        price: 12.75,
        image: 'chicken',
        category: 'Chicken',
        description: 'Organic free-range chicken, hormone-free',
        rating: 4.9,
        reviews: 203,
        weight: '3 lb',
        inStock: true,
      ),
      Product(
        id: '4',
        name: 'T-Bone Steak',
        price: 32.99,
        image: 'tbone',
        category: 'Beef',
        description: 'Premium T-bone steak with tenderloin',
        rating: 4.7,
        reviews: 156,
        weight: '1.5 lb',
        inStock: true,
      ),
      Product(
        id: '5',
        name: 'Chicken Wings',
        price: 8.99,
        image: 'wings',
        category: 'Chicken',
        description: 'Fresh chicken wings, perfect for grilling',
        rating: 4.5,
        reviews: 178,
        weight: '2 lb',
        inStock: false,
      ),
      Product(
        id: '6',
        name: 'Salmon Fillet',
        price: 24.99,
        image: 'salmon',
        category: 'Seafood',
        description: 'Fresh Atlantic salmon, wild-caught',
        rating: 4.9,
        reviews: 267,
        weight: '1 lb',
        inStock: true,
      ),
      Product(
        id: '7',
        name: 'Goat Chops',
        price: 22.50,
        image: 'goat_chops',
        category: 'Goat',
        description: 'Tender goat chops, expertly cut',
        rating: 4.7,
        reviews: 92,
        weight: '1.5 lb',
        inStock: true,
      ),
    ];
  }
}

