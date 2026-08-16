import 'package:ecom/Models/order/order_response.dart';
import 'package:ecom/Services/order_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final orderServiceProvider = Provider<OrderService>((ref) {
  return OrderService();
});

final customerOrdersProvider = FutureProvider<List<OrderResponse>>((ref) async {
  final service = ref.read(orderServiceProvider);

  return service.getCustomerOrders();
});

final merchantServiceProvider = FutureProvider<List<OrderResponse>>((ref) {
  final service = ref.read(orderServiceProvider);

  return service.getMerchantOrders();
});

final merchantOrdersProvider = FutureProvider<List<OrderResponse>>((ref) async {
  return OrderService().getMerchantOrders();
});
