import 'package:ecom/Providers/customer/order_provider.dart';
import 'package:ecom/Widgets/customer/order_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyOrdersPage extends ConsumerWidget {
  const MyOrdersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(customerOrdersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("My Orders"), centerTitle: true),

      body: orders.when(
        loading: () => const Center(child: CircularProgressIndicator()),

        error: (e, _) => Center(child: Text(e.toString())),

        data: (orders) {
          if (orders.isEmpty) {
            return const Center(
              child: Text("No orders found", style: TextStyle(fontSize: 18)),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(customerOrdersProvider);
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              itemBuilder: (_, index) {
                return OrderCard(order: orders[index]);
              },
            ),
          );
        },
      ),
    );
  }
}
