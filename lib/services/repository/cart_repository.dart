import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../model/cart_model.dart';
import '../../model/product_cart_model.dart';

class CartRepository {
  final String apiUrl = "https://fakestoreapi.com";

  Future<List<CartModel>> fetchCart() async {
    final response = await http.get(Uri.parse("$apiUrl/carts"));

    if (response.statusCode == 200) {
      List<CartModel> cart = (json.decode(response.body) as List)
          .map((data) => CartModel.fromJson(data))
          .toList();
      return cart;
    } else {
      throw Exception('Failed to load cart');
    }
  }

  Future<ProductCartModel> fetchProductCart({
    required int id,
  }) async {
    final response = await http.get(Uri.parse("$apiUrl/products/$id"));

    if (response.statusCode == 200) {
      final productCart = ProductCartModel.fromJson(json.decode(response.body));

      return productCart;
    } else {
      throw Exception('Failed to load product');
    }
  }
}
