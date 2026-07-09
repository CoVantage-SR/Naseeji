import 'package:flutter/material.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';

class NegotiationSummarySheet extends StatelessWidget {
  final double originalPrice;
  final double finalPrice;
  final String status;

  const NegotiationSummarySheet({
    super.key,
    required this.originalPrice,
    required this.finalPrice,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final diff = originalPrice - finalPrice;
    final diffPercent = originalPrice > 0 ? (diff / originalPrice) * 100 : 0.0;
    final savingsAmount = diff * 5000; // Mock 5,000 meters quantity

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Center(
            child: Container(
              width: 48,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE2E1EF),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          SizedBox(height: 16),
          Center(
            child: Text(
              'ملخص المفاوضات المالية',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          SizedBox(height: 24),

          // Compare prices
          _buildItemRow('العرض المبدئي للمورد', '${originalPrice.toStringAsFixed(2)} جنيه / متر'),
          SizedBox(height: 12),
          _buildItemRow('عرض التفاوض الأول للمصنع', '13.50 جنيه / متر'),
          SizedBox(height: 12),
          _buildItemRow('السعر النهائي المتفق عليه', '${finalPrice.toStringAsFixed(2)} جنيه / متر', isHighlight: true),
          SizedBox(height: 16),
          const Divider(height: 1, color: Color(0xFFF1F1F5)),
          SizedBox(height: 16),

          // Analysis Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E1EF)),
            ),
            child: Column(
              children: [
                _buildAnalysisRow('نسبة الخصم النهائي', '${diffPercent.toStringAsFixed(1)}%', isDiscount: true),
                SizedBox(height: 10),
                _buildAnalysisRow('إجمالي التوفير للمصنع', '${savingsAmount.toStringAsFixed(2)} جنيه', isDiscount: true),
                SizedBox(height: 10),
                _buildAnalysisRow('حالة الاعتماد للاتفاقية', status, statusColor: const Color(0xFF16A34A)),
              ],
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0040E0),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: Text(
              'إغلاق',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildItemRow(String label, String value, {bool isHighlight = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal,
            color: isHighlight ? const Color(0xFF0040E0) : AppColors.onSurface,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isHighlight ? AppColors.onSurface : AppColors.outline,
          ),
        ),
      ],
    );
  }

  Widget _buildAnalysisRow(String label, String value, {bool isDiscount = false, Color? statusColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: statusColor ?? (isDiscount ? const Color(0xFF006B5F) : AppColors.onSurface),
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: AppColors.outline,
          ),
        ),
      ],
    );
  }
}