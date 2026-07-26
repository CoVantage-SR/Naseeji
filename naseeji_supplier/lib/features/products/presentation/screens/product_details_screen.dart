import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/product_model.dart';
import '../providers/product_details_provider.dart';
import '../widgets/details/product_gallery_widget.dart';
import '../widgets/details/product_basic_info_card.dart';
import '../widgets/details/product_pricing_card.dart';
import '../widgets/details/inventory_card.dart';
import '../widgets/details/certificates_card.dart';
import '../widgets/details/subscription_info_card.dart';
import '../widgets/details/analytics_card.dart';
import '../widgets/details/timeline_card.dart';
import '../widgets/details/related_deals_card.dart';
import '../widgets/details/bottom_action_bar.dart';
import '../widgets/details/sheets/share_product_bottom_sheet.dart';
import '../widgets/details/sheets/manage_inventory_bottom_sheet.dart';
import '../widgets/details/sheets/store_preview_bottom_sheet.dart';
import '../widgets/details/sheets/toggle_status_bottom_sheet.dart';

class ProductDetailsScreen extends ConsumerWidget {
  final String productId;

  const ProductDetailsScreen({
    super.key,
    required this.productId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(productDetailsNotifierProvider(productId));
    final notifier = ref.read(productDetailsNotifierProvider(productId).notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF9FAFB),
        appBar: AppBar(
          backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
          elevation: 0.5,
          leading: IconButton(
            icon: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2D1B4E) : const Color(0xFFF3E8FF),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_forward_rounded,
                color: isDark ? const Color(0xFFC084FC) : const Color(0xFF9333EA),
                size: 20,
              ),
            ),
            onPressed: () => context.pop(),
          ),
          title: Column(
            children: [
              Text(
                'تفاصيل المنتج',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF111827),
                ),
              ),
              Text(
                'عرض وإدارة تفاصيل المنتج',
                style: TextStyle(
                  fontSize: 11,
                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          centerTitle: true,
          actions: [
            // Top Overflow Menu (3 dots) as requested
            PopupMenuButton<String>(
              icon: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2D1B4E) : const Color(0xFFF3E8FF),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.more_vert_rounded,
                  color: isDark ? const Color(0xFFC084FC) : const Color(0xFF9333EA),
                  size: 20,
                ),
              ),
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              onSelected: (value) => _handleMenuSelection(context, value, state, notifier),
              itemBuilder: (context) => [
                _buildMenuItem(context, value: 'edit', icon: Icons.edit_outlined, text: 'تعديل المنتج'),
                _buildMenuItem(
                  context,
                  value: 'toggle_status',
                  icon: state.product?.status == ProductStatus.published
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  text: state.product?.status == ProductStatus.published ? 'إخفاء المنتج' : 'إظهار المنتج',
                ),
                _buildMenuItem(context, value: 'copy', icon: Icons.copy_rounded, text: 'نسخ المنتج'),
                const PopupMenuDivider(),
                _buildMenuItem(
                  context,
                  value: 'delete',
                  icon: Icons.delete_outline_rounded,
                  text: 'حذف المنتج',
                  isDanger: true,
                ),
              ],
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: SafeArea(
          child: state.isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Color(0xFF9333EA)),
                )
              : state.error != null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline_rounded, size: 48, color: Color(0xFFEF4444)),
                          const SizedBox(height: 12),
                          Text('تعذر تحميل تفاصيل المنتج: ${state.error}'),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => notifier.loadDetails(),
                            child: const Text('إعادة المحاولة'),
                          ),
                        ],
                      ),
                    )
                  : state.product == null
                      ? const Center(child: Text('المنتج غير موجود'))
                      : Column(
                          children: [
                            // Main Scrollable Area
                            Expanded(
                              child: SingleChildScrollView(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                child: Column(
                                  children: [
                                    // Section 0: Top Info Row (matching reference image top card)
                                    _buildTopInfoCard(context, state.product!),
                                    const SizedBox(height: 14),

                                    // Section 1: Product Gallery Slider & Action Buttons
                                    ProductGalleryWidget(
                                      product: state.product!,
                                      onEdit: () => _handleEditProduct(context, state),
                                      onToggleStatus: () => _handleToggleStatus(context, state, notifier),
                                      onCopy: () => _handleCopyProduct(context, notifier),
                                      onShare: () => _handleShare(context, state.product!),
                                    ),
                                    const SizedBox(height: 14),

                                    // Section 2: Basic Specifications Card
                                    ProductBasicInfoCard(product: state.product!),
                                    const SizedBox(height: 14),

                                    // Section 3: Pricing & Capacity Card
                                    ProductPricingCard(product: state.product!),
                                    const SizedBox(height: 14),

                                    // Section 4: Inventory & Availability Card
                                    InventoryCard(
                                      product: state.product!,
                                      onStockUpdated: (newStock) => notifier.updateStock(newStock),
                                    ),
                                    const SizedBox(height: 14),

                                    // Section 5: Certificates Card
                                    CertificatesCard(product: state.product!),
                                    const SizedBox(height: 14),

                                    // Section 6: Subscription Limits Card
                                    SubscriptionInfoCard(
                                      limits: state.subscriptionLimits,
                                      onUpgrade: () => context.push('/subscription/management'),
                                    ),
                                    const SizedBox(height: 14),

                                    // Section 7: Analytics & Performance Card
                                    AnalyticsCard(product: state.product!),
                                    const SizedBox(height: 14),

                                    // Section 8: Timeline Card
                                    TimelineCard(product: state.product!),
                                    const SizedBox(height: 14),

                                    // Section 9: Related Deals Card
                                    RelatedDealsCard(deals: state.relatedDeals),
                                    const SizedBox(height: 20),
                                  ],
                                ),
                              ),
                            ),

                            // Sticky Bottom Action Bar
                            BottomActionBar(
                              product: state.product!,
                              onEdit: () => _handleEditProduct(context, state),
                              onManageInventory: () => _handleManageInventory(context, state, notifier),
                              onToggleHideRepublish: () => _handleToggleStatus(context, state, notifier),
                              onViewInStore: () => _handleViewInStore(context, state.product!),
                              onShare: () => _handleShare(context, state.product!),
                            ),
                          ],
                        ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Top Info Card (matching reference image top summary banner)
  // ---------------------------------------------------------------------------
  Widget _buildTopInfoCard(BuildContext context, ProductModel product) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final statusText = product.statusArabicLabel;
    final statusColor = product.status.color;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left in RTL: Product Status Badge
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: statusColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    statusText,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                'الحالة',
                style: TextStyle(
                  fontSize: 10,
                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280),
                ),
              ),
            ],
          ),

          // Center in RTL: Added Date
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2D1B4E) : const Color(0xFFF3E8FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.calendar_today_rounded,
                  size: 16,
                  color: isDark ? const Color(0xFFC084FC) : const Color(0xFF9333EA),
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '25 مايو 2024',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'تاريخ الإضافة',
                    style: TextStyle(
                      fontSize: 10,
                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Right in RTL: Product Code / SKU
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    product.sku.isNotEmpty ? product.sku : 'PRD-2024-00045',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'رقم المنتج',
                    style: TextStyle(
                      fontSize: 10,
                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2D1B4E) : const Color(0xFFF3E8FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.local_offer_outlined,
                  size: 16,
                  color: isDark ? const Color(0xFFC084FC) : const Color(0xFF9333EA),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Handlers & Business Rules
  // ---------------------------------------------------------------------------
  PopupMenuItem<String> _buildMenuItem(
    BuildContext context, {
    required String value,
    required IconData icon,
    required String text,
    bool isDanger = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isDanger
        ? const Color(0xFFEF4444)
        : (isDark ? Colors.white : const Color(0xFF111827));

    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(fontSize: 13, color: color, fontWeight: isDanger ? FontWeight.bold : FontWeight.w500),
          ),
        ],
      ),
    );
  }

  void _handleMenuSelection(
    BuildContext context,
    String value,
    ProductDetailsState state,
    ProductDetailsNotifier notifier,
  ) {
    switch (value) {
      case 'edit':
        _handleEditProduct(context, state);
        break;
      case 'toggle_status':
        _handleToggleStatus(context, state, notifier);
        break;
      case 'copy':
        _handleCopyProduct(context, notifier);
        break;
      case 'delete':
        _handleDeleteProduct(context, state, notifier);
        break;
    }
  }

  void _handleEditProduct(BuildContext context, ProductDetailsState state) {
    // Business Rule 1: Subscription Expired Check
    if (state.isSubscriptionExpired) {
      _showSubscriptionExpiredDialog(context);
      return;
    }
    context.push('/add-product');
  }

  void _handleToggleStatus(
    BuildContext context,
    ProductDetailsState state,
    ProductDetailsNotifier notifier,
  ) {
    if (state.isSubscriptionExpired) {
      _showSubscriptionExpiredDialog(context);
      return;
    }
    if (state.product != null) {
      ToggleStatusBottomSheet.show(
        context,
        product: state.product!,
        onConfirm: () async {
          final success = await notifier.toggleProductStatus();
          if (success && context.mounted) {
            final newStatus = state.product?.status == ProductStatus.published ? 'مخفي' : 'منشور';
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('تم تغيير حالة المنتج إلى: $newStatus'),
                backgroundColor: const Color(0xFF16A34A),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
      );
    }
  }

  void _handleCopyProduct(BuildContext context, ProductDetailsNotifier notifier) async {
    final duplicated = await notifier.duplicateProduct();
    if (duplicated != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم نسخ المنتج بنجاح كمسودة جديدة'),
          backgroundColor: Color(0xFF16A34A),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _handleDeleteProduct(
    BuildContext context,
    ProductDetailsState state,
    ProductDetailsNotifier notifier,
  ) {
    // Business Rule 2: Cannot delete if product is linked to active deals
    if (!notifier.canDeleteProduct()) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Color(0xFFEF4444), size: 22),
              SizedBox(width: 8),
              Text('تعذر حذف المنتج', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          content: const Text(
            'هذا المنتج مرتبط بصفقات جارية أو طلبات سابقة، ولا يمكن حذفه للحفاظ على سجلات المعاملات.',
            style: TextStyle(fontSize: 13, height: 1.4),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4F46E5)),
              child: const Text('حسناً'),
            ),
          ],
        ),
      );
      return;
    }

    // Otherwise confirm deletion
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('تأكيد حذف المنتج', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        content: const Text('هل أنت تأكد من رغبتك في حذف هذا المنتج بشكل نهائي؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم حذف المنتج بنجاح')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444)),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  void _showSubscriptionExpiredDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.lock_clock_rounded, color: Color(0xFFEF4444), size: 24),
            SizedBox(width: 8),
            Text('انتهى اشتراكك', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        content: const Text(
          'يرجى تجديد الباقة الحالية لتتمكن من تعديل أو إعادة نشر المنتجات وإدارة التوفر.',
          style: TextStyle(fontSize: 13, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.push('/subscription/management');
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF9333EA)),
            child: const Text('تجديد الباقة'),
          ),
        ],
      ),
    );
  }

  void _handleManageInventory(
    BuildContext context,
    ProductDetailsState state,
    ProductDetailsNotifier notifier,
  ) {
    if (state.product != null) {
      ManageInventoryBottomSheet.show(
        context,
        product: state.product!,
        onStockUpdated: (newStock) => notifier.updateStock(newStock),
      );
    }
  }

  void _handleViewInStore(BuildContext context, ProductModel product) {
    StorePreviewBottomSheet.show(context, product);
  }

  void _handleShare(BuildContext context, ProductModel product) {
    ShareProductBottomSheet.show(context, product);
  }
}
