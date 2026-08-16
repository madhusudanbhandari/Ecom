import 'create_order_item.dart';

class CreateOrderRequest {
  final List<CreateOrderItem> items;

  CreateOrderRequest({required this.items});

  Map<String, dynamic> toJson() {
    return {"items": items.map((e) => e.toJson()).toList()};
  }
}
