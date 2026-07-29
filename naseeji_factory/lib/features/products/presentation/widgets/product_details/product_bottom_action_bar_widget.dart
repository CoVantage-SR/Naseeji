import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_radius.dart';

/// Sticky bottom bar matching reference design:
/// - [...] More options button
/// - [إرسال RFQ] Outlined button with icon
/// - [طلب عرض سعر] Primary blue button with paper plane icon
class ProductBottomActionBarWidget extends StatelessWidget {
  final VoidCallback onSendRfq;
  final VoidCallback onRequestQuote;
  final VoidCallback onMoreOptions;

  const ProductBottomActionBarWidget({
    super.key,
    required this.onSendRfq,
    required this.onRequestQuote,
    required this.onMoreOptions,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.borderDark : Colors.grey.shade200,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // More options button (...)
            InkWell(
              onTap: onMoreOptions,
              borderRadius: AppRadius.rSM,
              child: Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.backgroundDark : Colors.grey.shade100,
                  borderRadius: AppRadius.rSM,
                  border: Border.all(
                    color: isDark ? AppColors.borderDark : Colors.grey.shade300,
                  ),
                ),
                child: const Icon(
                  Icons.more_horiz_rounded,
                  color: Colors.grey,
                  size: 22,
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Outlined button: إرسال RFQ
            Expanded(
              flex: 5,
              child: SizedBox(
                height: 46,
                child: OutlinedButton.icon(
                  onPressed: onSendRfq,
                  icon: Icon(
                    Icons.chat_bubble_outline_rounded,
                    size: 18,
                    color: primaryColor,
                  ),
                  label: Text(
                    'إرسال RFQ',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.rSM,
                    ),
                    padding: EdgeInsets.zero,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Primary Button: طلب عرض سعر
            Expanded(
              flex: 6,
              child: SizedBox(
                height: 46,
                child: ElevatedButton.icon(
                  onPressed: onRequestQuote,
                  icon: const Icon(
                    Icons.near_me_rounded,
                    size: 18,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'طلب عرض سعر',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.rSM,
                    ),
                    padding: EdgeInsets.zero,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
