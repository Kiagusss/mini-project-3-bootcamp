import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/product_cart_cubit/product_detail_cubit.dart'; // Pastikan path ini benar
import '../model/product_cart_model.dart'; // Pastikan path ini benar
import '../services/repository/cart_repository.dart'; // Pastikan path ini benar
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
        create: (context) => ProductDetailCubit(
            cartRepository: CartRepository() // Pastikan repository sudah sesuai
            )
          ..fetchProductDetail(productId),
        child: BlocBuilder<ProductDetailCubit, ProductDetailState>(
          builder: (context, state) {
            if (state is ProductDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ProductDetailLoaded) {
              final product = state.product;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: [
                    Center(
                      child: Image.network(
                        product.image!,
                        height: 300,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      product.title!,
                      style: title.copyWith(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '\$${product.price}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber),
                        const SizedBox(width: 5),
                        Text(
                          product.rating!.rate.toString(),
                          style: TextStyle(
                            color: blackColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '(${product.rating?.count} reviews)',
                          style: subtitle.copyWith(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      product.description!,
                      style: subtitle.copyWith(
                        fontSize: 18,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              );
            }

            if (state is ProductDetailError) {
              return const Center(child: Text('Failed to load product detail'));
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
