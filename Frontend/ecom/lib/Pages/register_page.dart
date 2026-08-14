import 'package:ecom/Widgets/custom_button.dart';
import 'package:ecom/Widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import '../Models/register_request.dart';
import '../Services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isChecked = false;
  bool obscureText = true;
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final AuthService _authService = AuthService();

  Future<void> register() async {
    final request = RegisterRequest(
      fullName: fullNameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      confirmPassword: confirmPasswordController.text.trim(),
    );

    try {
      final response = await _authService.register(request);

      print("Registration sucessfull");
    } catch (e) {
      print("Registration failed: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register'), centerTitle: true),

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              SizedBox(height: 40),
              Center(
                child: const Column(
                  children: [
                    Text(
                      "Join EasyShop",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text("Create your account"),
                  ],
                ),
              ),

              const SizedBox(height: 60),

              CustomTextfield(
                hintText: "Full Name",
                controller: fullNameController,
              ),
              const SizedBox(height: 10),
              CustomTextfield(
                hintText: "Email Address",
                controller: emailController,
              ),
              const SizedBox(height: 10),

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

              CustomTextfield(
                hintText: "Confirm Password",
                controller: confirmPasswordController,
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
                  Text("I agree all the "),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "terms and conditions",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              CustomButton(text: "Register", onPressed: register),

              const SizedBox(height: 50),
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey, height: 2)),
                  Text("OR"),
                  Expanded(child: Divider(color: Colors.grey, height: 2)),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account"),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Sign in",
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
