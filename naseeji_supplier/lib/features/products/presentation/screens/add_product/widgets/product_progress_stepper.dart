import 'package:flutter/material.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';

class ProductProgressStepper extends StatelessWidget {
  final int currentStep;

  const ProductProgressStepper({
    super.key,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Stack(
        children: [
          // Vertical Line
          Positioned(
            right: 19,
            top: 20,
            bottom: 20,
            child: Container(
              width: 2,
              color: AppColors.surfaceContainerHighest,
            ),
          ),
          // Steps Column
          Column(
            children: [
              _buildStepRow(1, 'المعلومات الأساسية', 'الاسم، الوصف، الفئة', currentStep == 1),
              const SizedBox(height: 28),
              _buildStepRow(2, 'المواصفات الفنية', 'الوزن، الكثافة، الغرز', currentStep == 2),
              const SizedBox(height: 28),
              _buildStepRow(3, 'التسعير والمخزون', 'الأسعار، الكميات المتاحة', currentStep == 3),
              const SizedBox(height: 28),
              _buildStepRow(4, 'الصور والملفات', 'رفع الوسائط والشهادات', currentStep == 4),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepRow(int number, String title, String subtitle, bool isActive) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: isActive ? AppColors.primary : AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 11,
                  color: isActive ? AppColors.onSurfaceVariant : AppColors.outline,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : AppColors.surfaceContainerHighest,
            shape: BoxShape.circle,
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    )
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            '$number',
            style: TextStyle(
              color: isActive ? Colors.white : AppColors.onSurfaceVariant,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
