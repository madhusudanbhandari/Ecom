import 'package:ecom/Providers/customer/order_provider.dart';
import 'package:ecom/Services/order_service.dart';
import 'package:ecom/Widgets/Merchant/merchant_order_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MerchantOrdersPage extends ConsumerWidget {
  const MerchantOrdersPage({super.key});

  Future<void> _updateStatus(
    WidgetRef ref,
    BuildContext context,
    int orderId,
    String status,
  ) async {
    try {
      await OrderService().updateOrderStatus(orderId, status);

      ref.invalidate(merchantOrdersProvider);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Order $status successfully"),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(merchantOrdersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Merchant Orders"), centerTitle: true),

      body: orders.when(
        loading: () => const Center(child: CircularProgressIndicator()),

        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 60, color: Colors.red),

              const SizedBox(height: 15),

              Text(error.toString(), textAlign: TextAlign.center),

              const SizedBox(height: 15),

              ElevatedButton(
                onPressed: () {
                  ref.invalidate(merchantOrdersProvider);
                },
                child: const Text("Retry"),
              ),
            ],
          ),
        ),

        data: (orders) {
          if (orders.isEmpty) {
            return RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(merchantOrdersProvider);
              },
              child: ListView(
                children: const [
                  SizedBox(height: 200),

                  Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.receipt_long_outlined,
                          size: 80,
                          color: Colors.grey,
                        ),

                        SizedBox(height: 20),

                        Text(
                          "No orders received yet",
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(merchantOrdersProvider);
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];

                return MerchantOrderCard(
                  order: order,

                  onAccept: () async {
                    await _updateStatus(ref, context, order.id, "Accepted");
                  },

                  onReject: () async {
                    await _updateStatus(ref, context, order.id, "Rejected");
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
