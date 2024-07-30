import 'dart:convert';

import '../../model/product_model.dart';
import 'package:http/http.dart' as http;

class ProductRepository {
  final String apiUrl = "https://fakestoreapi.com/products";

  Future<List<ProductModel>> fetchProduct() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List<ProductModel> product = (json.decode(response.body) as List)
          .map((data) => ProductModel.fromJson(data))
          .toList();
      print(product);
      return product;
    } else {
      throw Exception('Failed to load product');
    }
  }
}
