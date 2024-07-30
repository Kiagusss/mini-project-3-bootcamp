import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../model/product_model.dart';
import '../../services/repository/product_repository.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository productRepository;
  List<ProductModel> allProducts = [];

  ProductBloc(this.productRepository) : super(ProductInitial()) {
    on<LoadProductEvent>((event, emit) async {
      emit(ProductLoadingState());
      try {
        final products = await productRepository.fetchProduct();
        allProducts = products;
        emit(ProductLoadedState(products: products, filteredProducts: products));
      } catch (e) {
        emit(ProductErrorState());
      }
    });

    on<SearchProductEvent>((event, emit) {
      final query = event.query.toLowerCase();
      final filteredProducts = allProducts.where((product) {
        return product.title.toLowerCase().contains(query) ||
               product.description.toLowerCase().contains(query);
      }).toList();
      emit(ProductLoadedState(products: allProducts, filteredProducts: filteredProducts));
    });
  }
}
