import 'package:ecom/Widgets/custom_button.dart';
import 'package:ecom/Widgets/custom_textfield.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isChecked = false;
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

              CustomTextfield(hintText: "Full Name"),
              const SizedBox(height: 10),
              CustomTextfield(hintText: "Email Address"),
              const SizedBox(height: 10),

              CustomTextfield(
                hintText: "Password",
                obscureText: true,
                suffixIcon: Icon(Icons.remove_red_eye),
              ),
              const SizedBox(height: 10),

              CustomTextfield(
                hintText: "Confirm Password",
                obscureText: true,
                suffixIcon: Icon(Icons.remove_red_eye),
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
              CustomButton(text: "Register", onPressed: () {}),

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
