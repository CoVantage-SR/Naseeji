import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../steps/step2_tech_specs_widget.dart';
import '../controllers/add_product_controller.dart';

class ProductTechnicalSpecsForm extends ConsumerWidget {
  const ProductTechnicalSpecsForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formData = ref.watch(addProductControllerProvider);
    return Step2TechSpecsWidget(formData: formData);
  }
}
