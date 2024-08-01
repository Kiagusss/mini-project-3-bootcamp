import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/cart_model.dart';
import '../../model/product_cart_model.dart';

class CartRepository {
  final CollectionReference cartCollection =
      FirebaseFirestore.instance.collection('orders');
  final CollectionReference productCollection =
      FirebaseFirestore.instance.collection('products');

  Future<List<CartModel>> fetchCart() async {
    try {
      final snapshot = await cartCollection.get();
      final carts = snapshot.docs.map((doc) {
        return CartModel.fromFirestore(doc);
      }).toList();
      return carts;
    } catch (e) {
      print('Failed to fetch cart from Firestore: $e');
      throw Exception('Failed to load cart');
    }
  }

  Future<ProductCartModel> fetchProductCart({
    required int id,
  }) async {
    try {
      final doc = await productCollection.doc(id.toString()).get();
      if (doc.exists) {
        return ProductCartModel.fromFirestore(doc);
      } else {
        throw Exception('Product not found');
      }
    } catch (e) {
      print('Failed to fetch product from Firestore: $e');
      throw Exception('Failed to load product');
    }
  }
}
