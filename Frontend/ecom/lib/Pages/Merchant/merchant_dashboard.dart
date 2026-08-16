import 'package:ecom/Models/customer/product.dart';
import 'package:ecom/Models/order/order_response.dart';
import 'package:ecom/Pages/Merchant/add_product_page.dart';
import 'package:ecom/Pages/Merchant/my_products.dart';
import 'package:ecom/Pages/Merchant/view_orders.dart';
import 'package:ecom/Services/order_service.dart';
import 'package:ecom/Services/product_service.dart';
import 'package:ecom/Widgets/merchant/dashboard_action_button.dart';
import 'package:ecom/Widgets/merchant/dashboard_stat_card.dart';
import 'package:ecom/Widgets/merchant/merchant_drawer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MerchantDashboard extends StatefulWidget {
  const MerchantDashboard({super.key});

  @override
  State<MerchantDashboard> createState() => _MerchantDashboardState();
}

class _MerchantDashboardState extends State<MerchantDashboard> {
  final ProductService _productService = ProductService();
  final OrderService _orderService = OrderService();

  List<Product> products = [];
  List<OrderResponse> orders = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    try {
      final fetchedProducts = await _productService.getMyProducts();
      final fetchedOrders = await _orderService.getMerchantOrders();

      setState(() {
        products = fetchedProducts;
        orders = fetchedOrders;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  int get totalProducts => products.length;

  int get totalOrders => orders.length;

  int get pendingOrders => orders.where((e) => e.status == "Pending").length;

  int get acceptedOrders => orders.where((e) => e.status == "Accepted").length;

  List<Product> get lowStockProducts =>
      products.where((e) => e.stock <= 5).toList();

  List<OrderResponse> get recentOrders => orders.take(5).toList();

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      drawer: const MerchantDrawer(),
      appBar: AppBar(
        title: const Text("Merchant Dashboard"),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: loadDashboard,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome Back ",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                DateFormat.yMMMMEEEEd().format(DateTime.now()),
                style: TextStyle(color: Colors.grey.shade600),
              ),

              const SizedBox(height: 25),

              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 1.35,
                children: [
                  DashboardStatCard(
                    title: "Products",
                    value: totalProducts.toString(),
                    icon: Icons.inventory_2,
                    color: Colors.blue,
                  ),

                  DashboardStatCard(
                    title: "Orders",
                    value: totalOrders.toString(),
                    icon: Icons.shopping_bag,
                    color: Colors.green,
                  ),

                  DashboardStatCard(
                    title: "Pending",
                    value: pendingOrders.toString(),
                    icon: Icons.pending_actions,
                    color: Colors.orange,
                  ),

                  DashboardStatCard(
                    title: "Accepted",
                    value: acceptedOrders.toString(),
                    icon: Icons.check_circle,
                    color: Colors.purple,
                  ),
                ],
              ),

              const SizedBox(height: 30),

              const Text(
                "Quick Actions",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),

              const SizedBox(height: 15),

              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: .95,
                children: [
                  DashboardActionButton(
                    icon: Icons.add_box,
                    title: "Add Product",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AddProductPage(),
                        ),
                      );
                    },
                  ),

                  DashboardActionButton(
                    icon: Icons.inventory,
                    title: "My Products",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const MyProductsPage(),
                        ),
                      );
                    },
                  ),

                  DashboardActionButton(
                    icon: Icons.receipt_long,
                    title: "Orders",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const MerchantOrdersPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 30),
              const Text(
                "Low Stock Products",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 15),

              if (lowStockProducts.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Text(
                      "🎉 All products have sufficient stock.",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: lowStockProducts.length,
                  itemBuilder: (context, index) {
                    final product = lowStockProducts[index];

                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            product.imageUrl,
                            width: 55,
                            height: 55,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                const Icon(Icons.image),
                          ),
                        ),
                        title: Text(product.name),
                        subtitle: Text(
                          "Only ${product.stock} left",
                          style: const TextStyle(color: Colors.red),
                        ),
                        trailing: const Icon(
                          Icons.warning_amber_rounded,
                          color: Colors.orange,
                        ),
                      ),
                    );
                  },
                ),

              const SizedBox(height: 30),

              const Text(
                "Recent Orders",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 15),

              if (recentOrders.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Text(
                      "No orders yet.",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: recentOrders.length,
                  itemBuilder: (context, index) {
                    final order = recentOrders[index];

                    Color statusColor = Colors.orange;

                    if (order.status == "Accepted") {
                      statusColor = Colors.green;
                    } else if (order.status == "Rejected") {
                      statusColor = Colors.red;
                    }

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue.shade100,
                          child: Text(
                            "#${order.id}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        title: Text(
                          "Order #${order.id}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text("Rs. ${order.totalAmount.toStringAsFixed(2)}"),
                            const SizedBox(height: 4),
                            Text(
                              DateFormat.yMMMd().add_jm().format(
                                order.createdAt,
                              ),
                            ),
                          ],
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(.15),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            order.status,
                            style: TextStyle(
                              color: statusColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
