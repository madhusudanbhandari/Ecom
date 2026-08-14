import 'package:ecom/Models/product.dart';
import 'package:ecom/Widgets/buttom_nav_icons.dart';
import 'package:ecom/Widgets/product_card.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Welcome home")),
      body: Column(
        children: [
          Center(
            child: Text(
              "Welcome to EasyShop",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),

          ProductCard(
            product: Product(
              id: 1,
              name: "Sample Product",
              price: 19.99,
              image: "https://via.placeholder.com/150",
              category: "Sample Category",
            ),
          ),
        ],
      ),
      bottomNavigationBar: ButtomNavBar(),
    );
  }
}
