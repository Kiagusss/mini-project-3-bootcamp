import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import '../../model/cart_model.dart';
import '../../services/repository/cart_repository.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository cartRepository;

  CartBloc({required this.cartRepository}) : super(CartInitial()) {
    on<LoadCartEvent>((event, emit) async {
      emit(CartLoadingState());
      try {
        final carts = await cartRepository.fetchCart();
        emit(CartLoadedState(cart: carts));
      } catch (e) {
        emit(CartErrorState());
      }
    });
  }
}
