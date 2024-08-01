import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/product_cart_cubit/product_detail_cubit.dart';
import '../model/product_cart_model.dart';
import '../services/repository/cart_repository.dart';
import '../shared/style.dart';

class ProductCartDetailPage extends StatelessWidget {
  final int productId;

  const ProductCartDetailPage({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Product Detail',
          style: title.copyWith(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocProvider(
        create: (context) =>
            ProductDetailCubit(cartRepository: CartRepository())
              ..fetchProductDetail(productId),
        child: BlocBuilder<ProductDetailCubit, ProductDetailState>(
          builder: (context, state) {
            if (state is ProductDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ProductDetailLoaded) {
              final product = state.product;
              return ProductDetail(product: product);
            }

            if (state is ProductDetailError) {
              return const Center(
                  child: Text('Failed to fetch product detail'));
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}

class ProductDetail extends StatelessWidget {
  final ProductCartModel product;

  const ProductDetail({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          Image.network(product.image!),
          const SizedBox(height: 16),
          Text(
            product.title!,
            style: title.copyWith(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            '\$${product.price}',
            style: title.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            product.description!,
            style: body,
          ),
        ],
      ),
    );
  }
}
