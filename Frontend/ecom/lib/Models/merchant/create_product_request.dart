class CreateProductRequest {
  final String name;
  final String description;
  final double price;
  final int stock;
  final String imageUrl;

  CreateProductRequest({
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "description": description,
      "price": price,
      "stock": stock,
      "imageUrl": imageUrl,
    };
  }
}
