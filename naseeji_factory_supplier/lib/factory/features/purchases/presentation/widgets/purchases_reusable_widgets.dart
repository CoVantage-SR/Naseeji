import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../providers/purchases_provider.dart';

/// StatusChip - Custom widget for displaying themed badges
class StatusChip extends StatelessWidget {
  final String label;
  final Color color;

  const StatusChip({
    super.key,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.2 : 0.08),
        borderRadius: AppRadius.rRound,
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
      ),
    );
  }
}

/// PurchaseCard - Renders a single purchase record in list view
class PurchaseCard extends StatelessWidget {
  final PurchaseModel purchase;
  final VoidCallback onViewDetails;
  final VoidCallback onReorder;

  const PurchaseCard({
    super.key,
    required this.purchase,
    required this.onViewDetails,
    required this.onReorder,
  });

  @override
  Widget build(BuildContext context) {
    final order = purchase.order;
    final isDark = context.theme.brightness == Brightness.dark;

    Color statusColor = AppColors.success;
    String statusText = 'مكتملة';
    if (purchase.status == 'cancelled') {
      statusColor = AppColors.error;
      statusText = 'ملغاة';
    } else if (purchase.status == 'returned') {
      statusColor = AppColors.secondary;
      statusText = 'مرتجعة';
    } else if (purchase.status == 'replacement') {
      statusColor = AppColors.info;
      statusText = 'استبدال';
    }

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.rMD,
        side: BorderSide(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row 1: Logo & Name & Status
            Row(
              children: [
                ClipOval(
                  child: Image.network(
                    purchase.supplierLogo,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) => Container(
                      width: 40,
                      height: 40,
                      color: AppColors.primary.withValues(alpha: 0.1),
                      child: const Icon(Icons.business_rounded, color: AppColors.primary),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.supplierName,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'طلب رقم: ${order.id}',
                        style: const TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                StatusChip(label: statusText, color: statusColor),
              ],
            ),
            const Divider(height: 24),
            // Row 2: Product Image & Name & Details
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: AppRadius.rSM,
                  child: Image.network(
                    order.productImage,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) => Container(
                      width: 60,
                      height: 60,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.image_not_supported_rounded),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.productName,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'الكمية: ${order.quantity} وحدة | السعر: ${order.finalPrice.toInt()} ج.م',
                        style: const TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today_rounded, size: 10, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            'تاريخ الشراء: ${order.orderDate}',
                            style: const TextStyle(fontSize: 10, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Row 3: Extra Badges & Rating
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.05),
                    borderRadius: AppRadius.rSM,
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.description_rounded, size: 12, color: AppColors.primary),
                      const SizedBox(width: 4),
                      Text(
                        purchase.invoiceNumber,
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (purchase.supplierRating != null)
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                      const SizedBox(width: 2),
                      Text(
                        '${purchase.supplierRating}',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 2),
                      const Text('(تقييمنا)', style: TextStyle(fontSize: 9, color: Colors.grey)),
                    ],
                  )
                else
                  Text(
                    'غير مقيم بعد',
                    style: TextStyle(fontSize: 10, color: Colors.amber.shade800, fontWeight: FontWeight.bold),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            // Row 4: Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onViewDetails,
                    icon: const Icon(Icons.visibility_outlined, size: 16),
                    label: const Text('تفاصيل الشراء', style: TextStyle(fontSize: 11)),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: AppRadius.rSM),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onReorder,
                    icon: const Icon(Icons.repeat_rounded, size: 16),
                    label: const Text('إعادة طلب', style: TextStyle(fontSize: 11)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: AppRadius.rSM),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// InvoiceCard - Renders a single invoice card
class InvoiceCard extends StatelessWidget {
  final InvoiceModel invoice;
  final VoidCallback onView;
  final VoidCallback onDownload;
  final VoidCallback onShare;

  const InvoiceCard({
    super.key,
    required this.invoice,
    required this.onView,
    required this.onDownload,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    Color statusColor = AppColors.success;
    if (invoice.paymentStatus == 'ملغاة') {
      statusColor = AppColors.error;
    } else if (invoice.paymentStatus == 'قيد التحصيل') {
      statusColor = AppColors.warning;
    }

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.rMD,
        side: BorderSide(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      invoice.invoiceNumber,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'أمر الشراء: ${invoice.orderId}',
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ],
                ),
                StatusChip(label: invoice.paymentStatus, color: statusColor),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('المورد:', style: TextStyle(fontSize: 11, color: Colors.grey)),
                Text(invoice.supplierName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('تاريخ الفاتورة:', style: TextStyle(fontSize: 11, color: Colors.grey)),
                Text(invoice.invoiceDate, style: const TextStyle(fontSize: 11)),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('تاريخ الاستحقاق:', style: TextStyle(fontSize: 11, color: Colors.grey)),
                Text(invoice.dueDate, style: const TextStyle(fontSize: 11)),
              ],
            ),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('المبلغ الإجمالي:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                Text(
                  '${invoice.totalAmount.toInt()} ج.م',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.primary),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onView,
                    icon: const Icon(Icons.picture_as_pdf_rounded, size: 14),
                    label: const Text('عرض PDF', style: TextStyle(fontSize: 10)),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: AppRadius.rSM),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onDownload,
                    icon: const Icon(Icons.download_rounded, size: 14),
                    label: const Text('تحميل', style: TextStyle(fontSize: 10)),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: AppRadius.rSM),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onShare,
                    icon: const Icon(Icons.share_rounded, size: 14),
                    label: const Text('مشاركة', style: TextStyle(fontSize: 10)),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: AppRadius.rSM),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// SupplierCard - Favorite Supplier List Item
class SupplierCard extends StatelessWidget {
  final FavoriteSupplierModel supplier;
  final VoidCallback onViewProfile;
  final VoidCallback onSendRFQ;
  final VoidCallback onStartChat;
  final VoidCallback onRemoveFavorite;

