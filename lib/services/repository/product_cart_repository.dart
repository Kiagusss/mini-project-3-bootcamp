
import 'package:dio/dio.dart';

import '../../model/product_model.dart';

class ProductCartRepository {
  final Dio dio;

  ProductCartRepository({required this.dio});

  Future<ProductModel> getProductDetail(int productId) async {
    final response = await dio.get('https://jsonplaceholder.typicode.com/products/$productId');
    return ProductModel.fromJson(response.data);
  }
}