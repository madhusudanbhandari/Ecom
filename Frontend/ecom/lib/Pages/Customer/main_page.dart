import 'package:ecom/Pages/Customer/bag_page.dart';
import 'package:ecom/Pages/Customer/cart_page.dart';
import 'package:ecom/Pages/Customer/home_page.dart';
import 'package:ecom/Pages/Customer/my_orders_page.dart';
import 'package:ecom/Pages/Customer/profile_page.dart';
import 'package:ecom/Widgets/customer/buttom_nav_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainPage extends ConsumerWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeTab = ref.watch(activeTabProvider);

    Widget page;

    switch (activeTab) {
      case 'cart':
        page = const CartPage();
        break;

      case 'profile':
        page = const CustomerProfilePage();
        break;

      case 'bag':
        page = const MyOrdersPage();
        break;

      case 'home':
      default:
        page = const HomePage();
    }

    return Scaffold(body: page, bottomNavigationBar: const ButtomNavBar());
  }
}
