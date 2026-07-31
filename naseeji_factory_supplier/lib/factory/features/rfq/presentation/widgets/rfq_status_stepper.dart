import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../providers/rfq_provider.dart';

/// 5-Step Status Lifecycle Stepper for RFQs:
/// 1. مفتوح (10 مايو)
/// 2. العروض (3)
/// 3. التفاوض (-)
/// 4. الموافقة (-)
/// 5. تم الإغلاق (-)
class RFQStatusStepper extends StatelessWidget {
  final RFQ rfq;

  const RFQStatusStepper({super.key, required this.rfq});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    final steps = [
      {
        'title': 'مفتوح',
        'subtitle': '10 مايو',
        'icon': Icons.article_rounded,
      },
      {
        'title': 'العروض',
        'subtitle': '${rfq.receivedQuotesCount}',
        'icon': Icons.sell_outlined,
      },
      {
        'title': 'التفاوض',
        'subtitle': '-',
        'icon': Icons.chat_bubble_outline_rounded,
      },
      {
        'title': 'الموافقة',
        'subtitle': '-',
        'icon': Icons.check_circle_outline_rounded,
      },
      {
        'title': 'تم الإغلاق',
        'subtitle': '-',
        'icon': Icons.lock_outline_rounded,
      },
    ];

    final currentIdx = rfq.currentStepIndex;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: AppRadius.rMD,
        border: Border.all(
          color: isDark ? AppColors.borderDark : Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: List.generate(steps.length, (index) {
          final item = steps[index];
          final isCompleted = index < currentIdx;
          final isActive = index == currentIdx;

          final color = isCompleted
              ? AppColors.success
              : isActive
                  ? primaryColor
                  : (isDark ? Colors.grey.shade600 : Colors.grey.shade400);

          final iconColor = isCompleted || isActive ? Colors.white : color;

          return Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    if (index != 0)
                      Expanded(
                        child: Container(
                          height: 2.5,
                          color: index <= currentIdx
                              ? AppColors.success
                              : (isDark ? AppColors.borderDark : Colors.grey.shade300),
                        ),
                      ),
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? AppColors.success
                            : isActive
                                ? primaryColor
                                : (isDark ? AppColors.backgroundDark : Colors.grey.shade100),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: color,
                          width: isActive ? 2.5 : 1,
                        ),
                        boxShadow: isActive
                            ? [
                                BoxShadow(
                                  color: primaryColor.withValues(alpha: 0.3),
                                  blurRadius: 6,
                                  spreadRadius: 1,
                                )
                              ]
                            : null,
                      ),
                      child: Icon(
                        item['icon'] as IconData,
                        color: iconColor,
                        size: 18,
                      ),
                    ),
                    if (index != steps.length - 1)
                      Expanded(
                        child: Container(
                          height: 2.5,
                          color: index < currentIdx
                              ? AppColors.success
                              : (isDark ? AppColors.borderDark : Colors.grey.shade300),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  item['title'] as String,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: isActive || isCompleted ? FontWeight.bold : FontWeight.normal,
                    color: isActive
                        ? primaryColor
                        : isCompleted
                            ? AppColors.success
                            : (isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 2),
                Text(
                  item['subtitle'] as String,
                  style: TextStyle(
                    fontSize: 10,
                    color: isDark ? Colors.grey.shade500 : Colors.grey.shade500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}


