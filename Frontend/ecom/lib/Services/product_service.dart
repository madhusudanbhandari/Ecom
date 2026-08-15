import 'dart:convert';
import 'dart:io';

import 'package:ecom/Models/merchant/create_product_request.dart';
import 'package:ecom/Models/merchant/update_product_request.dart';
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

  Future<List<Product>> getMyProducts() async {
    final token = await TokenStorage.getToken();

    if (token == null) {
      throw Exception("No token found. Please login again.");
    }

    final url = Uri.parse("${ApiConstants.baseUrl}/product/my-products");

    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);

      return data.map((e) => Product.fromJson(e)).toList();
    }

    if (response.statusCode == 401) {
      throw Exception("Unauthorized. Token may be expired or invalid.");
    }

    if (response.statusCode == 403) {
      throw Exception("Forbidden. You are not authorized as a Merchant.");
    }

    throw Exception(
      "Failed to load your products. "
      "Status: ${response.statusCode}, "
      "Response: ${response.body}",
    );
  }

  Future<Product> updateProduct(int id, UpdateProductRequest request) async {
    final token = await TokenStorage.getToken();

    if (token == null) {
      throw Exception("User not logged in");
    }
    final response = await http.put(
      Uri.parse("${ApiConstants.baseUrl}/product/$id"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      return Product.fromJson(jsonDecode(response.body));
    }

    throw Exception(response.body);
  }

  Future<void> deleteProduct(int id) async {
    final token = await TokenStorage.getToken();

    if (token == null) {
      throw Exception("User not logged in");
    }

    final response = await http.delete(
      Uri.parse("${ApiConstants.baseUrl}/product/$id"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode != 200) {
      throw Exception("Unable to delete product");
    }
  }
}
