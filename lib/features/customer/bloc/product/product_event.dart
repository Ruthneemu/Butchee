import 'package:equatable/equatable.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class LoadProducts extends ProductEvent {}

class SearchProducts extends ProductEvent {
  final String query;

  const SearchProducts(this.query);

  @override
  List<Object?> get props => [query];
}

class FilterProductsByCategory extends ProductEvent {
  final String category;

  const FilterProductsByCategory(this.category);

  @override
  List<Object?> get props => [category];
}

class SortProducts extends ProductEvent {
  final String sortBy;

  const SortProducts(this.sortBy);

  @override
  List<Object?> get props => [sortBy];
}

class ToggleFavorite extends ProductEvent {
  final String productId;

  const ToggleFavorite(this.productId);

  @override
  List<Object?> get props => [productId];
}

class RefreshProducts extends ProductEvent {}