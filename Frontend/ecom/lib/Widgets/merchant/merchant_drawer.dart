import 'package:ecom/Pages/Merchant/add_product_page.dart';
import 'package:ecom/Pages/Merchant/edit_product.dart';
import 'package:ecom/Pages/Merchant/my_products.dart';
import 'package:ecom/Pages/Merchant/profile_page.dart';
import 'package:ecom/Pages/Merchant/view_orders.dart';
import 'package:flutter/material.dart';

class MerchantDrawer extends StatelessWidget {
  const MerchantDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.blue),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                CircleAvatar(radius: 28, child: Icon(Icons.store, size: 32)),
                SizedBox(height: 12),

                Text(
                  "Merchant Panel",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Text(
                  "Manage your storage",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text("Dashboard"),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_box),
            title: const Text("Add product"),
            onTap: () {
              Navigator.pop(context);

              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddProductPage()),
              );
            },
          ),

          ListTile(
            leading: Icon(Icons.person_2_sharp),
            title: Text("My Products"),
            onTap: () {
              Navigator.pop(context);

              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => MyProductsPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.request_page_rounded),
            title: Text("View Orders"),
            onTap: () {
              Navigator.pop(context);

              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => MerchantOrdersPage()),
              );
            },
          ),

          ListTile(
            leading: Icon(Icons.person_3_outlined),
            title: Text("Profile"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => MerchantProfilePage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
