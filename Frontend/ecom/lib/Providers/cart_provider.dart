import 'package:ecom/Models/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Models/cart_item.dart';

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  void addProduct(Product product) {
    final index = state.indexWhere((item) => item.product.id == product.id);

    if (index == -1) {
      state = [...state, CartItem(product: product, quantity: 1)];
    } else {
      final updated = [...state];

      updated[index] = updated[index].copyWith(
        quantity: updated[index].quantity + 1,
      );
      state = updated;
    }
  }

  void increaseQuantity(Product product) {
    final updated = [...state];

    final index = updated.indexWhere((item) => item.product.id == product.id);

    if (index != -1) {
      updated[index] = updated[index].copyWith(
        quantity: updated[index].quantity + 1,
      );

      state = updated;
    }
  }

  void decreaseQuantity(Product product) {
    final updated = [...state];

    final index = updated.indexWhere((item) => item.product.id == product.id);

    if (index == -1) return;

    if (updated[index].quantity == 1) {
      updated.removeAt(index);
    } else {
      updated[index] = updated[index].copyWith(
        quantity: updated[index].quantity - 1,
      );
    }
    state = updated;
  }

  void clearCart() {
    state = [];
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>(
  (ref) => CartNotifier(),
);
