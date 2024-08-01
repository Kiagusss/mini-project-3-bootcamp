import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'dart:convert';
import 'dart:math';

import '../bloc/product_bloc/product_bloc.dart';
import '../main.dart';
import '../model/product_model.dart';
import '../shared/style.dart';
import 'product_detail_page.dart'; 
import 'widgets/custom_drawer.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<ProductBloc>().add(LoadProductEvent());
    final TextEditingController searchController = TextEditingController();

    return DefaultTabController(
      length: 5,
      initialIndex: 0,
      child: Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Belanjain',
            style: title.copyWith(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          backgroundColor: whiteColor,
          actions: [
            IconButton(
                onPressed: () async {
                  NotificationHelper.payload.value = "";
                  await NotificationHelper.flutterLocalNotificationsPlugin.show(
                      Random().nextInt(99),
                      "Belanjain",
                      "Belanja Mudah? Belanjain Aja!",
                      payload: jsonEncode({"data": "test"}),
                      NotificationHelper.notificationDetails);
                },
                icon: const Icon(Icons.notifications))
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(100.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search products...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                    onChanged: (value) {
                      context
                          .read<ProductBloc>()
                          .add(SearchProductEvent(value));
                    },
                  ),
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      TabItem('Fashion'),
                      TabItem('Shoes'),
                      TabItem('Food'),
                      TabItem('Electronic'),
                      TabItem('Sport'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        drawer: const CustomDrawer(),
        body: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            if (state is ProductLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProductLoadedState) {
              var data = state.filteredProducts;
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: MasonryGridView.builder(
                    gridDelegate:
                        const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      var product = data[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProductDetailPage(product: product),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            border: Border.all(
                              color: primaryColor.withOpacity(0.2),
                              width: 5.0,
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Image.network(
                                product.image,
                                height: 150,
                                fit: BoxFit.fitWidth,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                product.title,
                                style: title,
                                textAlign: TextAlign.start,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                product.description,
                                style: subtitle.copyWith(
                                    fontSize: 14, color: Colors.grey[600]),
                                textAlign: TextAlign.start,
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Text(
                                    '\$${product.price}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.star,
                                          color: Colors.amber),
                                      const SizedBox(width: 2),
                                      Text(
                                        product.rating.rate.toString(),
                                        style: TextStyle(
                                          color: blackColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              );
            } else if (state is ProductErrorState) {
              return const Center(child: Text('Failed to fetch cart'));
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }

  Container TabItem(String nameTab) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6.0),
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Tab(
        child: Text(
          nameTab,
          style: title.copyWith(color: whiteColor),
        ),
      ),
    );
  }
}
