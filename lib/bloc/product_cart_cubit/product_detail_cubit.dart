// product_detail_cubit.dart
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/repository/cart_repository.dart'; // Update import repository
import '../../model/product_cart_model.dart'; 

// Update import model

// Define states
abstract class ProductDetailState {}

class ProductDetailInitial extends ProductDetailState {}

class ProductDetailLoading extends ProductDetailState {}

class ProductDetailLoaded extends ProductDetailState {
  final ProductCartModel product;

  ProductDetailLoaded({required this.product});
}

class ProductDetailError extends ProductDetailState {}

// Define Cubit
class ProductDetailCubit extends Cubit<ProductDetailState> {
  final CartRepository cartRepository;

  ProductDetailCubit({required this.cartRepository}) : super(ProductDetailInitial());

  Future<void> fetchProductDetail(int productId) async {
    try {
      emit(ProductDetailLoading());
      final product = await cartRepository.fetchProductCart(id: productId);
      emit(ProductDetailLoaded(product: product));
    } catch (e) {
      emit(ProductDetailError());
    }
  }
}
