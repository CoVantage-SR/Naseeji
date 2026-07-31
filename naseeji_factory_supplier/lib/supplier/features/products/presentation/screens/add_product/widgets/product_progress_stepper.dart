import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naseeji_factory/supplier/features/products/presentation/controllers/add_product_controller.dart';
import 'wizard_progress_header.dart';

class ProductProgressStepper extends ConsumerWidget {
  const ProductProgressStepper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formData = ref.watch(addProductControllerProvider);
    return WizardProgressHeader(formData: formData);
  }
}

