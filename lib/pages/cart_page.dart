import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mini_project_3_bootcamp/pages/product_cart_detail_page.dart';
import 'package:mini_project_3_bootcamp/services/repository/cart_repository.dart';
import '../bloc/cart_bloc/cart_bloc.dart';
import '../model/cart_model.dart';
import '../model/product_cart_model.dart';
import '../shared/lottie.dart';
import '../shared/style.dart'; 

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: whiteColor,
        title: Text(
          'Shopping Cart',
          style: title.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Text(
                  'Cart',
                  style: title.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 16,
                  ),
                  padding: const EdgeInsets.all(16),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: greyColor,
                    ),
                  ),
                  child: Column(
                    children: [
                      lottieCartEmpty,
                      Text(
                        'Your cart is empty',
                        style: body.copyWith(
                          fontWeight: FontWeight.w600,
                          color: placeholderColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Start Shopping',
                          style: body.copyWith(
                            color: whiteColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  'History Cart',
                  style: title.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                BlocBuilder<CartBloc, CartState>(
                  builder: (context, state) {
                    if (state is CartLoadingState) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is CartLoadedState) {
                      var data = state.cart;
                      return HistoryCart(data: data);
                    }

                    if (state is CartErrorState) {
                      return const Center(child: Text('Failed to fetch cart'));
                    }

                    return const SizedBox();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HistoryCart extends StatelessWidget {
  final List<CartModel> data;

  const HistoryCart({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(
          vertical: 8,
        ),
        itemCount: data.length,
        itemBuilder: (context, index) {
          final cart = data[index];
          return Container(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.symmetric(
              vertical: 8,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: greyColor,
              ),
              borderRadius: BorderRadius.circular(8),
              color: whiteColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Column(
                      children: cart.products.map((e) {
                        return Column(
                          children: [
                            CustomTileCart(product: e),
                            const Divider(),
                          ],
                        );
                      }).toList(),
                    ),
                    Text(
                      'Total Product: ${cart.products.length}',
                      style: body.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat('dd-MM-yyyy').format(cart.date),
                      style: body.copyWith(
                        fontWeight: FontWeight.w600,
                        color: placeholderColor,
                      ),
                      textAlign: TextAlign.end,
                    ),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        height: 32,
                        width: 120,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'Buy Again',
                              style: body.copyWith(
                                color: whiteColor,
                              ),
                            ),
                            Icon(
                              Icons.refresh_outlined,
                              color: whiteColor,
                              size: 18,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class CustomTileCart extends StatelessWidget {
  final ProductCart product;

  const CustomTileCart({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final cartRepository = context.read<CartRepository>();

    return FutureBuilder<ProductCartModel>(
      future: cartRepository.fetchProductCart(
          id: product.productId), // Update to use CartRepository
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Failed to load product'));
        }

        if (snapshot.hasData) {
          final data = snapshot.data!;
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductCartDetailPage(
                    productId: product.productId,
                  ),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: NetworkImage(data.image!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 180,
                        child: Text(
                          data.title!,
                          style: body.copyWith(fontWeight: FontWeight.w600),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      Text(
                        '\$${data.price}',
                        style: body.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${product.quantity} items',
                        style: body.copyWith(
                          color: primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const Icon(Icons.chevron_right_rounded),
                ],
              ),
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
}
