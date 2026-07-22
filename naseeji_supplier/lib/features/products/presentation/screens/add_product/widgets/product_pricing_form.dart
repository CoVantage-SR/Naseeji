import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../steps/step6_pricing_tiers_widget.dart';
import '../controllers/add_product_controller.dart';

class ProductPricingForm extends ConsumerWidget {
  const ProductPricingForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formData = ref.watch(addProductControllerProvider);
    return Step6PricingTiersWidget(formData: formData);
  }
}
