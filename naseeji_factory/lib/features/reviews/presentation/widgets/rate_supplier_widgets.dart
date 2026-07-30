import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../providers/reviews_provider.dart';
import 'reviews_reusable_widgets.dart';

// ─── Rate Supplier Header Widget ──────────────────────────────────────────
class RateSupplierHeaderWidget extends StatelessWidget {
  final String orderId;
  const RateSupplierHeaderWidget({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.amber.withValues(alpha: 0.1),
            Colors.amber.withValues(alpha: 0.03),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppRadius.rMD,
        border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.star_rounded, color: Colors.amber, size: 36),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'تقييم تجربتك مع المورد',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  'طلب رقم: $orderId | تقييمك يساعد المصانع الأخرى',
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Supplier Summary Widget ───────────────────────────────────────────────
class SupplierSummaryWidget extends StatelessWidget {
  final String supplierName;
  final String productName;
  final String orderDate;
  const SupplierSummaryWidget({
    super.key,
    required this.supplierName,
    required this.productName,
    required this.orderDate,
  });

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
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: AppRadius.rSM,
              ),
              child: const Icon(Icons.business_rounded, color: AppColors.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(supplierName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(height: 2),
                  Text(productName, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                  Text(orderDate, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Overall Rating Widget ─────────────────────────────────────────────────
class OverallRatingWidget extends StatelessWidget {
  final double rating;
  const OverallRatingWidget({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            rating > 0 ? rating.toStringAsFixed(1) : '--',
            style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: AppColors.primary),
          ),
          StarsWidget(rating: rating, size: 28),
          const SizedBox(height: 4),
          Text(
            rating == 0
                ? 'قيّم المورد بالنقر على النجوم أدناه'
                : _getRatingLabel(rating),
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  String _getRatingLabel(double r) {
    if (r >= 4.5) return 'ممتاز جداً';
    if (r >= 4.0) return 'جيد جداً';
    if (r >= 3.0) return 'جيد';
    if (r >= 2.0) return 'مقبول';
    return 'ضعيف';
  }
}

// ─── Category Ratings Widget ───────────────────────────────────────────────
class CategoryRatingsWidget extends StatelessWidget {
  final Map<String, double> ratings;
  final bool readOnly;
  final Function(String, double)? onRatingChanged;
  const CategoryRatingsWidget({
    super.key,
    required this.ratings,
    this.readOnly = false,
    this.onRatingChanged,
  });

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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'تقييم تفصيلي حسب المعاير',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary),
            ),
            const SizedBox(height: 12),
            ...kRatingCategories.map((cat) => CategoryRatingWidget(
                  label: cat,
                  rating: ratings[cat] ?? 0,
                  readOnly: readOnly,
                  onRatingChanged: onRatingChanged == null ? null : (val) => onRatingChanged!(cat, val),
                )),
          ],
        ),
      ),
    );
  }
}

// ─── Rate Supplier Submit Widget ───────────────────────────────────────────
class RateSubmitWidget extends StatelessWidget {
  final VoidCallback onSubmit;
  final VoidCallback onCancel;
  final bool isEnabled;
  const RateSubmitWidget({
    super.key,
    required this.onSubmit,
    required this.onCancel,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: isEnabled ? onSubmit : null,
            icon: const Icon(Icons.send_rounded, size: 18),
            label: const Text('متابعة وكتابة التقييم التفصيلي', style: TextStyle(fontSize: 13)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.grey.shade300,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: AppRadius.rMD),
              elevation: 0,
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: onCancel,
            child: const Text('إلغاء', style: TextStyle(color: Colors.grey)),
          ),
        ),
      ],
    );
  }
}
