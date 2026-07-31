// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../providers/orders_provider.dart';

/// ERP Progress Stepper Bar displaying all stages + Interactive Shipment Alert Banner
class DealProgressStepper extends StatelessWidget {
  final OrderModel order;
  final VoidCallback? onTrackTap;

  const DealProgressStepper({
    super.key,
    required this.order,
    this.onTrackTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    final steps = [
      {
        'title': 'الاتفاق',
        'date': '10 مايو',
        'icon': Icons.handshake_rounded,
      },
      {
        'title': 'الإنتاج',
        'date': '12 مايو',
        'icon': Icons.precision_manufacturing_rounded,
      },
      {
        'title': 'الشحن',
        'date': '16 مايو',
        'icon': Icons.local_shipping_rounded,
      },
      {
        'title': 'التسليم',
        'date': '-',
        'icon': Icons.inventory_2_outlined,
      },
      {
        'title': 'التفتيش',
        'date': '-',
        'icon': Icons.fact_check_outlined,
      },
      {
        'title': 'الدفع',
        'date': '-',
        'icon': Icons.credit_card_outlined,
      },
    ];

    // Current active step index (0-based)
    final currentIdx = order.currentStepIndex;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: AppRadius.rMD,
        border: Border.all(
          color: isDark ? AppColors.borderDark : Colors.grey.shade200,
        ),
      ),
      child: Column(
        children: [
          // 1. ERP Stepper Row
          LayoutBuilder(
            builder: (context, constraints) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        // Icon Circle + Connecting Line
                        Row(
                          children: [
                            // Left connecting line (in RTL)
                            if (index != 0)
                              Expanded(
                                child: Container(
                                  height: 2.5,
                                  color: index <= currentIdx
                                      ? AppColors.success
                                      : (isDark ? AppColors.borderDark : Colors.grey.shade300),
                                ),
                              ),
                            // Circle Icon Container
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
                            // Right connecting line (in RTL)
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

                        // Title Label
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

                        // Date Subtitle
                        Text(
                          item['date'] as String,
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
              );
            },
          ),
          const SizedBox(height: 16),

          // 2. Interactive Shipment Alert Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.amber.shade500.withValues(alpha: isDark ? 0.15 : 0.1),
              borderRadius: AppRadius.rSM,
              border: Border.all(
                color: Colors.amber.shade600.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                // Warning / Info Icon
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade700.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.info_rounded,
                    color: isDark ? Colors.amber.shade300 : Colors.amber.shade900,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),

                // Shipment Message & Tracking Number Link
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.currentLocation,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.directions_boat_outlined, size: 14, color: AppColors.primary),
                          const SizedBox(width: 4),
                          Text(
                            'رقم الشحنة: ',
                            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                          ),
                          InkWell(
                            onTap: () {
                              Clipboard.setData(ClipboardData(text: order.trackingNumber));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('تم نسخ رقم الشحنة (${order.trackingNumber})')),
                              );
                            },
                            child: Text(
                              order.trackingNumber,
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
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
        ],
      ),
    );
  }
}