  const SupplierCard({
    super.key,
    required this.supplier,
    required this.onViewProfile,
    required this.onSendRFQ,
    required this.onStartChat,
    required this.onRemoveFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.rMD,
        side: BorderSide(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipOval(
                  child: Image.network(
                    supplier.logo,
                    width: 44,
                    height: 44,
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) => Container(
                      width: 44,
                      height: 44,
                      color: AppColors.primary.withValues(alpha: 0.1),
                      child: const Icon(Icons.business_rounded, color: AppColors.primary),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        supplier.name,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        supplier.type,
                        style: const TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.favorite_rounded, color: Colors.red),
                  onPressed: onRemoveFavorite,
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                    const SizedBox(width: 2),
                    Text(
                      '${supplier.rating}',
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Text(
                  '${supplier.completedOrders} طلب مكتمل',
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: AppRadius.rSM,
                  ),
                  child: Text(
                    'مستوى الأسعار: ${supplier.avgPriceLevel}',
                    style: const TextStyle(fontSize: 9, color: AppColors.primary, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'سرعة الاستجابة: ${supplier.avgResponseTime}',
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
                Text(
                  'متوسط التوصيل: ${supplier.avgDeliveryTime}',
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'آخر تعامل: ${supplier.lastOrderDate}',
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onViewProfile,
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: AppRadius.rSM),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    child: const Text('الملف الشخصي', style: TextStyle(fontSize: 10)),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onStartChat,
                    icon: const Icon(Icons.chat_bubble_outline_rounded, size: 12),
                    label: const Text('محادثة', style: TextStyle(fontSize: 10)),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: AppRadius.rSM),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onSendRFQ,
                    icon: const Icon(Icons.request_quote_rounded, size: 12),
                    label: const Text('طلب عرض سعر', style: TextStyle(fontSize: 10)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: AppRadius.rSM),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// FinancialCard - Billing / Invoice Financial Summary Card
class FinancialCard extends StatelessWidget {
  final double subtotal;
  final double discount;
  final double shipping;
  final double taxes;
  final double total;

  const FinancialCard({
    super.key,
    required this.subtotal,
    required this.discount,
    required this.shipping,
    required this.taxes,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.rMD,
        side: BorderSide(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'الخلاصة المالية وتفاصيل السداد',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primary),
            ),
            const SizedBox(height: 12),
            _buildRow('المبلغ الفرعي (البضاعة)', '${subtotal.toInt()} ج.م', false),
            _buildRow('الخصم التجاري المطبق', '- ${discount.toInt()} ج.م', false, color: Colors.green),
            _buildRow('تكلفة الشحن والتأمين', '+ ${shipping.toInt()} ج.م', false),
            _buildRow('الضرائب والرسوم (١٤%)', '+ ${taxes.toInt()} ج.م', false),
            const Divider(height: 20),
            _buildRow('المبلغ الإجمالي الكلي', '${total.toInt()} ج.م', true, color: AppColors.primary),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String val, bool isTotal, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 12 : 11,
              color: isTotal ? null : Colors.grey,
            ),
          ),
          Text(
            val,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: isTotal ? 14 : 11,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

/// DocumentCard - Document list row item
class DocumentCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onView;
  final VoidCallback onDownload;
  final VoidCallback onShare;

  const DocumentCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onView,
    required this.onDownload,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.rSM,
        side: BorderSide(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: AppRadius.rSM,
          ),
          child: const Icon(Icons.picture_as_pdf_rounded, color: AppColors.primary, size: 24),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 10, color: Colors.grey),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.visibility_outlined, size: 18, color: AppColors.primary),
              onPressed: onView,
              tooltip: 'معاينة المستند',
            ),
            IconButton(
              icon: const Icon(Icons.download_rounded, size: 18, color: Colors.grey),
              onPressed: onDownload,
              tooltip: 'تحميل',
            ),
            IconButton(
              icon: const Icon(Icons.share_rounded, size: 16, color: Colors.grey),
              onPressed: onShare,
              tooltip: 'مشاركة',
            ),
          ],
        ),
      ),
    );
  }
}

/// EmptyStateWidget - Layout to show when data is unavailable
class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;

  const EmptyStateWidget({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

