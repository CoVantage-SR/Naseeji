import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../orders/presentation/providers/orders_provider.dart';
import '../providers/purchases_provider.dart';
import 'purchases_reusable_widgets.dart';

// ─── Purchase Header Widget ────────────────────────────────────────────────
class PurchaseHeaderWidget extends StatelessWidget {
  final PurchaseModel purchase;
  const PurchaseHeaderWidget({super.key, required this.purchase});

  @override
  Widget build(BuildContext context) {
    final order = purchase.order;
    String statusText = 'مكتملة';
    Color statusColor = AppColors.success;
    if (purchase.status == 'cancelled') {
      statusText = 'ملغاة';
      statusColor = AppColors.error;
    } else if (purchase.status == 'returned') {
      statusText = 'مرتجعة';
      statusColor = AppColors.secondary;
    } else if (purchase.status == 'replacement') {
      statusText = 'استبدال';
      statusColor = AppColors.info;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.08),
            AppColors.primary.withValues(alpha: 0.02),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppRadius.rMD,
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                order.id,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primary),
              ),
              StatusChip(label: statusText, color: statusColor),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.description_rounded, size: 14, color: Colors.grey),
              const SizedBox(width: 6),
              Text('فاتورة: ${purchase.invoiceNumber}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.calendar_today_rounded, size: 12, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text('تاريخ الشراء: ${order.orderDate}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.local_shipping_rounded, size: 12, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text('التوصيل: ${order.expectedDeliveryDate}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Supplier Information Widget ───────────────────────────────────────────
class SupplierInformationWidget extends StatelessWidget {
  final PurchaseModel purchase;
  const SupplierInformationWidget({super.key, required this.purchase});

  @override
  Widget build(BuildContext context) {
    final order = purchase.order;
    final isDark = context.theme.brightness == Brightness.dark;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.rMD,
        side: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'معلومات المورد',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                ClipOval(
                  child: Image.network(
                    purchase.supplierLogo,
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) => Container(
                      width: 48,
                      height: 48,
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
                      Text(order.supplierName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      if (purchase.supplierRating != null)
                        Row(
                          children: [
                            const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                            const SizedBox(width: 2),
                            Text('${purchase.supplierRating}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          ],
                        ),
                    ],
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.chat_bubble_outline_rounded, size: 14),
                  label: const Text('محادثة', style: TextStyle(fontSize: 10)),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: AppRadius.rSM),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  ),
                ),
              ],
            ),
            const Divider(height: 20),
            _infoRow('شركة الشحن', order.shippingCompany),
            _infoRow('رقم التتبع', order.trackingNumber),
            _infoRow('وسيلة الدفع', order.paymentMethod),
            _infoRow('عنوان التوصيل', order.address),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Purchased Products Widget ─────────────────────────────────────────────
class PurchasedProductsWidget extends StatelessWidget {
  final OrderModel order;
  const PurchasedProductsWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.rMD,
        side: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'المنتجات المشتراة',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary),
            ),
            const SizedBox(height: 12),
            Row(
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
                      Text(order.productName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      const SizedBox(height: 4),
                      _specRow('الكمية', '${order.quantity} وحدة'),
                      _specRow('سعر الوحدة', '${(order.finalPrice / order.quantity).toStringAsFixed(1)} ج.م'),
                      _specRow('الإجمالي', '${order.finalPrice.toInt()} ج.م'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _specRow(String label, String val) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Row(
        children: [
          Text('$label: ', style: const TextStyle(fontSize: 10, color: Colors.grey)),
          Text(val, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

// ─── Shipment Information Widget ───────────────────────────────────────────
class ShipmentInformationWidget extends StatelessWidget {
  final OrderModel order;
  const ShipmentInformationWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.rMD,
        side: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'معلومات الشحن',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary),
            ),
            const SizedBox(height: 12),
            _infoTile(Icons.local_shipping_rounded, 'شركة الشحن', order.shippingCompany),
            _infoTile(Icons.qr_code_rounded, 'رقم التتبع', order.trackingNumber),
            _infoTile(Icons.location_on_rounded, 'آخر موقع', order.currentLocation),
            _infoTile(Icons.info_outline_rounded, 'حالة الشحن', order.carrierStatus),
            _infoTile(Icons.event_rounded, 'الوصول المتوقع', order.estimatedArrival),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                Flexible(
                  child: Text(
                    value,
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Documents Widget ──────────────────────────────────────────────────────
class DocumentsWidget extends StatelessWidget {
  const DocumentsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final docs = [
      ('الفاتورة الرسمية', 'Invoice_2026.pdf'),
      ('عقد التوريد المبرم', 'Contract_2026.pdf'),
      ('مستندات الشحن', 'Shipping_Docs.pdf'),
      ('تقرير مراقبة الجودة', 'Quality_Report.pdf'),
    ];
    final isDark = context.theme.brightness == Brightness.dark;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.rMD,
        side: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'المستندات والوثائق',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary),
            ),
            const SizedBox(height: 12),
            ...docs.map((d) => DocumentCard(
                  title: d.$1,
                  subtitle: d.$2,
                  onView: () {},
                  onDownload: () {},
                  onShare: () {},
                )),
          ],
        ),
      ),
    );
  }
}

// ─── Quick Actions Widget ──────────────────────────────────────────────────
class QuickActionsWidget extends StatelessWidget {
  final String orderId;
  final VoidCallback onReorder;
  final VoidCallback onRateSupplier;
  final VoidCallback onDownloadInvoice;
  final VoidCallback onOpenChat;
  const QuickActionsWidget({
    super.key,
    required this.orderId,
    required this.onReorder,
    required this.onRateSupplier,
    required this.onDownloadInvoice,
    required this.onOpenChat,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'إجراءات سريعة',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primary),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _actionBtn(Icons.repeat_rounded, 'إعادة طلب', AppColors.primary, onReorder),
            _actionBtn(Icons.chat_bubble_outline_rounded, 'فتح محادثة', AppColors.info, onOpenChat),
            _actionBtn(Icons.star_outline_rounded, 'تقييم المورد', Colors.amber, onRateSupplier),
            _actionBtn(Icons.download_rounded, 'تحميل الفاتورة', AppColors.success, onDownloadInvoice),
          ],
        ),
      ],
    );
  }

  Widget _actionBtn(IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: AppRadius.rSM,
          border: Border.all(color: color.withValues(alpha: 0.25)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 6),
            Text(label, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

