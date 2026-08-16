class OrderResponse {
  final int id;
  final double totalAmount;
  final String status;
  final DateTime createdAt;

  OrderResponse({
    required this.id,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    return OrderResponse(
      id: json["id"],
      totalAmount: (json["totalAmount"] as num).toDouble(),
      status: json["status"],
      createdAt: DateTime.parse(json["createdAt"]),
    );
  }
}
