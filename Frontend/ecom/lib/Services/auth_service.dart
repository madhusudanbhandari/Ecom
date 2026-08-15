import 'dart:convert';

import 'package:ecom/Models/auth/login_request.dart';
import 'package:http/http.dart' as http;

import '../Models/auth/auth_response.dart';
import '../Models/auth/register_request.dart';
import '../utils/api_constants.dart';

class AuthService {
  Future<AuthResponse> register(RegisterRequest request) async {
    final url = Uri.parse("${ApiConstants.baseUrl}/auth/register");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      return AuthResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.body);
    }
  }

  Future<AuthResponse> login(LoginRequest request) async {
    final url = Uri.parse("${ApiConstants.baseUrl}/auth/login");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      return AuthResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.body);
    }
  }
}
