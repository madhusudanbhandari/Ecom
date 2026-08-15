import 'dart:convert';

import 'package:ecom/utils/api_constants.dart';

import 'package:ecom/Models/product.dart';
import 'package:http/http.dart' as http;

class ProductService {
  Future<List<Product>> getProducts() async {
    final response = await http.get(
      Uri.parse("${ApiConstants.baseUrl}/product"),
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Product.fromJson(e)).toList();
    }
    throw Exception("Failed to load products");
  }
}
