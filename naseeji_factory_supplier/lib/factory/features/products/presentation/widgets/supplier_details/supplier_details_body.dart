import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:naseeji_factory/core/constants/app_colors.dart';
import 'package:naseeji_factory/core/constants/app_radius.dart';
import 'package:naseeji_factory/core/constants/app_spacing.dart';
import 'package:naseeji_factory/core/widgets/reusable_widgets.dart';
import '../../providers/products_provider.dart';
import '../../providers/suppliers_provider.dart';
import '../products_widgets.dart';
import '../supplier_details_widgets.dart';

class SupplierDetailsBody extends ConsumerWidget {
  final Supplier supplier;
  final List<Product> supplierProducts;

  const SupplierDetailsBody({
    super.key,
    required this.supplier,
    required this.supplierProducts,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsNotifier = ref.read(productsNotifierProvider.notifier);

    return SingleChildScrollView(
      child: Column(
        children: [
          SupplierHeaderWidget(supplier: supplier),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SupplierStatisticsWidget(supplier: supplier),
                AppSpacing.hLG,
                CompanyInformationWidget(supplier: supplier),
                AppSpacing.hLG,
                CertificatesWidget(certificates: supplier.certificates),
                AppSpacing.hLG,
                const Divider(),
                AppSpacing.hLG,
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.0),
                  child: Text(
                    'منتجات هذا المورد',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
                ),
                AppSpacing.hMD,
                supplierProducts.isEmpty
                    ? const Center(child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text('لا توجد منتجات مسجلة لهذا المورد حالياً.'),
                      ))
                    : ProductsGridWidget(
                        products: supplierProducts,
                        onFavoriteToggle: (id) => productsNotifier.toggleFavorite(id),
                        onProductTap: (prod) => context.push('/products/${prod.id}'),
                      ),
                const SizedBox(height: 24),
                // Contact Row Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          checkGuestAction(
                            context,
                            ref,
                            () => context.push('/chat'),
                          );
                        },
                        icon: const Icon(Icons.chat_bubble_outline_rounded),
                        label: const Text('فتح محادثة'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(color: AppColors.primary),
                          foregroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(borderRadius: AppRadius.rMD),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          checkGuestAction(
                            context,
                            ref,
                            () {
                              if (supplierProducts.isNotEmpty) {
                                context.push('/request-product?id=${supplierProducts.first.id}');
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('لا توجد منتجات لطلب عرض سعر لها حالياً.')),
                                );
                              }
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: AppRadius.rMD),
                        ),
                        child: const Text('إرسال طلب عرض سعر'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


