import 'package:ecom/Providers/customer/cart_provider.dart';
import 'package:ecom/Widgets/customer/cart_item_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("My Cart"), centerTitle: true),
      body: cart.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Your cart is empty",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: cart.length,
              itemBuilder: (context, index) {
                final item = cart[index];

                return CartItemCard(
                  item: item,
                  onIncrease: () {
                    ref
                        .read(cartProvider.notifier)
                        .increaseQuantity(item.product);
                  },
                  onDecrease: () {
                    ref
                        .read(cartProvider.notifier)
                        .decreaseQuantity(item.product);
                  },
                  onRemove: () async {
                    final shouldDelete = await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text("Remove Product"),
                        content: Text(
                          "Remove ${item.product.name} from your cart?",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text("Cancel"),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text("Remove"),
                          ),
                        ],
                      ),
                    );

                    if (shouldDelete == true) {
                      ref
                          .read(cartProvider.notifier)
                          .removeProduct(item.product);
                    }
                  },
                );
              },
            ),
    );
  }
}
