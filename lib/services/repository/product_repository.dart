import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/product_model.dart';

class ProductRepository {
  final CollectionReference productCollection =
      FirebaseFirestore.instance.collection('products');

  Future<List<ProductModel>> fetchProduct() async {
    try {
      final snapshot = await productCollection.get();
      final products = snapshot.docs.map((doc) {
        return ProductModel.fromFirestore(doc);
      }).toList();
      return products;
    } catch (e) {
      print('Failed to fetch products from Firestore: $e');
      throw Exception('Failed to load product');
    }
  }
}
