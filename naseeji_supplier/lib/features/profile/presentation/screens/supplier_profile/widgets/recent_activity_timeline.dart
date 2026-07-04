import 'package:flutter/material.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';

class RecentActivityTimeline extends StatelessWidget {
  const RecentActivityTimeline({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text(
            'النشاط الأخير',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          _buildTimelineItem(
            title: 'توقيع اتفاقية توريد جديدة',
            description: 'مع مصانع الرياض للحلول التقنية - 2000 متر من الألياف الذكية.',
            time: 'منذ ساعتين',
            dotColor: Colors.blue,
            isLast: false,
          ),
          _buildTimelineItem(
            title: 'إضافة منتج جديد',
            description: 'تم تحديث كتالوج "المنسوجات الصيفية 2024" بـ 15 صنف جديد.',
            time: 'أمس',
            dotColor: Colors.green,
            isLast: false,
          ),
          _buildTimelineItem(
            title: 'حضور معرض نسيج الدولي',
            description: 'الحصول على جائزة الابتكار في استدامة المواد الخام.',
            time: '3 أيام مضت',
            dotColor: Colors.red,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem({
    required String title,
    required String description,
    required String time,
    required Color dotColor,
    required bool isLast,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Time & Content Details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.onSurfaceVariant,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                time,
                style: const TextStyle(
                  fontSize: 10,
                  color: AppColors.outline,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),

        const SizedBox(width: 16),

        // Timeline dot & line connector
        Column(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
              ),
            ),
            if (!isLast)
              Container(
                width: 1,
                height: 70, // Line length matching content height
                color: Colors.grey.shade300,
              ),
          ],
        ),
      ],
    );
  }
}
