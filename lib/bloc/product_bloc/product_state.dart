part of 'product_bloc.dart';

@immutable
sealed class ProductState extends Equatable {
  @override
  List<Object> get props => [];
}

final class ProductInitial extends ProductState {}

class ProductLoadingState extends ProductState {}

class ProductLoadedState extends ProductState {
  final List<ProductModel> products;
  final List<ProductModel> filteredProducts;

  ProductLoadedState({required this.products, required this.filteredProducts});

  @override
  List<Object> get props => [products, filteredProducts];
}

class ProductErrorState extends ProductState {}
