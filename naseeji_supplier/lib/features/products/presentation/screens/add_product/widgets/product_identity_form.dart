import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../steps/step1_basic_info_widget.dart';
import '../controllers/add_product_controller.dart';

class ProductIdentityForm extends ConsumerWidget {
  const ProductIdentityForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formData = ref.watch(addProductControllerProvider);
    return Step1BasicInfoWidget(formData: formData);
  }
}