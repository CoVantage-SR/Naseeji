import 'package:flutter/material.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';

class ProductHorizontalStepper extends StatelessWidget {
  final int currentStep;

  const ProductHorizontalStepper({
    super.key,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(Icons.looks_one, color: currentStep >= 1 ? AppColors.primary : AppColors.outlineVariant),
          const Icon(Icons.arrow_back_ios, size: 12, color: AppColors.outlineVariant),
          Icon(Icons.looks_two, color: currentStep >= 2 ? AppColors.primary : AppColors.outlineVariant),
          const Icon(Icons.arrow_back_ios, size: 12, color: AppColors.outlineVariant),
          Icon(Icons.looks_3, color: currentStep >= 3 ? AppColors.primary : AppColors.outlineVariant),
          const Icon(Icons.arrow_back_ios, size: 12, color: AppColors.outlineVariant),
          Icon(Icons.looks_4, color: currentStep >= 4 ? AppColors.primary : AppColors.outlineVariant),
        ],
      ),
    );
  }
}
