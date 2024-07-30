part of 'product_cart_cubit.dart';

sealed class ProductCartState extends Equatable {
  const ProductCartState();

  @override
  List<Object> get props => [];
}

final class ProductCartInitial extends ProductCartState {}

class ProductCartLoading extends ProductCartState {}

class ProductCartLoaded extends ProductCartState {
  final ProductCartModel productCart;

  const ProductCartLoaded({required this.productCart});

  @override
  List<Object> get props => [productCart];
}

class ProductCartError extends ProductCartState {
  final String message;

  const ProductCartError({required this.message});

  @override
  List<Object> get props => [message];
}
