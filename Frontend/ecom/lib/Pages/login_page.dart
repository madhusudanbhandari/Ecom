import 'package:ecom/Pages/register_page.dart';
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

              DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    TabBar(
                      indicatorColor: Colors.blue,
                      indicatorWeight: 3,
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.grey,
                      tabs: const [
                        Tab(text: "Sign in"),
                        Tab(text: "Register"),
                      ],
                    ),
                  ],
                ),
              ),
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
              CustomTextfield(hintText: "Email address"),
              SizedBox(height: 10),
              CustomTextfield(
                hintText: "Password",
                obscureText: true,
                suffixIcon: Icon(Icons.remove_red_eye_outlined),
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
              CustomButton(text: "Sign In", onPressed: () {}),
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
