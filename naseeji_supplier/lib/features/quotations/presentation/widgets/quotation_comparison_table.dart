import 'package:flutter/material.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../../domain/entities/quotation_model.dart';

class QuotationComparisonTable extends StatelessWidget {
  final QuotationModel quotation;

  const QuotationComparisonTable({super.key, required this.quotation});

  @override
  Widget build(BuildContext context) {
    // Pricing stats
    final targetPrice = quotation.originalRequestedPrice; // Target requested by Factory
    
    // First price proposed by Supplier (first revision or a default mock)
    final firstPrice = quotation.revisions.isNotEmpty 
        ? quotation.revisions.first.supplierPrice 
        : quotation.supplierUnitPrice * 1.15; // fallback
    
    final currentPrice = quotation.supplierUnitPrice;
    final finalPrice = quotation.status == QuotationStatus.accepted ? quotation.supplierUnitPrice : null;
    
    // Calculate difference and savings
    final priceDiff = (currentPrice - targetPrice).abs();
    final priceDiffPercent = (priceDiff / targetPrice) * 100;
    
    // Total savings for factory
    final factorySavings = (firstPrice - currentPrice) * quotation.quantity;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(16)),
        boxShadow: [BoxShadow(color: Color(0x05000000), blurRadius: 10)],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Row(
            children: [
              Icon(Icons.compare_arrows_outlined, color: AppColors.primary, size: 18),
              SizedBox(width: 8),
              Text(
                'مقارنة وتحليل الأسعار التفاوضية',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.onSurface),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(height: 1, color: AppColors.surfaceContainerLow),
          const SizedBox(height: 12),

          // Comparison Rows Table
          Table(
            columnWidths: const {
              0: FlexColumnWidth(3),
              1: FlexColumnWidth(2),
              2: FlexColumnWidth(2),
            },
            children: [
              TableRow(
                decoration: const BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                ),
                children: [
                  _buildCell('المرحلة التفاوضية', isHeader: true),
                  _buildCell('سعر الوحدة', isHeader: true),
                  _buildCell('الإجمالي', isHeader: true),
                ],
              ),
              TableRow(
                children: [
                  _buildCell('السعر المستهدف للمصنع'),
                  _buildCell('${targetPrice.toStringAsFixed(2)} ${quotation.currency}'),
                  _buildCell('${(targetPrice * quotation.quantity).toStringAsFixed(0)} ${quotation.currency}'),
                ],
              ),
              TableRow(
                children: [
                  _buildCell('السعر الأول للمورد'),
                  _buildCell('${firstPrice.toStringAsFixed(2)} ${quotation.currency}'),
                  _buildCell('${(firstPrice * quotation.quantity).toStringAsFixed(0)} ${quotation.currency}'),
                ],
              ),
              TableRow(
                children: [
                  _buildCell('السعر الحالي المقترح'),
                  _buildCell('${currentPrice.toStringAsFixed(2)} ${quotation.currency}', isBold: true, isPrimary: true),
                  _buildCell('${(currentPrice * quotation.quantity).toStringAsFixed(0)} ${quotation.currency}', isBold: true, isPrimary: true),
                ],
              ),
              if (finalPrice != null)
                TableRow(
                  children: [
                    _buildCell('السعر النهائي المعتمد'),
                    _buildCell('${finalPrice.toStringAsFixed(2)} ${quotation.currency}', isBold: true, isSuccess: true),
                    _buildCell('${(finalPrice * quotation.quantity).toStringAsFixed(0)} ${quotation.currency}', isBold: true, isSuccess: true),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Key Analysis Metrics
          const Text(
            'تحليل التوفير والهوامش',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: AppColors.onSurface),
          ),
          const SizedBox(height: 8),
          
          Row(
            children: [
              _buildMetricTile(
                label: 'فرق السعر عن الهدف',
                value: '${priceDiff.toStringAsFixed(2)} ${quotation.currency} (${priceDiffPercent.toStringAsFixed(1)}%)',
                icon: Icons.difference_outlined,
                color: Colors.blue,
              ),
              const SizedBox(width: 8),
              _buildMetricTile(
                label: 'وفورات المصنع المحققة',
                value: factorySavings > 0 ? '${factorySavings.toStringAsFixed(0)} ${quotation.currency}' : 'لا يوجد تفاوض بعد',
                icon: Icons.savings_outlined,
                color: Colors.green,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildMetricTile(
                label: 'نسبة التخفيض بالتفاوض',
                value: firstPrice > currentPrice 
                    ? '${(((firstPrice - currentPrice) / firstPrice) * 100).toStringAsFixed(1)}%'
                    : '٠.٠%',
                icon: Icons.percent,
                color: Colors.orange,
              ),
              _buildMetricTile(
                label: 'هامش الربح المتوقع',
                value: '${quotation.expectedProfitMargin.toStringAsFixed(1)}%',
                icon: Icons.trending_up,
                color: Colors.green,
              ),
            ],
          ),

          // Simple Visual Price Trend Chart
          const SizedBox(height: 16),
          const Text(
            'رسم بياني لمسار السعر',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: AppColors.onSurface),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildBarChartColumn(label: 'هدف المصنع', value: targetPrice, maxValue: firstPrice, color: Colors.red),
                _buildBarChartColumn(label: 'العرض الأول', value: firstPrice, maxValue: firstPrice, color: Colors.blue),
                _buildBarChartColumn(label: 'العرض الحالي', value: currentPrice, maxValue: firstPrice, color: Colors.orange),
                if (finalPrice != null)
                  _buildBarChartColumn(label: 'المعتمد النهائي', value: finalPrice, maxValue: firstPrice, color: Colors.green),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCell(String text, {bool isHeader = false, bool isBold = false, bool isPrimary = false, bool isSuccess = false}) {
    TextStyle style = const TextStyle(fontSize: 10, color: AppColors.onSurface);
    if (isHeader) {
      style = const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.onSurfaceVariant);
    } else if (isBold || isPrimary || isSuccess) {
      style = TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.bold,
        color: isPrimary 
            ? AppColors.primary 
            : (isSuccess ? Colors.green : AppColors.onSurface),
      );
    }
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Text(text, style: style),
      ),
    );
  }

  Widget _buildMetricTile({required String label, required String value, required IconData icon, required Color color}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE2E1EF), width: 0.5),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(fontSize: 8, color: AppColors.outline)),
                  const SizedBox(height: 2),
                  Text(
                    value, 
                    style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: color),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBarChartColumn({required String label, required double value, required double maxValue, required Color color}) {
    final heightRatio = (value / maxValue).clamp(0.1, 1.0);
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          value.toStringAsFixed(0),
          style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: color),
        ),
        const SizedBox(height: 4),
        Container(
          width: 24,
          height: 40 * heightRatio,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.8),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 8, color: AppColors.outline)),
      ],
    );
  }
}
