part of 'cart_bloc.dart';

sealed class CartState extends Equatable {
  @override
  List<Object> get props => [];
}

final class CartInitial extends CartState {}

class CartLoadingState extends CartState {}

class CartLoadedState extends CartState {
  final List<CartModel> cart;

  CartLoadedState({required this.cart});

  @override
  List<Object> get props => [cart];
}

class CartErrorState extends CartState {}
