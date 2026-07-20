import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/reusable_widgets.dart';
import '../providers/products_provider.dart';
import '../providers/suppliers_provider.dart';
import '../widgets/favorites_widgets.dart';
import '../widgets/share_widgets.dart';

// Product-details sub-widgets
import '../widgets/product_details/product_gallery_widget.dart';
import '../widgets/product_details/product_summary_widget.dart';
import '../widgets/product_details/product_technical_specs_widget.dart';
import '../widgets/product_details/product_pricing_widget.dart';
import '../widgets/product_details/bulk_pricing_widget.dart';
import '../widgets/product_details/production_capacity_widget.dart';
import '../widgets/product_details/logistics_widget.dart';
import '../widgets/product_details/documents_widget.dart';
import '../widgets/product_details/sample_widget.dart';
import '../widgets/product_details/product_reviews_widget.dart';
import '../widgets/product_details/supplier_preview_widget.dart';
import '../widgets/product_details/video_preview_widget.dart';
import '../widgets/product_details/procurement_timeline_widget.dart';
import '../widgets/product_details/product_bottom_action_bar_widget.dart';

class ProductDetailsScreen extends ConsumerWidget {
  final String productId;

  const ProductDetailsScreen({super.key, required this.productId});

  void _showShareBottomSheet(BuildContext context, String name, String supplier) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => ShareProductBottomSheet(
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
      ),
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
      builder: (context) => AddToFavoritesBottomSheet(
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
      ),
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
      bottomNavigationBar: ProductBottomActionBarWidget(
        onFavoriteSupplier: () {
          final supplier = ref.read(suppliersNotifierProvider.notifier).getSupplierById(product.supplierId);
          if (supplier != null) {
            checkGuestAction(
              context,
              ref,
              () => _showFavoriteBottomSheet(context, ref, supplier.id, supplier.name, supplier.type),
            );
          }
        },
        onRequestQuote: () => checkGuestAction(
          context,
          ref,
          () => context.push('/request-product?id=${product.id}'),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Image Gallery
              ProductGalleryWidget(product: product),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 2. Product Name, Rating, Description
                    ProductSummaryWidget(product: product),
                    AppSpacing.hMD,
                    // 3. Video Preview
                    VideoPreviewWidget(onTap: () {}),
                    AppSpacing.hLG,
                    // 4. Base Unit Pricing + MOQ
                    ProductPricingWidget(product: product),
                    AppSpacing.hMD,
                    // 5. Bulk Pricing Tiers (NEW)
                    BulkPricingWidget(productId: productId),
                    AppSpacing.hLG,
                    // 6. Technical Specifications
                    ProductTechnicalSpecsWidget(product: product),
                    AppSpacing.hLG,
                    // 7. Production Capacity (NEW)
                    ProductionCapacityWidget(productId: productId),
                    AppSpacing.hLG,
                    // 8. Naseeji Logistics (NEW) — Naseeji Logistics Only, 48h SLA
                    LogisticsWidget(productId: productId),
                    AppSpacing.hLG,
                    // 9. Documents & Certificates (NEW)
                    DocumentsWidget(
                      productId: productId,
                      onDownload: () => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('بدء تحميل الوثيقة...')),
                      ),
                    ),
                    AppSpacing.hLG,
                    // 10. Physical Samples (NEW)
                    SampleWidget(
                      productId: productId,
                      onRequestSample: () => checkGuestAction(
                        context,
                        ref,
                        () => ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('سيتم التواصل معك لترتيب إرسال العينة.')),
                        ),
                      ),
                    ),
                    AppSpacing.hLG,
                    // 11. Supplier Profile Preview
                    SupplierPreviewWidget(
                      supplierName: product.supplierName,
                      onTap: () => context.push('/suppliers/${product.supplierId}'),
                    ),
                    AppSpacing.hLG,
                    // 12. B2B Reviews (NEW)
                    ProductReviewsWidget(productId: productId),
                    AppSpacing.hLG,
                    // 13. Procurement Timeline — 24 steps (NEW)
                    ProcurementTimelineWidget(productId: productId),
                    const SizedBox(height: 16),
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
