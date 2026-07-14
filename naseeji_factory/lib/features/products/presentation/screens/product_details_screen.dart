import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/reusable_widgets.dart';
import '../providers/products_provider.dart';
import '../providers/suppliers_provider.dart';
import '../widgets/favorites_widgets.dart';
import '../widgets/product_details_widgets.dart';
import '../widgets/share_widgets.dart';

class ProductDetailsScreen extends ConsumerWidget {
  final String productId;

  const ProductDetailsScreen({super.key, required this.productId});

  void _showShareBottomSheet(BuildContext context, String name, String supplier) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return ShareProductBottomSheet(
          productName: name,
          supplierName: supplier,
          onCopyLink: () {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('تم نسخ رابط المنتج بنجاح!')),
            );
          },
          onDownloadPdf: () {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('بدء تحميل الكتالوج الفني...')),
            );
          },
        );
      },
    );
  }

  void _showFavoriteBottomSheet(
    BuildContext context,
    WidgetRef ref,
    String supplierId,
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
                  supplierId,
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
    final product = ref.watch(productsNotifierProvider.notifier).getProductById(productId);

    if (product == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('المنتج غير موجود.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل المنتج'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              product.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: product.isFavorite ? AppColors.error : null,
            ),
            onPressed: () => ref.read(productsNotifierProvider.notifier).toggleFavorite(product.id),
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () => _showShareBottomSheet(context, product.name, product.supplierName),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProductGalleryWidget(product: product),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProductInformationWidget(product: product),
                    AppSpacing.hMD,
                    const VideoPreviewWidget(),
                    AppSpacing.hMD,
                    PdfCatalogWidget(
                      onDownload: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('بدء تحميل الكتالوج الفني...')),
                        );
                      },
                    ),
                    AppSpacing.hLG,
                    ProductPricingWidget(product: product),
                    AppSpacing.hLG,
                    TechnicalSpecificationsWidget(product: product),
                    AppSpacing.hLG,
                    SupplierPreviewWidget(
                      supplierName: product.supplierName,
                      onTap: () => context.push('/suppliers/${product.supplierId}'),
                    ),
                    const SizedBox(height: 24),
                    // Action Buttons Row
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              final supplier = ref
                                  .read(suppliersNotifierProvider.notifier)
                                  .getSupplierById(product.supplierId);
                              if (supplier != null) {
                                checkGuestAction(
                                  context,
                                  ref,
                                  () => _showFavoriteBottomSheet(
                                    context,
                                    ref,
                                    supplier.id,
                                    supplier.name,
                                    supplier.type,
                                  ),
                                );
                              }
                            },
                            icon: const Icon(Icons.favorite_border_rounded),
                            label: const Text('مفضلة الموردين'),
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
                                () => context.push('/request-product?id=${product.id}'),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: AppRadius.rMD),
                            ),
                            child: const Text('طلب عرض سعر'),
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
