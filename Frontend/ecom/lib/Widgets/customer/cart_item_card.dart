import 'package:ecom/Models/customer/cart_item.dart';
import 'package:flutter/material.dart';

class CartItemCard extends StatelessWidget {
  final CartItem item;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onRemove;

  const CartItemCard({
    super.key,
    required this.item,
    required this.onIncrease,
    required this.onDecrease,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),

      child: Padding(
        padding: const EdgeInsets.all(12),

        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),

              child: Image.network(
                item.product.imageUrl,
                width: 90,
                height: 90,
                fit: BoxFit.cover,

                errorBuilder: (_, __, ___) {
                  return Container(
                    width: 90,
                    height: 90,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.image),
                  );
                },
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    item.product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "\$${item.product.price}",
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "Subtotal : \$${item.product.price * item.quantity}",
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      IconButton(
                        onPressed: onDecrease,
                        icon: const Icon(Icons.remove_circle_outline),
                      ),

                      Text(
                        "${item.quantity}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      IconButton(
                        onPressed: onIncrease,
                        icon: const Icon(Icons.add_circle_outline),
                      ),

                      const Spacer(),

                      IconButton(
                        onPressed: onRemove,
                        color: Colors.red,
                        icon: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
