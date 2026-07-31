import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../products/presentation/widgets/product_details/documents_widget.dart';
import '../providers/orders_provider.dart';

/// Tab 1: Deal Overview Tab ("ملخص الصفقة")
class DealOverviewTab extends StatelessWidget {
  final OrderModel order;
  final VoidCallback? onTabSwitch;

  const DealOverviewTab({
    super.key,
    required this.order,
    this.onTabSwitch,
  });

  void _openPdfModal(BuildContext context, String docTitle) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PdfViewerModal(
        docTitle: docTitle,
        docType: 'مستند صفقة معتمد PDF',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          // 1. Row 1: Product Details Card & Financial Price Breakdown Card
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Details Card (Right in RTL layout)
              Expanded(
                flex: 6,
                child: _buildProductDetailsCard(context, isDark: isDark, primaryColor: primaryColor),
              ),
              const SizedBox(width: 12),

              // Price Breakdown Card (Left in RTL layout)
              Expanded(
                flex: 5,
                child: _buildPriceBreakdownCard(context, isDark: isDark, primaryColor: primaryColor),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 2. Timeline Card ("الجدول الزمني للصفقة")
          _buildTimelineCard(context, isDark: isDark, primaryColor: primaryColor),
          const SizedBox(height: 16),

          // 3. Row 3: Documents Card & Notes Card
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Documents Card (Right in RTL layout)
              Expanded(
                child: _buildDocumentsCard(context, isDark: isDark, primaryColor: primaryColor),
              ),
              const SizedBox(width: 12),

              // Notes Card (Left in RTL layout)
              Expanded(
                child: _buildNotesCard(context, isDark: isDark, primaryColor: primaryColor),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 1. Product Details Card
  Widget _buildProductDetailsCard(BuildContext context, {required bool isDark, required Color primaryColor}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: AppRadius.rMD,
        border: Border.all(color: isDark ? AppColors.borderDark : Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'تفاصيل المنتجات',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: () => context.push('/products/prod_1'),
            child: Row(
              children: [
                // Product Thumbnail
                ClipRRect(
                  borderRadius: AppRadius.rSM,
                  child: SizedBox(
                    width: 64,
                    height: 64,
                    child: Image.network(
                      order.productImage,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.image_not_supported_outlined, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Product Name & Spec
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.productName,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        order.specifications,
                        style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Divider(color: isDark ? AppColors.borderDark : Colors.grey.shade200),
          const SizedBox(height: 8),

          // Price & Qty Metrics Grid
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMetricItem('سعر الوحدة', '${order.unitPrice.toStringAsFixed(2)} ج.م'),
              _buildMetricItem('الوحدة', order.unit),
              _buildMetricItem('الكمية', '${order.quantity} ${order.unit}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem(String label, String val) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
        const SizedBox(height: 2),
        Text(val, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
      ],
    );
  }

  // Price Breakdown Card
  Widget _buildPriceBreakdownCard(BuildContext context, {required bool isDark, required Color primaryColor}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: AppRadius.rMD,
        border: Border.all(color: isDark ? AppColors.borderDark : Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'تفاصيل السعر',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildPriceRow('قيمة المنتجات', '${order.financialProducts.toStringAsFixed(0)} ج.م'),
          _buildPriceRow('الشحن', '${order.financialShipping.toStringAsFixed(0)} ج.م'),
          _buildPriceRow('التأمين', '${order.financialInsurance.toStringAsFixed(0)} ج.م'),
          _buildPriceRow('الضريبة (14%)', '${order.financialTax.toStringAsFixed(0)} ج.م'),
          Divider(color: isDark ? AppColors.borderDark : Colors.grey.shade200, height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'الإجمالي',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              Text(
                '${order.finalPrice.toStringAsFixed(0)} ج.م',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String val) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
          Text(val, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  // 2. Timeline Card
  Widget _buildTimelineCard(BuildContext context, {required bool isDark, required Color primaryColor}) {
    final timelineEvents = [
      {
        'title': 'تم شحن الطلب',
        'desc': 'تم شحن الطلب بواسطة شركة الشحن الوطنية',
        'icon': Icons.local_shipping_rounded,
        'color': primaryColor,
      },
      {
        'title': 'بدء الإنتاج',
        'desc': 'تم بدء الإنتاج في مصنع المورد',
        'icon': Icons.precision_manufacturing_rounded,
        'color': AppColors.success,
      },
      {
        'title': 'تم الاتفاق على الصفقة',
        'desc': 'تم الموافقة على العرض وإعادة إنشاء الصفقة',
        'icon': Icons.handshake_rounded,
        'color': AppColors.success,
      },
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: AppRadius.rMD,
        border: Border.all(color: isDark ? AppColors.borderDark : Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'الجدول الزمني للصفقة',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              InkWell(
                onTap: onTabSwitch,
                child: Text('عرض الكل', style: TextStyle(fontSize: 11, color: primaryColor, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...timelineEvents.map((e) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: (e['color'] as Color).withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(e['icon'] as IconData, size: 18, color: e['color'] as Color),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(e['title'] as String, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 2),
                        Text(e['desc'] as String, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // 3. Documents Card
  Widget _buildDocumentsCard(BuildContext context, {required bool isDark, required Color primaryColor}) {
    final docs = ['اتفاقية الصفقة', 'فاتورة أولية', 'قائمة التعبئة'];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: AppRadius.rMD,
        border: Border.all(color: isDark ? AppColors.borderDark : Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('المستندات', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              InkWell(
                onTap: onTabSwitch,
                child: Text('عرض الكل', style: TextStyle(fontSize: 10, color: primaryColor, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...docs.map((d) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(d, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
                  ),
                  IconButton(
                    icon: const Icon(Icons.file_download_outlined, size: 18, color: AppColors.primary),
                    onPressed: () => _openPdfModal(context, d),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // 4. Notes Card
  Widget _buildNotesCard(BuildContext context, {required bool isDark, required Color primaryColor}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: AppRadius.rMD,
        border: Border.all(color: isDark ? AppColors.borderDark : Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('الملاحظات', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              const Icon(Icons.sticky_note_2_outlined, size: 16, color: AppColors.primary),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDark ? AppColors.backgroundDark : Colors.grey.shade50,
              borderRadius: AppRadius.rSM,
              border: Border.all(color: isDark ? AppColors.borderDark : Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ملاحظة من المصنع',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'يرجى التأكيد على جودة التغليف ومطابقة درجة اللون.',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 6),
                Text(
                  '16 مايو 2024 - 10:45 ص',
                  style: TextStyle(fontSize: 9, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


