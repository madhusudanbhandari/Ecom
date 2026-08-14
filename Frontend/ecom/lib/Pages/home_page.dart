import 'package:ecom/Widgets/buttom_nav_icons.dart';
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
      body: Center(child: Text("Explore items")),
      bottomNavigationBar: ButtomNavBar(),
    );
  }
}
