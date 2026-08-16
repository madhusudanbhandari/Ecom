import 'dart:convert';

import 'package:ecom/Models/order/create_order_request.dart';
import 'package:ecom/Models/order/order_response.dart';
import 'package:ecom/Services/token_storage.dart';
import 'package:ecom/utils/api_constants.dart';
import 'package:http/http.dart' as http;

class OrderService {
  Future<OrderResponse> createOrder(CreateOrderRequest request) async {
    final token = await TokenStorage.getToken();

    if (token == null) {
      throw Exception("User not logged in");
    }

    final response = await http.post(
      Uri.parse("${ApiConstants.baseUrl}/order"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return OrderResponse.fromJson(jsonDecode(response.body));
    }

    throw Exception(
      "Status code: ${response.statusCode} and body ${response.body}",
    );
  }

  Future<List<OrderResponse>> getCustomerOrders() async {
    final token = await TokenStorage.getToken();

    if (token == null) {
      throw Exception("User not logged in");
    }

    final response = await http.get(
      Uri.parse("${ApiConstants.baseUrl}/order/my-orders"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);

      return data.map((e) => OrderResponse.fromJson(e)).toList();
    }

    throw Exception("Failed to load orders");
  }

  Future<List<OrderResponse>> getMerchantOrders() async {
    final token = await TokenStorage.getToken();

    if (token == null) {
      throw Exception("User not logged in");
    }

    final response = await http.get(
      Uri.parse("${ApiConstants.baseUrl}/order/merchant-orders"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);

      return data.map((e) => OrderResponse.fromJson(e)).toList();
    }

    throw Exception("Failed to load merchant orders");
  }

  Future<void> updateOrderStatus(int orderId, String status) async {
    final token = await TokenStorage.getToken();
    final url = "${ApiConstants.baseUrl}/order/$orderId/status";
    print("URL=$url");
    final response = await http.put(
      Uri.parse(url),

      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({"status": status}),
    );

    if (response.statusCode != 200) {
      throw Exception(
        "Status: ${response.statusCode} and body ${response.body}",
      );
    }
  }
}
