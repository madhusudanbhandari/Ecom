import 'package:ecom/Providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Models/product.dart';

class ProductCard extends ConsumerWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);

    final index = cart.indexWhere((item) => item.product.id == product.id);

    final quantity = index == -1 ? 0 : cart[index].quantity;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.shopping_bag, size: 60),
            ),
            const SizedBox(height: 10),

            Text(
              product.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),

            const SizedBox(height: 4),

            Text(
              "Rs.{product.price}",
              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 10),

            quantity == 0
                ? SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        ref.read(cartProvider.notifier).addProduct(product);
                      },
                      child: const Text("Add to cart"),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          ref
                              .read(cartProvider.notifier)
                              .decreaseQuantity(product);
                        },
                        icon: const Icon(Icons.remove_circle),
                      ),
                      Text(
                        '$quantity',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          ref
                              .read(cartProvider.notifier)
                              .increaseQuantity(product);
                        },
                        icon: const Icon(Icons.add_circle),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
