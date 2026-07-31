import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../providers/quotations_provider.dart';

/// Dedicated B2B Negotiation History & Metrics Card matching SAP Ariba / Oracle Procurement
class QuotationNegotiationCard extends StatelessWidget {
  final Quotation quotation;
  final VoidCallback onNewCounterOffer;

  const QuotationNegotiationCard({
    super.key,
    required this.quotation,
    required this.onNewCounterOffer,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    // Financial difference calculation
    final targetPrice = 35.0; // Expected factory baseline price
    final currentPrice = quotation.quotedPricePerUnit;
    final diff = currentPrice - targetPrice;
    final diffPercent = (diff / targetPrice * 100).toStringAsFixed(1);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: AppRadius.rMD,
        border: Border.all(color: isDark ? AppColors.borderDark : Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(Icons.handshake_outlined, color: Colors.orange, size: 18),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'تفاصيل وسجل التفاوض B2B',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'إصدار v${quotation.revisions.length}',
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Price Comparison Bar (Target vs Current vs Diff)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
              borderRadius: AppRadius.rSM,
              border: Border.all(color: isDark ? AppColors.borderDark : Colors.grey.shade200),
            ),
            child: Row(
              children: [
                // 1. Target Price
                Expanded(
                  child: Column(
                    children: [
                      Text('السعر المستهدف', style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
                      const SizedBox(height: 2),
                      Text(
                        '${targetPrice.toStringAsFixed(2)} ج.م',
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Container(width: 1, height: 32, color: Colors.grey.shade300),

                // 2. Current Offered Price
                Expanded(
                  child: Column(
                    children: [
                      Text('سعر المورد الحالى', style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
                      const SizedBox(height: 2),
                      Text(
                        '${currentPrice.toStringAsFixed(2)} ج.م',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(width: 1, height: 32, color: Colors.grey.shade300),

                // 3. Difference %
                Expanded(
                  child: Column(
                    children: [
                      Text('الفارق', style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
                      const SizedBox(height: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            diff > 0 ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                            size: 14,
                            color: diff > 0 ? AppColors.error : AppColors.success,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '+$diffPercent%',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: diff > 0 ? AppColors.error : AppColors.success,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Revisions & Counter Offer History List
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('سجل الجولات والتعديلات', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              Text(
                '${quotation.revisions.length} جولات تفاوض',
                style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
              ),
            ],
          ),
          const SizedBox(height: 10),

          ...quotation.revisions.asMap().entries.map((entry) {
            final idx = entry.key;
            final rev = entry.value;
            final isLast = idx == quotation.revisions.length - 1;

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isLast
                      ? primaryColor.withValues(alpha: 0.05)
                      : (isDark ? const Color(0xFF1E293B) : const Color(0xFFFAFAFA)),
                  borderRadius: AppRadius.rSM,
                  border: Border.all(
                    color: isLast
                        ? primaryColor.withValues(alpha: 0.3)
                        : (isDark ? AppColors.borderDark : Colors.grey.shade200),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: isLast ? primaryColor : Colors.grey.shade600,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'جولة #${rev.revisionNumber}',
                                style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              rev.user,
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Text(
                          rev.date,
                          style: TextStyle(fontSize: 9, color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'السعر المقترح: ${rev.price.toStringAsFixed(2)} ج.م / وحدة',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: isLast ? primaryColor : Colors.grey.shade800,
                          ),
                        ),
                        Text(
                          'الكمية: ${rev.quantity} وحدة',
                          style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                    if (rev.notes.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        'ملاحظات: "${rev.notes}"',
                        style: TextStyle(fontSize: 10, fontStyle: FontStyle.italic, color: Colors.grey.shade600),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 8),
          // Action Button inside Negotiation Card
          OutlinedButton.icon(
            onPressed: onNewCounterOffer,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.orange.shade900,
              side: BorderSide(color: Colors.orange.shade800),
              minimumSize: const Size(double.infinity, 42),
              shape: RoundedRectangleBorder(borderRadius: AppRadius.rSM),
            ),
            icon: const Icon(Icons.rate_review_outlined, size: 16, color: Colors.orange),
            label: const Text(
              'تقديم عرض سعر مضاد جديد',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.orange),
            ),
          ),
        ],
      ),
    );
  }
}

