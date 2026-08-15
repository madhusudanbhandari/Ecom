import 'package:ecom/Models/customer/product.dart';
import 'package:ecom/Models/merchant/update_product_request.dart';
import 'package:ecom/Providers/merchant/merchantProduct_provider.dart';
import 'package:ecom/Services/product_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditProduct extends ConsumerStatefulWidget {
  final Product product;

  const EditProduct({super.key, required this.product});

  @override
  ConsumerState<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends ConsumerState<EditProduct> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController priceController;
  late TextEditingController stockController;
  late TextEditingController imageController;

  final ProductService _productService = ProductService();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.product.name);

    descriptionController = TextEditingController(
      text: widget.product.description,
    );

    priceController = TextEditingController(
      text: widget.product.price.toString(),
    );

    stockController = TextEditingController(
      text: widget.product.stock.toString(),
    );

    imageController = TextEditingController(text: widget.product.imageUrl);
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    stockController.dispose();
    imageController.dispose();
    super.dispose();
  }

  Future<void> updateProduct() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final request = UpdateProductRequest(
        name: nameController.text.trim(),
        description: descriptionController.text.trim(),
        price: double.parse(priceController.text),
        stock: int.parse(stockController.text),
        imageUrl: imageController.text.trim(),
      );

      await _productService.updateProduct(widget.product.id, request);

      ref.invalidate(merchantProductsProvider);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Product Updated Successfully")),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Product"), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              buildTextField(
                controller: nameController,
                label: "Product Name",
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Enter product name";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              buildTextField(
                controller: descriptionController,
                label: "Description",
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Enter description";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              buildTextField(
                controller: priceController,
                label: "Price",
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter price";
                  }

                  if (double.tryParse(value) == null) {
                    return "Invalid price";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              buildTextField(
                controller: stockController,
                label: "Stock",
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter stock";
                  }

                  if (int.tryParse(value) == null) {
                    return "Invalid stock";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              buildTextField(
                controller: imageController,
                label: "Image URL",
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Enter image url";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: isLoading ? null : updateProduct,
                  icon: isLoading
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.save),

                  label: Text(isLoading ? "Updating..." : "Update Product"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
