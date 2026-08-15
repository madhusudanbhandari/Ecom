import 'package:ecom/Services/product_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final merchantProductsProvider = FutureProvider(((ref) async {
  final productService = ProductService();

  return await productService.getMyProducts();
}));
