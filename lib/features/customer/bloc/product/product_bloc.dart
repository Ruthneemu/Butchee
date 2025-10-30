import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/data/models/product_model.dart';
import 'package:myapp/features/customer/domain/entities/product.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final CollectionReference _productsRef = FirebaseFirestore.instance.collection('products');

  ProductBloc() : super(const ProductState()) {
    on<LoadProducts>(_onLoadProducts);
    on<SearchProducts>(_onSearchProducts);
    on<FilterProductsByCategory>(_onFilterProductsByCategory);
    on<SortProducts>(_onSortProducts);
    on<ToggleFavorite>(_onToggleFavorite);
    on<RefreshProducts>(_onRefreshProducts);
    on<GetProductById>(_onGetProductById);
  }

  void _onLoadProducts(LoadProducts event, Emitter<ProductState> emit) async {
    emit(state.copyWith(status: ProductStatus.loading));

    try {
      final QuerySnapshot snapshot = await _productsRef.get();
      
      if (snapshot.docs.isEmpty) {
        print('⚠️ No products found in Firestore. Please seed the database.');
        emit(state.copyWith(
          status: ProductStatus.loaded,
          allProducts: [],
          filteredProducts: [],
          errorMessage: 'No products available. Please seed the database.',
        ));
        return;
      }

      final List<Product> products = [];
      
      for (var doc in snapshot.docs) {
        try {
          final data = doc.data() as Map<String, dynamic>;
          print('Loading product: ${data['name']}');
          
          final productModel = ProductModel.fromJson(data);
          products.add(_convertToProduct(productModel));
        } catch (e) {
          print('❌ Error parsing product ${doc.id}: $e');
          continue;
        }
      }
      
      print('✅ Successfully loaded ${products.length} products');
      
      emit(state.copyWith(
        status: ProductStatus.loaded,
        allProducts: products,
        filteredProducts: products,
      ));
    } catch (e) {
      print('❌ Error loading products: $e');
      emit(state.copyWith(
        status: ProductStatus.error,
        errorMessage: 'Failed to load products: ${e.toString()}',
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
    try {
      final QuerySnapshot snapshot = await _productsRef.get();
      final List<Product> products = [];
      
      for (var doc in snapshot.docs) {
        try {
          final productModel = ProductModel.fromJson(doc.data() as Map<String, dynamic>);
          products.add(_convertToProduct(productModel));
        } catch (e) {
          print('Error parsing product during refresh: $e');
          continue;
        }
      }
      
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
      print('Error refreshing products: $e');
      emit(state.copyWith(
        status: ProductStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onGetProductById(GetProductById event, Emitter<ProductState> emit) async {
    try {
      final DocumentSnapshot doc = await _productsRef.doc(event.productId).get();
      
      if (doc.exists) {
        final productModel = ProductModel.fromJson(doc.data() as Map<String, dynamic>);
        final product = _convertToProduct(productModel);
        
        emit(state.copyWith(selectedProduct: product));
      }
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

  Product _convertToProduct(ProductModel model) {
    return Product(
      id: model.id,
      name: model.name,
      price: model.price,
      imageUrl: model.imageUrl.isNotEmpty ? model.imageUrl : null,
      category: model.categoryId,
      description: model.description,
      rating: 4.5,
      reviews: 24,
      weight: model.weightDisplay,
      inStock: model.isAvailable,
      options: model.options,
      allowHalf: model.allowHalf,
      unit: model.unit,
    );
  }
}