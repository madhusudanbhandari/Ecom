import 'package:ecom/Models/customer/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../Models/customer/cart_item.dart';

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

  void removeProduct(Product product) {
    state = state.where((item) => item.product.id != product.id).toList();
  }

  double get totalPrice {
    return state.fold(
      0,
      (sum, item) => sum + (item.product.price * item.quantity),
    );
  }

  int get totalItems {
    return state.fold(0, (sum, item) => sum + item.quantity);
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>(
  (ref) => CartNotifier(),
);
