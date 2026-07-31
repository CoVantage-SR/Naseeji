import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../providers/quotations_provider.dart';

/// Timeline Log ("سجل الأحداث") Section matching Reference Image
class QuotationTimelineLog extends StatelessWidget {
  final Quotation quotation;

  const QuotationTimelineLog({super.key, required this.quotation});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    final steps = [
      {
        'title': 'تم إنشاء RFQ',
        'date': '10 مايو 2024',
        'time': '10:30 ص',
        'icon': Icons.post_add_rounded,
        'status': 'completed',
      },
      {
        'title': 'تمت دعوتك',
        'date': '10 مايو 2024',
        'time': '02:15 م',
        'icon': Icons.person_add_alt_1_outlined,
        'status': 'completed',
      },
      {
        'title': 'تم إرسال العرض',
        'date': '12 مايو 2024',
        'time': '09:15 ص',
        'icon': Icons.send_rounded,
        'status': 'active',
      },
      {
        'title': 'تمت المراجعة',
        'date': '12 مايو 2024',
        'time': '10:45 ص',
        'icon': Icons.remove_red_eye_outlined,
        'status': 'pending',
      },
      {
        'title': 'تفاوض',
        'date': '-',
        'time': '',
        'icon': Icons.chat_bubble_outline_rounded,
        'status': 'pending',
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
          const Text(
            'سجل الأحداث',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: List.generate(steps.length, (index) {
              final item = steps[index];
              final isCompleted = item['status'] == 'completed';
              final isActive = item['status'] == 'active';

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
                              color: index <= 2
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
                            border: Border.all(color: color, width: isActive ? 2.5 : 1),
                          ),
                          child: Icon(item['icon'] as IconData, color: iconColor, size: 18),
                        ),
                        if (index != steps.length - 1)
                          Expanded(
                            child: Container(
                              height: 2.5,
                              color: index < 2
                                  ? AppColors.success
                                  : (isDark ? AppColors.borderDark : Colors.grey.shade300),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item['title'] as String,
                      style: TextStyle(
                        fontSize: 10,
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
                      item['date'] as String,
                      style: TextStyle(fontSize: 9, color: Colors.grey.shade500),
                      textAlign: TextAlign.center,
                    ),
                    if ((item['time'] as String).isNotEmpty)
                      Text(
                        item['time'] as String,
                        style: TextStyle(fontSize: 8, color: Colors.grey.shade500),
                        textAlign: TextAlign.center,
                      ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}



