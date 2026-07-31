import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naseeji_factory/supplier/features/products/presentation/controllers/add_product_controller.dart';
import '../steps/step6_pricing_tiers_widget.dart';

class ProductPricingForm extends ConsumerWidget {
  const ProductPricingForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formData = ref.watch(addProductControllerProvider);
    return Step6PricingTiersWidget(formData: formData);
  }
}
