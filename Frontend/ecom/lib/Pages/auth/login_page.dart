import 'dart:math';

import 'package:ecom/Models/auth/login_request.dart';
import 'package:ecom/Pages/home_page.dart';
import 'package:ecom/Pages/auth/register_page.dart';
import 'package:ecom/Pages/main_page.dart';
import 'package:ecom/Services/auth_service.dart';
import 'package:ecom/Widgets/custom_button.dart';
import 'package:ecom/Widgets/custom_textfield.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isChecked = false;
  bool obscureText = true;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final AuthService _authService = AuthService();

  Future<void> login() async {
    final request = LoginRequest(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    try {
      final response = await _authService.login(request);
      Navigator.push(context, MaterialPageRoute(builder: (_) => MainPage()));
      print("Login Successfull");
    } catch (e) {
      print("Login Failed: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Easy Shop', style: TextStyle(color: Colors.blue)),
        toolbarHeight: 140,
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),

              // DefaultTabController(
              //   length: 2,
              //   child: Column(
              //     children: [
              //       TabBar(
              //         indicatorColor: Colors.blue,
              //         indicatorWeight: 3,
              //         labelColor: Colors.black,
              //         unselectedLabelColor: Colors.grey,
              //         tabs: const [
              //           Tab(text: "Sign in"),
              //           Tab(text: "Register"),
              //         ],
              //       ),
              //     ],
              //   ),
              // ),
              SizedBox(height: 40),

              Center(
                child: Column(
                  children: const [
                    Text(
                      'Welcome back',
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              CustomTextfield(
                hintText: "Email address",
                controller: emailController,
              ),
              SizedBox(height: 10),
              CustomTextfield(
                hintText: "Password",
                controller: passwordController,
                obscureText: obscureText,
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      obscureText = !obscureText;
                    });
                  },
                  icon: Icon(Icons.remove_red_eye),
                ),
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  Checkbox(
                    value: isChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        isChecked = value!;
                      });
                    },
                  ),
                  const Text('Remember me'),

                  const Spacer(),

                  TextButton(
                    onPressed: () {},
                    child: const Text('Forgot Password?'),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // ignore: avoid_print
              CustomButton(text: "Sign In", onPressed: login),
              SizedBox(height: 30),

              Row(
                children: [
                  Expanded(child: Divider(thickness: 1, color: Colors.grey)),
                  Text("OR"),
                  Expanded(child: Divider(thickness: 1, color: Colors.grey)),
                ],
              ),

              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('New here?'),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => RegisterPage()),
                      );
                    },
                    child: Text(
                      "Create an account",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
