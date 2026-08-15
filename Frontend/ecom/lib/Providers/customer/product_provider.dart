import 'package:ecom/Services/product_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productServiceProvider = Provider((ref) {
  return ProductService();
});

final productProvider = FutureProvider((ref) async {
  return ref.read(productServiceProvider).getProducts();
});
