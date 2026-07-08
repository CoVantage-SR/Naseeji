import 'package:flutter/material.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../../domain/entities/marketing_models.dart';

class BudgetProgressCard extends StatelessWidget {
  final BudgetManagementData budgetInfo;

  const BudgetProgressCard({
    super.key,
    required this.budgetInfo,
  });

  @override
  Widget build(BuildContext context) {
    final double percent = budgetInfo.monthlyBudget > 0 ? (budgetInfo.spent / budgetInfo.monthlyBudget) : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text(
            'مؤشر الميزانية الشهرية',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.onSurface),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${(percent * 100).toStringAsFixed(1)}%',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: percent > 0.85 ? const Color(0xFFBA1A1A) : const Color(0xFF0040E0),
                ),
              ),
              const Text(
                'الاستهلاك الكلي للميزانية',
                style: TextStyle(fontSize: 10, color: AppColors.onSurfaceVariant),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percent,
              minHeight: 8,
              backgroundColor: AppColors.outlineVariant,
              valueColor: AlwaysStoppedAnimation<Color>(
                percent > 0.85 ? const Color(0xFFBA1A1A) : const Color(0xFF0040E0),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSimpleItem('المتبقي', '${budgetInfo.remaining.toStringAsFixed(0)} ر.س'),
              _buildSimpleItem('المستهلك', '${budgetInfo.spent.toStringAsFixed(0)} ر.س'),
              _buildSimpleItem('الميزانية المحددة', '${budgetInfo.monthlyBudget.toStringAsFixed(0)} ر.س'),
            ],
          ),
          if (budgetInfo.budgetAlerts.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Divider(color: AppColors.outlineVariant),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  budgetInfo.budgetAlerts.first,
                  style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: Color(0xFFBA1A1A)),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(width: 4),
                const Icon(Icons.warning_amber_rounded, color: Color(0xFFBA1A1A), size: 14),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSimpleItem(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 9, color: AppColors.onSurfaceVariant)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
      ],
    );
  }
}
