import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_radius.dart';
import '../providers/quotations_provider.dart';

/// Top Summary Card Banner for Quotation Details:
/// Left: QTN Tag & RFQ Number
/// Middle: Status Chip & Submission Time
/// Right: Expiry Date & Remaining Days
class QuotationHeaderCard extends StatelessWidget {
  final Quotation quotation;

  const QuotationHeaderCard({super.key, required this.quotation});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(14),
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
      child: Row(
        children: [
          // Left Column (In RTL): QTN Tag & RFQ Ref
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: quotation.quotationNumber));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('تم نسخ رقم العرض (${quotation.quotationNumber})')),
                    );
                  },
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            quotation.quotationNumber,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(Icons.copy_rounded, size: 12, color: primaryColor),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  quotation.rfqNumber,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.grey.shade300 : Colors.grey.shade800,
                  ),
                ),
                Text(
                  'رقم RFQ',
                  style: TextStyle(fontSize: 9, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),

          // Vertical Divider 1
          Container(
            width: 1,
            height: 70,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            color: isDark ? AppColors.borderDark : Colors.grey.shade200,
          ),

          // Middle Column: Status & Submission Time
          Expanded(
            flex: 5,
            child: Column(
              children: [
                Text('الحالة', style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.circle, color: AppColors.success, size: 7),
                      SizedBox(width: 4),
                      Text(
                        'تم استلام العرض',
                        style: TextStyle(
                          color: AppColors.success,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  quotation.submissionTime,
                  style: TextStyle(fontSize: 9, color: Colors.grey.shade500),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // Vertical Divider 2
          Container(
            width: 1,
            height: 70,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            color: isDark ? AppColors.borderDark : Colors.grey.shade200,
          ),

          // Right Column: Expiry & Remaining Days
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('وينتهي العرض في', style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
                    const SizedBox(width: 4),
                    Icon(Icons.calendar_today_outlined, size: 12, color: Colors.grey.shade500),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  quotation.validUntil,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.end,
                ),
                const SizedBox(height: 4),
                Text(
                  quotation.remainingDays,
                  style: const TextStyle(fontSize: 11, color: AppColors.error, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.end,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
