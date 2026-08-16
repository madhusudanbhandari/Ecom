class CreateOrderItem {
  final int productId;
  final int quantity;

  CreateOrderItem({required this.productId, required this.quantity});

  Map<String, dynamic> toJson() {
    return {"productId": productId, "quantity": quantity};
  }
}
