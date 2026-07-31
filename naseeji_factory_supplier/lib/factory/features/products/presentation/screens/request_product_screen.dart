import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/reusable_widgets.dart';
import '../providers/products_provider.dart';
import '../providers/request_product_provider.dart';
import '../widgets/request_product/request_product_form_widget.dart';

class RequestProductScreen extends ConsumerWidget {
  final String productId;

  const RequestProductScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final product = ref.watch(productsNotifierProvider.notifier).getProductById(productId);
    final formState = ref.watch(requestProductNotifierProvider);

    if (product == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('المنتج غير موجود.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('طلب عرض سعر للمنتج'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: formState.isLoading
            ? const Center(child: LoadingWidget())
            : RequestProductFormWidget(product: product),
      ),
    );
  }
}


