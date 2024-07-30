import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../model/product_cart_model.dart';
import '../../services/repository/cart_repository.dart';

part 'product_cart_state.dart';

class ProductCartCubit extends Cubit<ProductCartState> {
  ProductCartCubit() : super(ProductCartInitial());

  Future<ProductCartModel> fetchProductCart(int id) async {
    try {
      emit(ProductCartLoading());
      ProductCartModel productCart =
          await CartRepository().fetchProductCart(id: id);

      emit(ProductCartLoaded(productCart: productCart));
      return productCart;
    } catch (e) {
      emit(ProductCartError(message: e.toString()));
      return ProductCartModel();
    }
  }
}
