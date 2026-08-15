import 'package:ecom/Pages/bag_page.dart';
import 'package:ecom/Pages/cart_page.dart';
import 'package:ecom/Pages/home_page.dart';
import 'package:ecom/Pages/profile_page.dart';
import 'package:ecom/Pages/search_page.dart';
import 'package:ecom/Widgets/buttom_nav_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainPage extends ConsumerWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeTab = ref.watch(activeTabProvider);

    Widget page;

    switch (activeTab) {
      case "search":
        page = const SearchPage();
        break;

      case 'cart':
        page = const CartPage();
        break;

      case 'profile':
        page = const ProfilePage();
        break;

      case 'bag':
        page = const BagPage();
        break;

      case 'home':
      default:
        page = const HomePage();
    }

    return Scaffold(body: page, bottomNavigationBar: const ButtomNavBar());
  }
}
