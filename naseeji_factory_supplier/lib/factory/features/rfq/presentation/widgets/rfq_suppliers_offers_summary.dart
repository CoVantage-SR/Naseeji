import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../providers/rfq_provider.dart';

/// Suppliers & Offers Summary Bar (4 Metric Cards + Latest Offers List)
class RFQSuppliersOffersSummary extends StatelessWidget {
  final RFQ rfq;

  const RFQSuppliersOffersSummary({super.key, required this.rfq});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header: الموردين والعروض + عرض الكل
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'الموردين والعروض',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            InkWell(
              onTap: () => context.push('/rfq/${rfq.id}/quotations'),
              child: Text(
                'عرض الكل',
                style: TextStyle(fontSize: 12, color: primaryColor, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // 4 Metric Cards Bar
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                context,
                isDark: isDark,
                icon: Icons.groups_outlined,
                iconColor: primaryColor,
                bgColor: primaryColor.withValues(alpha: 0.1),
                val: '${rfq.invitedSuppliersCount}',
                label: 'إجمالي الموردين',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildMetricCard(
                context,
                isDark: isDark,
                icon: Icons.person_add_alt_1_outlined,
                iconColor: AppColors.success,
                bgColor: AppColors.success.withValues(alpha: 0.1),
                val: '${rfq.receivedQuotesCount}',
                label: 'عروض مستلمة',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildMetricCard(
                context,
                isDark: isDark,
                icon: Icons.forum_outlined,
                iconColor: Colors.amber.shade800,
                bgColor: Colors.amber.withValues(alpha: 0.15),
                val: '${rfq.negotiatingCount}',
                label: 'قيد التفاوض',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildMetricCard(
                context,
                isDark: isDark,
                icon: Icons.assignment_outlined,
                iconColor: Colors.grey.shade600,
                bgColor: Colors.grey.shade200,
                val: '${rfq.unrespondedCount}',
                label: 'لم يرد',
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Sub-Header: أحدث العروض المستلمة
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
              const Text(
                'أحدث العروض المستلمة',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ...rfq.offers.map((offer) => _buildOfferCardItem(context, offer: offer, isDark: isDark, primaryColor: primaryColor)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard(
    BuildContext context, {
    required bool isDark,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String val,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: AppRadius.rSM,
        border: Border.all(color: isDark ? AppColors.borderDark : Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
                child: Icon(icon, size: 14, color: iconColor),
              ),
              const SizedBox(width: 6),
              Text(val, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 9, color: Colors.grey.shade600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildOfferCardItem(
    BuildContext context, {
    required RFQOffer offer,
    required bool isDark,
    required Color primaryColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDark : Colors.grey.shade50,
        borderRadius: AppRadius.rSM,
        border: Border.all(color: isDark ? AppColors.borderDark : Colors.grey.shade200),
      ),
      child: InkWell(
        onTap: () => context.push('/rfq/quotation/${offer.id}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row 1: Logo, Supplier Name, Best Offer Badge, Left Arrow
            Row(
              children: [
                ClipOval(
                  child: SizedBox(
                    width: 32,
                    height: 32,
                    child: Image.network(
                      offer.supplierLogo,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(Icons.factory_rounded, size: 18, color: primaryColor),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              offer.supplierName,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (offer.isVerified) ...[
                            const SizedBox(width: 4),
                            const Icon(Icons.verified_rounded, color: AppColors.success, size: 14),
                          ],
                        ],
                      ),
                      Text(
                        offer.receivedDate,
                        style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                ),
                if (offer.isBestOffer)
                  Container(
                    margin: const EdgeInsets.only(left: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'أفضل عرض',
                      style: TextStyle(color: AppColors.success, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                const Icon(Icons.arrow_back_ios_rounded, size: 14, color: Colors.grey),
              ],
            ),
            const SizedBox(height: 10),
            Divider(color: isDark ? AppColors.borderDark : Colors.grey.shade200, height: 1),
            const SizedBox(height: 8),

            // Row 2: Price | Delivery Days | Payment Terms
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('السعر الإجمالي', style: TextStyle(fontSize: 9, color: Colors.grey.shade600)),
                    Text(
                      '${offer.totalPrice.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} ج.م',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('مدة التسليم', style: TextStyle(fontSize: 9, color: Colors.grey.shade600)),
                    Text(
                      offer.deliveryDays,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('طريقة الدفع', style: TextStyle(fontSize: 9, color: Colors.grey.shade600)),
                    Text(
                      offer.paymentTerms,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

