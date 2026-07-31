import 'package:flutter/material.dart';
import 'factory_product_details_screen.dart';

export 'factory_product_details_screen.dart';

/// Delegate ProductDetailsScreen to FactoryProductDetailsScreen
class ProductDetailsScreen extends StatelessWidget {
  final String productId;

  const ProductDetailsScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return FactoryProductDetailsScreen(productId: productId);
  }
}



