import 'dart:convert';
import 'dart:io';

import 'package:ecom/Models/merchant/create_product_request.dart';
import 'package:ecom/Services/token_storage.dart';
import 'package:ecom/utils/api_constants.dart';

import 'package:ecom/Models/customer/product.dart';
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

  Future<Product> createProduct(CreateProductRequest request) async {
    final token = await TokenStorage.getToken();

    if (token == null) {
      throw Exception("No JWT token found in storage");
    }

    final url = Uri.parse("${ApiConstants.baseUrl}/product");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Product.fromJson(jsonDecode(response.body));
    }

    throw Exception(
      "Create product failed: "
      "${response.statusCode} - ${response.body}",
    );
  }
}
