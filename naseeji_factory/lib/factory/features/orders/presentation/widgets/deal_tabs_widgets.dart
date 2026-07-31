import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../products/presentation/widgets/product_details/documents_widget.dart';
import '../providers/orders_provider.dart';

/// -------------------------------------------------------------------
/// Tab 2: Products Tab
/// -------------------------------------------------------------------
class DealProductsTab extends StatelessWidget {
  final OrderModel order;

  const DealProductsTab({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          borderRadius: AppRadius.rMD,
          border: Border.all(color: isDark ? AppColors.borderDark : Colors.grey.shade200),
        ),
        child: InkWell(
          onTap: () => context.push('/products/prod_1'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: AppRadius.rSM,
                    child: SizedBox(
                      width: 72,
                      height: 72,
                      child: Image.network(
                        order.productImage,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey.shade200),
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
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          order.specifications,
                          style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'سعر الوحدة: ${order.unitPrice.toStringAsFixed(2)} ج.م / ${order.unit}',
                          style: const TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
                ],
              ),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('الكمية المتعاقد عليها:', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                  Text('${order.quantity} ${order.unit}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('إجمالي الصنف:', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                  Text('${order.financialProducts.toStringAsFixed(0)} ج.م',
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primary)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// -------------------------------------------------------------------
/// Tab 3: Financial Tab
/// -------------------------------------------------------------------
class DealFinancialTab extends StatelessWidget {
  final OrderModel order;

  const DealFinancialTab({super.key, required this.order});

  void _openInvoiceModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const PdfViewerModal(
        docTitle: 'فاتورة أولية إلكترونية معتمدة',
        docType: 'فاتورة مبيعات ناصيجي PDF',
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
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : Colors.white,
              borderRadius: AppRadius.rMD,
              border: Border.all(color: isDark ? AppColors.borderDark : Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('الملخص المالي وحساب Escrow', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                _buildFinRow('قيمة المنتجات', '${order.financialProducts.toStringAsFixed(0)} ج.م'),
                _buildFinRow('رسوم الشحن والتوصيل', '${order.financialShipping.toStringAsFixed(0)} ج.م'),
                _buildFinRow('التأمين على الشحنة', '${order.financialInsurance.toStringAsFixed(0)} ج.م'),
                _buildFinRow('ضريبة القيمة المضافة (14%)', '${order.financialTax.toStringAsFixed(0)} ج.م'),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('إجمالي قيمة الصفقة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    Text('${order.finalPrice.toStringAsFixed(0)} ج.م',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: primaryColor)),
                  ],
                ),
                const SizedBox(height: 16),

                // Escrow Status Box
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.08),
                    borderRadius: AppRadius.rSM,
                    border: Border.all(color: AppColors.success.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.security_rounded, color: AppColors.success, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'المبلغ محمي بحساب ناصيجي الضامن (Escrow). سيتم تحويل المستحقات للمورد فور استلام الشحنة وتأكيد جودة الفحص.',
                          style: TextStyle(fontSize: 11, color: isDark ? Colors.grey.shade300 : Colors.grey.shade800),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _openInvoiceModal(context),
                    icon: const Icon(Icons.picture_as_pdf_outlined, size: 18),
                    label: const Text('معاينة وتحميل الفاتورة الضريبية'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: primaryColor,
                      side: BorderSide(color: primaryColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinRow(String label, String val) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
          Text(val, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

/// -------------------------------------------------------------------
/// Tab 4: Shipment Tab
/// -------------------------------------------------------------------
class DealShipmentTab extends StatelessWidget {
  final OrderModel order;

  const DealShipmentTab({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Container(
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
              children: [
                const Icon(Icons.local_shipping_rounded, color: AppColors.primary, size: 24),
                const SizedBox(width: 10),
                const Text('تفاصيل الشحن والتتبع', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            _buildTile('شركة الشحن', order.shippingCompany),
            _buildTile('رقم التتبع', order.trackingNumber),
            _buildTile('حالة الشحنة الحالية', order.currentLocation),
            _buildTile('تاريخ الوصول المتوقع', order.estimatedArrival),
            _buildTile('عنوان تسليم المصنع', order.address),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => context.push('/orders/${order.id}/shipment'),
                icon: const Icon(Icons.map_rounded, size: 18),
                label: const Text('فتح الخريطة التفاعلية لتتبع الشحنة'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTile(String label, String val) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
          Text(val, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

/// -------------------------------------------------------------------
/// Tab 5: Documents Tab
/// -------------------------------------------------------------------
class DealDocumentsTab extends StatelessWidget {
  final OrderModel order;

  const DealDocumentsTab({super.key, required this.order});

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

    final docs = [
      'اتفاقية الصفقة المعتمدة',
      'الفاتورة الأولية الضريبية',
      'قائمة التعبئة والتغليف (Packing List)',
      'شهادة منشأ الشحنة',
      'تقرير فحص الجودة المبدئي',
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: docs.length,
      itemBuilder: (context, index) {
        final d = docs[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : Colors.white,
            borderRadius: AppRadius.rMD,
            border: Border.all(color: isDark ? AppColors.borderDark : Colors.grey.shade200),
          ),
          child: Row(
            children: [
              const Icon(Icons.picture_as_pdf_outlined, color: AppColors.error, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(d, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              ),
              IconButton(
                icon: const Icon(Icons.download_rounded, color: AppColors.primary),
                onPressed: () => _openPdfModal(context, d),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// -------------------------------------------------------------------
/// Tab 6: Activity Tab
/// -------------------------------------------------------------------
class DealActivityTab extends StatelessWidget {
  final OrderModel order;

  const DealActivityTab({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final activities = [
      {'title': 'تم شحن الشحنة برقم TRK123456789EG', 'date': '16 مايو 2024 - 10:30 ص', 'actor': 'شركة الشحن'},
      {'title': 'بدء عمليات الإنتاج والنسيج بمصنع المورد', 'date': '12 مايو 2024 - 09:00 ص', 'actor': 'المورد'},
      {'title': 'تأكيد الاتفاقية واعتماد الشروط الفنية والمالية', 'date': '10 مايو 2024 - 02:15 م', 'actor': 'المصنع والمورد'},
      {'title': 'تقديم طلب عرض السعر رقم #RFQ-2024-0045', 'date': '08 مايو 2024 - 11:00 ص', 'actor': 'المصنع'},
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: activities.length,
      itemBuilder: (context, index) {
        final a = activities[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : Colors.white,
            borderRadius: AppRadius.rMD,
            border: Border.all(color: isDark ? AppColors.borderDark : Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(a['title'] as String, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('المسؤول: ${a['actor']}', style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                  Text(a['date'] as String, style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
