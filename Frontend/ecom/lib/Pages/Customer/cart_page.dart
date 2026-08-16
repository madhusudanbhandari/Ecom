import 'package:ecom/Models/order/create_order_item.dart';
import 'package:ecom/Models/order/create_order_request.dart';
import 'package:ecom/Providers/customer/cart_provider.dart';
import 'package:ecom/Providers/customer/product_provider.dart';
import 'package:ecom/Providers/customer/order_provider.dart';
import 'package:ecom/Services/order_service.dart';
import 'package:ecom/Widgets/customer/cart_item_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  Future<void> placeOrder(WidgetRef ref, BuildContext context) async {
    final cart = ref.read(cartProvider);

    if (cart.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Your cart is empty")));
      return;
    }

    final request = CreateOrderRequest(
      items: cart
          .map(
            (item) => CreateOrderItem(
              productId: item.product.id,
              quantity: item.quantity,
            ),
          )
          .toList(),
    );

    try {
      await OrderService().createOrder(request);

      ref.read(cartProvider.notifier).clearCart();

      ref.invalidate(customerOrdersProvider);
      ref.invalidate(productProvider);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Order placed successfully"),
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
    final cart = ref.watch(cartProvider);

    final total = cart.fold<double>(
      0,
      (sum, item) => sum + item.product.price.toDouble() * item.quantity,
    );

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
                            onPressed: () {
                              Navigator.pop(context, false);
                            },
                            child: const Text("Cancel"),
                          ),

                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context, true);
                            },
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

      bottomNavigationBar: cart.isEmpty
          ? null
          : SafeArea(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.08),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Total",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Text(
                          "\$${total.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.shopping_bag),
                        label: const Text(
                          "Checkout",
                          style: TextStyle(fontSize: 16),
                        ),
                        onPressed: () async {
                          await placeOrder(ref, context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
