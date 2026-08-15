import 'package:ecom/Models/customer/product.dart';
import 'package:ecom/Pages/Merchant/edit_product.dart';
import 'package:ecom/Services/product_service.dart';
import 'package:ecom/Widgets/merchant/merchant_product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ecom/Providers/merchant/merchantProduct_provider.dart';
import 'package:ecom/Widgets/customer/product_card.dart';

class MyProductsPage extends ConsumerWidget {
  const MyProductsPage({super.key});

  Future<void> showDeleteDialog(
    BuildContext context,
    WidgetRef ref,
    Product product,
  ) async {
    final confirm = await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          icon: const Icon(
            Icons.warning_amber_rounded,
            color: Colors.red,
            size: 45,
          ),
          title: const Text("Delete product"),

          content: Text('Are you sure you want to delete\n"${product.name}"?'),

          actions: [
            TextButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );

    if (confirm != true) {
      return;
    }

    try {
      await ProductService().deleteProduct(product.id);

      ref.invalidate(merchantProductsProvider);

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Product deleted successfully")),
      );
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(merchantProductsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("My Products"), centerTitle: true),

      body: productsAsync.when(
        loading: () {
          return const Center(child: CircularProgressIndicator());
        },

        error: (error, stackTrace) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 50, color: Colors.red),

                const SizedBox(height: 12),

                Text(error.toString(), textAlign: TextAlign.center),

                const SizedBox(height: 16),

                ElevatedButton(
                  onPressed: () {
                    ref.invalidate(merchantProductsProvider);
                  },
                  child: const Text("Retry"),
                ),
              ],
            ),
          );
        },

        data: (products) {
          if (products.isEmpty) {
            return RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(merchantProductsProvider);
              },

              child: ListView(
                children: const [
                  SizedBox(height: 200),

                  Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 70,
                          color: Colors.grey,
                        ),

                        SizedBox(height: 15),

                        Text(
                          "You haven't added any products yet",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
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
              ref.invalidate(merchantProductsProvider);
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];

                return MerchantProductCard(
                  product: product,
                  onEdit: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditProduct(product: product),
                      ),
                    );
                  },
                  onDelete: () {
                    showDeleteDialog(context, ref, product);
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
