import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/reusable_widgets.dart';
import '../providers/products_provider.dart';
import '../providers/suppliers_provider.dart';
import '../widgets/favorites_widgets.dart';
import '../widgets/products_widgets.dart';
import '../widgets/supplier_details_widgets.dart';

class SupplierDetailsScreen extends ConsumerWidget {
  final String supplierId;

  const SupplierDetailsScreen({super.key, required this.supplierId});

  void _showFavoriteBottomSheet(
    BuildContext context,
    WidgetRef ref,
    String id,
    String name,
    String type,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return AddToFavoritesBottomSheet(
          supplierName: name,
          supplierType: type,
          onSave: (category, note) {
            ref.read(suppliersNotifierProvider.notifier).toggleFavorite(
                  id,
                  category: category,
                  note: note,
                );
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('تم إضافة المورد إلى المفضلة بنجاح!')),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final supplier = ref.watch(suppliersNotifierProvider.notifier).getSupplierById(supplierId);
    final allProducts = ref.watch(productsNotifierProvider);
    final productsNotifier = ref.read(productsNotifierProvider.notifier);
    final suppliersNotifier = ref.read(suppliersNotifierProvider.notifier);

    if (supplier == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('المورد غير موجود.')),
      );
    }

    final supplierProducts = allProducts.where((p) => p.supplierId == supplier.id).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('الملف التعريفي للمورد'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              supplier.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: supplier.isFavorite ? AppColors.error : null,
            ),
            onPressed: () {
              checkGuestAction(
                context,
                ref,
                () {
                  if (supplier.isFavorite) {
                    suppliersNotifier.toggleFavorite(supplier.id);
                  } else {
                    _showFavoriteBottomSheet(context, ref, supplier.id, supplier.name, supplier.type);
                  }
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم نسخ رابط الملف الشخصي للمورد!')),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
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
        ),
      ),
    );
  }
}
