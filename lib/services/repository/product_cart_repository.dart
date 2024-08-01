import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/product_model.dart';

class ProductCartRepository {
  final FirebaseFirestore firestore;

  ProductCartRepository({required this.firestore});

  Future<ProductModel> getProductDetail(int productId) async {
    try {
      DocumentSnapshot doc = await firestore
          .collection('products')
          .doc(productId.toString())
          .get();

      if (doc.exists) {
        return ProductModel.fromFirestore(doc);
      } else {
        throw Exception('Product not found');
      }
    } catch (e) {
      throw Exception('Failed to load product: $e');
    }
  }
}
