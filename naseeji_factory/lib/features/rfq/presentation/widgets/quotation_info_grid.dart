import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_radius.dart';
import '../providers/quotations_provider.dart';

/// Offer Details Grid ("تفاصيل العرض") Section matching Reference Image
class QuotationInfoGrid extends StatelessWidget {
  final Quotation quotation;

  const QuotationInfoGrid({super.key, required this.quotation});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

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
            'تفاصيل العرض',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // 2-Column Grid Row 1: Unit Price | Quantity
          Row(
            children: [
              Expanded(
                child: _buildTile(
                  context,
                  isDark: isDark,
                  primaryColor: primaryColor,
                  icon: Icons.attach_money_rounded,
                  label: 'السعر للوحدة',
                  val: '${quotation.quotedPricePerUnit.toStringAsFixed(2)} ↟ ج.م / متر',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTile(
                  context,
                  isDark: isDark,
                  primaryColor: primaryColor,
                  icon: Icons.grid_view_rounded,
                  label: 'الكمية',
                  val: '${quotation.requestedQuantity.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} متر',
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // 2-Column Grid Row 2: Total Price | MOQ
          Row(
            children: [
              Expanded(
                child: _buildTile(
                  context,
                  isDark: isDark,
                  primaryColor: primaryColor,
                  icon: Icons.calculate_outlined,
                  label: 'إجمالي السعر',
                  val: '${quotation.totalPrice.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} ج.م',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTile(
                  context,
                  isDark: isDark,
                  primaryColor: primaryColor,
                  icon: Icons.inventory_2_outlined,
                  label: 'الحد الأدنى للطلب (MOQ)',
                  val: '${quotation.moq} متر',
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // 2-Column Grid Row 3: Production Time | Offer Expiry
          Row(
            children: [
              Expanded(
                child: _buildTile(
                  context,
                  isDark: isDark,
                  primaryColor: primaryColor,
                  icon: Icons.show_chart_rounded,
                  label: 'مدة الإنتاج',
                  val: '${quotation.prepTimeDays} أيام',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTile(
                  context,
                  isDark: isDark,
                  primaryColor: primaryColor,
                  icon: Icons.event_busy_outlined,
                  label: 'صلاحية العرض',
                  val: quotation.validUntil,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // 2-Column Grid Row 4: Delivery Terms | Payment Method
          Row(
            children: [
              Expanded(
                child: _buildTile(
                  context,
                  isDark: isDark,
                  primaryColor: primaryColor,
                  icon: Icons.access_time_rounded,
                  label: 'مدة التسليم',
                  val: quotation.paymentMethod,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTile(
                  context,
                  isDark: isDark,
                  primaryColor: primaryColor,
                  icon: Icons.movie_outlined,
                  label: 'طريقة الدفع',
                  val: quotation.paymentMethod,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // 2-Column Grid Row 5: Country of Origin | Currency
          Row(
            children: [
              Expanded(
                child: _buildTile(
                  context,
                  isDark: isDark,
                  primaryColor: primaryColor,
                  iconWidget: const Text('🇪🇬', style: TextStyle(fontSize: 18)),
                  label: 'بلد المنشأ',
                  val: 'مصر',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTile(
                  context,
                  isDark: isDark,
                  primaryColor: primaryColor,
                  icon: Icons.attach_money_rounded,
                  label: 'العملة',
                  val: quotation.currency,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTile(
    BuildContext context, {
    required bool isDark,
    required Color primaryColor,
    IconData? icon,
    Widget? iconWidget,
    required String label,
    required String val,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: primaryColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: iconWidget ?? Icon(icon, size: 18, color: primaryColor),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                val,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
