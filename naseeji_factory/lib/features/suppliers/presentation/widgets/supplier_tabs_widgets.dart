import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../products/presentation/providers/products_provider.dart';
import '../../../products/presentation/providers/suppliers_provider.dart';
import '../../../products/presentation/widgets/product_details/documents_widget.dart';

/// -------------------------------------------------------------------
/// Tab 2: Products Tab
/// -------------------------------------------------------------------
class SupplierProductsTab extends StatelessWidget {
  final Supplier supplier;
  final List<Product> products;

  const SupplierProductsTab({
    super.key,
    required this.supplier,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (products.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.inventory_2_outlined, size: 48, color: Colors.grey.shade400),
              const SizedBox(height: 12),
              const Text('لا توجد منتجات متاحة حالياً من هذا المورد.'),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final prod = products[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : Colors.white,
            borderRadius: AppRadius.rMD,
            border: Border.all(color: isDark ? AppColors.borderDark : Colors.grey.shade200),
          ),
          child: InkWell(
            onTap: () => context.push('/products/${prod.id}'),
            child: Row(
              children: [
                // Product Image
                ClipRRect(
                  borderRadius: AppRadius.rSM,
                  child: SizedBox(
                    width: 76,
                    height: 76,
                    child: Image.network(
                      prod.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.image_not_supported_outlined, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Product Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        prod.name,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'يبدأ من ${prod.price.toStringAsFixed(2)} ج.م / ${prod.unit}',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.inventory_outlined, size: 12, color: Colors.grey.shade600),
                          const SizedBox(width: 4),
                          Text(
                            'أقل كمية (MOQ): ${prod.moq} ${prod.unit}',
                            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.success.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              'متوفر',
                              style: TextStyle(fontSize: 10, color: AppColors.success, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// -------------------------------------------------------------------
/// Tab 3: Certificates Tab
/// -------------------------------------------------------------------
class SupplierCertificatesTab extends StatelessWidget {
  final Supplier supplier;

  const SupplierCertificatesTab({super.key, required this.supplier});

  void _openPdfModal(BuildContext context, String docTitle) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PdfViewerModal(
        docTitle: docTitle,
        fileSize: '2.4 MB',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: supplier.certificates.length,
      itemBuilder: (context, index) {
        final cert = supplier.certificates[index];
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
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.info.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.workspace_premium_rounded, color: AppColors.info, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cert,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'شهادة جودة وفحص فني معتمدة • PDF 2.4 MB',
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _openPdfModal(context, cert),
                icon: const Icon(Icons.visibility_outlined, size: 14),
                label: const Text('معاينة'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.rSM),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// -------------------------------------------------------------------
/// Tab 4: Reviews Tab
/// -------------------------------------------------------------------
class SupplierReviewsTab extends StatelessWidget {
  final Supplier supplier;

  const SupplierReviewsTab({super.key, required this.supplier});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final reviews = [
      {
        'name': 'مصنع النساجون الحديث',
        'rating': 5,
        'date': 'منذ 3 أيام',
        'comment': 'جودة ممتازة والتزام تام بمواعيد التسليم والتغليف محكم جداً لحماية الأقمشة أثناء الشحن.',
      },
      {
        'name': 'شركة الأمل للملابس الجاهزة',
        'rating': 5,
        'date': 'منذ أسبوعين',
        'comment': 'تعامل راقي جداً من ممثلي المبيعات ونسبة ثبات الألوان في الأقمشة القطنية 100%.',
      },
      {
        'name': 'مصنع القاهرة للنسيج والتطريز',
        'rating': 4,
        'date': 'منذ شهر',
        'comment': 'الخامات ممتازة وشهادات الفحص متطابقة بالكامل مع الاختبارات المعملية.',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        final r = reviews[index];
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
              Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    child: const Icon(Icons.factory_outlined, size: 16, color: AppColors.primary),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      r['name'] as String,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                  Text(
                    r['date'] as String,
                    style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: List.generate(
                  5,
                  (i) => Icon(
                    i < (r['rating'] as int) ? Icons.star_rounded : Icons.star_border_rounded,
                    color: Colors.amber,
                    size: 14,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                r['comment'] as String,
                style: TextStyle(fontSize: 12, height: 1.5, color: isDark ? Colors.grey.shade300 : Colors.grey.shade800),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// -------------------------------------------------------------------
/// Tab 5: Commercial Information Tab
/// -------------------------------------------------------------------
class SupplierCommercialInfoTab extends StatelessWidget {
  final Supplier supplier;

  const SupplierCommercialInfoTab({super.key, required this.supplier});

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
            const Text(
              'الشروط والمعلومات التجارية',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildRow('طرق الدفع المتاحة', supplier.paymentMethods.join('\n• ')),
            const Divider(height: 24),
            _buildRow('متوسط وقت التجهيز والإنتاج', supplier.avgDeliveryDays),
            const Divider(height: 24),
            _buildRow('الحد الأدنى للطلب (MOQ)', '500 متر لكل لون / صنف'),
            const Divider(height: 24),
            _buildRow('الصناعات المدعومة', supplier.supportedIndustries.join('، ')),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
        const SizedBox(height: 4),
        Text(content, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, height: 1.4)),
      ],
    );
  }
}

/// -------------------------------------------------------------------
/// Tab 6: Company Information Tab
/// -------------------------------------------------------------------
class SupplierCompanyInfoTab extends StatelessWidget {
  final Supplier supplier;

  const SupplierCompanyInfoTab({super.key, required this.supplier});

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
            const Text(
              'البيانات الرسمية والقانونية للشركة',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildInfoTile('اسم الشركة المسجل', supplier.name),
            _buildInfoTile('السجل التجاري', supplier.commercialReg),
            _buildInfoTile('الرقم الضريبي', supplier.taxNumber),
            _buildInfoTile('عنوان المصنع الرئيسي', '${supplier.city}، ${supplier.governorate}، جمهورية مصر العربية'),
            _buildInfoTile('الطاقة الإنتاجية اليومية', supplier.productionCapacity),
            _buildInfoTile('عدد الموظفين والمهندسين', supplier.employeesCount),
            _buildInfoTile('دول التصدير والمعارض الدولية', supplier.exportCountries.join('، ')),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(String title, String val) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
          Text(val, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

/// -------------------------------------------------------------------
/// Tab 7: Completed Deals Tab
/// -------------------------------------------------------------------
class SupplierCompletedDealsTab extends StatelessWidget {
  final Supplier supplier;

  const SupplierCompletedDealsTab({super.key, required this.supplier});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final deals = [
      {
        'id': 'DEAL-2024-0891',
        'product': 'قماش قطن 100% أبيض',
        'qty': '5,000 متر',
        'date': '2024/06/15',
        'value': '210,000 ج.م',
        'rating': '5.0 ★★★★★',
      },
      {
        'id': 'DEAL-2024-0412',
        'product': 'قماش جبردين كحلي متين',
        'qty': '2,500 متر',
        'date': '2024/04/10',
        'value': '212,500 ج.م',
        'rating': '4.9 ★★★★★',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: deals.length,
      itemBuilder: (context, index) {
        final d = deals[index];
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    d['id'] as String,
                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text('مكتملة ✅', style: TextStyle(fontSize: 10, color: AppColors.success)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(d['product'] as String, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text('الكمية: ${d['qty']}', style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                  const Spacer(),
                  Text('القيمة الإجمالية: ${d['value']}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
              const Divider(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('تاريخ الاستلام: ${d['date']}', style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
                  Text(d['rating'] as String, style: const TextStyle(fontSize: 11, color: Colors.amber, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
