import 'package:ecom/Models/product.dart';
import 'package:ecom/Providers/cart_provider.dart';
import 'package:ecom/Providers/product_provider.dart';
import 'package:ecom/Widgets/buttom_nav_icons.dart';
import 'package:ecom/Widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Easy Shop")),

      body: products.when(
        data: (items) {
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,

            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: .65,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
            ),
            itemBuilder: (_, index) {
              final product = items[index];

              return ProductCard(
                product: product,
                onAdd: () {
                  ref.read(cartProvider.notifier).addProduct(product);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("${product.name} added to cart")),
                  );
                },
              );
            },
          );
        },
        error: (e, _) => Center(child: Text(e.toString())),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
